
/**
 * com.sekati.math.RuleOfThree
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Adapted from nectere for dependencies
 */
 
/**
 * The rule of three is the method of finding the fourth term of a mathematical proportion when the first three terms are known.
 * {@code Usage:
 * 	var calc:RuleOf3 = new RuleOf3 (null, 500, 25, 100, 0); // partial value is 125;
 * }
 * @see http://en.wikipedia.org/wiki/Rule_of_three_%28mathematics%29
 */
class com.sekati.math.RuleOf3 extends Number {

	private var _n:Number;

	/**
	 * @param partialValue (Number)
	 * @param totalValue (Number)
	 * @param partialPercent (Number)
	 * @param totalPercent (Number)
	 * @param zeroPercentValue (Number)
	 * @throws Error on fault. 
	 */
	public function RuleOf3(partialValue:Number, totalValue:Number, partialPercent:Number, totalPercent:Number, zeroPercentValue:Number) {
		//defaults to 0% == 0
		if (zeroPercentValue == null) {
			zeroPercentValue = 0;
		}
		//calculate the null value    
		if (partialValue == null) {
			//partialValue
			_n = ((totalValue - zeroPercentValue) * partialPercent / totalPercent) + zeroPercentValue;
			return;
		} else if (totalValue == null) {
			//totalValue
			_n = ((partialValue - zeroPercentValue) * totalPercent / partialPercent) + zeroPercentValue;
			return;
		} else if (partialPercent == null) {
			//partialPercent
			_n = ((partialValue - zeroPercentValue) * totalPercent) / (totalValue - zeroPercentValue);
			return;
		} else if (totalPercent == null) {
			//totalPercent
			_n = ((totalValue - zeroPercentValue) * partialPercent) / (partialValue - zeroPercentValue);
			return;
		}
		//error
		throw new Error( "@@@ com.sekati.math.RuleOf3 Error: could not calculate faulty arguments." );
	}

	/**
	 * return number of representation of _n
	 * @return Number
	 */
	public function valueOf():Number {
		return _n;	
	}

	/**
	 * return string representation of _n
	 * @return String
	 */
	public function toString():String {
		return _n.toString( );
	}
}