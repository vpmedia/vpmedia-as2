/**
 * com.sekati.crypt.Base8
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from ascrypt for dependencies only - version 2.0, author Mika Pamu
 */

import com.sekati.crypt.ICipher;

/**
 * Encodes and decodes a base8 (hex) string.
 */
class com.sekati.crypt.Base8 implements ICipher {

	/**
	 * Encodes a base8 string.
	 * @param src (String) - string to encode
	 * @return String 
	 */
	public static function encode(src:String):String {
		var result:String = new String( "" );
		for (var i:Number = 0; i < src.length ; i++) {
			result += src.charCodeAt( i ).toString( 16 );
		}
		return result;
	}

	/**
	 * Decodes a base8 string.
	 * @param src (String) - string to decode
	 * @return String 
	 */
	public static function decode(src:String):String {
		var result:String = new String( "" );
		for (var i:Number = 0; i < src.length ; i += 2) {
			result += String.fromCharCode( parseInt( src.substr( i, 2 ), 16 ) );
		}
		return result;
	}

	private function Base8() {
	}
}