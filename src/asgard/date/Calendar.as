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

import asgard.date.DateFormatter;
import asgard.date.LocalDate;
import asgard.date.Time;

import vegas.core.HashCode;
import vegas.core.ICloneable;
import vegas.core.ICopyable;
import vegas.core.IEquality;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.core.ISerializable;
import vegas.util.MathsUtil;
import vegas.util.serialize.Serializer;

/**
 * This class contains all tools to creates a calendar.
 * <p><b>Example :</b></p>
 * {@code
 * import asgard.date.Calendar ;
 * 
 * var c1:Calendar = new Calendar(2005, 2, 15) ;
 * trace ("c1 getTime : " + c1.getTime()) ;
 * trace ("c1 toSource : " + c1.toSource()) ;
 * var c2:Calendar = new Calendar() ;
 * 
 * trace ("-- c1 : " + c1) ;
 * trace ("-- c2 : " + c2) ;
 * 
 * trace ("> c1 after c2 : " + c1.after(c2)) ;
 * trace ("> c2 after c1 : " + c2.after(c1)) ;
 * trace ("> c1 before c2 : " + c1.before(c2)) ;
 * 
 * trace ("> c1 format : " + c1.format("dd/mm/yyyy HH' h' nn' mn' ss' s'")) ;
 * 
 * var clone:Calendar = c1.clone() ;
 * trace ("-- c1 clone : " + clone) ;
 * trace ("> c1 equals clone : " + c1.equals(clone)) ;
 * 
 * trace ("-----") ;
 * var count:Number = Calendar.getDaysInMonth(2005, 11) ;
 * trace ("> days in month 2005/12 : " + count) ;
 * var first:String = Calendar.getFirstDay(2005, 11, true) ;
 * trace ("> first day 2005/12 : " + first) ;
 * 
 * var fc:Array = Calendar.getFullMonthCalendar(2005, 11) ;
 * trace ("> full calendar 2005/12 : " + fc) ;
 * }
 * @author eKameleon
 */
class asgard.date.Calendar extends Date implements ICloneable, ICopyable, IEquality, IFormattable, IHashable, ISerializable 
{

	/**
	 * Creates a new Calendar instance.
	 * @param yearOrTimevalue (optional) If other parameters are specified, this number represents a year (such as 1965); otherwise, it represents a time value. If the number represents a year, a value of 0 to 99 indicates 1900 through 1999; otherwise all four digits of the year must be specified. If the number represents a time value (no other parameters are specified), it is the number of milliseconds before or after 0:00:00 GMT January 1, 1970; a negative values represents a time before 0:00:00 GMT January 1, 1970, and a positive value represents a time after.
	 * @param month (optional) An integer from 0 (January) to 11 (December).
	 * @param date (optional) An integer from 1 to 31.
	 * @param hour (optional) An integer from 0 (midnight) to 23 (11 p.m.).
	 * @param minute (optional) An integer from 0 to 59.
	 * @param second (optional) An integer from 0 to 59.
	 * @param millisecond (optional) An integer from 0 to 999 of milliseconds.
	 */
	public function Calendar(yearOrTimevalue:Number, month:Number, date:Number, hour:Number, minute:Number, second:Number, millisecond:Number) 
	{
		super(yearOrTimevalue, month, date, hour, minute, second, millisecond) ;
	}

	/**
  	 * Constant field representing Day
	 */
	static public var DAY:String = "D" ;

	/**
	 * The default offset use in the getFullMonthCalendar() method.
	 */
	static public var DEFAULT_FULL_MONTH_OFFSET:Number = 0 ;

	/**
	 * Constant field representing hours.
	 */
	static public var HOUR:String = "h" ;

	/**
	 * Constant field representing milliseconds.
	 */
	static public var MILLISECOND:String = "ms" ;

	/**
	 * Constant field representing minutes.
	 */
	static public var MINUTE:String = "mn" ;

	/**
	 * Constant field representing Month
	 */	
	static public var MONTH:String = "M" ;

	/**
	 * Constant field representing seconds.
	 */
	static public var SECOND:String = "s" ;
	
	/**
	 * Constant field representing Week
	 */
	static public var WEEK:String = "W" ;
	
	/**
	 * Constant field representing Year
	 */
	static public var YEAR:String = "Y" ;

	/**
	 * Constant field representing one day, in milliseconds
	 */
	static public var ONE_DAY_MS:Number = 1000*60*60*24 ;

