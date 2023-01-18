import com.bumpslide.data.*;
import com.bumpslide.util.*;
import mx.events.EventDispatcher;

/**
* Tracks state changes in a model and fires off history events to a history swf
* 
*/
class com.bumpslide.data.HistoryTracker extends com.bumpslide.events.Dispatcher
{
	// PUBLIC CONFIG OPTIONS
	
	// Allow History Tracking for file:// urls
	public var HTTP_URLS_ONLY = false;
	
	// html file that contains swfhistory control swf
	public var HISTORY_HTML_URL : String = "swfhistory.html";
	
	// target frame
	public var HISTORY_HTML_FRAME : String = "swfhistory";
	
		
	
	// PRIVATE 
	
	// used during forced callbacks (see forceClickEvent)
	private var _waitingOnCallback : Boolean ;
	
	// Local connection id string
	private var _connectionId      : String = 'xxxx'; 
	
	// used to prevent state
	private var _latestNavEventReceived : Number = 0; 
	
	// part of leap-frogging state bugfix
	private var _latestNavEventSent     : Number = 0; 
	
	// interval used in sendClickEvent
	private var _sendClickInt           : Number=-1; 
	
	// interval used to delay start of model event listening
	private var _listenInt : Number = -1;
	
	// the serialized version of the default state
	private var _defaultPath : String;
	
	
	// local connection to hidden control SWF
	// use for browser history tracking
	private var control_lc         		: LocalConnection;	
	
	// keys we are watching
	private var _keys : Array;
	
	// model we are watching
	private var _model:Model;
	
	private var sep : String = "|";
	
	
	
	/**
	* Starts tracking changes to passed in Model
	*  
	* @param	state
	* @param	keys
	*/
	function init( state:Model, keys:Array ){	
		
		initBrowserConnection();
				
		// listen to model changes
		_model = state;		
		_keys = (keys==null) ? _model.getKeys() : keys;		
		_defaultPath = getSerialized();
		
		startListening();
	}
	
	private function initBrowserConnection() {
		
		// pull local connection id from flashvars
		_connectionId = _root.connId;
		
		if(_connectionId==undefined) {
			debug('!LocalConnection ID is undefined');
			return;
		}
		
		// determine URL Protocol (http, https, or file)
        var protocol = _root._url.split('://')[0];
		
		if( HTTP_URLS_ONLY && protocol!='http' && protocol!='https') {
			debug('!HistoryTracking disabled for file:// URL\'s');
			return;
		}
						
		_waitingOnCallback = false;

		debug('Initialized with connection ID:'+_connectionId); 
		
		// Local Connection listens to navTo messages sent from control SWF
		control_lc = new LocalConnection();
		control_lc.scope = this;
		control_lc.allowDomain = function(domain){ return true; }
		control_lc.historyNavTo = Delegate.create( this, goto );
		control_lc.connect( HistorySwf.LC_CONTROL+_connectionId );
	
		// control swf will return a historyNavTo call with the current state
		// This is what loads state vars in from the main url
		var readycheck_lc = new LocalConnection();
		readycheck_lc.send( HistorySwf.LC_READYCHECK + _connectionId, "readyCheck");
		
	}
	
		
	private function onValueChanged( e:ModelValueChangedEvent ) {
		debug('ModelValueChanged '+e.key + ' >> ' + e.newValue);
		if(ArrayUtil.in_array( e.key, _keys)) {
			sendClickEvent();
		}
	}
	
	private function serializeValue( key, val ) {
		return encodeKey(key)+'='+val;
	}
	
	private function unserializeValue( key, val ) {
		var nVal = Number( val );
		
		if(_model.get(key) instanceof Array) {			
			return val.split(',');			
		} else if (!isNaN(nVal)) {
			return nVal;		
		} else {
			return val;
		}		
	}
	
	/**
	* Get serialized version of current state
	*/
	public function getSerialized() {		
		var s:String = "";
		var len = _keys.length;
		for(var n=0; n<len; ++n) {
			s += serializeValue( _keys[n], _model.get( _keys[n] )) + sep;
		}
		return s;	
	}
	
	/**
	* change state by passing in a serialized string representation of the target state
	* @param	strPath
	*/
	public function goto(strPath:String) {
		
		
		if ( strPath=='' || strPath==null) strPath = _defaultPath;
		
		debug('goto ( '+strPath+' )' );

		// path comes in in two chunks separated by '||' (sep+sep)
		// first chunk (and only chunk if no '' is found)
		// is the serialized state data
		// the second chunk is the event number
		// If the event number is the one we just sent out, 
		// then we ignore it.
				
		var parts = strPath.split(sep+sep);
		var serializedState = parts[0];
		var eventNum = parseInt(parts[1]);
				
		// if eventNum is greater than the last one we received
		// update latestNavEventReceived and don't update state
		// unless the eventNum is greater than the last one we sent
		// if that is the case, then we don't want to ignore it
		// thus, the empty block here...		
		if(eventNum > _latestNavEventSent) { 
			
			// invalid event num, not a problem, just ignore 
			// must have been an old boomarked URL or something,
			// but we still want to update state
			
		} else if(!isNaN(eventNum) && eventNum>_latestNavEventReceived ) {			
			
			// This is just us receiving the nav event we just issued.
			// don't bother reacting to it
			//debug('eventNum '+eventNum+' is latest received, NO CHANGE');
			_latestNavEventReceived = eventNum;			
			return;		
			
		} else {			
			
			if(isNaN(eventNum)) {
				//debug('no eventNum, must be a deep-link or bookmarked URL, OK');    
			} else {
				//debug('eventNum is old, must be back button, OK');    
			}			
		}
		
		updateState( unserialize( serializedState ) );		
	}
	
