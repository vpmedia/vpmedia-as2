/**
 * com.sekati.crypt.LZW
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from ascrypt for dependencies only - version 1.1, author Mika Pamu
 * Original Flash port by Ash & Lalek & Shoebox and others.
 * @see http://www.razorberry.com/blog/archives/2004/08/22/lzw-compression-methods-in-as2/
 * @see http://www.lalex.com/blog/comments/200405/164-compression-lzw-actionscript-2.html
 */

import com.sekati.crypt.ICipher;

/**
 * Compresses and decompresses text with the LZW algorithm.
 */
class com.sekati.crypt.LZW implements ICipher {

	/**
	 * Compresses the specified text.
	 * @param src (String)
	 * @return String
	 */
	public static function compress(src:String):String {
		var chars:Number = 256;
		var original:String = src;
		var dict:Array = new Array( );
		var i:Number;
		var xstr:String;
		for (i = 0; i < chars ; i++) dict[String( i )] = i;
		var result:String = new String( "" );
		var splitted:Array = original.split( "" );
		var buffer:Array = new Array( );
		for (i = 0; i <= splitted.length ; i++) {
			var current:String = splitted[i];
			if (buffer.length == 0) xstr = String( current.charCodeAt( 0 ) );
			else xstr = buffer.join( "-" ) + "-" + String( current.charCodeAt( 0 ) );
			if (dict[xstr] !== undefined) {
				buffer.push( current.charCodeAt( 0 ) );
			} else {
				result += String.fromCharCode( dict[buffer.join( "-" )] );
				dict[xstr] = chars;
				chars++;
				delete buffer;
				buffer = new Array( );
				buffer.push( current.charCodeAt( 0 ) );
			}
		}
		return result;
	}

	/**
	 * Decompresses the specified text.
	 * @param src (String)
	 * @return String 
	 */
	public static function decompress(src:String):String {
		var chars:Number = 256;
		var dict:Array = new Array( );
		var i:Number;
		for (i = 0; i < chars ; i++) {
			var c:String = String.fromCharCode( i );
			dict[i] = c;
		}
		var original:String = src;
		var splitted:Array = original.split( "" );
		var buffer:String = new String( "" );
		var chain:String = new String( "" );
		var result:String = new String( "" );
		for (i = 0; i < splitted.length ; i++) {
			var code:Number = original.charCodeAt( i );
			var current:String = dict[code];
			if (buffer == "") {
				buffer = current;
				result += current;
			} else {
				if (code <= 255) {
					result += current;
					chain = buffer + current;
					dict[chars] = chain;
					chars++;
					buffer = current;
				} else {
					chain = dict[code];
					if (chain == undefined) chain = buffer + buffer.slice( 0, 1 );
					result += chain;
					dict[chars] = buffer + chain.slice( 0, 1 );
					chars++;
					buffer = chain;
				}
			}
		}
		return result;
	}

	private function LZW() {
	}
}