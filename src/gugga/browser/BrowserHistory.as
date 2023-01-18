import mx.events.EventDispatcher;
import mx.utils.Delegate;

import gugga.browser.BrowserHistoryCommander;
import gugga.debug.Assertion;
import gugga.utils.DebugUtils;

[Event("navigated")] // historyRecord : String

/**
 * BrowserHistory abstracts communication between BrowserHistoryManager and the history iframe.
 * The communication is delivered to the <code>save</code> and <code>onNavigate</code> methods.
 * <code>Save</code> reloads the history iframe thus saving new history records.
 * <code>onNavigate</code> receives message sent by the iframe via LocalConnection 
 * whenever it gets reloaded due to a Back or Forward browser button click. 
 * 
 * @author stefan
 * 
 * @see BrowserHistoryManager
 * @see BrowserHistoryCommander
 */
class gugga.browser.BrowserHistory extends EventDispatcher
{
	private static var mInstance : BrowserHistory = null;
	
	private static var mConnection : LocalConnection;
	private static var mHistoryWindowName : String;
	
	/**
	 * Creates singletone instance. Initializes LocalConnection. 
	 * This method receives flashvar params for local connection id and history iframe window name.
	 */
	private function BrowserHistory () 
	{
		super();
		
		Assertion.failIfNull(
			_level0[BrowserHistoryCommander.LOCAL_CONNECTION_ID_FLASHVAR_NAME],
			"_level0[BrowserHistoryCommander.LOCAL_CONNECTION_ID_FLASHVAR_NAME] should not be undefined when instantiating BrowserHistoryReceiver",
			this,
			arguments
		);
		
		Assertion.failIfNull(
			_level0.historyWindowName,
			"_level0.historyWindowName should not be undefined when instantiating BrowserHistoryReceiver",
			this,
			arguments
		);

		mConnection = new LocalConnection();
		mConnection.connect(_level0[BrowserHistoryCommander.LOCAL_CONNECTION_ID_FLASHVAR_NAME]);
		mConnection[BrowserHistoryCommander.LISTENER_METHOD_NAME] = 
			Delegate.create(this, this.onNavigate);
		
		mHistoryWindowName = _level0.historyWindowName;
	}
	
	/**
	 * Getter for the singletone Instance.
	 */
	public static function get Instance():BrowserHistory
	{
		if (mInstance == null)
		{
			mInstance = new BrowserHistory();
		}
		return mInstance;
	}
	
	/**
	 * Reloads the iframe with query string containing the record data.
	 * 
	 * @param String history record passed to the iframe. This param might be string value or
	 * serialized object depending on the BrowserHistoryManager behaviour.  
	 */
	public function save (aHistoryRecord : String)
	{
		DebugUtils.traceContext("", this, arguments);
		var url : String = formatUrl(aHistoryRecord); 
		
		DebugUtils.traceContext("url = " + url, this, arguments);
		
		getURL(url, mHistoryWindowName, "GET");
	}
	
	
	/**
	 * Creates url for the iframe to be reloaded with.
	 * It makes use of window name and flashvar name containing the record data. 
	 * The flashvar name is obtained from BrowserHistoryCommander constant value.  
	 * 
	 * @param String history record data to put in url.
	 */
	private function formatUrl(aHistoryRecord : String) : String 
	{
		var result : String = mHistoryWindowName + ".html?" + 
			BrowserHistoryCommander.HISTORY_RECORD_FLASHVAR_NAME + "=" + 
			aHistoryRecord;
		
		return result;
	}
	
	/**
	 * Dispatches event "navigated" whenever the iframe BrowserHistory is navigated on Back or Forward click.
	 * Movieclip in the iframe makes local connection call to the BrowserHistory when the iframe gets reloaded.
	 * 
	 * @param Object data containing history record corresponding to the navigated history state. Record data is attached to the event dispatched.   
	 */
	private function onNavigate(aHistoryRecord : Object)
	{	
		DebugUtils.trace("browser history navigated: " + String(aHistoryRecord) );
				
		dispatchEvent({type: "navigated", target: this, historyRecord: aHistoryRecord});	
	}
}