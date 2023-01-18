/**
 * com.sekati.display.LiquidWClip
 * @version 1.0.5
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.LiquidClip;

/**
 * LiquidWClip - scale clip to Stage.width
 */
class com.sekati.display.LiquidWClip extends LiquidClip {

	private var _liquid:MovieClip;

	/**
	 * Constructor
	 */
	public function LiquidWClip() {
		super( );
		_liquid = _this;
	}

	/**
	 * Scales ({@code _liquid = this; // default can be overriden by subclass}) to Stage.width.
	 * @return Void
	 */	
	public function _onResize():Void {
		_liquid._width = Stage.width;
	}	
}