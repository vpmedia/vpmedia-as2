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

import asgard.date.LocalDate;

import pegas.maths.Range;

import vegas.errors.IllegalArgumentError;
import vegas.util.format.AbstractFormatter;

/**
 * DateFormatter formats a given date with a specified pattern.
 * <p>Use the declared constants as placeholders for specific parts of the date-time.</p>
 * <p>All characters from 'A' to 'Z' and from 'a' to 'z' are reserved, although not all of these characters are interpreted right now.</p> 
 * <p>If you want to include plain text in the pattern put it into quotes (') to avoid interpretation.</p>
 * <p>If you want a quote in the formatted date-time, put two quotes directly after one another. For example: {@code "hh 'o''clock'"}.</p>
 * <p><b>Example :</b>
 * {@code
 * import asgard.date.DateFormatter ;
 * 
 * var f:DateFormatter = new DateFormatter() ;
 * 
 * f.pattern = "yyyy DDDD d MMMM - hh 'h' nn 'mn' ss 's'" ;
 * var result:String = f.format() ;
 * trace("pattern : " + f.pattern) ;
 * trace("result  : " + result) ;
 * 
 * trace("----") ;
 * 
 * f.pattern = "DDDD d MMMM yyyy" ;
 * var result:String = f.format(new Date(2005, 10, 22)) ;
 * trace("pattern : " + f.pattern) ;
 * trace("result  : " + result) ;
 * }
 * @author eKameleon
 */
class asgard.date.DateFormatter extends AbstractFormatter 
{

	/**
	 * Creates a new DateFormatter instance.
	 * <p>If you do not pass-in a pattern or if the passed-in one is null or undefined the constant DEFAULT_DATE_FORMAT is used.</p>
	 * @param pattern (optional) the pattern describing the date and time format.
	 */
	public function DateFormatter( pattern:String ) 
	{
		super( pattern || DEFAULT_DATE_FORMAT ) ;
	}

	/**
	 * The default date format pattern {@code "dd.mm.yyyy HH:nn:ss"}.
	 */
	static public  var DEFAULT_DATE_FORMAT:String = "dd.mm.yyyy HH:nn:ss" ;
	
	/**
	 * Placeholder for day in month as number in date format.
	 */
	static public var DAY_AS_NUMBER:String = "d";
	
	/**
	 * Placeholder for day in week as text in date format.
	 */
	static public var DAY_AS_TEXT:String = "D";
	
	/**
	 * Placeholder for hour in am/pm (1 - 12) in date format.
	 */
	static public var HOUR_IN_AM_PM:String = "h";
	
	/**
	 * Placeholder for hour in day (0 - 23) in date format.
	 */
	static public var HOUR_IN_DAY:String = "H";

	/**
	 * Placeholder for minute in hour in date format.
	 */
	static public var MINUTE:String = "n";

	/**
	 * Placeholder for millisecond in date format.
	 */
	static public var MILLISECOND:String = "S";

	/**
	 * Placeholder for month in year as number in date format.
	 */
	static public var MONTH_AS_NUMBER:String = "m";
	
	/**
	 * Placeholder for month in year as text in date format.
	 */
	static public var MONTH_AS_TEXT:String = "M";
	
	/**
	 * Quotation beginning and ending token. 
	 */
	static public var QUOTE:String = "'";

	/**
	 * The internal range use to defined the days as text in the DateFormatter.
	 */
	static public var RANGE_DAY_AS_TEXT:Range = new Range(0, 6) ;

	/**
	 * The internal range use to defined the hours in the DateFormatter.
	 */
	static public var RANGE_HOUR:Range = new Range(0, 23) ;

	/**
	 * The internal range use to defined the minutes in the DateFormatter.
	 */
	static public var RANGE_MINUTE:Range = new Range(0, 59) ;

	/**
	 * The internal range use to defined the milliseconds in the DateFormatter.
	 */
	static public var RANGE_MILLISECOND:Range = new Range(0, 999) ;

	/**
	 * The internal range use to defined the months in the DateFormatter.
	 */
	static public var RANGE_MONTH:Range = new Range(0, 11) ;

	/**
	 * The internal range use to defined the seconds in the DateFormatter.
	 */
	static public var RANGE_SECOND:Range = new Range(0, 59) ;

	/**
	 * Placeholder for second in minute in date format.
	 */
	static public var SECOND:String = "s";

