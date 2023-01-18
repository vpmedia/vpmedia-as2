/**
 * com.sekati.math.MathBase
 * @version 1.1.9
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.math.Integer;

/**
 * Static class wrapping various Math utilities.
 */
class com.sekati.math.MathBase {			

	/**
	 * Returns the highest value of all passed arguments
	 * Like Math.max() but supports any number of args passed to it
	 * @return Number
	 */
	public static function max():Number {
		return maxArray( arguments );
	}

	/**
	 * Returns the lowest value of all passed arguments
	 * Like Math.min() but supports any number of args passed to it
	 * @return Number
	 */
	public static function min():Number {
		return minArray( arguments );
	}

	/**
	 * Returns the highest value of all items in array
	 * Like Math.max() but supports any number of items
	 * @param a (Array)
	 * @return Number
	 */
	public static function maxArray(a:Array):Number {
		var val:Number = null;
		for (var i in a) {
			if (a[i] > val || val == null) {
				val = Number( a[i] );
			}
		}
		return val;
	}

	/**
	 * Returns the lowest value of all items in array
	 * Like Math.min() but supports any number of items
	 * @param a (Array)
	 * @return Number
	 */
	public static function minArray(a:Array):Number {
		var val:Number = null;
		for (var i in a) {
			if (a[i] < val || val == null) {
				val = Number( a[i] );
			}
		}
		return val;
	}

	/**
	 * Same as Math.foor with extra argument to specify number of decimals
	 * @param val (Number)
	 * @param decimal (Number)
	 * @return Number
	 */
	public static function floor(val:Number, decimal:Number):Number {
		var n:Number = Math.pow( 10, decimal );
		return Math.floor( val * n ) / n;
	}	

	/**
	 * Round to a given amount of decimals
	 * @param val (Number)
	 * @param decimal (Number)
	 * @return Number
	 */
	public static function round(val:Number, decimal:Number):Number {
		return Math.round( val * Math.pow( 10, decimal ) ) / Math.pow( 10, decimal );
	}

	/**
	 * Round to nearest .5
	 * @param val (Number)
	 * @return Number
	 * {@code Example:
	 * 	trace(MathBase.roundHalf(4.47)); // returns 4.5
	 * }
	 */	
	public static function roundHalf(val:Number):Number {
		var num:String = String( Math.round( val * 10 ) / 10 );
		var tmp:Array = num.split( "." );
		var integer:Object = tmp[0]; 
		// loose type since we swap from String to Number (cheap!)
		var decimal:Number = tmp[1];
		if (decimal >= 3 && decimal <= 7 && decimal != null) {
			decimal = 5;
		} else {
			if (decimal > 7) {
				integer = Number( integer ) + 1;
			}
			decimal = 0;
		}
		return Number( integer + "." + decimal );
	}

	/**
	 * Will constrain a value to the defined boundaries
	 * @param val (Number)
	 * @param min (Number)
	 * @param max (Number)
	 * @return Number
	 * {@code Examples:
	 * val: 20, 2 to 5    this will give back 5 since 5 is the top boundary
	 * val: 3, 2 to 5     this will give back 3
	 * }
	 */
	public static function constrain(val:Number, min:Number, max:Number):Number {
		if (val < min) {
			val = min;
		} else if (val > max) {
			val = max;
		}
		return val;
	}

	/**
	 * Return the proportional value of two pairs of numbers.
	 * @param x1 (Number)
	 * @param x2 (Number)
	 * @param y1 (Number)
	 * @param y2 (Number)
	 * @param x (Number) optional
	 * @return Number
	 */
	public static function proportion(x1:Number, x2:Number, y1:Number, y2:Number, x:Number):Number {
		var n:Number = (!x) ? 1 : x;
		var slope:Number = (y2 - y1) / (x2 - x1);
		return (slope * (n - x1) + y1);
	}

	/**
	 * Check if number is positive (zero is considered positive)
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isPositive(n:Number):Boolean {
		return (n >= 0);
	}

	/**
	 * Check if number is negative
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isNegative(n:Number):Boolean {
		return (n < 0);
	}	

	/**
	 * Check if number is Odd (convert to Integer if necessary)
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isOdd(n:Number):Boolean {
		var i:Integer = new Integer( n );
		var e:Integer = new Integer( 2 );
		return Boolean( i % e );	
	}

	/**
	 * Check if number is Even (convert to Integer if necessary)
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isEven(n:Number):Boolean {
		var int:Integer = new Integer( n );
		var e:Integer = new Integer( 2 );
		return (int % e == 0);
	}

	/**
	 * Check if number is Prime (divisible only itself and one)
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isPrime(n:Number):Boolean {
		if (n > 2 && n % 2 == 0) return false;
		var l:Number = Math.sqrt( n );
		for (var i:Number = 3; i <= l ; i += 2) {
			if (n % i == 0) return false;
		}
	}

	/**
	 * Calculate the factorial of the integer.
	 * @param n (Number) 
	 * @return Number
	 */
	 
	public static function factorial(n:Number):Number {
		if (n == 0) return 1;
		var d:Number = n.valueOf( );
		var i:Number = d - 1;
		while (i) {
			d = d * i;
			i--;
		}
		return d;
	}

	/**
	 * Return an array of divisors of the integer.
	 * @param n (Number)
	 * @return Number
	 */
	public static function getDivisors(n:Number):Array {
		var r:Array = new Array( );
		for (var i:Number = 1, e:Number = n / 2; i <= e ; i++) {
			if (n % i == 0) r.push( i );
		}
		if (n != 0) r.push( n.valueOf( ) );
		return r;
	}

	/**
	 * Check if number is an Integer
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isInteger(n:Number):Boolean {
		return (n % 1 == 0);
	}

	/**
	 * Check if number is Natural (positive Integer)
	 * @param n (Number)
	 * @return Boolean
	 */
	public static function isNatural(n:Number):Boolean {
		return (n >= 0 && n % 1 == 0);
	}

	/**
	 * Returns a random number inside a specific range
	 * @param start (Number)
	 * @param end (Number)
	 * @return Number
	 */	
	public static function rnd(start:Number, end:Number):Number {
		return Math.round( Math.random( ) * (end - start) ) + start;
	}

	/**
	 * Correct "roundoff errors" in floating point math.
	 * @param n (Number)
	 * @param precision (Number) - optional [default: returns (10000 * number) / 10000]
	 * @return Number
	 * @see {@link http://www.zeuslabs.us/2007/01/30/flash-floating-point-number-errors/} 
	 */
	public static function sanitizeFloat(n:Number, precision:Number):Number {
		var p:Number = (!precision) ? 5 : int( precision );
		var c:Number = Math.pow( 10, p );
		return Math.round( c * n ) / c;
	}

	/**
	 * Evaluate if two numbers are nearly equal
	 * @param n1 (Number)
	 * @param n2 (Number)
	 * @param precision (Number) - optional [default: 0.00001 <diff> -0.00001]
	 * @return Boolean
	 * @see {@link http://www.zeuslabs.us/2007/01/30/flash-floating-point-number-errors/}
	 */
	public static function fuzzyEval(n1:Number, n2:Number, precision:Number):Boolean {
		var d:Number = n1 - n2;
		var p:Number = (!precision) ? 5 : int( precision );
		var r:Number = Math.pow( 10, -p );
		return d < r && d > -r;
	}	

	private function MathBase() {
	}
}