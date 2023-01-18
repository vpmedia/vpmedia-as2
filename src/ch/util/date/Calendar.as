/*
Class	Calendar
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	25 nov. 2005
*/

/**
 * Represent a gregorian calendar.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		25 nov. 2005
 * @version		1.0
 */
class ch.util.date.Calendar
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Month January.
	 * <p>Constant value : 0.</p>
	 */
	public static function get JANUARY():Number { return 0; }
	
	/**
	 * Month February.
	 * <p>Constant value : 1.</p>
	 */
	public static function get FEBRUARY():Number { return 1; }
	/**
	 * Month March.
	 * <p>Constant value : 2.</p>
	 */
	public static function get MARCH():Number { return 2; }
	/**
	 * Month April.
	 * <p>Constant value : 3.</p>
	 */
	public static function get APRIL():Number { return 3; }
	/**
	 * Month May.
	 * <p>Constant value : 4.</p>
	 */
	public static function get MAY():Number { return 4; }
	/**
	 * Month June.
	 * <p>Constant value : 5.</p>
	 */
	public static function get JUNE():Number { return 5; }
	/**
	 * Month July.
	 * <p>Constant value : 6.</p>
	 */
	public static function get JULY():Number { return 6; }
	/**
	 * Month August.
	 * <p>Constant value : 7.</p>
	 */
	public static function get AUGUST():Number { return 7; }
	/**
	 * Month September.
	 * <p>Constant value : 8.</p>
	 */
	public static function get SEPTEMBER():Number { return 8; }
	/**
	 * Month October.
	 * <p>Constant value : 9.</p>
	 */
	public static function get OCTOBER():Number { return 9; }
	/**
	 * Month November.
	 * <p>Constant value : 10.</p>
	 */
	public static function get NOVEMBER():Number { return 10; }
	/**
	 * Month December.
	 * <p>Constant value : 11.</p>
	 */
	public static function get DECEMBER():Number { return 11; }
	
	/**
	 * Day Sunday.
	 * <p>Constant value : 0.</p>
	 */
	public static function get SUNDAY():Number { return 0; }
	
	/**
	 * Day Monday.
	 * <p>Constant value : 1.</p>
	 */
	public static function get MONDAY():Number { return 1; }
	
	/**
	 * Day Tuesday.
	 * <p>Constant value : 2.</p>
	 */
	public static function get TUESDAY():Number { return 2; }
	
	/**
	 * Day Wednesday.
	 * <p>Constant value : 3.</p>
	 */
	public static function get WEDNESDAY():Number { return 3; }
	
	/**
	 * Day Thursday.
	 * <p>Constant value : 4.</p>
	 */
	public static function get THURSDAY():Number { return 4; }
	
	/**
	 * Day Firday.
	 * <p>Constant value : 5.</p>
	 */
	public static function get FIRDAY():Number { return 5; }
	
	/**
	 * Day Saturday.
	 * <p>Constant value : 6.</p>
	 */
	public static function get SATURDAY():Number { return 6; }
	
	//---------//
	//Variables//
	//---------//
	private var			_year:Number; //the year
	private var			_month:Number; //the month
	private var			_date:Number; //the date
	private static var	__monthDays:Array =					 [31,
															  -1, //for february, an algo is used
															  31,
															  30,
															  31,
															  30,
															  31,
															  31,
															  30,
															  31,
															  30,
															  31
															  ];
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new Calendar with the specified date.
	 * <p>If a parameter is not specified, the field will be extract from
	 * the current date.</p>
	 * 
	 * @param		year	The year or {@code null}.
	 * @param		month	The month or {@code null}.
	 * @param		date	The date or {@code null}.
	 */
	public function Calendar(year:Number, month:Number, date:Number)
	{
		_year = 1970;
		_month = 0;
		_date = 1;
		
		setYear(year);
		setMonth(month);
		setDate(date);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Check if a date is valid.
	 * 
	 * @param	year	The year.
	 * @param	month	The month (0-11).
	 * @param	date	The date (1-31).
	 */
	public static function checkDate(year:Number, month:Number, date:Number):Boolean
	{
		//check the ranges
		if (month > 11 || month < 0)
		{
			return false;
		}
		
		if (date > 31 || date < 1)
		{
			return false;
		}
		
		//check the number of days
		if (month == FEBRUARY)
		{
			if (Calendar.isLeapYear(year) && date > 29)
			{
				return false;
			}
			else if (date > 28)
			{
				return false;
			}
		}
		else if (date > __monthDays[month])
		{
			return false;
		}
		
		return true;
	}
	
	/**
	 * Get if a year is leap (if february has 29 days).
	 * 
	 * @param	year	The year to check.
	 * @return	{@code true} if {@code year} is a leap year.
	 */
	public static function isLeapYear(year:Number):Boolean
	{
		year = Math.abs(year);
		
		if (year%4 == 0 && year%100 != 0)
		{
			return true;
		}
		else if (year%400 == 0)
		{
			return true;
		}
		
		return false;
	}
	
	/**
	 * Get the number of days in the month of the year.
	 * 
	 * @param	year	The year.
	 * @param	month	The month (0-11).
	 * @return	The number of days of the specified {@code month} of the specified {@code year}.
	 * @throws	Error	If {@code month} is invalid.
	 */
	public static function getDayCount(year:Number, month:Number):Number
	{
		if (month < 0 || month > 11)
		{
			throw new Error("ch.util.date.Calendar.getDayCount : month is invalid");
		}
		
		var d:Number = __monthDays[month];
		
		if (d == -1)
		{
			d = (Calendar.isLeapYear(year)) ? 29 : 28;
		}
			
		return d;
	}
	
	/**
	 * Get the year.
	 * 
	 * @return	The year.
	 */
	public function getYear(Void):Number
	{
		return _year;
	}
	
	/**
	 * Set the year.
	 * <p>If {@code year} is not specified, the
	 * current year will be used.</p>
	 * 
	 * @param	year	The year or {@code null}.
	 * @throws	Error	If the new date is invalid.
	 */
	public function setYear(year:Number):Void
	{
		var ny:Number = (year == null) ? (new Date()).getFullYear() : year;
		
		if (!Calendar.checkDate(ny, _month, _date))
		{
			throw new Error(this+".setYear : invalid date ("+ny+"."+(_month+1)+"."+_date+")");
		} 
		
		_year = ny;
	}
	
	/**
	 * Get the month.
	 * 
	 * @return	A Number between 0 and 11.
	 */
	public function getMonth(Void):Number
	{
		return _month;
	}
	
	/**
	 * Set the month.
	 * <p>If {@code month} is not specified, the
	 * current month will be used. {@code month} must
	 * stand between 0 and 11 included.</p>
	 * 
	 * @param	month	The month (between 0 and 11) or {@code null}.
	 * @throws	Error	If {@code month} is invalid.
	 * @throws	Error	If the new date is invalid.
	 */
	public function setMonth(month:Number):Void
	{
		if (month != null  && (month < 0 || month > 11))
		{
			throw new Error(this+".setMonth : month invalid ("+month+")");
		}
		
		var nm:Number = (month == null) ? (new Date()).getMonth() : month;
		
		if (!Calendar.checkDate(_year, nm, _date))
		{
			throw new Error(this+".setMonth : invalid date ("+_year+"."+(nm+1)+"."+_date+")");
		}
		
		_month = nm;
	}
	
	/**
	 * Get the date.
	 * 
	 * @return	A Number between 1 and 31.
	 */
	public function getDate(Void):Number
	{
		return _date;
	}
	
	/**
	 * Set the date.
	 * <p>If no date is specified, the current date will be used.</p>
	 * 
	 * @param	date	The date (between 1 and 31) or {@code null}.
	 * @throws	Error	If {@code date} is invalid.
	 * @throws	Error	If the new date is invalid.
	 */
	public function setDate(date:Number):Void
	{
		if (date != null && (date < 1 || date > 31))
		{
			throw new Error(this+".setDate : date invalid ("+date+")");
		}
		
		var nd:Number = (date == null) ? (new Date()).getDate() : date;
		
		if (!Calendar.checkDate(_year, _month, nd))
		{
			throw new Error(this+".setDate : invalid date ("+_year+"."+(_month+1)+"."+nd+")");
		}
		
		_date = nd;
	}
	
	/**
	 * Transform the {@code Calendar} into a {@code Date} Object.
	 * 
	 * @return	The new {@code Date} created.
	 */
	public function toDate(Void):Date
	{
		return new Date(_year, _month, _date);
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the Calendar instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.date.Calendar";
	}
}