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

import vegas.core.CoreObject;
import vegas.string.UnicodeChar;
import vegas.util.StringUtil;

/**
 * A wild expression is constructed like a regular expression but is based on a globbing algorithm like the one you found for searching files on a hard-drive.
 * <p><b>Syntax :</b>
 * 	<p>1. ? : match any unique char - exactly 1 char must be found</p>
 * 	<p>2. * : match any number of chars - at least 0 or more any chars can be found</p>
 * 	<p>3. ! : ignore next char</p>
 * </p>
 * <p><b>Rules :</b>
 *	<p>1. "*" is equal to "**" to "***" to an infinity number of "*" chars</p>
 *	<p>2. "*?" is concatened to "*" (more precisely "*?*")</p>
 *	<p>3. "*" if for zero char to infinity chars</p>
 *	<p>4. "!*" ignore the pattern and look for the char "*" in string</p>
 *	<p>5. "!?" ignore the pattern and look for the char "?" in string</p>
 *	</p>
 *	<p><b>Tips and tricks :</b>
 *	
 *	<p><b>1. find all the words in a string</b>
 *	{@code 
 *	import vegas.string.WildExp ;
 *	var we:WildExp = new WildExp( "*", WildExp.IGNORECASE | WildExp.MULTIWORD );
 *	result = we.test( "any phrases with words inside" );
 *	//result = [ "any", "phrases", "with", "words", "inside" ];
 *	}
 *	</p>
 *	<p><b>2. find comments in a string</b>
 *	{@code 
 *	import vegas.string.WildExp ;
 *	var we:WildExp = new WildExp( "*\/!**!*!/\*", WildExp.IGNORECASE | WildExp.MULTIWORD );
 *	result = we.test( "toto = \"123\"; /\*hello world*\/" );
 *	//result = [ "toto = \"123\"; ", "hello world" ] ;
 *	}
 *	</p>
 *	<p><b>3. find the name, arguments and body of a function</b>
 *	{@code 
 *	import vegas.string.WildExp ;
 *	var we:WildExp = new WildExp( "function *(*)*{*}", WildExp.IGNORECASE | WildExp.MULTIWORD );
 *	result = we.test( "function toto( a, b, c )\r\n{\treturn \"hello world\";\r\n\t}" );
 *	//result = [ "toto", " a, b, c ", "\r\n", "\treturn \"hello world\";\r\n\t" ];
 *	}
 *	</p>
 *	<p>Thanks Zwetan : <a href='http://groups.google.com/group/FCNG/browse_thread/thread/467e11b594bb180d/4baedfcc0d2cd95f?lnk=st&q=%5BFMX%5D+WildExp&rnum=1#4baedfcc0d2cd95f'>WildExp in FCNG</a></p>
 *	
 *	@see vegas.string.StringUtil replace() method
 *	@see vegas.string.UnicodeChar WHITE_SPACE_CHARS and LINE_TERMINATOR_CHARS constants
 *	@author eKameleon
 */
class vegas.string.WildExp extends CoreObject 
{

	/**
	 * Creates a new WildExp instance.
	 */
	public function WildExp (pattern:String, flag:Number) 
	{
		
		if( isNaN(flag) ) 
		{
			flag = NONE ;
		}
       	wildcards = [] ;
		questionMarks = [] ;
		
		_caseSensitive = true ;
		_multiline = false ;
		_multiword = false ;
		_wildcardFound = false;
		_questionMarksFound = false ;
    
		switch(flag) 
		{
        	case IGNORECASE : // 1
        	{
				_caseSensitive = false ;
				break ;
        	}
        	case MULTILINE :
        	{
				_multiline = true ; // 2
				break ;
        	}
			case IGNORECASE | MULTILINE : // 3
			{
				_caseSensitive = false ;
				_multiline = true ;
				break ;
			}
			case MULTIWORD : // 4
			{
				_multiword = true ;
				break ;
			}
			case IGNORECASE | MULTIWORD : // 5
			{
				_caseSensitive = false ;
				_multiword = true ;
				break ;
			}
			case MULTILINE | MULTIWORD : // 6
			{
				_multiline = true ;
				_multiword = true ;
				break ;
			}
			case IGNORECASE | MULTILINE | MULTIWORD : // 7
			{
				_caseSensitive = false ;
				_multiline = true ;
				_multiword = true ;
				break ;
			}
			case NONE : 
			default :
			{
				
			}
        }
		
		if( _caseSensitive ) {
			pattern = pattern.toLowerCase();
		}
        
		source = pattern ;
    
    }
	
	/**
	 * const the NONE value (0).
	 */	
	static public var NONE:Number = 0 ;

	/**
	 * const the IGNORECASE value (1).
	 */	
	static public var IGNORECASE:Number = 1 ;

	/**
	 * const the MULTILINE value (2).
	 */	
	static public var MULTILINE:Number = 2 ;
	
	/**
	 * const the MULTIWORD value (4).
	 */	
	static public var MULTIWORD:Number = 4 ;

	static private var __ASPF__ = _global.ASSetPropFlags(WildExp, null , 7, 7) ;

	/**
	 * The array of all wildcards.
	 */		
	public var wildcards:Array ;
	
	/**
	 * The array of all question marks.
	 */
	public var questionMarks:Array ;
	
	/**
	 * The source of this wildcard.
	 */
	public var source:String ;
	
