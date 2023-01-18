/**
 * com.sekati.utils.DateUtils
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.convert.TimeConversion;
import com.sekati.math.Range;

/**
 * Static function for handling dates from db and converting them into readable strings. Note that days & months are 0-indexed.
 * 
 * {@code Usage:
 * var d = DateUtils.dateFromDB("2006-06-01 12:10:45");
 * trace(DateUtils.days[d.getDay()] + ", " + DateUtils.months[d.getMonth()] + " " + d.getDate() + ", " + (d.getHours()%12) + ":" + DateUtils.padTime(d.getMinutes()) + ((d.getHours() > 12) ? "pm" :"am"));
 * }
 */
class com.sekati.utils.DateUtils {

	/**
	 * Gets 0 indexed array of months for use with Date.getMonth()
	 * @return Array
	 */
	public static function get months():Array {
		return new Array( "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" );
	}

	/**
	 * Gets 0 indexed array of short months for use with Date.getMonth()
	 * @return Array
	 */
	public static function get shortmonths():Array {
		return new Array( "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" );	
	}

	/**
	 * Gets 0 indexed array of days for use with Date.getDay()
	 * @return Array
	 */
	public static function get days():Array {
		return new Array( "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" );
	}

	/**
	 * Get 0 indexed array of days for use with Date.getDay();
	 * @return Array
	 */
	public static function get shortdays():Array {
		return new Array( "Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat" );
	}

	/**
	 * Get the month name by month number.
	 * @param n (Number)
	 * @return String
	 * {@code Usage:
	 * 	trace(DateUtils.getMonth(0); // returns "January"
	 * }
	 */
	public static function getMonth(n:Number):String {
		return months[n];	
	}

	/**
	 * Get the short month name by month number.
	 * @param n (Number)
	 * @return String
	 * {@code Usage:
	 * 	trace(DateUtils.getShortMonth(0); // returns "Jan"
	 * }
	 */
	public static function getShortMonth(n:Number):String {
		return shortmonths[n];	
	}

	/**
	 * Get the day name by day number.
	 * @param n (Number)
	 * @return String
	 * {@code Usage:
	 * 	trace(DateUtils.getDay(0); // returns "Sunday"
	 * }
	 */	
	public static function getDay(n:Number):String {
		return days[n];	
	}

	/**
	 * Get the short day name by day number.
	 * @param n (Number)
	 * @return String
	 * {@code Usage:
	 * 	trace(DateUtils.getShortDay(0); // returns "Sun"
	 * }
	 */	
	public static function getShortDay(n:Number):String {
		return shortdays[n];
	}

	/**
	 * Pads hours, Minutes or Seconds with a leading 0, 12:01 doesn't end up 12:1
	 * @param n (Number)
	 * @return String
	 */
	public static function padTime(n:Number):String {
		return (String( n ).length < 2) ? ("0" + n) : n;
	}

	/**
	 * converts a DB formatted date string into a Flash Date Object.
	 * @param dbDate (String) date in YYYY-MM-DD HH:MM:SS format
	 * @return Date
	 */
	public static function dateFromDB(dbdate:String):Date {
		var tmp:Array = dbdate.split( " " );
		var dates:Array = tmp[0].split( "-" );
		var hours:Array = tmp[1].split( ":" );
		var d:Date = new Date( dates[0], dates[1] - 1, dates[2], hours[0], hours[1], hours[2] );
		return d;
	}

	/**
	 * Takes 24hr hours and converts to 12 hour with am/pm.
	 * @param hour24 (Number)
	 * @return Object
	 */
	public static function getHoursAmPm(hour24:Number):Object {
		var returnObj:Object = new Object( );
		returnObj.ampm = (hour24 < 12) ? "am" : "pm";
		var hour12:Number = hour24 % 12;
		if (hour12 == 0) {
			hour12 = 12;
		}
		returnObj.hours = hour12;
		return returnObj;
	}

	/**
	 * Get the differences between two Dates in milliseconds.
	 * @param d1 (Date) 
	 * @param d2 (Date) optional [default: now]
	 * @return Number - difference between two dates in ms
	 */
	 
	public static function dateDiff(d1:Date, d2:Date):Number {
		if(d2 == null) d2 = new Date( );
		return d2.getTime( ) - d1.getTime( );
	}

	/**
	 * Check if birthdate entered meets required age.
	 * @param year (Number)
	 * @param month (Number)
	 * @param day (Number)
	 * @param requiredAge (Number)
	 * @return Boolean
	 */
	public static function isValidAge(year:Number, month:Number, day:Number, requiredAge:Number):Boolean {
		if (!isValidDate( year, month, day, true )) return false;
		var now:Date = new Date( );
		var bd:Date = new Date( year + requiredAge, month, day );
		return (now.getTime( ) > bd.getTime( ));
	}

	/**
	 * Check if a valid date can be created with inputs.
	 * @param year (Number)
	 * @param month (Number)
	 * @param day (Number)
	 * @param mustBeInPast (Boolean)
	 * @return Boolean
	 */
	public static function isValidDate(year:Number, month:Number, day:Number, mustBeInPast:Boolean):Boolean {
		if(!Range.isInRange( year, 1800, 3000 ) || isNaN( year )) return false;
		if(!Range.isInRange( month, 0, 11 ) || isNaN( month )) return false;
		if(!Range.isInRange( day, 1, 31 ) || isNaN( day )) return false;
		if(day > getTotalDaysInMonth( year, month )) return false;
		if(mustBeInPast && dateDiff( new Date( year, month, day ) ) < 0) return false;
		return true;
	}	

	/**
	 * Return the number of dates in a specific month.
	 * @param year (Number)
	 * @param month (Number)
	 * @return Number
	 */
	public static function getTotalDaysInMonth(year:Number, month:Number):Number {
		return TimeConversion.ms2days( dateDiff( new Date( year, month, 1 ), new Date( year, month + 1, 1 ) ) );
	}

	/**
	 * Returns the number of days in a specific year.
	 * @param year (Number)
	 * @return Number
	 */
	public static function getTotalDaysInYear(year:Number):Number {
		return TimeConversion.ms2days( dateDiff( new Date( year, 0, 1 ), new Date( year + 1, 0, 1 ) ) );
	}

	private function DateUtils() {
	}
}