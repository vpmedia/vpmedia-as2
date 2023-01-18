/**
 *  Throttles function calls
 * 
 *  This class is designed to limit the number of calls made to a function 
 *  by putting a minimum time requirement in between each call.
 *  We often do this with setInterval, but with setInterval, we are constantly
 *  resetting the timer.  Throttling is useful for stage updates and for operations
 *  that require loading resources to be viewed such as in a thumbnail scroller.  
 * 
 *  Usage:
 *  <code>
 * 
 *  	var stageUpdater = new Throttle( Delegate.create( this, doUpdate), 500 );
 * 
 * 		function onResize() {  // Stage.onResize handler (for example)
 * 			stageUpdater.trigger();  
 * 		}
 * 
 * 		function doUpdate() {
 *			// my expensive code goes here and will only get called twice per second * 
 *		}
 * 
 * </code>
 * 
 * @author David Knape
 * @version 1.0
 */

class com.bumpslide.util.Throttle {

	
	
	public function Throttle ( proxyFunc:Function, msDelay:Number ) {
		func = proxyFunc;
		delay = msDelay;
	}
	
	public function trigger() {
		
		clearInterval( finalInt );	
		
		// If this is the last trigger call, and we are not allowed yet
		// we want to do a final call as soon as possible
		if(forcingWait) {

			//trace('[Throttle] Forcing Wait...');
			finalCallPending = true;
			return;

		} else {
			
			// call function 
			_doFunctionCall();
			
			finalCallPending = false;
			forcingWait = true;		
			
			// start timer, so we don't call again for X milliseconds		
			clearInterval( delayInt );
			delayInt = setInterval(this, 'clearForcedWait', delay);
		}
	}
	
	private function _doFunctionCall() {
		trace('[Throttle] Calling Function at '+getTimer());
		finalCallPending = false;
		func.call(null);		
	}
	
	
	public function clearForcedWait() {
		clearInterval( delayInt );		
		forcingWait = false;
		
		if(finalCallPending) {
			//trace('[Throttle] Doing Final Call...');
			_doFunctionCall();
		}
	}

	
	
	private var func : Function;
	private var delay : Number;
	private var finalInt : Number = -1;
	private var delayInt : Number = -1;
	private var forcingWait : Boolean = false;
	private var finalCallPending : Boolean = false;	
	
	
}