	/**
	* Unserializes a string representation of state into an object of some sort
	* 
	* @param	serializedState
	* @return
	*/
	function unserialize( serializedState:String ) : Map {
		
		debug( 'unserializing: '+serializedState);
		
		var a = serializedState.split(sep);
		var len = a.length;
		
		// key/value pairs
		var parts:Array; 
		var newState:Object = new Object();
		
		for (var n=0; n<len; ++n) {
			//debug('unserializing '+ a[n]);
			if ( a[n].length>0 ) {
				parts = a[n].split('=');
				var sepPos = a[n].indexOf('=');
				var key = decodeKey( a[n].slice(0,sepPos) );
				var val = unserializeValue( key, a[n].slice(sepPos+1) );
				//debug( key + ' = ' + val );
				newState[key] = val;
			}
		}
		
		return new Map( newState );		
	}
	
	/**
	* Decodes a shortcut keyname into the full key name
	* 
	* override as necessary 
	* 
	* @param	shortcutKeyName
	* @return
	*/
	private function decodeKey( shortcutKeyName:String ):String {
		return shortcutKeyName;
	}
	
	/**
	* Encodes full state key as a short name for use in a url
	* 
	* override as necessary
	* 
	* @param	fullKeyName
	* @return
	*/
	private function encodeKey( fullKeyName ):String {
		return fullKeyName;
	}
	
	
	
	/**
	* Updates state with data decoded from local connection nav event
	*/
	function updateState( newStateData:Map ) {
		
		debug( 'New State data Received:' );
		debug( newStateData );
		// don't respond to state changes while we are changing state 
		_model.removeEventListener( Model.VALUE_CHANGED_EVENT, this );
		
		//var newState:Array = Array( newStateData );
		//newState.reverse();
		
		var keys = newStateData.getKeys();
		
		for(var n in keys ) {
			
			var key = keys[n];
			
			var val = newStateData.get(key);
			
			if (!_model.containsKey(key)) {
				debug('!Undefined Model Key "'+key+'"');
				continue;
			}

			if (_model.getValue(key) != val) {
				debug('changing '+key+' to '+ val + ' (' + typeof(val)+ ')');
				_model.put( key, val );				
			} 		
		}
		
		startListening();	
	}
	
	/**
	* Start listening to model change events
	*/
	private function startListening() {		
		clearInterval( _listenInt );
		_listenInt = setInterval( this, 'doStartListening', 50 );		
	}
	
	private function doStartListening() {
		clearInterval( _listenInt );
		_model.addEventListener( Model.VALUE_CHANGED_EVENT, this );
	}
	
	
	

	/**
	* Force a browse history event for the current state
	* 
	* One sample use case for this is when we want to save form vars to history 
	* before showing results so that form contents are filled in when the user hits 
	* the back button.  client code needs to wait for the (onForcedStateCallback) 
	* event before changing view state to search results screen
	* 
	* 
	*/
	public function forceClickEvent() {
		_waitingOnCallback = true;
		doSendClickEvent();
	}
	
	/**
	* triggers browser history nav event
	*/
	private function sendClickEvent(){
		clearInterval(_sendClickInt);
		_sendClickInt = setInterval( this, 'doSendClickEvent', 300);
	}
	
	/**
	* passes serialized state to hidden frame for browser history tracking
	*/
	private function doSendClickEvent() {
		clearInterval(_sendClickInt);		
		_root.getURL( buildUrl(), HISTORY_HTML_FRAME );
	}
	
	/**
	* Returns the url to the history html file
	* @return
	*/
	private function buildUrl() : String {
		var url:String = HISTORY_HTML_URL+'?'+escape(getSerialized());
		url += escape(sep)+ (++_latestNavEventSent);
		debug('Senging click event with url:'+url);
		return url;
	}
	
	
	// ---- DEBUG ----

	private var mDebug : Boolean = false;
	
	function debug ( o ) : Void {
		if ( !mDebug ) return;
		if ( typeof(o)=='string' ) {
			var msg : String = this.toString();
			( o.substr(0,1)=='!' ) ? Debug.error( msg+o.substr(1) ) : Debug.info( msg+o );
		} else {
			Debug.info( o );
		}
	}	
	
	function toString() {
		return '[HistoryTracker] ';
	}
	
	
}
