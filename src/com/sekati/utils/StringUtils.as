
/**
 * com.sekati.utils.StringUtils
 * @version 1.3.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Static class wrapping various String utilities.
 */
class com.sekati.utils.StringUtils {

	/**
	 * search for key in string
	 * @param str (String)
	 * @param key (String)
	 * @return Boolean
	 */
	public static function search(str:String, key:String):Boolean {
		return (str.indexOf( key ) <= -1) ? false : true;
	}

	/**
	 * search for key in string - case insensitive.
	 * @param str (String)
	 * @param key (String)
	 * @return Boolean
	 */	
	public static function searchCaseInsensitive(str:String, key:String):Boolean {
		return StringUtils.search( str.toUpperCase( ), key.toUpperCase( ) );
	}	

	/**
	 * replace every instance of a string with something else
	 * @param str (String)
	 * @param oldChar (String)
	 * @param newChar (String)
	 * @return String
	 */
	public static function replace(str:String, oldChar:String, newChar:String):String {
		return str.split( oldChar ).join( newChar );
	}

	/**
	 * remove spaces
	 * @param str (String)
	 * @return String
	 */
	public static function removeSpaces(str:String):String {
		return replace( str, " ", "" );
	}

	/**
	 * remove tabs
	 * @param str (String)
	 * @return String
	 */
	public static function removeTabs(str:String):String {
		return replace( str, "	", "" );	
	}	

	/**
	 * remove spaces at end and beginning of the string only
	 * @param str (String)
	 * @return String
	 */
	public static function trim(str:String):String {
		var index0:Number = 0;
		while (str.charAt( index0 ) == " ") {
			index0++;
		}
		var index1:Number = str.length - 1;
		while (str.charAt( index1 ) == " ") {
			index1--;
		}
		return str.substring( index0, index1 + 1 );
	}

	/**
	 * remove spaces  tabs, line feeds, carrige returns from string
	 * @param str (String)
	 * @return String
	 */
	public static function xtrim(str:String):String {
		var o:String = new String( );
		var TAB:Number = 9;
		var LINEFEED:Number = 10;
		var CARRIAGE:Number = 13;
		var SPACE:Number = 32;
		for (var i:Number = 0; i < str.length ; i++) {
			if (str.charCodeAt( i ) != SPACE && str.charCodeAt( i ) != CARRIAGE && str.charCodeAt( i ) != LINEFEED && str.charCodeAt( i ) != TAB) {
				o += str.charAt( i );
			}
		}
		return o;
	}

	/**
	 * trim spaces and camel notate string
	 * @param str (String)
	 * @return String
	 */
	public static function trimCamel(str:String):String {
		var o:String = new String( );
		for (var i:Number = 0; i < str.length ; i++) {
			if (str.charAt( i ) != " ") {
				if (justPassedSpace) {
					o += str.charAt( i ).toUpperCase( );
					justPassedSpace = false;
				} else {
					o += str.charAt( i ).toLowerCase( );
				}
			} else {
				var justPassedSpace:Boolean = true;
			}
		}
		return o;
	}

	/**
	 * format a number with commas - ie. 10000 -> 10,000
	 * @param inNum (Object) String or Number
	 * @return String
	 */
	public static function commaFormatNumber(inNum:Object):String {
		var tmp:String = String( inNum );
		//step through backwards and insert commas
		var outString:String = "";
		var l:Number = tmp.length;
		for (var i:Number = 0; i < l ; i++) {
			if (i % 3 == 0 && i > 0) {
				//insert commas
				outString = "," + outString;
			}
			outString = tmp.substr( l - (i + 1), 1 ) + outString;
		}
		return outString;		
	}

	/**
	 * Capitalize the first character in the string.
	 * @param str (String)
	 * @return String
	 */
	 
	public static function firstToUpper(str:String):String {
		return str.charAt( 0 ).toUpperCase( ) + str.substr( 1 );
	}	

	/**
	 * encode html
	 * @param str (String)
	 * @return String
	 */
	public static function htmlEncode(str:String):String {
		var s:String = str, a:Object = new String( );
		a = s.split( "&" ), 
		s = a.join( "&amp;" );
		a = s.split( " " ), 
		s = a.join( "&nbsp;" );
		a = s.split( "<" ), 
		s = a.join( "&lt;" );
		a = s.split( ">" ), 
		s = a.join( "&gt;" );
		a = s.split( '"' ), 
		s = a.join( "&quot;" );
		return s;
	}

	/**
	 * decode html
	 * @param t (String)
	 * @return String
	 */
	public static function htmlDecode(t:String):String {
		t = t.split( "&reg;" ).join( "¨" );
		t = t.split( "&copy;" ).join( "©" );
		t = t.split( "&rsquo;" ).join( "'" );
		t = t.split( "&ldquo;" ).join( '"' );
		t = t.split( "&rdquo;" ).join( '"' );
		t = t.split( "&hellip;" ).join( '...' );
		t = t.split( "&middot;" ).join( '*' );
		t = t.split( "&ndash;" ).join( '-' );
		t = t.split( "&trade;" ).join( '(TM)' );
		t = t.split( "&egrave;" ).join( );
		t = t.split( "&eacute;" ).join( 'Ž.' );
		t = t.split( "&bull;" ).join( '-' );
		t = t.split( "&amp;" ).join( "&" );
		return t;
	}

