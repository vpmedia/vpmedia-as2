/**
 * com.sekati.display.LiquidHClip
 * @version 1.0.5
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.LiquidClip;

/**
 * LiquidHClip - scale clip to Stage.height
 */
class com.sekati.display.LiquidHClip extends LiquidClip {

	private var _liquid:MovieClip;

	/**
	 * Constructor
	 */
	public function LiquidHClip() {
		super( );
		_liquid = _this;
	}

	/**
	 * Scales ({@code _liquid = this; // default can be overriden by subclass}) to Stage.height.
	 * @return Void
	 */
	public function _onResize():Void {
		_liquid._height = Stage.height;
	}	
}