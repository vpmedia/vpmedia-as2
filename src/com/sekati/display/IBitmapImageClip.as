/**
 * com.sekati.display.IBitmapImageClip
 * @version 1.0.2
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.IBaseClip;

/**
 * Interface describing {@link com.sekati.display.CoreClip} which
 * is the core UI building block class for all subclasses to
 * extend instead of {@link com.sekati.display.BaseClip}.
 */
interface com.sekati.display.IBitmapImageClip extends IBaseClip {

	/**
	 * load an image into the {@link com.sekati.display.BitmapImageClip} tmp container.
	 */
	function load(uri:String, isSmoothed:Boolean, onInit:Function, onProgress:Function, onError:Function):Void;

	/**
	 * Unload the img, bmp objects from the {@link com.sekati.display.ImageClip}
	 */
	function unload():Void;
}