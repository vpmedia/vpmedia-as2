/**
 *  Proxies Stage onResizeEvents and implements min and max dimensions
 * 
 * 
 *  <code>
 * 
 *  var stage:StageProxy; 
 *  stage = StageProxy.getInstance();
 * 
 *  stage.addEventListener( StageProxy.ON_RESIZE_EVENT, this );
 * 
 *  function onStageResize(e:StageResizeEvent) {
 *     
 *    // reference ...  stage.height, stage.width
 *  }
 *   
 *  </code>
 * 
 *  There are 3 modes of operations. 
 *  1 - PASS_THRU - Every stage.onResize event passes right through
 *  2 - WAIT_FOR_STOP - (default) uses setInterval so resize event only fires after we have stopped resizing
 *  3 - THROTTLED - ues throttle class to limit number of events to a minimum interval
 * 
 *  Broadcasts event 'onStageResize'
 * 
 *	@version 1.1
 *  @author David Knape
 */
import com.bumpslide.util.*;

import mx.events.EventDispatcher;

class com.bumpslide.util.StageProxy {
	
	// available event modes
	static var PASS_THRU 	 : Number = 0; 
	static var WAIT_FOR_STOP : Number = 1;
	static var THROTTLED     : Number = 2;
	
	// Event
	static var ON_RESIZE_EVENT : String = "onStageResize";
	
	// config
	public var maxWidth  : Number = 1500;
	public var maxHeight : Number = 1000;
	public var minWidth  : Number = 500;
	public var minHeight : Number = 300;
	public var fixedSizeEnabled : Boolean = false;
	
	public var throttleTime : Number = 100;
	public var intervalTime : Number = 100;
				
	public function set eventMode ( n:Number ) : Void {
		_eventMode = n;
	}
	
	public function get eventMode () : Number {
		return _eventMode;
	}
	
	// height and width
	public function get width () : Number {	return _stageWidth; }		
	public function get height () : Number { return _stageHeight; }

		
	// local debug implementation
	private function myTrace( o ) {
		//Debug.dTrace(o);
	}
	
	// private CTOR (singleton)
	private function StageProxy() {
		
		EventDispatcher.initialize( this );

		// Align Top Left and don't scale
		Stage.align = "TL";
		Stage.scaleMode = "noScale";		
		Stage.addListener( this );		
		
		_doJavaScriptCalls = _root._url.split('/')[0]=='http:';
		
		//_updateFunc = new Throttle( Delegate.create(this, doResize), throttleTime);
		onResize();  
	}
	
	//Singleton Implementation (getInstance)
	public static function getInstance() : StageProxy {
		if (StageProxy._instance == null) { StageProxy._instance = new StageProxy(); }
		return _instance;
	}
	
	function update() {
		onResize();
	}
	
	function onResize( noFixedCheck:Boolean ) {
		
		// In some browsers, our attempts at enforcing a minimum size do not work.
		// when this happens, we must go to a fixed size using a JS function call
		// When we first init ourselves, this doesn't work, so we bypass this 
		// check using the noFixedCheck parameter above
		// flash player is always 100x100 at startup, we check for that here as well
		if ( 	noFixedCheck===true 
				|| Stage.width==0 
				|| Stage.height==0 
				|| ( Stage.width==100 && Stage.height==100 ) 
				|| !_doJavaScriptCalls ) 
		{
			myTrace('[StageProxy] Skipping goFixedSize Check');
		} else {
			if (fixedSizeEnabled && (Stage.width<minWidth || Stage.height<minHeight)) {
				getURL("javascript:goFixedSize("+Stage.width+","+Stage.height+");");
			}
		}
				
		// our 'stage' should not exceed max height and width
		_stageWidth = Math.max( Math.min( Stage.width, maxWidth ), minWidth);
		_stageHeight = Math.max( Math.min( Stage.height, maxHeight ), minHeight);
	
	
		switch (eventMode) {
			
			case PASS_THRU:
				doResize();
				break;

			//case THROTTLED:
			//	_updateFunc.trigger();
			//	break;
				
			default: // ( WAIT_FOR_STOP )
				clearInterval( _resizeInt );	
				_resizeInt = setInterval( this, 'doResize', intervalTime);	
				break;
		}
	}
		
	function doResize() {
		myTrace( '[StageProxy] Broadcasting onStageResize '+width+','+height);
		clearInterval( _resizeInt );
		dispatchEvent( new StageResizeEvent(width, height) );		
	}
				
	
	
	// singleton instance
	static private var _instance;
	
	// private
	private var _stageWidth : Number;			// stage width
	private var _stageHeight : Number;			// stage height
	private var _doJavaScriptCalls:Boolean;	// whether or not to do JS checks (see CTOR)
	private var _eventMode : Number = 1;   	// event mode
	//private var _updateFunc : Throttle;			// throttled function call
	private var _resizeInt : Number = -1;		// wait_for_stop interval
	
	public var addEventListener    : Function;
 	public var removeEventListener : Function;
 	private var dispatchEvent      : Function;
 	private var dispatchQueue      : Function;
	
	public var broadcastMessage    : Function;
	public var addListener         : Function;
	public var removeListener      : Function;
}
