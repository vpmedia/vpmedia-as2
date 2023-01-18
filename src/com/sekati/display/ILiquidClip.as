/**
 * com.sekati.display.ILiquidClip
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.IBaseClip;

/**
 * Interface describing {@link com.sekati.display.LiquidClip} and its subclips which add 
 * need to respond to {@link com.sekati.display.StageDisplay} events such as onResize or 
 * onResizeComplete.
 */
interface com.sekati.display.ILiquidClip extends IBaseClip {

	/**
	 * Triggered by {@link com.sekati.events.Dispatcher} upon StageResize.
	 * @return Void
	 */
	function _onResize():Void;

	/**
	 * Triggered by {@link com.sekati.events.Dispatcher} upon StageResizeComplete 
	 * as defined by {@link com.sekati.display.StageDisplay}.
	 * @return Void
	 */
	function _onResizeComplete():Void;
}