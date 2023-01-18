import gugga.utils.DebugUtils;
/**
 * BrowserHistoryCommander is instantiated by movie clip loaded into the history.html iframe.
 * Whenever this class gets instantiated it makes a LocalConnection call to the application passing
 * concrete history record. History record is a string value contained in the query string.  
 * 
 * @author stefan
 */
class gugga.browser.BrowserHistoryCommander 
{
	public static var LOCAL_CONNECTION_ID_FLASHVAR_NAME : String = "historyLocalConnection";
	public static var LISTENER_METHOD_NAME : String = "receiver";
	public static var HISTORY_RECORD_FLASHVAR_NAME : String = "historyRecord";
	
	private var connection : LocalConnection;
	
	/**
	 * Creates an instance and sends the history record via LocalConnection to the main application.
	 */
	public function BrowserHistoryCommander () 
	{
		connection = new LocalConnection();
		connection.send(_level0[LOCAL_CONNECTION_ID_FLASHVAR_NAME], LISTENER_METHOD_NAME, 
			_level0[HISTORY_RECORD_FLASHVAR_NAME]);
	}
} 