/**
 * Math Utility Functions
 * 
 * @author David Knape
 * @version 1.0
 */

class com.bumpslide.util.MathUtil {

	/**
	 * Constrains an input value to within a min and max value
	 * 
	 * @param   n		input value
	 * @param   minVal 	minimum
	 * @param   maxVal  maximum value
	 * @return  number constrained to min and max
	 */
	
	static function constrain( n:Number, minVal:Number, maxVal:Number ) : Number {
		return Math.min( Math.max(n, minVal), maxVal); 
	}

}