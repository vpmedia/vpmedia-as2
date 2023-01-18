/**
 * com.sekati.effects.Typo
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Typo Text Effects
 */
class com.sekati.effects.Typo {

	/**
	 * Generate a set of random characters
	 * @param x (Number) of characters to generate
	 * @param n (Boolean) character set
	 * @return String
	 */
	private static function genChars(x:Number,n:Boolean):String {
		var str:String = "";
		var sc:Number,ec:Number;
		if(n == true) { 
			sc = 33; 
			ec = 64; 
		} else { 
			sc = 33; 
			ec = 126; 
		}	
		for(var i:Number = 0; i < x ; i++) { 
			str += chr( Math.round( Math.random( ) * (ec - sc) ) + sc ); 
		}
		return str;
	}

	/**
	 * Detect spaces in one string and insert them into the other
	 * @param s1 (String) pull spaces from
	 * @param s2 (String) insert spaces in to
	 * @return String
	 * {@code Usage:
	 * 	var foobar:String = Typo.commonSpace("Foo Foo Foo", "Bar*Bar*Bar"); // returns "Bar Bar Bar"
	 * }
	 */
	private static function commonSpace(s1:String,s2:String):String {
		var str:String = "";
		for (var i:Number = 0; i < s2.length ; i++) {
			str += (s1.charAt( i ) == " ") ? " " : s2.charAt( i );
		}
		return str;
	}

	public static function writein():Void {
	}

	public static function writeout():Void {
	}	

	private function Typo() {
	}
}