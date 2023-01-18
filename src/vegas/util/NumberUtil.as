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

import vegas.util.MathsUtil;

/**
 * The {@code NumberUtil} utility class is an all-static class with methods for working with number.
 * @author eKameleon
 */
class vegas.util.NumberUtil 
{

	/**
	 * Returns a shallow copy by reference of this Number.
	 * @return a shallow copy by reference of this Number.
	 */
	static public function clone(n:Number):Number 
	{
		return n ;
	}

	/**
	 * Returns a deep copy by value of this Number.
	 * @return a deep copy by value of this Number.
	 */
	static public function copy(n:Number):Number 
	{
		return Number(n.valueOf()) ;
	}

	/**
	 * compare if two Numbers are equal by value
	 */
	static public function equals( n1:Number, n2:Number ):Boolean 
	{
		if (! n2 ) return false ;
		if(n1.valueOf() == n2.valueOf()) 
		{
			return true ;
		}
		return false ;
    }
	
	/**
	 * Converts to an equivalent Boolean value.
	 * @return an equivalent Boolean value of the passed-in number.
	 */
	static public function toBoolean(n:Number):Boolean 
	{
		if (isNaN(n) || n.valueOf() == 0) 
		{
			return false ;
		}
		return true ;
	}
	
	/***
	 * Returns the exponential string reprsentation of the number passsed in argument.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.NumberUtil ;
	 * 
	 * var num:Number = 77.1234;
	 * 
	 * trace( NumberUtil.toExponential(num) ) ; // 7.71234e+1
	 * trace( NumberUtil.toExponential(num, 4)) ; // 7.7123e+1
	 * trace( NumberUtil.toExponential(num, 2)) ; // 7.71e+1
	 * trace( NumberUtil.toExponential(77.1234) ) ; // 7.71234e+1
	 * trace( NumberUtil.toExponential(77) ) ; // 7.7e+1
	 * }
	 * @param n the number to format.
	 * @param fractionDigits An integer specifying the number of digits after the decimal point. Defaults to as many digits as necessary to specify the number.
	 * @return the exponential string reprsentation of the number passsed in argument.
	 */
	static public function toExponential( n:Number, fractionDigits:Number):String 
	{
		var str:String ;
        var x:Number = n ;
       	var s:String = "+" ;
        if( isNaN( x ) ) 
        {
        	return "NaN" ;
        }
        if( x < 0 ) 
        {
			s = "-";
			x = -x ;
		}
		if( x == Infinity ) 
		{
			return s + "Infinity" ;
		}
        var l:Number = Math.floor( Math.log(x) / Math.LN10 ) ;
        var lm:Number = Math.pow( 10, l ) ;
       	n = x/lm ;
        if( fractionDigits == null ) 
        {
            str = n.toString();
        }
        else 
        {
        	fractionDigits = MathsUtil.clamp(fractionDigits, 0, 20) ;
            str = NumberUtil.toFixed( n, fractionDigits );
        }
        str += (l > 0) ? ("e" + s + l) : "" ;
        return str ;
	}
	
	/**
	 * Returns a string representing the number in fixed-point notation (*ECMA-262*).
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.NumberUtil ;
	 * 
	 * var n:Number = 12345.6789 ;
	 * 
	 * trace( NumberUtil.toFixed(n) ) ;
	 * // Returns 12346: note rounding, no fractional part
	 * 
	 * trace( NumberUtil.toFixed( n , 1) ) ;
	 * // Returns 12345.7: note rounding
	 * 
	 * trace( NumberUtil.toFixed( n , 6 ) );
	 * // Returns 12345.678900 : note added zeros
	 * }
	 * @param n the number to fixed.
	 * @param fractionDigits the number of digits to appear after the decimal point; this may be a value between 0 and 20, inclusive, and implementations may optionally support a larger range of values. If this argument is omitted, it is treated as 0.
	 * @return A string representation of number that does not use exponential notation and has exactly {@code fractionDigits} digits after the decimal place. The number is rounded if necessary, and the fractional part is padded with zeros if necessary so that it has the specified length. If number is greater than 1e+21, this method simply calls Number.toString() and returns a string in exponential notation.
	 */
	static public function toFixed( n:Number, fractionDigits:Number):String 
	{
        var x:Number = n ;
        
        if( isNaN( x )) 
        {
        	return "NaN" ;
        }
        if (isNaN(fractionDigits)) 
        {
        	fractionDigits = 0 ;
        }
       	fractionDigits = MathsUtil.clamp(fractionDigits, 0, 20) ;
        var m:Number = Math.pow( 10, fractionDigits );
        var r:Number = Math.round( x*m ) / m;
        var str:String = r.toString() ;
        var d = str.split( "." )[1] ;
        if( d && (d.length < fractionDigits) ) 
        {
			var len:Number = fractionDigits - d.length  ;
			for( var i:Number=0; i< len ; i++ ) 
			{
				str += "0" ;
			}
		}
        return str;
    }
	
	/**
	 * Converts to an equivalent Number value.
	 * @return an equivalent Number value of the passed-in Number.
	 */
	static public function toNumber(n:Number):Number 
	{
		return n.valueOf() ;	
	}
	
	/**
	 * Converts to an equivalent Object value.
	 * @return an equivalent Object value of the passed-in number.
	 */
	static public function toObject(n:Number):Number 
	{
		return new Number( n.valueOf() ) ;	
	}
	
	/**
	 * Returns a string representing the number to a specified precision in fixed-point notation (*ECMA-262*).
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.NumberUtil ;
	 * var num:Number = 5.123456 ;
	 * 
	 * trace( NumberUtil.toPrecision(num) )  ; // 5.123456
	 * trace( NumberUtil.toPrecision(num, 4) ) ; // 5.123
	 * trace( NumberUtil.toPrecision(num, 2) ) ; // 5.1
	 * trace( NumberUtil.toPrecision(num, 1) ) ; // 5
	 * trace( NumberUtil.toPrecision(1250, 2) ) ; // 1.3e+3
	 * trace( NumberUtil.toPrecision(1250, 5) ) ; // 1250.0
	 * }
	 * @param n The number to format.
	 * @param precision An integer specifying the number of digits after the decimal point.
	 * @return A string representing a Number object in fixed-point or exponential notation rounded to precision significant digits.
	 */
	static public function toPrecision(n:Number, precision:Number):String 
	{
		var x:Number = n ;
		var str:String = x.toString() ;
		if ( isNaN(x) ) 
		{
			return "NaN" ;
		}
		if( (precision == null) || (x == Infinity) || (x == -Infinity) ) 
		{
			return x.toString();
		}
		precision = MathsUtil.clamp(precision, 1, 21) ;
		if (str.length > precision) 
		{
			return NumberUtil.toExponential( x, precision - 1 ) ;	
		}
		var l:Number = Math.floor( Math.log(x) / Math.LN10 ) ;
		var m:Number = Math.pow( 10 , l+1 - precision ) ;
		var r:Number = Math.round(x/m) * m ;
		str = r.toString() ;
		var d = str.split( "." ).join( "" ) ;
		if( d && (d.length < precision) ) 
		{
			if( str.indexOf( "." ) == -1 ) 
			{
				str += "." ;
			}
			var len:Number = precision - d.length ;
            for( var i:Number = 0 ; i < len; i++ ) 
            {
            	str += "0" ;
            }
        }
        return str ;
	}
	
}