	/**
	 * Adds a caracter in the questionMarks array, only if the array isn't empty.
	 */
	public function addToQuestionMarks(chr:String):Void 
	{
		var l:Number = questionMarks.length ;
		if( l == 0 ) return ;
        questionMarks[l-1] += chr ;
    }
	
	/**
	 * Adds a caracter in the wildcards array, only if the array isn't empty.
	 */
	public function addToWildcards(chr:String):Void 
	{
		var l:Number = wildcards.length ;
		if( l == 0 ) return ;
		wildcards[l-1] += chr ;
    }

	/**
	 * Test the specific expression in argument.
	 */
	public function test(str:String) 
	{
		var segment, result:Array ;
		var i, j, k, l:Number ;
		var ORC:String  = "\uFFFC";
		var CRLF:String = "\r\n";
		if( _caseSensitive ) str = str.toLowerCase();
        if(_multiline) {
			var lineTerminatorChars:Array = UnicodeChar.LINE_TERMINATOR_CHARS ;
			if( str.indexOf( CRLF ) > -1 ) 
			{
				str = StringUtil.replace(str, CRLF, ORC ) ;
			}
			l = lineTerminatorChars.length ;
			for( i=0 ; i<l ; i++ ) 
			{
				if( str.indexOf( lineTerminatorChars[i] ) > -1 ) 
				{
					str = StringUtil.replace(str, lineTerminatorChars[i], ORC ) ;
				}
            }
        }
		if( _multiword ) 
		{
			var whiteSpaceChars:Array = UnicodeChar.WHITE_SPACE_CHARS ; 
			l = whiteSpaceChars.length ;
			for( j=0 ; j<l ; j++ ) 
			{
				if( str.indexOf( whiteSpaceChars[j] ) > -1 ) 
				{
					str = StringUtil.replace(str, whiteSpaceChars[j], ORC ) ;
				}
            }
        }
		if( str.indexOf( ORC ) > -1 ) 
		{
			segment = str.split( ORC ) ;
			result = [] ;
			l = segment.length ;
			for( k=0 ; k<l ; k++ ) 
			{
				if( _testMatch( segment[k], source ) ) result.push( segment[k] ) ;
		    }
			return ( result.length > 0 ) ? result : false ;
        }
		return _testMatch( str, source ) ;
    }

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */	
	public function toString():String 
	{
		return source ;
	}
	
	private var _caseSensitive:Boolean ;

	private var _multiline = false ;

	private var _multiword = false ;

	private var _wildcardFound = false;

	private var _questionMarksFound = false;
	
	private function _testMatch(str:String, pattern:String, ignoreChar:String ):Boolean 
	{
		
		str = new String(str) ;
		pattern = new String(pattern) ;
				
		var c, c1, pat, pat1:String ;
		c = str.charAt( 0 ) ;
		c1 = str.charAt( 1 ) ;
		pat = pattern.charAt( 0 ) ;
		pat1 = pattern.charAt( 1 ) ;
    
		if( pat != "?" ) _questionMarksFound = false ;
        if( pat == "!" ) return _testMatch( str, pattern.substr( 1 ), pat1 );
        
		if( pat == "?" && ignoreChar != "?" ) 
		{
			if( c != "" ) 
			{
				if( _questionMarksFound ) addToQuestionMarks( c );
                else questionMarks.push( c ) ;
				_questionMarksFound = true ;
				if ((pat1 == "") && (_wildcardFound == true)) pattern += "*" ;
                return _testMatch( str.substr( 1 ), pattern.substr( 1 ) ) ;
            } 
            else 
            {
				return false ;
            }
        }
		
		if( pat == "*" && ignoreChar != "*" ) 
		{
			_wildcardFound = true ;
			if( pat1 != "*" ) wildcards.push( "" );
            if( pat1 == "" ) 
            {
				addToWildcards( str ) ;
				return true ;
            }
			if( pattern.substr(1).indexOf( "*" ) > -1 ) 
			{
				while( str != "" ) 
				{
					if( pat1 == "*" ) break ;
					if( pat1 == "?" ) 
					{
						pattern = pattern.substr(1) ;
						break ;
					}
					if( str == "" ) return false ;
					if( str.charAt(0) == pat1 ) break ;
					if( pat1 == "!" ) 
					{
						ignoreChar = pattern.charAt( 2 ) ;
						pattern = pattern.substr( 2 ) ;
						pat1 = pattern.charAt( 1 ) ;
					}
					if( str.charAt(0) == ignoreChar ) 
					{
						str = str.substr(1) ; continue ;
					}
					addToWildcards( str.charAt( 0 ) ) ;
					str = str.substr(1) ;
				}
				return _testMatch( str, pattern.substr( 1 ), ignoreChar ) ;
			} 
			else 
			{
				var found:Number = str.lastIndexOf( pat1 ) ;
				if( found != -1 ) 
				{
					addToWildcards( str.substring( 0, found ) ) ;
					return _testMatch( str.substr( found ), pattern.substr( 1 ) ) ;
                }
                else if( pat1 == "?" ) 
                {
					if( pattern.charAt(2) == "" ) return str.length >= 1 ;
                    else return _testMatch( str.substr( 1 ), pattern.substr( 1 ) );
                }
				return false;
            }
        }
		
		if( pat == "" ) return( c == "" );
        if( c != pat ) return false ;
		
        if( c != "" ) return _testMatch( str.substr( 1 ), pattern.substr( 1 ) ) ;
        else return false ;
        
    }


}