import mx.utils.Delegate;

import gugga.browser.AddressBar;
import gugga.commands.CommandHistory;
import gugga.commands.IApplicationCommandReceiver;

/**
 * When initialized AddressBarManager begins publishing deep link for the current navigation state 
 * into the browser address bar whenever the user navigates through the application.
 * 
 * @author stefan
 * 
 * TODO: comments revision.
 */
class gugga.browser.AddressBarManager 
{
	private static var mInstance : AddressBarManager;
	
	private var mAddressBar : AddressBar;
	private var mCommandHistory : CommandHistory;
	private var mApplicationCommandReveiver : IApplicationCommandReceiver;

	private var mOnNavigateDelegate : Function;

	/**
	 *  Initializes singletone instance. 
	 *  Further calls will just replace the CommandHistory instance of the singletone.
	 * 
	 * @param aCommandHistory to pass to constructor
	 */
	public static function initialize (aCommandHistory : CommandHistory) : AddressBarManager
	{
		if(!mInstance)
		{
			mInstance = new AddressBarManager(aCommandHistory);
		}
		else
		{
			mInstance.mCommandHistory.removeEventListener("commandBufferContentChanged", mInstance.mOnNavigateDelegate);
			mInstance.mCommandHistory = aCommandHistory;
			mInstance.mCommandHistory.addEventListener("commandBufferContentChanged", mInstance.mOnNavigateDelegate);
		}
		
		return mInstance;
	}
	
	/**
	 * Initializes AddressBarManager, configures it with a CommandHistory instance and starts listening to it.   
	 * 
	 * @param aCommandHistory to listen for navigational activities.
	 */
	private function AddressBarManager (aCommandHistory : CommandHistory)
	{
		mCommandHistory = aCommandHistory;
		mApplicationCommandReveiver = IApplicationCommandReceiver(_global.ApplicationController);
		mAddressBar = AddressBar.Instance;
	
		mOnNavigateDelegate = Delegate.create(this, this.onNavigate);
			
		mCommandHistory.addEventListener("commandBufferContentChanged", mOnNavigateDelegate);
		mAddressBar.addEventListener("navigated", Delegate.create(this, navigateTo));
	}
	
	public function applyDeepLinks() : Boolean
	{
		if(_level0[AddressBar.MESSANGER_DEEP_LINK_FLASHVAR_NAME])
		{
			mApplicationCommandReveiver.NavigateTo(_level0[AddressBar.MESSANGER_DEEP_LINK_FLASHVAR_NAME]);
			
			return true;
		}	
		
		return false;
	}
	
	/**
	 * Handles <code>commandBufferContentChanged</code> of CommandHistory.
	 * 
	 * @param ev event object passed by CommandHistoryBuffer containing currentCommandIndex.
	 */
	private function onNavigate (ev) : Void
	{
		var navigationPath : String = AddressBar.SECTION_PATH_FLASH_VAR_NAME + "=" + mApplicationCommandReveiver.CreateNavigationState().NavigationPath;
		
		if(ev["currentCommandIndex"] || ev["currentCommandIndex"] == 0)
		{
			navigationPath += "&commandIndex=" + String(ev["currentCommandIndex"]);	
		}
		
		mAddressBar.onNavigate(navigationPath);
	}
	
	/**
	 * <code>navigateTo</code> is called whenever the client clicks back or forward.
	 * If no commandIndex parameter is provided applies navigationPath through the ApplicationCommandReceiver directly instead of the CommandHistoryBuffer.
	 * 
	 * @param ev event object passed by the AddressBar singletone containing navigationPath and commandIndex.
	 */
	public function navigateTo (ev) : Void
	{ 
		var navigationPath = ev["navigationPath"];
		var commandIndex = ev["commandIndex"];
		
		if(navigationPath == "-1")
		{
			commandIndex = -1;
		}
		
		if (!commandIndex || commandIndex == undefined || commandIndex == "undefined" || commandIndex == "")
		{
			mApplicationCommandReveiver.NavigateTo(String(navigationPath));
		}
		else
		{
			mCommandHistory.navigate(Number(commandIndex));
		}
	}
}