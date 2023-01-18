/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.util.ArrayUtil;

/**
 * The Align enumeration class provides constant values to align displays or components.
 * @author eKameleon
 */
class pegas.draw.Align 
{

	/**
	 * Defines the CENTER value (0).
	 */
	static public var CENTER:Number = 0 ;

	/**
	 * Defines the LEFT value (2).
	 */
	static public var LEFT:Number = 2 ;

	/**
	 * Defines the RIGHT value (4).
	 */
	static public var RIGHT:Number = 4 ;

	/**
	 * Defines the TOP value (8).
	 */
	static public var TOP:Number = 8 ;

	/**
	 * Defines the BOTTOM value (16).
	 */
	static public var BOTTOM:Number = 16 ;

	/**
	 * Defines the REVERSE value (32).
	 */
	static public var REVERSE:Number = 32 ;

	/**
	 * Defines the BOTTOM_LEFT value (18).
	 */
	static public var BOTTOM_LEFT = BOTTOM | LEFT ;

	/**
	 * Defines the BOTTOM_RIGHT value (20).
	 */
	static public var BOTTOM_RIGHT = BOTTOM | RIGHT ;

	/**
	 * Defines the TOP_LEFT value (10).
	 */
	static public var TOP_LEFT = TOP | LEFT ;

	/**
	 * Defines the TOP_RIGHT value (12).
	 */
	static public var TOP_RIGHT = TOP | RIGHT ;

	/**
	 * Defines the LEFT_BOTTOM value (50).
	 */
	static public var LEFT_BOTTOM = BOTTOM_LEFT | REVERSE ;

	/**
	 * Defines the RIGHT_BOTTOM value (52).
	 */
	static public var RIGHT_BOTTOM = BOTTOM_RIGHT | REVERSE ;

	/**
	 * Defines the LEFT_TOP value (42).
	 */
	static public var LEFT_TOP = TOP_LEFT | REVERSE ;

	/**
	 * Defines the RIGHT_TOP value (44).
	 */
	static public var RIGHT_TOP = TOP_RIGHT | REVERSE ;

	static private var __ASPF__ = _global.ASSetPropFlags(Align, null , 7, 7) ;

	/**
	 * Converts a string value in this Align value.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import pegas.draw.Align ;
	 * 
	 * var sAlign:String = "l" ;
	 * 
	 * trace( Align.toNumber("l") == Align.LEFT ) ; // true
	 * 
	 * }
	 */
	static public function toNumber(str:String):Number 
	{
		switch (str.toLowerCase()) 
		{
			case "l" : 
			{
				return Align.LEFT ;
			}
			case "r" :
			{
				return Align.RIGHT ;
			}
			case "t" :
			{
				return Align.TOP ;
			}
			case "b" :
			{
				return Align.BOTTOM ;
			}
			case "tl" :
			{
				return Align.TOP_LEFT ;
			}
			case "tr" :
			{
				return Align.TOP_RIGHT ;
			}
			case "bl" :
			{
				return Align.BOTTOM_LEFT ;
			}
			case "br" :
			{
				return Align.BOTTOM_RIGHT ;
			}
			case "lt" :
			{
				return Align.LEFT_TOP ;
			}
			case "rt" :
			{
				return Align.RIGHT_TOP ;
			}
			case "lb" :
			{
				return Align.LEFT_BOTTOM ;
			}
			case "rb" :
			{
				return Align.RIGHT_BOTTOM ;
			}	
			default :
			{
				return Align.CENTER ;
			}
		}
	}

	/**
	 * Returns the string representation of the specified Align value passed in argument.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import pegas.draw.Align ;
	 * trace( Align.toString(Align.LEFT)) ; // "l"
	 * trace( Align.toString(Align.TOP_LEFT)) ; // "tl"
	 * trace( Align.toString(Align.RIGHT_BOTTOM)) ; // "rb"
	 * }
	 * @return the string representation of the specified Align value passed in argument.
	 */
	static public function toString(n:Number):String 
	{
		switch (n) 
		{
			case Align.LEFT : return "l" ;
			case Align.RIGHT : return "r" ;
			case Align.TOP : return "t" ;
			case Align.BOTTOM : return "b" ;
			case Align.TOP_LEFT : return "tl" ; 
			case Align.TOP_RIGHT : return "tr" ;
			case Align.BOTTOM_LEFT  : return "bl" ;
			case Align.BOTTOM_RIGHT : return "br" ;
			case Align.LEFT_TOP : return "lt" ; 
			case Align.RIGHT_TOP : return "rt" ;
			case Align.LEFT_BOTTOM : return "lb" ;
			case Align.RIGHT_BOTTOM : return "rb" ;
			default : return "" ;
		}
	}

	/**
	 * Returns {@code true} if the specified Align value in argument is a valid Align value else returns {@code false}.
	 * @return {@code true} if the specified Align value in argument is a valid Align value else returns {@code false}.
	 */
	static public function validate(n:Number):Boolean 
	{
		var a:Array = [ 
			Align.CENTER, Align.LEFT , Align.RIGHT, 
			Align.TOP, Align.BOTTOM, 
			Align.TOP_LEFT, Align.TOP_RIGHT,
			Align.BOTTOM_LEFT, Align.BOTTOM_RIGHT
		] ;
		return  ArrayUtil.contains(a, n) ;
	}
	
}