	/**
	 * strip the zero off floated numbers
	 * @param n (Number)
	 * @return String
	 */	
	public static function stripZeroOnFloat(n:Number):String {
		var str:String = "";
		var a:Array = String( n ).split( "." );
		if (a.length > 1) {
			str = (a[0] == "0") ? "." + a[1] : String( n );
		} else {
			str = String( n );
		}
		return str;
	}

	/**
	 * add zero in front of floated number
	 * @param n (Number)
	 * @return String
	 */
	public static function padZeroOnFloat( n:Number ):String {
		return ( n > 1 || n < 0 ) ? String( n ) : ( "0." + String( n ).split( "." )[1] );	
	}

	/**
	 * Remove scientific notation from very small floats when casting to String.
	 * @param n (Number)
	 * @return String
	 * {@code Usage: 
	 * 	trace( String(0.0000001) ); // returns 1e-7
	 * 	trace( floatToString(0.0000001) ); // returns .00000001
	 * }
	 */
	public static function floatToString(n:Number):String {
		var s:String = String( n );
		return (n < 1 && (s.indexOf( "." ) <= -1 || s.indexOf( "e" ) <= -1)) ? "0." + String( n + 1 ).split( "." )[1] : s;
	}

	/**
	 * strip the zero off floated numbers and remove Scientific Notation
	 * @param n (Number)
	 * @return String
	 */
	public static function stripZeroAndRepairFloat(n:Number):String {
		var str:String;
		var tmp:String;
		var isZeroFloat:Boolean;
		// +=1 to prevent scientific notation.
		if(n < 1) {
			tmp = String( (n + 1) );
			isZeroFloat = true;
		} else {
			tmp = String( n );
			isZeroFloat = false;	
		}
		// if we have a float strip the zero (or +=1) off!
		var a:Array = tmp.split( "." );
		if (a.length > 1) {
			str = (a[0] == "1" && isZeroFloat == true) ? "." + a[1] : tmp;
		} else {
			str = tmp;
		}
		return str;
	}

	/**
	 * Generate a set of random characters
	 * @param amount (Number)
	 * @return String
	 */
	public static function randChar(amount:Number):String {
		var str:String = "";
		for(var i:Number = 0; i < amount ; i++) str += chr( Math.round( Math.random( ) * (126 - 33) ) + 33 );
		return str;
	}

	/**
	 * Generate a set of random LowerCase characters
	 * @param amount (Number)
	 * @return String
	 */	
	public static function randLowerChar(amount:Number):String {
		var str:String = "";
		for(var i:Number = 0; i < amount ; i++) str += chr( Math.round( Math.random( ) * (122 - 97) ) + 97 );
		return str;
	}

	/**
	 * Generate a set of random Number characters
	 * @param amount (Number)
	 * @return String
	 */		
	public static function randNum(amount:Number):String {
		var str:String = "";
		for(var i:Number = 0; i < amount ; i++) str += chr( Math.round( Math.random( ) * (57 - 48) ) + 48 );
		return str;
	}

	/**
	 * Generate a set of random Special and Number characters
	 * @param amount (Number)
	 * @return String
	 */		
	public static function randSpecialChar(amount:Number):String {
		var str:String = "";
		for(var i:Number = 0; i < amount ; i++) str += chr( Math.round( Math.random( ) * (64 - 33) ) + 33 );
		return str;
	}	

	/**
	 * strip html markup tags
	 * @param str (String)
	 * @return String
	 */
	public static function stripTags(str:String):String {
		var s:Array = new Array( );
		var c:Array = new Array( );
		for (var i:Number = 0; i < str.length ; i++) {
			if (str.charAt( i ) == "<") {
				s.push( i );
			} else if (str.charAt( i ) == ">") {
				c.push( i );
			}
		}
		var o:String = str.substring( 0, s[0] );
		for (var j:Number = 0; j < c.length ; j++) {
			o += str.substring( c[j] + 1, s[j + 1] );
		}
		return o;
	}

	/**
	 * detect html breaks
	 * @param str (String)
	 * @return Boolean
	 */
	public static function detectBr(str:String):Boolean {
		return (str.split( "<br" ).length > 1) ? true : false;
	}

	/**
	 * convert single quotes to double quotes
	 * @param str (String)
	 * @return String
	 */
	public static function toDoubleQuote(str:String):String {
		var sq:String = "'";
		var dq:String = String.fromCharCode( 34 );
		return str.split( sq ).join( dq );
	}

	/**
	 * convert double quotes to single quotes
	 * @param str (String)
	 * @return String
	 */
	public static function toSingleQuote(str:String):String {
		var sq:String = "'";
		var dq:String = String.fromCharCode( 34 );
		return str.split( dq ).join( sq );
	}

	/**
	 * Remove all formatting and return cleaned numbers from string.
	 * @param str (String)
	 * @return String
	 * {@code Usage: 
	 * 	StringUtils.toNumeric("123-123-1234"); // returns 1221231234 
	 * }
	 */
	public static function toNumeric(str:String):String {
		var len:Number = str.length;
		var result:String = "";
		for (var i:Number = 0; i < len ; i++) {
			var code:Number = str.charCodeAt( i );
			if (code >= 48 && code <= 57) {
				result += str.substr( i, 1 );
			}
		}
		return result;
	}

	private function StringUtils() {
	}	
}