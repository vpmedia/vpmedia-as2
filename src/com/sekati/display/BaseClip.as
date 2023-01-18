/**
 * com.sekati.display.BaseClip
 * @version 1.1.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.IBaseClip;
import com.sekati.display.ITweenClip;
import com.sekati.core.KeyFactory;
import com.sekati.except.IllegalArgumentException;
import com.sekati.reflect.Stringifier;
import com.sekati.utils.MovieClipUtils;
import com.sekati.validate.TypeValidation;
import caurina.transitions.Tweener;

/**
 * This is the foundational MovieClip class and should be
 * thought of as the main building block of the SASAPI framework.
 * @see {@link com.sekati.display.CoreClip}
 */
class com.sekati.display.BaseClip extends MovieClip implements IBaseClip, ITweenClip {

	private var _this:MovieClip;
	private var __isClean:Boolean;

	public function BaseClip() {
		_this = this;
		__isClean = false;
		KeyFactory.inject( _this );
	}

	/**
	 * if destroy hasnt already been called manually
	 * run it onUnload.
	 */
	public function onUnload():Void {
		if(!__isClean) {
			destroy( );
		}	
	}

	/**
	 * Destroy object elements and events for proper garbage collection.
	 * This is a generic destroy method to insure that, at a minimum, the 
	 * enterFrame and clip itself are removed when destroy is called. 
	 * This behavior can be overwritten by BaseClip's subclasses. 
	 * If you wish to use BaseClip's destroy in addition to your subclass 
	 * destroy you may do so via: 
	 * {@code
	 * 	super.destroy(); 
	 * }
	 */	
	public function destroy():Void {
		__isClean = true;
		_this.onEnterFrame = null;
		/*
		 * VERY DANGEROUS BUGS CAN OCCUR WHEN EXTENDING 
		 * BASECLIP WITH THIS LOOP INCLUDED!
		for(var i in _this) {
		MovieClipUtils.rmClip(_this[i]);	
		}
		 */
		MovieClipUtils.rmClip( _this );		
	}

	/**
	 * Built-in {@link com.sekati.transitions.Tweener.addTween} wrapper. The method 
	 * accepts either one argument (TweenerObject) or two arguments (target, TweenerObject).
	 * {@code Usage:
	 * 	tween({_x:100, time:1, transition:"linear"});
	 * 	tween(someOtherMc, {_x:100, time:1, transition:"linear"});
	 * }
	 * @see {@link http://hosted.zeh.com.br/tweener/docs/en-us/}
	 * @return Void
	 */
	public function tween():Void {
		if (arguments.length == 1) {
			Tweener.addTween( _this, arguments[0] );
		} else if (TypeValidation.isMovieClip( arguments[0] ) || TypeValidation.isTextField( arguments[0] )) {
			Tweener.addTween( arguments[0], arguments[1] );	
		} else {
			throw new IllegalArgumentException( this, "BaseClip.tween requires either (tweenerObject) or (target, tweenerObject) arguments.", arguments );
		}
	}

	/**
	 * Remove any or all Tweener tweens on the instance object using arguments array.
	 * @param arguments
	 * @return Void
	 */
	public function stopTween():Void {
		var args:Array = [ _this ];
		for (var i:Number = 0; i < arguments.length ; i++) {
			args.push( arguments[i] );
		}
		Tweener.removeTweens.apply( this, args );
	}

	/**
	 * return reflective output
	 * @return String
	 */	
	public function toString():String {
		return Stringifier.stringify( this );
	}
}