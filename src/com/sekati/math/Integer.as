/**
 * com.sekati.math.Integer
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Integer Object (a positive or negative natural number including 0).
 */
class com.sekati.math.Integer extends Number {

	private var _int:Number;

	/**
	 * Construct a new Integer instance (number will be floored)
	 * @param n (Number) to convert to an Integer
	 * @throws Error on Infinity
	 */
	public function Integer(n:Number) {
		if (n == Infinity || n == -Infinity) {
			throw new Error( "Infinity cannot be evaluated to an integer" );
		} else {
			_int = n - n % 1;
		}
	}

	/**
	 * return the value of Integer as Number
	 * @return Number
	 */
	public function valueOf():Number {
		return _int;
	}

	/**
	 * return string representation of Integer
	 * @return String
	 */
	public function toString():String {
		return _int.toString( );
	}
}