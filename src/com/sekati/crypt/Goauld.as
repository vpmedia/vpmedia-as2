/**
 * com.sekati.crypt.Goauld
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from ascrypt for dependencies only - version 2.0, author Mika Pamu
 */

import com.sekati.crypt.ICipher;

/**
 * Encodes and decodes a Goauld string.
 */
class com.sekati.crypt.Goauld implements ICipher {

	public static var shiftValue:Number = 6;

	/**
	 * Encodes and decodes a Goauld string with the character code shift value.
	 * @param src (String)
	 * @return String  
	 */
	public static function calculate(src:String):String {
		var result:String = new String( "" );
		for (var i:Number = 0; i < src.length ; i++) {
			var charCode:Number = src.substr( i, 1 ).charCodeAt( 0 );
			result += String.fromCharCode( charCode ^ shiftValue );
		}
		return result;
	}

	private function Goauld() {
	}
}