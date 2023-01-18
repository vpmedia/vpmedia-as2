import mx.utils.Delegate;

import gugga.browser.BrowserHistory;
import gugga.commands.CommandHistory;
import gugga.utils.DebugUtils;
/**
 * When initialized BrowserHistoryManager applies browser history navigation user activities to 
 * the application. BrowserHistoryManager is configured with concrete CommandHistory responsible for
 * handling user activities over the browser history navigation buttons.  
 * 
 * @author stefan
 * 
 * @see BrowserHistory
 * @see BrowserHistoryCommander
 * @see CommandHistory
 * 
 * TODO: Synchronize CommandHistory undo/redo state with BrowserHistory
 */
class gugga.browser.BrowserHistoryManager 
{
	private static var mInstance : BrowserHistoryManager;
	
	private var mCommandHistory : CommandHistory;
	private var mBrowserHistory : BrowserHistory;
	private var mOnCommandHistoryCommandAddedDelegate : Function;
	
	/**
	 * Crates instance and starts listening for events notifying navigation actions in the browser history
	 * or the application history (command history).
	 * 
	 * @param CommandHistory instance to synchronize with the browser history.
	 */
	private function BrowserHistoryManager (aCommandHistory : CommandHistory)
	{
		mCommandHistory = aCommandHistory;
		mBrowserHistory = BrowserHistory.Instance;
		
		mOnCommandHistoryCommandAddedDelegate = Delegate.create(this, this.onCommandHistoryCommandAdded);
		
		mCommandHistory.addEventListener("commandAdded", mOnCommandHistoryCommandAddedDelegate);
		mBrowserHistory.addEventListener("navigated", Delegate.create(this, this.onBrowserHistoryNavigated));
	}
	
	/**
	 * Initializes BrowserHistoryManager.
	 * Further calls will just replace the CommandHistory instance of the singletone.
	 * 
	 * @param CommandHistory responsible for handling user activities over the browser history navigation buttons.
	 */
	public static function initialize (aCommandHistory : CommandHistory) : Void
	{
		if(!mInstance)
		{
			mInstance = new BrowserHistoryManager(aCommandHistory);
		}
		else
		{
			mInstance.mCommandHistory.removeEventListener("commandAdded", mInstance.mOnCommandHistoryCommandAddedDelegate);
			mInstance.mCommandHistory = aCommandHistory;
			mInstance.mCommandHistory.addEventListener("commandAdded", mInstance.mOnCommandHistoryCommandAddedDelegate);	
		}
	}
	
	/**
	 * Handles the event dispatched when new command is executed by CommandMangager and added to CommandHistory.
	 * Calls the BrowserHistory to save new history record. 
	 * 
	 * @param Object event data containing index of executed command to be saved.   
	 */
	private function onCommandHistoryCommandAdded (ev) : Void
	{
		var historyRecord : String = String(ev["currentCommandIndex"]);
		
		mBrowserHistory.save(historyRecord);	
	}
	
	/**
	 * Handles the event dispatched when the browser history is navigated.
	 * Calls CommandHistory to navigate to commandIndex passed by the event received.
	 * 
	 * @param Object event containing commandIndex history record.   
	 */
	private function onBrowserHistoryNavigated (ev) : Void
	{
		var commandIndex : Number = -1; 
		var historyRecord : String = ev["historyRecord"];
		if(historyRecord)
		{
			commandIndex = Number(historyRecord);
		}
		
		mCommandHistory.navigate(commandIndex);
	}
}