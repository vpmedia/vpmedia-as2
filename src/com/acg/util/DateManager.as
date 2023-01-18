
import com.acg.util.NumberManager;
import com.acg.util.StringManager;

/**
 * 
 * 날짜 관리 클래스
 * 
 * @author	홍준수
 */
 
 
class com.acg.util.DateManager
{
	
	/**
	 * 해당 월의 1일의 요일을 구합니다.
	 * @param	d	(Date)
	 * @return	(Number)	-	0~6
	 */
	 
	public static function getFirstDayOfMonth(d:Date):Number 
	{
		var tempDate:Date = new Date(d.getFullYear(), d.getMonth() , 1);
		return tempDate.getDay()
	}
	
	/**
	 * 윤년인지 아닌지 판정합니다.
	 * @param	d	(Date)
	 * @return	(Boolean)
	 */
	public static function isLeapyear(d:Date):Boolean
	{
		var year:Number=d.getFullYear()
		if((year % 4)==0 && (year % 100)!=0 || (year % 400)==0)
		{
			return true;
		}
		else
		{
			return false
		}
	}
	
	/**
	 * 해당월에 며칠까지 있는지 알아내서 리턴합니다.
	 * @param	d	(Date)
	 * @return	(Number)
	 */
	 
	public static function getDaysInMonth(d:Date):Number 
	{
		var daysInMonth = new Array(31,28,31,30,31,30,31,31,30,31,30,31)
		if (DateManager.isLeapyear(d) == true)
		{
			daysInMonth[1]=29;
		}
		return daysInMonth[d.getMonth()]
	}
	
	/**
	 * 요일을 스트링으로 리턴합니다.
	 * @method   getDayName
	 * @param	d(Date)
	 * @param	lang(String)	-	"kr" or "eng"
	 * @return	(String)	
	 */
	public static function getDayName(d:Date, lang:String):String
	{
		var dayNamesEng=new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
		var dayNamesKr=new Array("월", "화", "수", "목", "금", "토", "일");
		if(lang == "kr")
			return dayNamesKr[d.getUTCDay()];
		else
			return dayNamesEng[d.getUTCDay()];
	}
	
	/**
	 * @param	d	(Date)
	 * @return	(String)
	 */
	public static function getMonthName(d:Date):String
	{
		var monthNames=new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
		return monthNames[d.getUTCMonth()];
	}
	
	/**
	 * @param	d	(Date)
	 * @param	lang	(String)
	 * @return	(Boolean)
	 */
	public static function getAMPM(d:Date, lang:String):String
	{
		var hour=d.getUTCHours();
		if(hour > 12)
		{
			if(lang == "kr")
				return "오후";
			else
				return "PM"
		}
		else
		{
			if(lang == "kr")
				return "오전";
			else
				return "AM"
		}
	}
	
	/**
	 * @param	d	(Date)
	 * @return	(Number)
	 */
	public static function getHour12(d:Date):Number
	{
		var hour:Number=d.getUTCHours();
			if(hour > 12)
				return (hour-12);
			else
				return hour;
	}
	
	/**
	 * @param	d1	(Date)
	 * @param	d2	(Date)
	 * @return	(Number)
	 */
	/*public static function getMillisecondsBetween(d1:Date, d2:Date):Number 
	{
		var t1:Number=d1.getTime();
		var t2:Number=d2.getTime();
		var t3:Number=t2-t1;
		if(Time3 < 0)
			t3=t3*(-1);
		return t3;
	}*/
	
	/**
	 * @param	d1	(Date)
	 * @param	d2	(Date)
	 * @param	datePart	(String)	-	"y", "m", "d", "h", "i" or "s"
	 * @return	(Number)
	 */
	public static function getDateDifference(d1:Date, d2:Date, datePart:String):Number
	{
		var orgDate:Date = d1;
		var newDate:Date = d2;
		var millisecondsBtwDates:Number = (newDate-orgDate);
		var secondsBtwDates:Number = Math.floor(millisecondsBtwDates/1000);
		var minutesBtwDates:Number = Math.floor(secondsBtwDates/60);
		var hoursBtwDates:Number = Math.floor(minutesBtwDates/60);
		var daysBtwDates:Number = Math.floor(hoursBtwDates/24);
		var yearsBtwDates:Number = Math.floor(daysBtwDates/365);
		var monthsBtwDates:Number = Math.floor(daysBtwDates/365*12);
		var returnVar:Number = (datePart == "y")?yearsBtwDates:(datePart == "m")?monthsBtwDates:(datePart == "d")?daysBtwDates:(datePart == "h")?hoursBtwDates:(datePart == "n")?minutesBtwDates:(datePart == "s")?secondsBtwDates:millisecondsBtwDates;
		return returnVar;
	}
	
