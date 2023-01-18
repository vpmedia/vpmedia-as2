import gugga.browser.AddressBarManager;
import mx.utils.Delegate;
import gugga.debug.Assertion;
import mx.events.EventDispatcher;
import gugga.utils.DebugUtils;
/**
 * @author stefan
 * 
 * TODO: Apply strategies based on ExternalInterface or LocalConnection for communicating with the browser.
 * TODO: Write comments   
 */
class gugga.browser.AddressBar 
	extends EventDispatcher
{
	public static var SECTION_PATH_FLASH_VAR_NAME : String = "navigationPath";
	public static var UPDATE_LOCATION_JS_FUNCTION_NAME : String = "updateLocation";
	public static var LOCAL_CONNECTION_ID_FLASHVAR_NAME : String = "historyLocalConnection";
	public static var LISTENER_METHOD_NAME = "receiver";
	public static var MESSANGER_DEEP_LINK_FLASHVAR_NAME : String = "navigationPath";
	public static var MESSANGER_COMMAND_INDEX_FLASHVAR_NAME : String = "commandIndex";
	
	private static var mInstance : AddressBar;
	
	private var mConnection : LocalConnection;
	
	private function AddressBar ()
	{
		Assertion.failIfNull(
			_level0[LOCAL_CONNECTION_ID_FLASHVAR_NAME],
			"_level0[LOCAL_CONNECTION_ID_FLASHVAR_NAME] should not be undefined",
			this,
			arguments
		);
		
		mConnection = new LocalConnection();
		mConnection.connect(_level0[LOCAL_CONNECTION_ID_FLASHVAR_NAME]);
		mConnection[LISTENER_METHOD_NAME] = Delegate.create(this, this.addressBarNavigated);
	}
	
	public static function get Instance () : AddressBar
	{
		if (mInstance == null)
		{
			mInstance = new AddressBar();
		}
		return mInstance;
	}
	
	public function onNavigate (navigationPath : String)
	{		
		getURL("javascript:" + UPDATE_LOCATION_JS_FUNCTION_NAME + "('" + navigationPath + "');");	
	}

	private function addressBarNavigated (aData : Object)
	{
		var navigationPath = aData[MESSANGER_DEEP_LINK_FLASHVAR_NAME];
		var commandIndex = aData[MESSANGER_COMMAND_INDEX_FLASHVAR_NAME];
		
		dispatchEvent({type: "navigated", target: this, navigationPath : navigationPath, commandIndex : commandIndex});
	}
}