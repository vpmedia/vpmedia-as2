/**
 * com.sekati.math.Range
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Number Range Utilities.
 */
class com.sekati.math.Range {
	/**
	 * Check if a number is in range.
	 * @param n (Number)
	 * @param min (Number)
	 * @param max (Number)
	 * @param blacklist (Array) optional.
	 * @return Boolean
	 */
	public static function isInRange(n:Number, min:Number, max:Number, blacklist:Array):Boolean {	
		if (n == null || typeof(n) != "number") return false;
		if(blacklist.length > 0) {
			for(var i:String in blacklist) if(n == blacklist[i]) return false;
		}
		return (n >= min && n <= max);
	}
	/**
	 * Returns a set of random numbers inside a specific range (unique numbers is optional)
	 * @param min (Number)
	 * @param max (Number)
	 * @param count (Number)
	 * @param unique (Boolean)
	 * @return Array
	 */
	public static function RandRangeSet(min:Number, max:Number, count:Number, unique:Boolean):Array {
		var rnds:Array = new Array( );
		if (unique && count <= max - min + 1) {
			//unique
			// create num range array
			var nums:Array = new Array( );
			for (var i:Number = min; i <= max ; i++) {
				nums.push( i );
			}
			for (var j:Number = 1; j <= count ; j++) {
				// random number
				var rn:Number = Math.floor( Math.random( ) * nums.length );
				rnds.push( nums[rn] );
				nums.splice( rn, 1 );
			}
		} else {
			//non unique
			for (var k:Number = 1; k <= count ; k++) {
				rnds.push( randRangeInt( min, max ) );
			}
		}
		return rnds;
	}
	/**
	 * Returns a random float number within a given range
	 * @param min (Number)
	 * @param max (Number)
	 * @return Number
	 */
	public static function randRangeFloat(min:Number, max:Number):Number {
		return Math.random( ) * (max - min) + min;
	}
	/**
	 * Returns a random int number within a given range
	 * @param min (Number)
	 * @param max (Number)
	 * @return Number
	 */
	public static function randRangeInt(min:Number, max:Number):Number {
		return Math.floor( Math.random( ) * (max - min + 1) + min );
	}		
	/**
	 * Resolve the number inside the range. If outside the range the nearest boundary value will be returned.
	 * @param val (Number)
	 * @param min (Number)
	 * @param max (Number)
	 * @return Number
	 */
	public static function resolve(val:Number, min:Number, max:Number):Number {
		return Math.max( Math.min( val, max ), min );	
	}	
	private function Range() {
	}
}