	/**
	 * @param	d	(Date)
	 * @param	datePart	(String)	-	"y", "m", "d", "h", "i" or "s"
	 * @param	value	(Nubmer)
	 * @return	(Date)
	 */
	public static function addDate(d:Date, datePart:String, value:Number):Date
	{
		switch(datePart)
		{
		case "y" :
			d.setFullYear(d.getFullYear()+value);
			break;
		case "m" :
			d.setMonth(d.getMonth()+value);
			break;
		case "d" :
			d.setDate(d.getDate()+value);
			break;
		case "h" :
			d.setHours(d.getHours()+value);
			break;
		case "i" :
			d.setMinutes(d.getMinutes()+value);
			break;
		case "s" :
			d.setSeconds(d.getSeconds()+value);
			break;
		default :
			d.setMilliseconds(d.getMilliseconds()+value);
			break;
		}
		return d;
	}
	
	/**
	 * @method   getQuarterOfYear
	 * @param	d	(Date)
	 * @return	(Number)
	 */
	public static function getQuarterOfYear(d:Date):Number
	{
		return Math.floor(d.getMonth()/3)+1;
	}
	
	
	/**
	* @method  convertFromString
	*/
	public static function convertFromString(str:String, charPattern:Number):Date
	{
		var date:Date = new Date();
		switch (charPattern) {
			case 1 : 
			{
			    date.setFullYear(Number ("20" + str.substring(0, 2)), StringManager.cutZero(str.substring(2, 4)) - 1, StringManager.cutZero(str.substring(4, 6)));
			   	date.setHours(StringManager.cutZero(str.substring(7, 9)));
			    date.setMinutes(StringManager.cutZero(str.substring(9, 11)));
			    date.setSeconds(0);
			    date.setMilliseconds(0);
			    break;
			}
			case 2 :
			{ 
			    date.setFullYear(Number (str.substring(0, 4)), StringManager.cutZero(str.substring(4, 6)) - 1, StringManager.cutZero(str.substring(6, 8)));
			   	date.setHours(0);
			    date.setMinutes(0);
			    date.setSeconds(0);
			    date.setMilliseconds(0);
			    break;
			}
			case 3 :
			{ 
			    date.setUTCFullYear(Number (str.substring(0, 4)), StringManager.cutZero(str.substring(5, 7)) - 1, StringManager.cutZero(str.substring(8, 10)));
			    date.setUTCHours(StringManager.cutZero(str.substring(11, 13)));
			    date.setMinutes(StringManager.cutZero(str.substring(14, 16)));
			    date.setSeconds(StringManager.cutZero(str.substring(17, 19)));
			    date.setMilliseconds(0);
			    break;
			}
		}
		return date;
	}
	
	/**
	* yyyymmdd 형식의 스트링을 Date객체로 반환합니다.
	* @param s yyyymmdd 스트링
	* @return Date
	*/
	
	public static function convertDateToString(s:String):Date
	{
		var tempDate:Date = new Date( Number(s.substr(0,4)) , Number(s.substr(4,2))-1 , Number(s.substr(6,2)) );
		return tempDate;
	}
	
	/**
	* Date객체를 xxxx년 xx월 xx일의 형식으로 반환합니다.
	* @param d Date객체
	* @return String
	*/
	
	public static function getDateString(d:Date):String
	{
		var returnString:String = d.getFullYear()+ "년 " + StringManager.pad(String(d.getMonth()+1), "0", 2) +"월 "+ StringManager.pad(String(d.getDate()) , "0" , 2) +"일";
		return returnString;
	}
	
	public static function getDATE(s:String):String
	{
		var returnString:String = s.substr(0,4)+"년 "+s.substr(4,2)+"월 "+s.substr(6,2)+"일 "
		return returnString;
	}
	
	public static function getTIME(s:String):String
	{
		var returnString:String = s.substr(0,2)+"시 "+s.substr(2,2)+"분";
		return returnString;
	}
	
	/**
	* 
	* yyyy년 mm월 dd일의 형식의 스트링을 yymmdd형식으로 반환합니다.
	* @param	s
	* @return
	*/
	
	public static function convertFormat(s:String):String
	{
		trace("aa");
		var a:String = s.split("년").join("");
		var b:String = a.split("월").join("");
		var c:String = b.split("일").join("");
		var d:String = c.split(" ").join("");
		return d;
	}		

}