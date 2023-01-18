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

import vegas.data.iterator.Iterator;
import vegas.data.iterator.StringIterator;
import vegas.errors.ArgumentsError;
import vegas.util.comparators.StringComparator;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * The {@code StringUtil} utility class is an extended String class with methods for working with string.
 * @author eKameleon
 */
class vegas.util.StringUtil
{
	
    /**
	 * Represents the empty string.
	 */
	static public var EMPTY:String = "" ;
	
	/**
	 * Contains a list of all white space chars.
	 */
	static public var WHITE_SPACE_CHARS:Array = 
	[ 
		"\u0009", "\u000A", "\u000B", "\u000C", "\u000D",
		"\u0020", "\u00A0", "\u2000", "\u2001", "\u2002",
		"\u2003", "\u2004", "\u2005", "\u2006", "\u2007",
		"\u2008", "\u2009", "\u200A", "\u200B", "\u3000",
        "\uFEFF" 
    ];

	/**
	 * Returns 0 if the passed string is lower case else 1.
	 * @return 0 if the passed string is lower case else 1.
	 */
	static public function caseValue( str:String ):Number
	{
		return ( str.toLowerCase() == str ) ? 0 : 1 ;
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	static public function clone( str:String ):String 
	{
		return str ;	
	}

	/**
	 * Compares its two arguments for order. You can ignore the case of the 2 strings parameters.
	 * @param o1 the first String object to compare.
	 * @param o2 the second String object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @throws IllegalArgumentError if compare(a, b) and 'a' and 'b' must be String objects.
	 * @see StringComparator
	 */
	static public function compare( strA:String , strB:String, ignoreCase:Boolean ):Number 
	{
		return (new StringComparator(ignoreCase)).compare(strA, strB) ;
	}
	
	/**
	 * Compares the two caracteres passed in argument for order.
	 * @return <p>
	 * <li>-1 if charA is "lower" than (less than, before, etc.) charB ;</li>
	 * <li> 1 if charA is "higher" than (greater than, after, etc.) charB ;</li>
	 * <li> 0 if charA and charB are equal.</li>
	 * </p>
	 */
	static public function compareChars( charA:String, charB:String ):Number
	{
		var a:String = charA.charAt(0) ;
		var b:String = charB.charAt(0) ;
		if ( caseValue(a) < caseValue(b) ) 
		{
			return -1;
		}
		if ( caseValue(a) > caseValue(b) ) 
		{
			return 1 ;
		}
		if ( a < b ) 
		{
			return -1;
		}
		if ( a > b ) 
		{
			return 1;
		}
		return 0 ;
	}
	
	/**
	 * Compares this object with the specified object for order.
	 * @return <p>
	 * <li>-1 if charA is "lower" than (less than, before, etc.) charB ;</li>
	 * <li> 1 if charA is "higher" than (greater than, after, etc.) charB ;</li>
	 * <li> 0 if charA and charB are equal.</li>
	 * </p>
	 */
	static public function compareTo( str:String, o ):Number 
	{
		if (! TypeUtil.typesMatch(o, String)) 
		{
			throw new ArgumentsError("StringUtil.compareTo('"+ o + "' value must be a string") ;
		}
		if (o == null) 
		{
			return 1 ;
		}
		return StringUtil.compare(String(str.valueOf()), String(o.valueOf()) ) ;
	}
	
	/**
	 * Returns a deep copy of this object.
	 * @return a deep copy of this object.
	 */
	static public function copy(str:String):String 
	{
		return str.valueOf()  ;
	}
	
	/**
	 * Returns {@code true} if the string contains the specified caractere at the end.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * trace( StringUtil.endsWith("hello world", "d") ) ; // true
	 * }
	 * @return {@code true} if the string contains the specified caractere at the end.
	 */
	static public function endsWith( str:String, value:String ):Boolean 
	{
		if (value == null) return false ;
		if ( str.length < value.length ) return false ;
		return StringUtil.compare( str.substr( str.length-value.length ), value) == 0;
	}
	
	/**
	 * Returns the first character in the string.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * trace( StringUtil.firstChar("hello world") ; // h
	 * }
	 * @return the first character in the string.
	 */
	static public function firstChar( str:String ):String 
	{
		return str.charAt(0) ;
	}

	/**
	 * Reports the index of the first occurrence in this instance of any character in a specified array of Unicode characters.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * StringUtil.indexOfAny("hello world", [2, "hello", 5]) ; // 0
	 * StringUtil.indexOfAny("Five = 5", [2, "hello", 5]) ; // 7
	 * StringUtil.indexOfAny("actionscript is good", [2, "hello", 5]) ; // -1
	 * }
	 * @return the index of the first occurrence in this instance of any character in a specified array of Unicode characters.
	 */
	static public function indexOfAny(str:String, ar:Array):Number 
	{
		var index:Number ;
		var l:Number = ar.length ;
		for (var i:Number = 0 ; i<l ; i++) 
		{
			index = str.indexOf(ar[i]) ;
			if (index > -1) 
			{
				return index ;
			}
		}
		return -1 ;
	}
	
	/**
	 * Inserts a specified instance of String at a specified index position in this instance.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * var result:String ;
	 * result = StringUtil.insert("hello", 0, "a" ) ;  // ahello
	 * result = StringUtil.insert("hello", -1, "a" ) ; // ahello
	 * result = StringUtil.insert("hello", 10, "a" ) ; // helloa
	 * result = StringUtil.insert("hello", 1, "a" ) ;  // haello
	 * }
	 * @return the string modified by the method.
	 */
	static public function insert( str:String, startIndex:Number, value:String):String 
	{
		str = str.valueOf() ;
		if( value == null ) 
		{
			return str ;
		}
		if( str == "" ) 
		{
			return value ;
		}
        if( startIndex <= 0 )
        {
        	return value + str ;
        }
       	else if( isNaN(startIndex) || (startIndex >= str.length) ) 
       	{
       		return str + value ;
       	}
       	var strA:String = str.substr( 0, startIndex );
    	var strB:String = str.substr( startIndex ) ;
    	return strA + value + strB ;
	}
	
	/**
	 * Returns {@code true} if this string is empty.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * var b1:Boolean = StringUtil.isEmpty("") ; // true
	 * var b2:Boolean = StringUtil.isEmpty("hello world") ; // false
	 * }
	 * @param str the string object.
	 * @return {@code true} if this string is empty.
	 */
	static public function isEmpty( str:String ):Boolean 
	{
		return str.length == 0 ;
	}
	
	/**
	 * Returns a StringIterator reference of this string instance.
	 * <p><b>Example :</b></p>
	 * {@code
	 * var it:Iterator = vegas.util.StringUtil.iterator("hello") ;
	 * while(it.hasNext())
	 * {
	 *     trace("-> " + it.next()) ;
	 * }
	 * }
	 * @param str the string object.
	 * @return a StringIterator reference of this string instance.
	 */
	static public function iterator( str:String):Iterator 
	{
		return new StringIterator( str.toString()) ;
	}	
	
	/**
	 * Returns the last char of the string. 
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * trace( StringUtil.firstChar("hello world") ; // d
	 * }
	 * @param str the string object.
	 * @return the last char of the string.
	 */
	static public function lastChar( str:String ):String 
	{
		return str.charAt(str.length - 1) ;
	}

	/**
	 * Reports the index position of the last occurrence in this instance of one or more characters specified in a Unicode array.
	 * <p><b>Example :</b></p>
	 * {@code
	 * vegas.util.StringUtil.lastChar("hello world") ; // the last char is 'd'.
	 * }
	 * @return the index position of the last occurrence in this instance of one or more characters specified in a Unicode array.
	 */
	static public function lastIndexOfAny(str:String, ar:Array):Number 
	{
		var index:Number = -1 ;
		var l:Number = ar.length ;
		for (var i:Number = 0 ; i<l ; i++) 
		{
			index = str.lastIndexOf(ar[i]) ;
			if (index > -1) 
			{
				return index ;
			}
		}
		return index ;
	}
	
	/**
	 * Right-aligns the characters in this instance, padding on the left with a specified Unicode character for a specified total length.
	 * {@code
	 * import vegas.util.StringUtil ;
	 * 
	 * var result:String = StringUtil.padLeft("hello", 8) ;
	 * trace(result) ; //  "   hello"
	 * 
	 * var result:String = StringUtil.padLeft("hello", 8, ".") ;
	 * trace(result) ; //  "...hello" 
	 * }
	 * @return The right-aligns the characters in this instance, padding on the left with a specified Unicode character for a specified total length.
	 */
	static public function padLeft(str:String, i:Number /*Int*/, char:String):String 
	{
		char = char || " " ;
		var s:String = new String( str ) ;
        var l:Number = s.length ;
        for (var k:Number = 0 ; k < (i - l) ; k++) 
        {
        	s = char + s ;
        }
        return s ;
    }
	
	/**
	 * Left-aligns the characters in this string, padding on the right with a specified Unicode character, for a specified total length.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * 
	 * var result:String = StringUtil.padRight("hello", 8) ;
	 * trace(result) ; //  "hello   "
	 * 
	 * var result:String = StringUtil.padRight(hello", 8, ".") ;
	 * trace(result) ; //  "hello..." 
	 * }
	 * @return The left-aligns the characters in this string, padding on the right with a specified Unicode character, for a specified total length.
	 */
	static public function padRight(str:String, i:Number /*Int*/ , char:String):String 
	{
		char = char || " " ;
        var s:String = new String( str ) ;
        var l:Number = s.length ;
		for (var k:Number = 0 ; k < (i - l) ; k++) 
		{
			s = s + char ;
		}
        return s ;
    }
	
	/**
	 * Replaces the 'search' string with the 'replace' String.
	 * <p><b>Example :</b></p>
	 * {@code
	 * vegas.util.StringUtil.replace("hello world", "hello", "hi") ; // "hello world" -> "hi world"
	 * }
	 * @param the string to transform.
	 * @return the new string transform with this method.
	 */
	static public function replace(str:String, search:String, replace:String):String 
	{
		return str.split(search).join(replace) ;
	}
	
	/**
	 * Reverses the current instance.
	 * <p><b>Example :</b></p>
	 * {@code
	 * var reverse:String = vegas.util.StringUtil.reverse("hello") ; // "olleh"
	 * }
	 * @return the reverse string of the specified string passed-in argument.
	 */
	static public function reverse( str:String ):String 
	{  
		var ar:Array = str.split("") ;
		ar.reverse() ;
		return ar.join("") ;
	}
	
	/**
	 * Adds and removes elements in the string.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * 
	 * var result:String = StringUtil.splice("hello world", 0, 1, "H") ;
	 * trace(result) ; // Hello world
	 * 
	 * var result:String = StringUtil.splice("hello world", 6, 0, "life") ;
	 * trace(result) ; // hello lifeworld
	 * 
	 * var result:String = StringUtil.splice("hello world", 6, 5, "life") ;
	 * trace(result) ; // hello life
	 * }
	 * @param startIndex Index at which to start changing the string.
	 * @param deleteCount Indicating the number of old character elements to remove.
	 * @param value The elements to add to the string. If you don't specify any elements, splice simply removes elements from the string.
	 */
	static public function splice( str:String, startIndex:Number, deleteCount:Number, value):String 
	{
		var a:Array = StringUtil.toArray(str) ;
		a.splice(startIndex, deleteCount, value) ;
		return a.join("") ;
	}

	/**
	 * Determines whether a specified string is a prefix of the current instance. 
	 * <p><b>Example : </b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * 
	 * trace( StringUtil.startsWith("hello world", "h") ) ; // true
	 * trace( StringUtil.startsWith("hello world", "hello") ) ; // true
	 * trace( StringUtil.startsWith("hello world", "a") ) ; // false
	 * }
	 * @return {@code true} if the specified string is a prefix of the current instance.
	 */
	static public function startsWith( str:String, value:String ):Boolean
   	{
	   	if( value == null )
		{
    	   	return false;
        }
	    
	    if( str.length < value.length )
        {
        	return false;
        }
	    
	    if( str.charAt( 0 ) != value.charAt( 0 ) )
        {
        	return false;
        }
	    
	   	return( StringUtil.compare( str.substr( 0, value.length), value) == 0);
	}

	/**
	 * Returns an array representation of this instance.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * trace( StringUtil.toArray("hello world" )) ; // h,e,l,l,o, ,w,o,r,l,d
	 * }
	 * @return an array representation of this instance.
	 */
	static public function toArray( str:String ):Array 
	{
		return str.split("") ;
	}
	
	/**
	 * Returns a Eden representation of the object.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * var source:String = StringUtil.toSource("hello world") ;
	 * trace(source) ; // "hello world"
	 * }
	 * @return a string representing the source code of the object.
	 */
	static public function toSource(str:String, indent:Number, indentor:String):String 
	{
		return Serializer.toSource(str) ;
	}

	/**
	 * Removes all occurrences of a set of specified characters (or strings)
	 * from the beginning and end of this instance.
	 */
	static public function trim( str:String,  trimChars:Array )
    {
    	if( (trimChars == null) || (trimChars.length == 0) )
        {
        	trimChars = WHITE_SPACE_CHARS ;
        }
    	return _trimHelper( str, trimChars, true, true );
    }

	/**
	 * Removes all occurrences of a set of characters specified in an array from the end of this instance.
	 */
	static public function trimEnd( str:String , trimChars:Array )
    {
    	if( (trimChars == null) || (trimChars.length == 0) )
        {
        	trimChars = WHITE_SPACE_CHARS;
        }
    	return _trimHelper( str, trimChars, null, true );
    }

	/**
	 * Removes all occurrences of a set of characters specified 
	 * in an array from the beginning of this instance.
	 */
	static public function trimStart( str:String, trimChars:Array )
    {
    	if( (trimChars == null) || (trimChars.length == 0) )
        {
        	trimChars = WHITE_SPACE_CHARS;
        }
    	return _trimHelper( str, trimChars, true ) ;
    }

	/**
	 * Returns the value of this specified string with the first character in uppercase.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * trace( StringUtil.ucFirst("hello world" )) ; // Hello world
	 * }
	 * @return the value of this string with the first character in uppercase.
	 */
	static public function ucFirst(str:String):String 
	{
		return str.charAt(0).toUpperCase() + str.substring(1) ;
	}
	
	/**
	 * Uppercase the first character of each word in a string.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.StringUtil ;
	 * trace( StringUtil.ucWords("hello world" )) ; // Hello World
	 * }
	 * @return the string value with the first character in uppercase of each word in a string.
	 */
	static public function ucWords( str:String ):String 
	{
		var ar:Array = str.split(" ") ;
		var l:Number = ar.length ;
		while(--l > -1) 
		{
			ar[l] = StringUtil.ucFirst(ar[l]) ;
		}
		return ar.join(" ") ;
	}

	/**
	 * Helper method used by trim, trimStart and trimEnd methods.
	 */
	static private function _trimHelper( str:String, trimChars:Array, trimStart:Boolean, trimEnd:Boolean )
    {
	    if( trimStart == null )
        {
    	    trimStart = false;
        }
    	
    	if( trimEnd == null )
        {
        	trimEnd = false;
        }
    	
    	var iLeft, iRight;
    	var s:String = copy(str) ;
    
    	if( trimStart )
        {
        	for( iLeft=0; (iLeft<s.length) && (trimChars.contains( s.charAt( iLeft ) )); iLeft++ )
        	{
	    	    
    	    }
        	s = s.substr( iLeft );
        }
    
    	if( trimEnd )
        {
        	for( iRight=s.length-1; (iRight>=0) && (trimChars.contains( s.charAt( iRight ) )); iRight-- )
            {            
            
            }
        
        	s = s.substring( 0, iRight+1 );
        }
    
    	return s ;
    }

}