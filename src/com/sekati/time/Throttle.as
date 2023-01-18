/**
 * com.sekati.time.Throttle
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced/adapted from bumpslide lib
 */
 
import com.sekati.core.CoreObject;

/**
 * Throttle time between method calls
 * {@code Usage:
 * var stageUpdater = new Throttle(Delegate.create(this, update), 500);
 * function onResize() { stageUpdater.trigger(); }
 * function doUpdate() { trace("throttled method!"); }
 * }
 */
class com.sekati.time.Throttle extends CoreObject {

	private var _fn:Function;
	private var _delay:Number;
	private var _finalInt:Number = -1;
	private var _delayInt:Number = -1;
	private var _isThrottled:Boolean = false;
	private var _finalCallPending:Boolean = false;

	/**
	 * Constructor
	 * @param proxyFunc (Function) Function to throttle calls to
	 * @param ms (Number) millisecond delay between calls
	 */
	public function Throttle(proxyFunc:Function, msDelay:Number) {
		super( );
		_fn = proxyFunc;
		_delay = msDelay;
	}

	/**
	 * trigger call to method
	 */
	public function trigger():Void {	
		clearInterval( _finalInt );	
		if(_isThrottled) {
			//trace('[Throttle] Forcing Wait...');
			_finalCallPending = true;
			return;
		} else {
			_doFunctionCall( );
			_finalCallPending = false;
			_isThrottled = true;		
			clearInterval( _delayInt );
			_delayInt = setInterval( this, 'clearThrottle', _delay );
		}
	}

	/**
	 * clear throttling
	 */
	public function clearThrottle():Void {
		clearInterval( _delayInt );		
		_isThrottled = false;
		if(_finalCallPending) {
			//trace('[Throttle] Doing Final Call...');
			_doFunctionCall( );
		}
	}

	private function _doFunctionCall():Void {
		//trace('[Throttle] Calling Function at '+getTimer());
		_finalCallPending = false;
		_fn.call( null );		
	}

	/**
	 * Destroy instance.
	 */
	public function destroy():Void {
		clearThrottle( );
		super.destroy( );
	}	
}