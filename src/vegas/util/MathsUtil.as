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

import vegas.errors.IllegalArgumentError;

/**
 * The {@code MathUtil} utility class is an all-static class with methods for working with numbers.
 * @author eKameleon
 */
class vegas.util.MathsUtil 
{

	/**
	 * Rounds and returns the ceiling of the specified number or expression. 
	 * The ceiling of a number is the closest integer that is greater than or equal to the number.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.MathsUtil ;
	 * var n = MathsUtil.ceil(4.572525153, 2) ;
	 * trace ("n : " + n) ; // n : 4.58
	 * 
	 * var n = MathsUtil.ceil(4.572525153, -1) ;
	 * trace ("n : " + n) ; // n : 5
	 * }
	 * @param n the number to round.
	 * @param floatCount the count of number after the point.
	 * @return the ceil value of a number by a count of floating points.
	 */
	static public function ceil(n:Number, floatCount:Number):Number 
	{
		if (isNaN(n)) 
		{
			throw new IllegalArgumentError("MathsUtil.floor, Argument 'n' must not be 'null' or 'undefined'.") ;
		}
		var r:Number = 1 ;
		var i:Number = -1 ;
		while (++i < floatCount) 
		{
			r *= 10 ;
		}
		return Math.floor(n*r) / r  ;
	}
	
	
	/**
	 * Bounds a numeric value between 2 numbers.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.MathsUtil ;
	 * 
	 * var n = MathsUtil.clamp(4, 5, 10) ;
	 * trace ("n : " + n) ;
	 * 
	 * var n = MathsUtil.clamp(12, 5, 10) ;
	 * trace ("n : " + n) ;
	 * 
	 * var n = MathsUtil.clamp(6, 5, 10) ;
	 * trace ("n : " + n) ;
	 * 
	 * var n = MathsUtil.clamp(null, 5, 10) ;
	 * trace ("n : " + n) ;
	 * }
	 * @param value the value to clamp.
	 * @param min the min value of the range.
	 * @param max the max value of the range.
	 * @return a bound numeric value between 2 numbers.
	 */
	static public function clamp(value:Number, min:Number, max:Number):Number 
	{
		if (isNaN(value)) 
		{
			throw new IllegalArgumentError("MathsUtils.clamp, argument 'value' must not be 'null' or 'undefined' or 'NaN'") ;
		}
		if (isNaN(min)) 
		{
			min = value ;
		}
		if (isNaN(max)) 
		{
			max = value ;
		}
		return Math.max(Math.min(value, max), min) ;
	}
	
	/**
	 * Rounds and returns the number or expression specified in the parameter n. 
	 * The floor is the closest integer that is less than or equal to the specified number or expression.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.MathsUtil ;
	 * 
	 * var n = MathsUtil.floor(4.572525153, 2) ;
	 * trace ("n : " + n) ; // n : 4.57
	 * 
	 * var n = MathsUtil.floor(4.572525153, -1) ;
	 * trace ("n : " + n) ; // n : 4
	 * }
	 * @param n the number to round.
	 * @param floatCount the count of number after the point.
	 * @return the floor value of a number by a count of floating points.
	 */
	static public function floor(n:Number, floatCount:Number):Number 
	{
		if (isNaN(n)) 
		{
			throw new IllegalArgumentError("MathsUtil.floor, Argument 'n' must not be 'null' or 'undefined'.") ;
		}
		var r:Number = 1 ;
		var i:Number = -1 ;
		while (++i < floatCount) 
		{
			r *= 10 ;
		}
		return Math.floor(n*r) / r  ;
	}
	
	/**
	 * Returns a percentage value or null.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.MathsUtil ;
	 * trace( MathsUtil.getPercent( 50 , 100 ) + "%" ) ; // 50%
	 * trace( MathsUtil.getPercent( 68 , 425 ) + "%" ) ; // 16% 
	 * }
	 * @param nValue the current value.
	 * @param nMax the max value.
	 * @return a percentage value or null.
	 */
	static public function getPercent(nValue:Number, nMax:Number):Number 
	{
		var nP:Number = (nValue / nMax) * 100 ;
		return (isNaN(nP) || !isFinite(nP)) ? null : nP ;
	}
	
	/**
	 * Rounds and returns a number by a count of floating points.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.MathsUtil ;
	 * 
	 * var n = MathsUtil.round(4.572525153, 2) ;
	 * trace ("n : " + n) ;
	 * 
	 * var n = MathsUtil.round(4.572525153, -1) ;
	 * trace ("n : " + n) ;
	 * }
	 * @param n the number to round.
	 * @param floatCount the count of number after the point.
	 * @return the round of a number by a count of floating points.
	 */
	static public function round(n:Number, floatCount:Number):Number 
	{
		if (isNaN(n)) 
		{
			throw new IllegalArgumentError("MathsUtil.round, Argument 'n' must not be 'null' or 'undefined'.") ;
		}
		var r:Number = 1 ;
		var i:Number = -1 ;
		while (++i < floatCount) 
		{
			r *= 10 ;
		}
		return Math.round(n*r) / r  ;
	}
	
	/**
	 * Returns 1 if the value is positive or -1.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.MathsUtil ;
	 * 
	 * n = MathsUtil.sign(-150) ;
	 * trace ("n : " + n) ;
	 * 
	 * n = MathsUtil.sign(200) ;
	 * trace ("n : " + n) ;
	 * 
	 * n = MathsUtil.sign(0) ;
	 * trace ("n : " + n) ;
	 * }
	 * @param n the number to defined this sign.
	 * @return 1 if the value is positive or -1.
	 */
	static public function sign( n:Number ):Number 
	{
		if (isNaN(n)) 
		{
			throw new IllegalArgumentError("MathsUtil.sign, Argument 'n' must not be 'null' or 'undefined'.") ;
		}
		return n<0 ? -1 : 1 ;
	}

}