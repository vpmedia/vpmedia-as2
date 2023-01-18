/*
Class	DateParser
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	18 nov. 2005
*/

//import
import ch.util.StringTokenizer;
import ch.util.date.Calendar;

/**
 * Parse dates.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		18 nov. 2005
 * @version		1.0
 */
class ch.util.date.DateParser
{
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new DateParser.
	 */
	private function DateParser(Void)
	{
		//empty
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Parse a date from the english format 2005-06-12 12:04:45.
	 * 
	 * @param	aDate	The date to parse.
	 * @return	The parsed {@code Date}.
	 * @throws	Error	If {@code aDate} is invalid.
	 */
	public static function parse(aDate:String):Date
	{
		var stk:StringTokenizer = new StringTokenizer(aDate);
		
		if (stk.countTokens() < 3)
		{
			throw new Error("ch.util.DataParser.parse : '"+aDate+"' is invalid !");
		}
		
		var year:Number = parseYear(stk.nextToken());
		var month:Number = parseMonth(stk.nextToken());
		var date:Number = parseDate(stk.nextToken());
		
		if (!Calendar.checkDate(year, month, date))
		{
			throw new Error("ch.util.DataParser.parse : '"+aDate+"' is invalid !");
		}
		
		if (!stk.hasMoreTokens())
		{
			return new Date(year, month, date);
		}
		
		var hour:Number = parseHour(stk.nextToken());
		
		if (!stk.hasMoreTokens())
		{
			return new Date(year, month, date, hour);
		}
		
		var minute:Number = parseMinute(stk.nextToken());
		
		if (!stk.hasMoreTokens())
		{
			return new Date(year, month, date, hour, minute);
		}
		
		var second:Number = parseSecond(stk.nextToken());
		
		if (!stk.hasMoreTokens())
		{
			return new Date(year, month, date, hour, minute, second);
		}
		
		var ms:Number = parseMillisecond(stk.nextToken());
		
		return new Date(year, month, date, hour, minute, ms);
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private static function parseYear(year:String):Number
	{
		if (isNaN(year))
		{
			throw new Error("ch.util.DateParser.parseYear : '"+year+"' is not a Number");
		}
		
		var ye:Number = parseInt(year);
		
		if (ye < 0)
		{
			throw new Error("ch.util.DateParser.parseYear : '"+year+"' is invalid");
		}
		
		if (ye < 100)
		{
			ye += parseInt("20"+year);
		}
		
		return ye;
	}
	
	private static function parseMonth(month:String):Number
	{
		if (isNaN(month))
		{
			throw new Error("ch.util.DateParser.parseMonth : '"+month+"' is not a Number");
		}
		
		var mon:Number = parseInt(month)-1;
		
		if (mon < 0)
		{
			throw new Error("ch.util.DateParser.parseMonth : '"+month+"' is invalid");
		}
		
		return mon;
	}
	
	private static function parseDate(date:String):Number
	{
		if (isNaN(date))
		{
			throw new Error("ch.util.DateParser.parseDate : '"+date+"' is not a Number");
		}
		
		var da:Number = parseInt(date);
		
		if (da < 0)
		{
			throw new Error("ch.util.DateParser.parseDate : '"+da+"' is invalid");
		}
		
		return da;
	}
	
	private static function parseHour(hour:String):Number
	{
		if (isNaN(hour))
		{
			throw new Error("ch.util.DateParser.parseHour : '"+hour+"' is not a Number");
		}
		
		var ho:Number = parseInt(hour);
		
		if (ho < 0)
		{
			throw new Error("ch.util.DateParser.parseHour : '"+hour+"' is invalid");
		}
		
		return ho;
	}
	
	private static function parseMinute(minute:String):Number
	{
		if (isNaN(minute))
		{
			throw new Error("ch.util.DateParser.parseMinute : '"+minute+"' is not a Number");
		}
		
		var mi:Number = parseInt(minute);
		
		if (mi < 0)
		{
			throw new Error("ch.util.DateParser.parseMinute : '"+minute+"' is invalid");
		}
		
		return mi;
	}
	
	private static function parseSecond(second:String):Number
	{
		if (isNaN(second))
		{
			throw new Error("ch.util.DateParser.parseSecond : '"+second+"' is not a Number");
		}
		
		var se:Number = parseInt(second);
		
		if (se < 0)
		{
			throw new Error("ch.util.DateParser.parseSecond : '"+second+"' is invalid");
		}
		
		return se;
	}
	
	private static function parseMillisecond(ms:String):Number
	{
		if (isNaN(ms))
		{
			throw new Error("ch.util.DateParser.parseMillisecond : '"+ms+"' is not a Number");
		}
		
		var m:Number = parseInt(ms);
		
		if (m < 0)
		{
			throw new Error("ch.util.DateParser.parseMillisecond : '"+ms+"' is invalid");
		}
		
		return m;
	}
}