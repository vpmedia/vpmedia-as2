/**
 * com.sekati.display.ICoreClip
 * @version 1.0.7
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
interface com.sekati.display.ICoreClip extends IBaseClip {

	/**
	 * handles the MovieClip.onLoad event which much call configUI
	 */
	function onLoad():Void;

	/**
	 * class method called once the clip has loadeded and been registered
	 * to configure the clip UI and initialize its behavior.
	 */
	function configUI():Void;
}