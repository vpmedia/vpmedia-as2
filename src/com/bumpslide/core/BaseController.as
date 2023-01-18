import org.asapframework.util.FrameDelay;
import org.asapframework.management.movie.*;
import com.bumpslide.util.*;
import com.bumpslide.events.*;

/**
* David's extension of the ASAP LocalController
* 
* We've added automatic event bubbling to parent controllers,
* an init hook, and more. 
* Copyright (c) 2006, David Knape and contributing authors
* Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
* 
* @author David Knape
*/

class com.bumpslide.core.BaseController extends LocalController
{
	
	// Nearest parent controller used for bubbling up events
	private var parentController:LocalController;
	
	// whether or not to show debug messages for this class
	private var mDebug : Boolean = true;
	
	private var mName : String = "Controller";
	
	// shortcuts...
	
	// auto-scoped delegate ( or Delegate.create )
	private var d:Function;	
	
	
	// frame delay instance for 'onEnterFrameCall/ec'
	private var _fd:FrameDelay;
	
	/**
	* Constructor overriden to setup frameDelayed init and parentController
	* @param	timeline_mc
	*/
	function BaseController(timeline_mc:MovieClip) {
		super(timeline_mc);	
		
		d = delegate;
		
		if(timeline_mc._parent!=undefined) {
			parentController = MovieManager.getInstance().getNearestLocalController( timeline_mc._parent );
			//trace('Parent controller for '+this.mName+' is '+parentController.mName );
		}		
		// do 'onLoad' init stuff after a frame has elapsed
		onEnterFrameCall( _init );
	}
	
	
	function kill() {
		cancelEnterFrameCall();
	}
	
	/**
	* Called one frame after clip is constructed (like an onLoad)
	*/
	private function _init() {	
		// subclass initialization hook
		init();		
		
		// notify MovieManager that we are done initializing
		notifyMovieInitialized();
	}	
	
	
	/**
	* Hook for subclasses to run initialization commands "onLoad"
	*/
	private function init() {
		// blah-de-dah
	}
	
	/**
	* Default EventDispatcher event handler
	* 
	* Facilitates bubbling.
	* 
	* @param	e
	*/
	function handleEvent(e:Event) {
		if(typeof(this[e.type])!='function') {			
			if(parentController!=null) {
				debug('Bubbling up event "'+e.type+'"');
				addEventListener( e.type, parentController );
				dispatchEvent(e);
				removeEventListener( e.type, parentController );
			} else {
				debug('!Unhandled Controller Event "'+e.type+'"');				
			}		
		}
	}
	
	/**
	 *  Custom toString method
	 */
	public function toString () : String {
		return "["+getName()+"] ";
	}
	
	
	/**
	 *  Shortcut delegate method 
	 * 
	 *  if first argument was a function, make the scope 'this' 
	 */
	function delegate() 
	{		
		var args:Array = arguments.concat();
		
		// if first argument was a function, make the scope 'this'
		if(typeof(args[0]) == 'function') {
			args.unshift( this );
		} 
		return Delegate.create.apply( null, args );
	}
		
	/**
	 *  Calls a function in the current class after a delay of one frame
	 * 
	 *  extra arguments are passed 
	 *
	 *  @param	func
	 *  @param	args
	 */
	private function onEnterFrameCall( func:Function ) {
		if(_fd) _fd.die();
		_fd = new FrameDelay(this, func, 1, arguments.slice(1));
	}
	
	/**
	 * Cancels pending onEnterFrameCall function
	 */
	function cancelEnterFrameCall() {
		_fd.die();
	}
	
	/**
	* Custom logging/trace util
	* @param	s
	*/
	function debug(s) {
		if(!mDebug) return;
		if(typeof(s)=='object') {
			Debug.debug( s );
		} else {
			//var time = Math.round(getTimer()/10)/100; // seconds
			//var msg = this.toString()+'('+time+'s) - ';
			var msg = this.toString();
			switch(s.substr(0,1)) {
				case '#':	Debug.info( msg + s.substr(1) );	break;
				case '*':	Debug.warn( msg + s.substr(1) );	break;
				case '!':	Debug.error( msg + s.substr(1) ); 	break;
				default:	Debug.debug( msg + s );
			}
		}
	} 
	
}