	/**
	 * Placeholder for year in date format.
	 */
	static public var YEAR:String = "y";
	
	/**
	 * Format a date based on the current style set for the Date Formatter.
	 * <p>If the passed-in {@code date} is {@code null} or {@code undefined}, the current date-time will be used instead.
	 * @param o the date-time value to format into a date-time string.
	 * @return The formatted date-time string representation.
	 */
	public function format(o):String 
	{
		if (pattern == null) 
		{
			return "" ;
		}
		var date:Date = (o instanceof Date) ? o : new Date() ;
		var p:String = getPattern() ;
		var a:Array = p.split("") ;
		var l:Number = a.length ;
		var cpt:Number ;
		var ch:String ; // current character
		var i:Number = -1 ;
		var r:String = "" ;
		while (++i < l) 
		{
			ch = a[i] ;
			if (ch == DateFormatter.QUOTE) 
			{
				if (a[i + 1] == DateFormatter.QUOTE) 
				{
					r += "'" ; 
					i++ ;
				}
				var next:Number = i ;
				var prev:Number ;
				while (true) 
				{
					prev = next ;
					next = p.indexOf("'", next + 1) ;
					if (a[next + 1] != QUOTE) break ;
					r += p.substring(prev+1, next+1) ;
					next++;
				}
				r += p.substring(prev+1, next) ;
				i = next ;
			} 
			else if (ch == YEAR) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatYear( date.getFullYear(), cpt );
				i += cpt - 1 ;
			}
			else if (ch == MONTH_AS_NUMBER) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatMonthAsNumber(date.getMonth(), cpt);
				i += cpt - 1 ;
			}
			else if (ch == MONTH_AS_TEXT) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatMonthAsText(date.getMonth(), cpt) ;
				i += cpt - 1 ;
			} 
			else if (ch == DAY_AS_NUMBER) 
			{
				cpt = _count(ch, a.slice(i)) ;
				r += formatDayAsNumber(date.getDate(), cpt) ;
				i += cpt - 1 ;
			}
			else if (ch == DAY_AS_TEXT) 
			{
				cpt = _count(ch, a.slice(i)) ;
				r += formatDayAsText(date.getDay(), cpt) ;
				i += cpt - 1 ;
			} 
			else if (ch == HOUR_IN_AM_PM) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatHourInAmPm(date.getHours(), cpt) ;
				i += cpt - 1 ;
			} 
			else if (ch == HOUR_IN_DAY) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatHourInDay(date.getHours(), cpt) ;
				i += cpt - 1 ;
			} 
			else if (ch == MINUTE) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatMinute(date.getMinutes(), cpt) ;
				i += cpt - 1 ;
			}
			else if (ch == SECOND) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatSecond( date.getSeconds(), cpt ) ;
				i += cpt - 1 ;
			}
			else if (ch == MILLISECOND) 
			{
				cpt = _count(ch, a.slice(i));
				r += formatMillisecond(date.getMilliseconds(), cpt);
				i += cpt - 1 ;
			} 
			else 
			{
				r += ch;
			}
		} 
		return r ;
	}

	public function formatDayAsNumber(day:Number, cpt:Number):String 
	{
		if (isNaN(cpt)) 
		{
			cpt = 0 ;
		}
		var string:String = day.toString();
		return (getZeros(cpt - string.length) + string);
	}
	
	public function formatDayAsText(day:Number, cpt:Number):String 
	{
		if (RANGE_DAY_AS_TEXT.isOutOfRange(day)) 
		{
			throw new IllegalArgumentError(this + " formatDayAsText method failed, the day value is out of range.") ;
		}
		if (isNaN(cpt)) 
		{
			cpt = 0 ;
		}
		var days:Array = LocalDate.getDays() ;
		var r:String = days[day] ;
		if (cpt < 4) return r.substr(0, 2);
		return r ;
	}

	/**
	 * Formats the specified hour value in a string representation with the am-pm notation.
	 * @return the specified hour value in a string representation with the am-pm notation.
	 */
	public function formatHourInAmPm(hour:Number, cpt:Number):String 
	{
		if (RANGE_HOUR.isOutOfRange(hour)) 
		{
			throw new IllegalArgumentError(this + " formatHourInAmPm method failed, the hour value is out of range.") ;
		}
		if (isNaN(cpt)) 
		{
			cpt = 0 ;
		}
		var s:String ;
		if (hour == 0) 
		{
			s = (12).toString() ;
		}
		else if (hour > 12) 
		{
			s = (hour - 12).toString() ;
		}
		else 
		{
			s = hour.toString();
		}
		return (getZeros(cpt - s.length) + s);
	}
	
	/**
	 * Formats an hour number in string expression.
	 */
	public function formatHourInDay(hour:Number, cpt:Number):String 
	{
		if (RANGE_HOUR.isOutOfRange(hour))
		{
			throw new IllegalArgumentError(this + " formatHourInDay method failed, the hour value is out of range.") ;
		}
		if (isNaN(cpt)) 
		{
			cpt = 0 ;
		}
		var s:String = hour.toString();
		return (getZeros(cpt - s.length) + s) ;
	}

	public function formatMillisecond(millisecond:Number, cpt:Number):String 
	{
		if (RANGE_MILLISECOND.isOutOfRange(millisecond)) 
		{
			throw new IllegalArgumentError(this + " formatMillisecond method failed, the millisecond value is out of range.");
		}
		if (isNaN(cpt)) 
		{
			cpt = 0 ;
		}
		var s:String = millisecond.toString();
		return (getZeros(cpt - s.length) + s) ;
	}

	public function formatMinute(minute:Number, cpt:Number):String 
	{
		if (RANGE_MINUTE.isOutOfRange(minute)) 
		{
			throw new IllegalArgumentError(this + " formatMinute method failed, the minute value is out of range.") ;
		}
		if (isNaN(cpt)) cpt = 0 ;
		var s:String = minute.toString();
		return (getZeros(cpt - s.length) + s);
	}
	
	public function formatMonthAsNumber(month:Number, cpt:Number):String 
	{
		if (RANGE_MONTH.isOutOfRange(month)) 
		{
			throw new IllegalArgumentError(this + " formatMonthAsNumber method failed, the month value is out of range.") ;
		}
		if (isNaN(cpt)) cpt = 0 ;
		var string:String = (month + 1).toString();
		return (getZeros(cpt - string.length) + string) ;
	}
	
	public function formatMonthAsText(month:Number, cpt:Number):String 
	{
		if (RANGE_MONTH.isOutOfRange(month)) 
		{
			throw new IllegalArgumentError(this + " formatMonthAsText method failed, the month value is out of range.") ;
		}
		if (isNaN(cpt)) cpt = 0 ;
		var r:String;
		var months:Array = LocalDate.getMonths() ;
		r = months[month] ;
		if (cpt < 4) return r.substr(0, 3);
		return r;
	}

	/**
	 * Format the second value passed in argument.
	 * @return the second string representation of this DateFormatter.
	 */
	public function formatSecond(second:Number, cpt:Number):String 
	{
		if (RANGE_SECOND.isOutOfRange(second)) 
		{
			throw new IllegalArgumentError(this + " formatSecond method failed, the second value is out of range.") ;
		}
		if (isNaN(cpt))
		{
			cpt = 0 ;
		}
		var s:String = second.toString() ;
		return (getZeros(cpt - s.length) + s);
	}

	/**
	 * Format the year value passed in argument.
	 * @return the year string representation of this DateFormatter.
	 */
	public function formatYear( year:Number, cpt:Number ):String 
	{
		if ( isNaN(year) ) 
		{
			throw new IllegalArgumentError(this + " formatYear method failed, the year value must be a Number.") ;
		}
		if (isNaN(cpt)) 
		{
			cpt = 0 ;
		}
		if (cpt < 4) 
		{
			return year.toString().substr(2) ;
		}
		return (getZeros(cpt - 4) + year.toString());
	}

	/**
	 * Returns a string representation fill by 0 values or an empty string if the cpt value is NaN or <1.
	 * @return a string representation fill by 0 values or an empty string if the cpt value is NaN or <1.
	 */
	public function getZeros(cpt:Number):String 
	{
		if (cpt < 1 || isNaN(cpt)) 
		{
			return "" ;
		}
		if (cpt < 2) 
		{
			return "0" ;
		}
		var r:String = "00";
		cpt -= 2;
		while (cpt) 
		{
			r += "0" ;
			cpt-- ;
		}
		return r ;
	}
	
	private function _count(char:String, a:Array):Number 
	{
		if (!a) return 0 ;
		var r:Number = 0 ;
		var i:Number = -1 ;
		var l:Number = a.length ;
		while (++i < l && a[r] == char) 
		{
			r++ ;
		}
		return r ;
	}


}