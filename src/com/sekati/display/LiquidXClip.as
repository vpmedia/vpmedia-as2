/**
 * com.sekati.display.LiquidXClip
 * @version 1.0.5
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.LiquidClip;
import com.sekati.math.MathBase;

/**
 * LiquidXClip - maintain a right-aligned clip positioning.
 */
class com.sekati.display.LiquidXClip extends LiquidClip {

	private var _liquid:MovieClip;
	private var _xoffset:Number;
	private var _xmin:Number;

	/**
	 * Constructor
	 */
	public function LiquidXClip() {
		super( );
		_liquid = _this;
		_xoffset = 0;
		_xmin = 0;
	}

	/**
	 * Position ({@code _liquid = this; // default can be overriden by subclass}) right taking into account {@code _xoffset, _xmin}.
	 * @return Void
	 */
	private function _onResize():Void {
		_liquid._x = MathBase.constrain( int( Stage.width - _liquid._width - _xoffset ), _xmin, Stage.width );
	}
}