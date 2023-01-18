/**
 * com.sekati.convert.TimeConversion
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Time Conversion Utilities
 */
class com.sekati.convert.TimeConversion {

	public static function weeks2ms(n:Number):Number {
		return n * days2ms( 7 );
	}

	public static function days2ms(n:Number):Number {
		return n * hours2ms( 24 );
	}

	public static function hours2ms(n:Number):Number {
		return n * minutes2ms( 60 );
	}

	public static function minutes2ms(n:Number):Number {
		return n * seconds2ms( 60 );
	}

	public static function seconds2ms(n:Number):Number {
		return n * ms( 1000 );
	}

	public static function ms(n:Number):Number {
		return n;
	}

	public static function ms2weeks(n:Number):Number {
		return n / days2ms( 7 );
	}

	public static function ms2days(n:Number):Number {
		return n / hours2ms( 24 );
	}

	public static function ms2hours(n:Number):Number {
		return n / minutes2ms( 60 );
	}

	public static function ms2minutes(n:Number):Number {
		return n / seconds2ms( 60 );
	}

	public static function ms2seconds(n:Number):Number {
		return n / ms( 1000 );
	}		

	private function TimeConversion() {	
	}
}