	/**
 	 * Adds the specified amount of time to the this instance.
 	 * <p>Examples :</p>
 	 * {@code
 	 * import asgard.date.Calendar ;
 	 *
 	 * var begin:Calendar = new Calendar( 2007, 5 , 14, 11, 30, 0 ) ;
 	 * var duration:Number = 50 ;
 	 * 
 	 * var end:Calendar = Calendar.add( begin, Calendar.MINUTE , 50 ) ;
 	 *
 	 * var sBegin:String = begin.format("MM dd yyyy hh:nn:ss") ;
 	 * var sFinish:String   = end.format("MM dd yyyy hh:nn:ss") ;
 	 * 
 	 * trace( "start  : " + sBegin ) ;
 	 * trace( "finish : " + sFinish ) ;
 	 * }
	 * @param date The Date object to perform addition on
	 * @param field The this field constant to be used for performing addition.
	 * @param amount The number of units (measured in the field constant) to add to the date.
	 * @return the new {@code Calendar} object.
	 */
	static public function add( date:Date, field:String, amount:Number ):Calendar 
	{
		var c:Calendar = new Calendar( (date == null) ? (new Date()).valueOf() : date.valueOf() );
		switch (field) 
		{
			case Calendar.MILLISECOND :
			{
				c.setTime( c.getTime() + amount ) ; 
				break ;
			}
			case Calendar.SECOND :
			{
				c.setTime( c.getTime() + (amount * Time.SECOND) ) ;
				break ;	
			}
			case Calendar.MINUTE :
			{
				c.setTime( c.valueOf() + (amount * Time.MINUTE) ) ;
				break ;
			}
			case Calendar.HOUR :
			{
				c.setTime( c.getTime() + (amount * Time.HOUR) ) ;
				break ;
			}
			case Calendar.DAY :
			{
				c.setDate( date.getDate() + amount ) ;
				break;
			}
			case Calendar.WEEK :
			{
				c.setDate( date.getDate() + 7 ) ;
				break;
			}
			case Calendar.MONTH :
			{
				var newMonth:Number = date.getMonth() + amount;
				var years:Number = 0;
				if (newMonth < 0) 
				{
					while (newMonth < 0) 
					{
						newMonth += 12;
						years -= 1 ;
					}
				}
				else if (newMonth > 11) 
				{
					while (newMonth > 11) 
					{
						newMonth -= 12;
						years += 1 ;
					}
				}
				c.setMonth(newMonth) ;
				c.setFullYear(date.getFullYear() + years) ;
				break ;
			}
			case Calendar.YEAR :
			{
				c.setFullYear(date.getFullYear() + amount) ;
				break;
			}
		}
		return c ;
	}
	
	/**
	 * Returns {@code true} if the current time of this Calendar is after the time of Calendar when; false otherwise.
	 * @return {@code true} if the current time of this Calendar is after the time of Calendar when; false otherwise.
	 */
	public function after(d:Date):Boolean 
	{
		return d.valueOf() < valueOf() ;
	}

