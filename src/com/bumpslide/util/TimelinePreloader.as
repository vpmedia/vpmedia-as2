import mx.events.EventDispatcher;

/**
* Preloads a timeline and dispatches events along the way
* 
* We like to have a delay before we show a loading indicator, so we wait for the
* EVENT_SHOW_INDICATOR event before showing the load indicator. By default, this 
* delay is set to 1 second. 
* 
* Once that delay is passed, you will notice that the EVENT_PRELOAD_PROGRESS event
* contains a property called 'adjustedPercent'.  This is a percentage of remaining bytes 
* offset by the amount loaded before the 1 second delay.  You can choose to use this 
* percentage to feed your load indicator if you want a bar that doesn't start at 50% 
* or something similar.
* 
* You can hide the progress bar and start your app reliably once the EVENT_PRELOAD_COMPLETE 
* event is received.  
*  
* <p>Example Usage:
* {@code 
* 
*   var display_txt:TextField;
*   var preloader:TimelinePreloader;
* 
*   function init() {
*   	stop();
* 		display_txt.autoSize = true;
* 		display_txt._visible = false;
* 	 	preloader = new TimelinePreloader( this );
* 		preloader.addEventListener( TimelinePreloader.EVENT_SHOW_INDICATOR, Delegate.create( this, showProgressBar ) );
*  	 	preloader.addEventListener( TimelinePreloader.EVENT_PRELOAD_PROGRESS, Delegate.create( this, updateProgressBar ) );
* 		preloader.addEventListener( TimelinePreloader.EVENT_PRELOAD_COMPLETE, Delegate.create( this, hideProgressBarAndStartApp ) );
*   	preloader.start();   
* 	}
* 
*   function showProgressBar() {
*		display_txt._visible = true;	
*	}
*
*	function updateProgressBar(e:Object) {
*		var pct:String = Math.round( e.adjustedPercent*100 ) + '%';
*		display_txt.text = "Loaded "+pct;
*	}
*
*	function hideProgressBarAndStartApp() {
*		gotoAndStop('start');	
*	}
* 
*   init();
* }
* 
* You can remove or alter the indicator delay time with code such as:
* {@code
*   preloader.indicatorDelayTime = 0;
* }
* 
*/
class com.bumpslide.util.TimelinePreloader
{
	
	// EVENTS...
	
	// Event, Dispatched after {indicatorDelayTime} milliseconds
	// This is when the progress bar should be displayed
	static public var EVENT_SHOW_INDICATOR:String = "preloadDelayComplete";
	
	// Event, dispatched periodically while loading 
	static public var EVENT_PRELOAD_PROGRESS:String = "preloadProgress";
	
	// dispatched when loading is complete
	static public var EVENT_PRELOAD_COMPLETE:String = "preloadComplete";
	
	
	/**
	* Constructor
	* @param	timeline_mc
	*/
	function TimelinePreloader( timeline_mc:MovieClip ) {
		_mc = timeline_mc;
		EventDispatcher.initialize(this);
	}

	/**
	* Sets indicator delay time in milliseconds 
	* @param	ms
	*/
	function set indicatorDelayTime ( ms:Number ) {
		_indicatorDelay = ms;
	}
	
	/**
	* starts preloading
	*/
	public function start() {
		// save start time
		_startTime = getTimer();
    	
		// monitor loading
		clearInterval(_monitorInt);
		_monitorInt = setInterval( this, '_monitor', 40);
	}
	
	/**
	* Monitors load progress, called via setInterval
	*/
	private function _monitor() {
	
		var loadTime:Number = getTimer() - _startTime;	            
		var l:Number = _mc.getBytesLoaded();
		var t:Number = _mc.getBytesTotal();		
		
		if (loadTime > _indicatorDelay) {			
			if(!_indicatorVisible) {
				_indicatorVisible = true;
				_startBytes = _mc.getBytesLoaded();
				trace('preloader - show indicator delay passed');
				dispatchEvent( { type: EVENT_SHOW_INDICATOR, target: _mc } );
			} else {					
				dispatchEvent( { type: EVENT_PRELOAD_PROGRESS, loaded: l, total: t, adjustedPercent: (l-_startBytes)/(t-_startBytes)} );
			}        
		} 
		//dispatchEvent( { type: EVENT_PRELOAD_PROGRESS, loaded: l, total: t} );
			
		//trace( 'preloaded '+Math.round( l/t * 100) + '%' );		
		if ( t>4 && l>=t ) {
			//trace('complete ... '+l+'/'+t);
			clearInterval( _monitorInt );
			dispatchEvent( { type: EVENT_PRELOAD_COMPLETE, target: _mc } );
		}
	}
	
	// PRIVATE 
	//-----------
	
	// time at which preloading started
	private var _startTime : Number;	
	
	// bytes loaded at time indicator is shown
	private var _startBytes : Number;		
	
	// reference to mc that we are preloading
	private var _mc  : MovieClip;			
	
	// interval for progress monitor
	private var _monitorInt:Number;
	
	// delay before broadcasting the EVENT_SHOW_INDICATOR event 
	// (see indicatorDelayTime setter below)
	private var _indicatorDelay : Number = 1000;
	
	// private flag
	private var _indicatorVisible : Boolean = false;
	
	
	// ----------------------------------------------
    //  EventDispatcher Stuff

    var addEventListener    :Function
 	var removeEventListener :Function
 	var dispatchEvent       :Function
 	var dispatchQueue       :Function
}
