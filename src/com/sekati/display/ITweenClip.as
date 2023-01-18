/**
 * com.sekati.display.ITweenClip
 * @version 1.0.2
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.IBaseClip;
/**
 * Interface describing {@link com.sekati.display} clips which add 
 * prototypical (mc_tween2-like) tween functionality via mix-in.
 * @see {@link http://tweener.googlecode.com}
 */
interface com.sekati.display.ITweenClip extends IBaseClip {
	/**
	 * wraps {@link com.sekati.transitions.Tweener.addTween}
	 * @return Void
	 */
	function tween():Void;
	/**
	 * wrap {@link com.sekati.transitions.Tweener.removeTweens}
	 * @return Void 
	 */
	function stopTween():Void;
}