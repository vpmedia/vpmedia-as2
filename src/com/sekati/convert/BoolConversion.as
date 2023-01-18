/**
 * com.sekati.convert.BoolConversion
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Boolean Conversion utilities
 */
class com.sekati.convert.BoolConversion {

	/**
	 * Convert string to boolean
	 * @param str (String) boolean string ("1", "true", "yes", "on")
	 * @return Boolean
	 * {@code Usage:
	 * 	var b:Boolean = BoolConversion.toBoolean("true");
	 * }
	 */
	public static function toBoolean(str:String):Boolean {
		var b:String = str.toLowerCase( );
		if (b == "1" || b == "true" || b == "yes" || b == "on") {
			return true;
		} else if ( b == "0" || b == "false" || b == "no" || b == "off") {
			return false;
		}
	}

	/**
	 * Convert boolean value to string
	 * @param b (Boolean)
	 * @return String
	 * {@code Usage:
	 * 	var str:String = BoolConversion.toString(true);
	 * }
	 */
	public static function toString(b:Boolean):String {
		var str:String = (b) ? "true" : "false";
		return str;
	}

	private function BoolConversion() {
	}
}