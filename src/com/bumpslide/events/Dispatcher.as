import com.bumpslide.util.*;
import mx.events.EventDispatcher;
import org.asapframework.util.FrameDelay;

/**
* A simple dispatcher with some helpers
*/
class com.bumpslide.events.Dispatcher
{

	var mName = "Dispatcher";
	
	function Dispatcher()
	{
		EventDispatcher.initialize( this );
	}
		
	/**
	* returns array of listeners for an event from this dispatcher
	*
	* @param	eventName
	*/
	function getListeners( eventName:String ) {
		return this["__q_" + eventName];
	}
	
	/**
	* removes all event listeners for a specific event type
	* 
	* @param	eventName
	*/
	function removeAllListeners( eventName:String ) {
		this["__q_" + eventName] = new Array();
	}
			
	// EventDispatcher mix-in functions
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	// whether or not to show debug messages for this class
	private var mDebug : Boolean = true;

	/**
	 *  Overrides toString method to customize for this app
	 */
	function toString ():String {
		return '['+mName+']';
	}	
	
	/**
	* Custom logging/trace util
	* @param	s
	*/
	function debug(s) {
		if(!mDebug) return;
		if(typeof(s)=='object') {
			Debug.info( s );
		} else {
			var time = Math.round(getTimer()/10)/100; // seconds
			var msg = this.toString()+' ('+time+'s) - ';
			switch(s.substr(0,1)) {
				case '#':	Debug.info( msg + s.substr(1) );	break;
				case '*':	Debug.warn( msg + s.substr(1) );	break;
				case '!':	Debug.error( msg + s.substr(1) ); 	break;
				default:	Debug.debug( msg + s );
			}
		}
	} 
	
	
	var _fd:FrameDelay;
	
	/**
	 *  Calls a function in the current class after a delay of one frame
	 * 
	 *  extra arguments are passed 
	 *
	 *  @param	func
	 *  @param	args
	 */
	private function onEnterFrameCall( func:Function ) {
		_fd.die();
		_fd = new FrameDelay(this, func, 2, arguments.slice(1));
	}
	
	/**
	 * Cancels pending onEnterFrameCall function
	 */
	function cancelEnterFrameCall() {
		_fd.die();
	}
}
