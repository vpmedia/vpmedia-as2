/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.types.Char;

/**
 * ECMA 262 Unicode IFormat-Control Characters tools.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.string.UnicodeChar ;
 * import vegas.core.types.Char ;
 *   
 * trace (UnicodeChar.WHITE_SPACE_CHARS.length) ;
 *   
 * var str:String = UnicodeChar.TAB + "coucou" ;
 * trace (str) ;
 *  
 * var s:Char = new Char('\t') ;
 * var b:Boolean = UnicodeChar.isWhiteSpace(s) ;
 * trace ("isWhiteSpace : " + b) ;
 *  
 * var unicode:String = "0040" ;
 * var char:Char = UnicodeChar.toChar(unicode) ;
 * trace(">> " + char) ;
 * }
 * @author eKameleon
 * @see <a href='http://www.ecma-international.org/publications/files/ECMA-ST/Ecma-262.pdf'>ECMAScript 262 specifications</a>
 */
class vegas.string.UnicodeChar 
{

	/**
	 * Back Slash utf8 representation (special char).
	 */
	static public var BACK_SLASH:String = "\u005C" ;	

	/**
	 * Back Space utf8 representation (special char).
	 */
	static public var BACK_SPACE:String = "\u0008" ;
	
	/**
	 * Simple Quote utf8 representation (special char).
	 */
	static public var SIMPLE_QUOTE:String = "\u0027" ;
	
	/**
	 * Double Quote utf8 representation (special char).
	 */
	static public var DOUBLE_QUOTE:String = "\u0022" ;
	
	/**
	 * Tab utf8 representation (whitespace).
	 */
	static public var TAB:String = "\u0009" ;

	/**
	 * Vertical Tab utf8 representation (whitespace).
	 */
	static public var VT:String = "\u000B" ;
	
	/**
	 * Form Feed utf8 representation (whitespace).
	 */
	static public var FF:String = "\u000C" ;
	
	/**
	 * Space utf8 representation (whitespace).
	 */
	static public var SP:String = "\u0020" ;

	/**
	 * No-break space utf8 representation (whitespace).
	 */
	static public var NBSP:String = "\u00A0" ;

	/**
	 * Array with all whitespace characters. NB : USP no implement (Any other Unicode "space separator")
	 */
	static public var WHITE_SPACE_CHARS:Array = [ TAB, VT, FF, SP, NBSP ] ;
	
	/**
	 * Line Feed utf8 representation (line terminators).
	 */
	static public var LF:String = "\u000A" ;

	/**
	 * Carriage Return utf8 representation (line terminators).
	 */
	static public var CR:String = "\u000D" ;

	/**
	 * Line Separator utf8 representation (line terminators).
	 */
	static public var LS:String = "\u2028" ;

	/**
	 * Paragraph Separator utf8 representation (line terminators).
	 */
	static public var PS:String = "\u2029" ;	

	/**
	 * Array with all line terminators characters
	 */
	static public var LINE_TERMINATOR_CHARS:Array = [ LF, CR, LS, PS ] ;
	
	
	static private var __ASPF__ = _global.ASSetPropFlags(UnicodeChar, null , 7, 7) ;
	
	/**
	 * Returns {@code true} of the specified character is a whitespace.
	 * @return {@code true} of the specified character is a whitespace.
	 */
	static public function isWhiteSpace( char:String ):Boolean 
	{
		var c:Char = new Char(char) ;
		var ar:Array = WHITE_SPACE_CHARS ;
		var l:Number = ar.length ;
		while (--l > -1) 
		{
			if (ar[l] == char) 
			{
				return true ;
			}
		}
		return false ;
	}

	/**
	 * Returns {@code true} of the specified character is a line terminator.
	 * @return {@code true} of the specified character is a line terminator.
	 */
	static public function isLineTerminators( char:String ):Boolean 
	{
		var c:Char = new Char(char) ;
		var ar:Array = LINE_TERMINATOR_CHARS ;
		var l:Number = ar.length ;
		while (--l > -1) 
		{
			if (ar[l] == char) 
			{
				return true ;
			}
		}
		return false ;
	}

	/**
	 * Converts a unicode representation and returns this char's string.
	 * @return The char of the unicode representation.
	 */
	static public function toChar( unicode:String ):Char 
	{
		return new Char(String.fromCharCode(parseInt( unicode, 16))) ;
	}

	/**
	 * Converts an unicode number value and returns this string representation.
	 * @return The string representation of a unicode number.
	 */
    static public function toUnicode(n:Number):String 
    {
		var hex:String = n.toString(16) ;
		while( hex.length < 4 )
		{
			hex = "0" + hex ;
		}
		return hex ;
	}

}