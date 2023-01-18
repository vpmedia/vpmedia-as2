/**
 * com.sekati.convert.TempConversion
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Temperature Conversion utilities
 */
class com.sekati.convert.TempConversion {

	/**
	 * Convert fahrenheit to celsius
	 * @param f (Number) fahrenheit value
	 * @param p (Number) number of decimal after int '.' without round
	 * @return Number
	 */
	public static function f2c(f:Number, p:Number):Number {
		var d:String;
		var r:Number = (5 / 9) * (f - 32);
		var s:Array = r.toString( ).split( "." );
		if (s[1] != undefined) {
			d = s[1].substr( 0, p );
		} else {
			var i:Number = p;
			while (i > 0) {
				d += "0";
				i--;
			}
		}
		var c:String = s[0] + "." + d;
		return Number( c );		
	}

	/**
	 * Convert celsius to fahrenheit
	 * @param c (Number) celsius value
	 * @param p (Number) number of decimal after int '.' without round
	 * @return Number
	 */
	public static function c2f(c:Number, p:Number):Number {
		var d:String;
		var r:Number = (c / (5 / 9)) + 32;
		var s:Array = r.toString( ).split( "." );
		if (s[1] != undefined) {
			d = s[1].substr( 0, p );
		} else {
			var i:Number = p;
			while (i > 0) {
				d += "0";
				i--;
			}
		}
		var f:String = s[0] + "." + d;
		return Number( f );		
	}

	private function TempConversion() {
	}
}