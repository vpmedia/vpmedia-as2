/**
 * com.sekati.display.LiquidYClip
 * @version 1.0.5
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.LiquidClip;
import com.sekati.math.MathBase;

/**
 * LiquidYClip - maintain a bottom-aligned clip positioning.
 */
class com.sekati.display.LiquidYClip extends LiquidClip {

	private var _liquid:MovieClip;
	private var _yoffset:Number;
	private var _ymin:Number;

	/**
	 * Constructor
	 */
	public function LiquidYClip() {
		super( );
		_yoffset = 0;
		_ymin = 0;
	}

	/**
	 * Position ({@code _liquid = this; // default can be overriden by subclass}) right taking into account {@code _yoffset, _ymin}.
	 */
	private function _onResize():Void {
		_liquid._y = MathBase.constrain( int( Stage.height - _liquid._height - _yoffset ), _ymin - _liquid._height, Stage.height );
	}	
}