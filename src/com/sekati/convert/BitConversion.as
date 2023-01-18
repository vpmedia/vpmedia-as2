
/**
 * com.sekati.convert.BitConversion
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Bit Conversion Utilites
 */
class com.sekati.convert.BitConversion {

	private static var BYTE:Number = 8;
	private static var KILOBIT:Number = 1024;
	private static var KILOBYTE:Number = 8192;
	private static var MEGABIT:Number = 1048576;
	private static var MEGABYTE:Number = 8388608;
	private static var GIGABIT:Number = 1073741824;
	private static var GIGABYTE:Number = 8589934592; 
	private static var TERABIT:Number = 1.099511628e+12;
	private static var TERABYTE:Number = 8.796093022e+12;
	private static var PETABIT:Number = 1.125899907e+15;
	private static var PETABYTE:Number = 9.007199255e+15;
	private static var EXABIT:Number = 1.152921505e+18;
	private static var EXABYTE:Number = 9.223372037e+18;

	public static function byte2bit(n:Number):Number {
		return n * BYTE;
	}

	public static function kilobit2bit(n:Number):Number {
		return n * KILOBIT;
	}

	public static function kilobyte2bit(n:Number):Number {
		return n * KILOBYTE;	
	}

	public static function megabit2bit(n:Number):Number {
		return n * MEGABIT;
	}

	public static function megabyte2bit(n:Number):Number {
		return n * MEGABYTE;
	}			

	public static function gigabit2bit(n:Number):Number {
		return n * GIGABIT;
	}

	public static function gigabyte2bit(n:Number):Number {
		return n * GIGABYTE;
	}

	public static function terabit2bit(n:Number):Number {
		return n * TERABIT;	
	}

	public static function terabyte2bit(n:Number):Number {
		return n * TERABYTE;
	}

	public static function petaabit2bit(n:Number):Number {
		return n * PETABIT;	
	}

	public static function petabyte2bit(n:Number):Number {
		return n * PETABYTE;
	}

	public static function exabit2bit(n:Number):Number {
		return n * EXABIT;	
	}

	public static function exabyte2bit(n:Number):Number {
		return n * EXABYTE;
	}	
}