import com.cetdemi.Timeline.*;

/**
 * A wrapper for Date that calculates positions, strings, other stuff from a string
 * representing a date
 */
class com.cetdemi.Timeline.DateWrapper
{
	/**
	* The original date received in contructor
	*/
	private var rawDate:String;
	
	/**
	* Internal utc
	*/
	private var _utc:Number = -1;
	/** 
	* Internal position
	*/
	private var _pos:Number = -1;
	
	private var _monthLengths:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
	
	/**
	* Constructor
	*/
	function DateWrapper(rawDate)
	{
		this.rawDate = rawDate;
	}
	
	/**
	* Shows the raw date un human-readable format
	*/
	function toString()
	{
		var monthnames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		//Assigns a numerical value to a date
		var day = rawDate.substr(0,2);
		var month = Number(rawDate.substr(2,2)) - 1;
		
		//Since we will rawDate UTC, we need years over 1970, hence the +100
		var year = Number(rawDate.substr(4,4));
		
		return monthnames[month] + ' ' + day + ', ' +  year;
	}
	
	/**
	 * Transfoms a date to a relative position in offset space (from 0 to 1)
	 */
	private function dateToPos()
	{
		var measurer = Referencer.getController().measurer;
		_pos = (utc - measurer.periodStart)/measurer.periodDelta;
	}
	
	/**
	 * Calculates utc from rawDate
	 */
	private function dateToUtc()
	{		
		//Assigns a numerical value to a date
		var day = Number(rawDate.substr(0,2));
		var month = Number(rawDate.substr(2,2));
		
		//Since we will rawDate UTC, we need years over 1970, hence the +100
		var year = Number(rawDate.substr(4,4));
	
		if(month == 0)
		{
			month = 7;
			day = 1;
		}
		else if(day == 0)
		{
			day = 15;
		}
		
		//Use UTC date to get a number
		_utc = normalizedUTC(year, month - 1, day);
	}
	
	/**
	* Calculates a normalized UTC
	* 
	* In previous versions the Date.UTC method was used. The issue is that: 
	* not all months have the same number of days, and not all years have the same number of days
	* Hence years don't have exactly 365.2425 days as wished, and errors accumulate, and boundaries
	* of months and year become unreliable. Hence a normalized UTC solves these issues by assuming that
	* every year has 365.2425 days, and every month has 365.2425/12 days. longer and shorter years/months
	* are normalized to these specs, and it creates graphics with better precision
	* 
	* @param year The year
	* @param month The month, (0 based index)
	* @param day
	*/
	private function normalizedUTC(year:Number, month:Number, day:Number)
	{
		var yearoffset = year - 1970;
		if(month != 1)
		{
			var monthoffset = ((day - 1)/_monthLengths[month]);
		}
		else
		{
			var monthoffset = (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) ? 
								((day - 1)/29) : 
								((day - 1)/28);
		}
		//31556952000 = 365.2425*24*60*60*1000
		return (yearoffset + (month + monthoffset)/12)*31556952000;
	}
	
	/**
	 * Retrieves relative position from start date
	 */
	function get pos():Number
	{
		if(_pos == -1)
		{
			dateToPos();
		}
		return _pos;
	}
	
	/**
	 * Sets the position
	 */
	function set pos(paramPos):Number
	{
		_pos = paramPos;
	}
	
	/**
	 * Returns the utc of a date
	 */
	function get utc():Number
	{
		if(_utc == -1)
		{
			dateToUtc();
		}
		return _utc;
	}
	
	/**
	* Sets the utc
	*/
	function set utc(paramUtc:Number)
	{
		_utc = paramUtc;
	}
}