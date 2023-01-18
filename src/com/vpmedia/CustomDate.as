/**
 * CustomDate
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: CustomDate
 * File: CustomDate.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.CustomDate extends Date implements IFramework
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "CustomDate";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// constructor
	function CustomDate ()
	{
		trace ("CustomDate constructor!");
	}
	/**
	 * <p>Description: get current time</p>
	 *
	 * @author András Csizmadia
	 * @version 1.5
	 */
	public function getCurrentTime ()
	{
		var cDate:Date = new Date ();
		var cHour:Number = cDate.getHours ();
		var cMin:Number = cDate.getMinutes ();
		var cSec:Number = cDate.getSeconds ();
		var ct = (cHour * 3600) + cSec + (cMin * 60);
		//
		var hours = Math.floor (ct / 3600);
		var minutes = Math.floor (ct / 60) - (60 * hours);
		var seconds = Math.floor (ct - (60 * minutes) - (3600 * hours));
		//
		minutes < 10 ? minutes = "0" + minutes : "";
		seconds < 10 ? seconds = "0" + seconds : "";
		hours < 10 ? hours = "0" + hours : "";
		//
		return hours + ":" + minutes + ":" + seconds;
	}
	/**
	 * <p>Description: Date Validation with Leap-Year feature</p>
	 *
	 * @author András Csizmadia
	 * @comatible AS2.0 - Flash Player 6-7
	 * @source Ported from JavaScript
	 * @version 1.5
	 * @method calcLeapYear
	 * @usage calcLeapYear (yearToDisplay, monthToDisplay);
	 */
	// private method
	public function calcLeapYear (yearToDisplay, monthToDisplay)
	{
		var daysInMonth:Array = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		var oD = new Date (yearToDisplay, monthToDisplay - 1, 1);
		//DD replaced line to fix date bug when current day is 31st, so we flip to 1st day of the month
		daysInMonth[1] = (((oD.getFullYear () % 100 != 0) && (oD.getFullYear () % 4 == 0)) || (oD.getFullYear () % 400 == 0)) ? 29 : 28;
		// debug
		// trace (oD.getFullYear()+" februar has " + daysInMonth[1] + " days.");
		// return days in month Array
		return daysInMonth;
	}
	/*
	Data.prototype.calcLeapYear = function (yearToDisplay, monthToDisplay, dayToDisplay, hourToDisplay, minToDisplay)
	{
	var daysInMonth:Array = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	var oD = new Date (yearToDisplay, monthToDisplay - 1, 1);
	//DD replaced line to fix date bug when current day is 31st, so we flip to 1st day of the month
	daysInMonth[1] = (((oD.getFullYear () % 100 != 0) && (oD.getFullYear () % 4 == 0)) || (oD.getFullYear () % 400 == 0)) ? 29 : 28;
	// debug
	trace (oD.getFullYear () + " februar has " + daysInMonth[1] + " days.");
	// return days in month Array
	return daysInMonth;
	};
	*/
	/*
	//Usage:-
	//sample date in Pacific Daylight Time 
	var str = "Sun Aug 11 17:00:00 GMT-0700 1974";
	trace(getDateFromString(str));
	//traces "Mon Aug 12 08:00:00 GMT+0800 1974" on my machine (Singapore Time)
	//output will be in local time and will vary accordingly
	*/
	public function getDateFromString (str:String):Date
	{
		//converts a date string in the following format
		//"Thu Jul 8 12:48:23 GMT+0800 2004"
		var m = {Jan:0, Feb:1, Mar:2, Apr:3, May:4, Jun:5, Jul:6, Aug:7, Sep:8, Oct:9, Nov:10, Dec:11};
		var dArr:Array = str.split (' ');
		var tArr:Array = dArr[3].split (':');
		return new Date (Date.UTC (Number (dArr[5]), m[dArr[1]], Number (dArr[2]), (Number (tArr[0]) - Number (dArr[4].substring (3, 6))), (Number (tArr[1]) - Number (dArr[4].substring (6, 8))), Number (tArr[2])));
	}
	/**
	 * <p>Description: get day of year</p>
	 *
	 * @author András Csizmadia
	 * @version 1.5
	 * @method Date.getDifference(hh,min,sec,year,month,date); 
	 */
	public function getDifference2 (e, h, n, o, p, mp, ms)
	{
		!e ? e = 0 : null;
		!h ? h = 0 : null;
		!o ? o = 0 : null;
		!p ? p = 0 : null;
		!mp ? mp = 0 : null;
		!ms ? ms = 0 : null;
		var b:Date = new Date (e, h - 1, n, o, p, mp, ms);
		var now = new Date ();
		var res = now - b;
		trace ("ysolt:    " + res);
		trace ("andras: " + getDifference (e, h - 1, n, o, p, mp, ms).time);
		//trace ((now - b) / 1000 / 60 / 60 / 24);
		return res;
	}
	/**/
	public function getDifference (e, h, n, o, p, mp, ms):Object
	{
		trace ("warning! arguments changed! y-m-d-h-m-s-ms is valid!");
		var endDate = new Date (e, h, n, o, p, mp, ms);
		var endTime = endDate.getTime ();
		var retObj = new Object ();
		var difference = new Date () - endDate;
		retObj.time = difference;
		retObj.days = Math.floor (difference / 86400000);
		retObj.hours = Math.floor ((difference - (retObj.days * 86400000)) / (3600000));
		retObj.minutes = Math.floor ((difference - (retObj.days * 86400000) - (retObj.hours * 3600000)) / (60000));
		retObj.seconds = Math.floor ((difference - (retObj.days * 86400000) - (retObj.hours * 3600000) - (retObj.minutes * 60000)) / (1000));
		return retObj;
	}
	/**
	 * <p>Description: Convert seconds to time</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	function displayTime (ct, isShort)
	{
		var hours = Math.floor (ct / 3600);
		var minutes = Math.floor (ct / 60) - (60 * hours);
		var seconds = Math.floor (ct - (60 * minutes) - (3600 * hours));
		// trace (_ct + "," + hours + "," + minutes + "," + seconds);
		minutes < 10 ? minutes = "0" + minutes : "";
		seconds < 10 ? seconds = "0" + seconds : "";
		hours < 10 ? hours = "0" + hours : "";
		if (isShort)
		{
			return minutes + ":" + seconds;
		}
		else
		{
			return hours + ":" + minutes + ":" + seconds;
		}
	}
	/**
	 * <p>Description: Current time</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	function displayCurrentTime ()
	{
		//com.webcam.Utils.dumpObject (null, "displayCurrentTime");
		var cDate:Date = new Date ();
		var cHour:Number = cDate.getHours ();
		var cMin:Number = cDate.getMinutes ();
		var cSec:Number = cDate.getSeconds ();
		var ct = (cHour * 3600) + cSec + (cMin * 60);
		//
		var hours = Math.floor (ct / 3600);
		var minutes = Math.floor (ct / 60) - (60 * hours);
		var seconds = Math.floor (ct - (60 * minutes) - (3600 * hours));
		//
		minutes < 10 ? minutes = "0" + minutes : "";
		seconds < 10 ? seconds = "0" + seconds : "";
		hours < 10 ? hours = "0" + hours : "";
		//
		return hours + ":" + minutes + ":" + seconds;
	}
	/**
	 * <p>Description: Create digit</p>
	 *
	 * @author Loop
	 * @version 1.0
	 */
	function createDigit (digitNumber:Number, digitLength:Number)
	{
		var digitResult:String;
		var digitSourceLength:Number = String (digitNumber).length;
		var length:Number = digitLength - digitSourceLength;
		var digitString:String = "";
		for (var i = 0; i < length; i++)
		{
			digitString += "0";
		}
		if (digitSourceLength < digitLength)
		{
			digitResult = digitString + digitNumber;
		}
		else
		{
			digitResult = String (digitNumber);
		}
		return (digitResult);
	}
	/**
	 * <p>Description: Make a Long String to Short String + ...</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function trimStr (stringSource:String, stringLength:Number)
	{
		// trim long name
		var stringResult:String;
		if (stringSource.length > stringLength)
		{
			stringResult = stringSource.substring (0, stringLength) + "...";
		}
		else
		{
			stringResult = stringSource;
		}
		return stringResult;
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
	// END CLASS
}
