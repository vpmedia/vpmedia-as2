import com.bumpslide.util.*;
import com.bumpslide.data.*;
import com.bumpslide.events.*;
import mx.events.EventDispatcher;
import org.asapframework.util.FrameDelay;

/**
* Bumpslide-specific base class for movie clips
* 
* Adds support for stage proxy and various shortcut methods.
* All apps should have a BaseClip class that extends this one.  
* 
* Copyright (c) 2006, David Knape and contributing authors
* Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
* 
* @author David Knape
*/
  
class com.bumpslide.core.BaseClip extends MovieClip
{		
	// clip name
	private var mName	: String;
	
	// reference to this clip (for asapframework compatibility)
	private var mMc	: MovieClip;
	
	// whether or not to show debug messages for this class
	private var mDebug : Boolean = true;
	
	// stage proxy
	private var stage : StageProxy;
	
	// should be true for all resizable apps
	// set to false in app base clip (subclass of this class)
	// if you want keep stage proxy from initializing
	private var _useStageProxy : Boolean = true;
	
	// ASAP Framework FrameDelay instance used for onEnterFrameCall
	private var _fd:FrameDelay;
	
	// EventDispatcher mix-in functions
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	// shortcuts...
	
	// auto-scoped delegate ( or Delegate.create )
	private var d:Function;	
	
	
	// remember, shortcuts to shortcuts can make for unreadable code... 
	// onEnterFrameCall( func )
	//private var ec:Function;	
	
	// debug/trace
	//private var t:Function;
	
	/**
	* Tweening API stubs
	*/
	var tween:Function;
	var isTweening:Function;
	var stopTween:Function;
	var colorTo:Function;
	var alphaTo:Function;
	var sizeTo:Function;
	var slideTo:Function;
	
	
	/**
	* Base Clip Constructor
	*/
	function BaseClip() 
	{		
		// save local copy for convenience sake and ASAP compatability
		mMc = MovieClip(this);
		
		// disable tab and focusrect by default
		_focusrect = false;
		tabEnabled = false;
		
		// initialize event dispatcher
		EventDispatcher.initialize(this);
		
		// store local name (ASAP style)
		if(mName==null) mName = _name;
						
		// listen to stage proxy events (for resizable apps)
		if(_useStageProxy) {
			stage = StageProxy.getInstance();
			stage.addEventListener( StageProxy.ON_RESIZE_EVENT, this );
		}
		
		d = delegate;
		//ec = onEnterFrameCall;
		//t = debug;
	}
	
	private function onLoad() {	
		onStageResize();
	}
	
	private function onUnload() {
		stage.removeEventListener( StageProxy.ON_RESIZE_EVENT, this );
		cancelEnterFrameCall();
	}	
	
	/**
	* Show
	* 
	* @param	delay
	* @param	speed
	* @param	onComplete
	*/
	public function show(delay:Number, fadeSpeed:Number, onComplete:Function) {
		_visible = true;
		if(fadeSpeed==null) fadeSpeed = .5;
		if(delay==null) delay = 0;	
		_hideShowCompleteFunc = onComplete;
		stopTween();
		alphaTo( 100, fadeSpeed, 'easeOutQuad', delay, d(onHideComplete) );		
	}	
	
	/**
	* Hide 
	* 
	* @param	delay
	* @param	fadeSpeed
	* @param	onComplete
	*/
	public function hide(delay:Number, fadeSpeed:Number, onComplete:Function) {
		if(fadeSpeed==null) fadeSpeed = 0;
		if(delay==null) delay = 0;
		_hideShowCompleteFunc = onComplete;
		stopTween();
		alphaTo( 0, fadeSpeed, 'easeInQuad', delay, d(onHideComplete) );		
	}
		
	private var _hideShowCompleteFunc:Function = null;
	
	private function onHideComplete() {
		if(_hideShowCompleteFunc!=null) _hideShowCompleteFunc.call( this );
		if(_alpha==0) _visible = false;
	}
	
	/**
	* Colorize shortcut
	* 
	* @param	mc
	* @param	color
	*/
	function colorize(mc:MovieClip, color:Number) {
		var c:Color = new Color( mc );
		c.setRGB( color );		
	}
	
	/*
	* Dispatches a controller command event with automatic listener setup
	* 
	* 
	*/
	function runCommand( commandName:String, argument:Object ) {		
		var localController = this['mController'];
		if(localController==undefined) {
			debug('!no controller defined to run command '+commandName);
			return;
		}
		addEventListener( commandName, localController );
		dispatchEvent( new CommandEvent(commandName, this, argument ) );
		removeEventListener( commandName, localController );
	}
	
	/**
	* Default StageProxy event handler
	* 
	* @param	e
	*/
	private function onStageResize( e:StageResizeEvent ) 
	{
	
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
		_fd.die();
		_fd = new FrameDelay(this, func, 1, arguments.slice(1));
	}
	
	/**
	 * Cancels pending onEnterFrameCall function
	 */
	function cancelEnterFrameCall() {
		_fd.die();
	}
	
	/**
	 *  Overrides toString method to customize for this app
	 */
	function toString () {
		return "["+mName+"] ";
	}	
	
	/**
	* Custom logging/trace util
	* @param	s
	*/
	function debug(s) {
		if(!mDebug) return;
		Debug.trace.apply( null, arguments );
		return;
		/*
		if(typeof(s)=='object') {
			Debug.debug( s );
		} else {
			var time = Math.round(getTimer())/1000; // seconds
			var msg = this.toString()+'('+time+') - ';
			//var msg = this.toString();
			switch(s.substr(0,1)) {
				case '#':	Debug.info( msg + s.substr(1) );	break;
				case '*':	Debug.warn( msg + s.substr(1) );	break;
				case '!':	Debug.error( msg + s.substr(1) ); 	break;
				default:	Debug.debug( msg + s );
			}
		}*/
	} 
	
	

	 
	
	
}