	/**
	 * Returns {@code true} if the current time of this Calendar is before the time of Calendar when; false otherwise.
	 * @return {@code true} if the current time of this Calendar is before the time of Calendar when; false otherwise. 
	 */
	public function before( d:Date ):Boolean 
	{
		return d.valueOf() > valueOf() ;
	}
	
	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		return new Calendar(valueOf()) ;
	}
	
	/**
	 * Returns the deep copy of this object.
	 * @return the deep copy of this object.
	 */
	public function copy() 
	{
		return new Calendar(valueOf()) ;
	}
	
	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		return o instanceof Date && o.valueOf() == valueOf() ;
	}

	/**
	 * Format the current Calendar date.
	 * @param pattern The {@code String} representation of the format pattern.
	 * @return the format string representation of the current Calendar date.
	 */
	public function format(pattern:String):String 
	{
		return (new DateFormatter(pattern)).format(this) ;
	}

	/**
	 * Returns the array representation of all days in the current month.
	 * @param offset the day offset value between 0 and 6 to fill the calendar. The default value is 0 (Sunday). 
	 * @return the array representation of all days in the current month.
	 */
	static public function getCurrentFullMonthCalendar( offset:Number ):Array 
	{
		return getFullMonthCalendar( null, offset ) ;
	}

	/**
	 * Returns the numbers of days in a specified month.
	 * @param d The specified {@code Date} object.
	 * @return the numbers of days in a specified month.
	 */
	static public function getDaysInMonth( d:Date ):Number 
	{
		var y:Number = d.getFullYear() ;
		var m:Number = d.getMonth() ;
		var monthDays:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] ;
		if (((y%4 == 0) && !(y%100 == 0) ) || (y%400 == 0)) 
		{
			monthDays[1] = 29 ;
		}
		return monthDays[m] ;
	}

	/**
	 * Calculates the number of days the specified date is from January 1 of the specified calendar year.
	 * Passing January 1 to this function would return an offset value of zero.
	 * @param date The Date for which to find the offset
	 * @param calendarYear The calendar year to use for determining the offset
	 * @return The number of days since January 1 of the given year
	 */
	static public function getDayOffset( date:Date, calendarYear:Number ):Number 
	{
		if (date == null)
		{
			date = new Date() ;	
		}
		var beginYear = Calendar.getJan1(calendarYear); // Find the start of the year. This will be in week 1.
		return Math.ceil( (date.getTime() - beginYear.getTime()) / Calendar.ONE_DAY_MS );
	}

	/**
	 * Returns the first day in the specified month.
	 * @param d The specified {@code Date} object of this method. 
	 * @return the first day in the specified month.
	 */
	static public function getFirstDay( d:Date, nameFlag:Boolean) 
	{
		if (d == null)
		{
			d = new Date() ;
		}
		var firstDay:Date = new Date( d.getFullYear(), d.getMonth()) ;
		return nameFlag ? LocalDate.getDays()[firstDay.getDay() ] : firstDay.getDay()  ;
	}
	
	/**
	 * Returns an array representation of all days in a full month. The array can begin with null values if the first day in the first week are previous days of the previous month.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import asgard.date.Calendar ;
	 * var ar:Array = Calendar.getFullMonthCalendar( new Date(2007,03) , 1 ) ;
	 * trace(ar) ;
	 * }
	 * @param d (optional) The specified {@code Date} to return the full month calendar. The default value is the current {@code Date} object.
	 * @param offset the day offset value between 0 and 6 to fill the calendar. The default value is 0 (Sunday). 
	 * @return an array representation of a full month.
	 */
	static public function getFullMonthCalendar( d:Date , offset:Number ):Array 
	{
		
		if (d == null)
		{
			d = new Date() ;	
		}
		
		if (isNaN(offset))
		{
			offset = DEFAULT_FULL_MONTH_OFFSET ;
		}

		offset = MathsUtil.clamp(offset, 0, 6) ; 
		
		var y:Number = d.getFullYear() ;
		var m:Number = d.getMonth() ;
		var min:Number = getFirstDay ( d ) - offset ;
		
		if (min < 0)
		{
			min += 7 ;
		}
		
		var max:Number = min + getDaysInMonth ( d ) ;
		var ar:Array = new Array () ;
		for (var i:Number = 0 ; i < max ; i++) 
		{
			var date:Number = (i - min + 1)  ;
			ar[i] = (i < min) ? null : new Calendar(y, m, date) ;
		}
		return ar ;
	}

	/**
	 * Retrieves a Date object representing January 1 of any given year.
	 * @param calendarYear	The calendar year for which to retrieve January 1
	 * @return January 1 of the calendar year specified.
	 */
	static public function getJan1(calendarYear:Number):Date 
	{
		return new Date(calendarYear, 0, 1) ; 
	}
	
	/**
	 * Returns the {@code Date} of the next month of the specified {@code Date} object.
	 * @return the {@code Data} of the next month of the specified {@code Date} object.
	 */
	static public function getNextMonth( date:Date ):Calendar
	{
		var today:Date = date || new Date() ;
		var thisMonth:Number = today.getMonth() ;
		if( thisMonth < 11 )
		{
			today.setMonth(thisMonth + 1) ;
		}
		else
		{
			today.setMonth(0);
			today.setFullYear(today.getFullYear() + 1);
		}
		return new Calendar( today.valueOf() ) ;
	}

	/**
	 * Returns the {@code Date} of the previous month of the specified {@code Date} object.
	 * @return the {@code Date} of the previous month of the specified {@code Date} object.
	 */
	static public function getPreviousMonth( date:Date ):Calendar
	{
		var today:Date = date || new Date() ;
		var thisMonth:Number = today.getMonth();
		if(thisMonth > 0)
		{
			today.setMonth(thisMonth - 1);
		}
		else
		{
			today.setMonth(11);
			today.setFullYear(today.getFullYear() - 1);
		}
		return new Calendar( today.valueOf() ) ;
	}

	/**
	 * Calculates the week number for the given date. This function assumes that week 1 is the 
	 * week in which January 1 appears, regardless of whether the week consists of a full 7 days.
	 * The calendar year can be specified to help find what a the week number would be for a given date if the date overlaps years. 
	 * For instance, a week may be considered week 1 of 2005, or week 53 of 2004. 
	 * Specifying the optional calendarYear allows one to make this distinction easily.
 	 * @param date The date for which to find the week number
	 * @param calendarYear (optional) The calendar year to use for determining the week number. Default is the calendar year of parameter "date".
	 * @param weekStartsOn (optional) The integer (0-6) representing which day a week begins on. Default is 0 (for Sunday).
	 * @return The week number of the given date.
	 */
	static public function getWeekNumber(date:Date, calendarYear:Number, weekStartsOn:Number):Number 
	{
		if (isNaN(weekStartsOn)) weekStartsOn = 0 ;
		if (isNaN(calendarYear)) calendarYear = date.getFullYear();
		
		var weekNum:Number = -1 ;
		
		var jan1:Date = Calendar.getJan1(calendarYear);
		var jan1DayOfWeek:Number = jan1.getDay() ;
		
		var month:Number = date.getMonth();
		var day:Number = date.getDate();
		var year:Number = date.getFullYear();
		
		var dayOffset:Number = Calendar.getDayOffset(date, calendarYear); // Days since Jan 1, Calendar Year
			
		if (dayOffset < 0 && dayOffset >= (-1 * jan1DayOfWeek)) 
		{
			weekNum = 1;
		}
		else
		{
			weekNum = 1;
			var testDate:Date = Calendar.getJan1(calendarYear);
			while (testDate.getTime() < date.getTime() && testDate.getFullYear() == calendarYear) 
			{
				weekNum += 1;
				testDate = Calendar.add(testDate, Calendar.WEEK, 1);
			}
		}
		
		return weekNum;
	};

	/**
	 * Returns {@code true} if the current or specified {@code Date} if the last day in the current or specified month.
	 * @return {@code true} if the current or specified {@code Date} if the last day in the current or specified month.
	 */
	static public function isEndOfMonth( date:Date ):Boolean
	{
		var today:Date = (date == undefined) ? new Date() : date ;
		var y:Number = today.getYear() ;
		var m:Number = today.getMonth() ;
		var lastDate:Number = getDaysInMonth( today ) ; 
		return today.getDate().valueOf() == lastDate.valueOf() ;
	}

	/**
	 * Returns the hashcode representation of this object.
	 * @return the hashcode representation of this object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Registers this object to be use with AMF protocol. Use this method with Flash remoting class mapping for example.
	 */
	static public function register( registerName:String ):Void
	{
		Object.registerClass( registerName || "Calendar", Calendar) ;
	}

	/**
	 * Subtracts the specified amount of time from the this instance.
 	 * @param date The Date object to perform subtraction on
	 * @param field	The this field constant to be used for performing subtraction.
	 * @param amount The number of units (measured in the field constant) to subtract from the date.
	 * @return the new {@code Calendar} object.
	 */
	static public function subtract(date:Date, field:String, amount:Number):Date 
	{
		return Calendar.add(date, field, (amount*-1));
	}
	
	/**
	 * Returns the {@code Date} representation of this object.
	 * @return the {@code Date} representation of this object.
	 */
	public function toDate():Date
	{
		return new Date( valueOf() ) ;	
	}

	/**
	 * Returns the Calendar reference of the "tomorrow" {@code Calendar} object of the specified {@code Date} in argument.
	 * <p><b>Example :</b></p>
	 * {@code
	 * trace ( "toDay     : " + (new Calendar()).format("DDDD yyyy-mm-dd") ) ;
	 * trace ( "tomorrow  : " + (Calendar.tomorrow()).format("DDDD yyyy-mm-dd") ) ;
	 * }
	 * @return the Calendar reference of the "tomorrow" {@code Calendar} object of the specified {@code Date} in argument.
	 */
	static public function tomorrow( d:Date ):Calendar
	{
		return new Calendar( (d || new Date()).valueOf() + ONE_DAY_MS ) ;
	}

	/**
	 * Returns the Eden string representation of this object.
	 * @return the Eden string representation of this object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return Serializer.getSourceOf(this, [Serializer.toSource(valueOf())]) ;
	}
	
	/**
	 * Returns the Calendar reference of the "yesterday" {@code Calendar} object of the specified {@code Date} in argument.
	 * <p><b>Example :</b></p>
	 * {@code
	 * trace ( "yesterday : " + (Calendar.yesterday()).format("DDDD yyyy-mm-dd") ) ;
	 * trace ( "toDay     : " + (new Calendar()).format("DDDD yyyy-mm-dd") ) ;
	 * }
	 * @return the Calendar reference of the "yesterday" {@code Calendar} object of the specified {@code Date} in argument.
	 */
	static public function yesterday ( d:Date ):Calendar
	{
		d = d || new Date() ;
		return new Calendar( (d || new Date()).valueOf() - ONE_DAY_MS ) ;
	}

	static private var _initHashCode:Boolean = HashCode.initialize(Calendar.prototype) ;
}