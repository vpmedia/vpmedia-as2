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

import vegas.core.CoreObject;
import vegas.util.MathsUtil;

/**
 * The {@code Time} object is a holder for a time difference.
 * <p>{@code Time} splits a time difference (distance between two dates) into 
 * days, hours, minutes, seconds and milliseconds to offers methods to access the time difference value.
 * @author eKameleon
 */
class asgard.date.Time extends CoreObject
{
	
	/**
	 * Creates a new {@code Time} instance.
     * @param timeDifference The time size of the time difference for the passed-in {@code format}.
     * @param format (optional) "d"/"h"/"m"/"s"/"ms" for the unit of the amout, default case is "ms".
     */
	public function Time( timeDifference:Number, format:String ) 
	{
		setValue( timeDifference, format) ;
	}

	/** 
	 * Factor from ms to second. 
	 */
	static public var SECOND:Number = 1000;
	
	/** 
	 * Factor from ms to minute.
	 */
	static public var MINUTE:Number = SECOND*60;
	
	/** 
	 * Factor from ms to hour.
	 */
	static public var HOUR:Number = MINUTE * 60 ;
	
	/** 
	 * Factor from ms to day.
	 */
	static public var DAY:Number = HOUR * 24 ;

	/** 
	 * Amount of days.
	 */
	public var days:Number;

	/**
	 * Time difference in ms.
	 */
	public var ms:Number;
	
	/**  
	 * Amount of hours.
	 */
	public var hours:Number;
	
	/**
	 *  Amount of minutes.
	 */
	public var minutes:Number;
	
	/**
	 *  Amount of seconds.
	 */
	public var seconds:Number;
	
	/** 
	 * Amount of milliseconds.
	 */
	public var milliSeconds:Number;
	
	/** 
	 * Flag if the instance need to be evaluated by {@link #evaluate}.
	 */
	public var doEval:Boolean = true;	

	/**
	 * Splits the time distance from ms (source value) into the different units.
	 */
	public function evaluate():Void 
	{
		var negative = MathsUtil.sign(ms) ;
		var rest:Number = ms ;
		
		days = rest / DAY ;
		rest -= negative * Math.floor(days) * DAY ;
		
		hours = rest / HOUR;
		rest -= negative * Math.floor(hours) * HOUR ;
		
		minutes = rest / MINUTE;
		rest -= negative * Math.floor(minutes) * MINUTE ;
		
		seconds = rest / SECOND ;
		rest -= negative * Math.floor(seconds)*SECOND ;
		
		milliSeconds = rest;
		
		doEval = false ;
	}
	
	/**
	 * Returns the amount of days are contained within the time.
	 * <p>It will not round the result if you pass-in nothing.</p>
	 * @param round (optional) the number of decimal spaces
	 * @return The time difference in days.
	 */
	public function getDays(round:Number):Number 
	{
		if (doEval) 
		{
			evaluate() ;
		}
		return isNaN(round) ? days : MathsUtil.floor(days, round) ;
	}

	/**
	 * Returns the amount of hours are contained within the time.
	 * <p>It will not round the result if you pass-in nothing.</p>
	 * @param round (optional) the number of decimal spaces
	 * @return The time difference in hours.
	 */
	public function getHours(round:Number):Number 
	{
		if (doEval) 
		{
			evaluate() ;
		}
		return isNaN(round) ? hours : MathsUtil.floor(hours, round);
	}

	/**
	 * Returns the amount of milliseconds are contained within the time.
	 * <p>It will not round the result if you pass-in nothing.</p>
	 * @param round (optional) the number of decimal spaces.
	 * @return The time difference in milliseconds.
	 */
	public function getMilliSeconds(round:Number):Number 
	{
		if (doEval) 
		{
			evaluate();
		}
		return isNaN(round) ? milliSeconds : MathsUtil.floor(milliSeconds, round) ;
	}

	/**
	 * Returns the amount of minutes are contained within the time.
	 * <p>It will not round the result if you pass-in nothing.</p>
	 * @param round (optional) the number of decimal spaces
	 * @return The time difference in minutes.
	 */
	public function getMinutes(round:Number):Number 
	{
		if (doEval) 
		{
			evaluate() ;
		}
		return isNaN(round) ? minutes :MathsUtil.floor(minutes, round) ;
	}
	/**
	 * Returns the amount of seconds are contained within the time.
	 * <p>It will not round the result if you pass-in nothing.</p>
	 * @param round (optional) the number of decimal spaces
	 * @return The time difference in seconds
	 */
	public function getSeconds(round:Number):Number 
	{
		if (doEval) 
		{
			evaluate();
		}
		return isNaN(round) ? seconds : MathsUtil.floor(seconds, round) ;
	}

	/**
	 * Returns the time distance in days.
	 * @return The time difference in days.
	 */
	public function inDays():Number 
	{
		return ms / DAY ;
	}

	/**
	 * Returns the time distance in hours.
	 * @return The time difference in hours.
	 */
	public function inHours():Number 
	{
		return ms / HOUR ;
	}

	/**
	 * Returns the time difference in milliseconds.
	 * @return the time difference in milliseconds.
	 */
	public function inMilliSeconds():Number 
	{
		return ms;
	}

	/**
	 * Returns the time distance in minutes.
	 * @return The time difference in minutes.
	 */
	public function inMinutes():Number 
	{
		return ms / MINUTE;
	}
	
	/**
	 * Returns The time difference in seconds.
	 * @return The time difference in seconds.
	 */
	public function inSeconds():Number 
	{
		return ms / SECOND ;
	}

	/**
	 * Removes the passed-in {@code timeDifference} from the current time.
	 * @param timeDifference time difference to be removed from the current time
	 * @return A new instance with the resulting amount of time
	 */
	public function minus(timeDifference:Time):Time 
	{
		return new Time(ms-timeDifference.valueOf());
	}

	/**
	 * Adds the passed-in {@code timedistance} to the current time.
	 * @param timeDifference time difference to be added to the current time.
	 * @return A new instance with the resulting amount of time.
	 */
	public function plus( timeDifference:Time ):Time 
	{
		return new Time( ms + timeDifference.valueOf() );
	}

	/** 
	 * Sets the time of the instance.
	 * 
	 * <p>Uses "ms" if no format or a wrong format was passed-in.</p>
	 * <p>Uses {@code Number.MAX_VALUE} if {@code Infinity} was passed-in.</p>
     * @param time size of the time difference for the passed-in {@code format}
     * @param format (optional) "d"/"h"/"m"/"s"/"ms" for the unit of the amout. Default value is ms.
	 */
	public function setValue(timeDifference:Number, format:String):Time 
	{
		
		if (timeDifference == Infinity) 
		{
			timeDifference = Number.MAX_VALUE;
		}
		
		switch (format) 
		{
			case "d" :
			{
				ms = timeDifference * DAY ;
				break;
			}
			case "h" :
			{
				ms = timeDifference * HOUR ;
				break;
			}
			case "m" :
			{
				ms = timeDifference * MINUTE ;
				break;
			}
			case "s":
			{
				ms = timeDifference * SECOND ;
				break;
			}
			default:
			{
				ms = timeDifference ;
			}
		}
		
		doEval = true ;
		
		return this ;
		
	}

	/**
	 * Returns the value of the time distance (in ms).
	 * @return The value of this object in ms.
	 */
	public function valueOf():Number 
	{
		return ms;
	}

}