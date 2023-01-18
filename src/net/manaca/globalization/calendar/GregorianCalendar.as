import net.manaca.globalization.calendar.AbstractCalendar;
import net.manaca.data.Cloneable;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.lang.exception.UnsupportedOperationException;

/**
 * 公历
 * @author Wersling
 * @version 1.0, 2006-1-14
 */
class net.manaca.globalization.calendar.GregorianCalendar extends AbstractCalendar implements Cloneable,ICalendar{
	private var className : String = "net.manaca.globalization.calendar.GregorianCalendar";
	/** 历法类型 */
	public static var CALENDAR_TYPE:String = "GR";
	/** 普通的每月天数列表 */
	public static var MONTH_LIST:Array = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	public function GregorianCalendar(date : Date) {
		super(date);
	}
	
	/**
	 * 返回一个新的添加指定 毫秒数 的 {@link ICalendar}。
	 * @param milliseconds 要添加的毫秒数
	 * @return ICalendar 添加指定 毫秒数 后的{@link ICalendar}
	 */
	public function addMilliseconds(milliseconds:Number):ICalendar{
		var ic:GregorianCalendar = new GregorianCalendar();
		ic.setTime(this.getTime()+milliseconds);
		return ic;
	}

	/**
	 * 返回一个新的添加指定 月数 的 {@link ICalendar}。
	 * @param months 要添加的月数
	 * @return ICalendar 添加指定 月数 后的{@link ICalendar}
	 */
	public function addMonths(months:Number):ICalendar{
		return new GregorianCalendar(new Date(this.getDate().getFullYear(),this.getMonth()+months,this.getDay(),this.getHour(),this.getMinute(),this.getSecond(),this.getMilliseconds()));
	}
	
	/**
	 * 返回一个新的添加指定 年数 的 {@link ICalendar}。
	 * @param years 要添加的年数
	 * @return ICalendar 添加指定 年数 后的{@link ICalendar}
	 */
	public function addYears(years:Number):ICalendar{
		return new GregorianCalendar(new Date(this.getDate().getFullYear()+years,this.getMonth(),this.getDay(),this.getHour(),this.getMinute(),this.getSecond(),this.getMilliseconds()));
	}
	
	/**
	 * 返回月份的天数
	 * @return Number 月份的天数
	 */
	public function getDaysInMonth(Void):Number{
		var m:Number = this.getMonth();
		return(isLeapMonth() ? 29 : MONTH_LIST[m]);
	}
	
	/**
	 * 返回年份的天数
	 * @return Number 年份的天数
	 */
	public function getDaysInYear(Void):Number{
		return( isLeapYear() ? 366: 365);
	}
	
	/**
	 * 返回年份中的月数
	 * @return Number 年份中的月数
	 */
	public function getMonthsInYear (Void):Number{
		return 12;
	}
	
	/**
	 * 返回 月份。
	 * @return Number 返回此 {@link ICalendar} 的 月份
	 */
	public function getMonth (Void):Number{
		return _date.getMonth();
	}
	
	/**
	 * 返回 年份。
	 * @return Number 返回此 {@link ICalendar} 的 年份
	 */
	public function getYear(Void):Number{
		return _date.getFullYear();
	}
	
	/**
	 * 返回 日期。
	 * @return Number 返回此 {@link ICalendar} 的 日期
	 */
	public function getDay (Void):Number{
		return _date.getDate();
	}
	
	/**
	 * 是否为 闰日。
	 * @return Number 如果此日期为 闰日 ，则返回 true
	 */
	public function isLeapDay(Void):Boolean{
		return(this.isLeapMonth && this.getDay() ==29 ? true: false);
	}
	
	/**
	 * 是否为 闰月。
	 * @return Number 如果此日期为 闰月 ，则返回 true
	 */
	public function isLeapMonth(Void):Boolean{
		var m:Number = this.getMonth();
		return(this.isLeapYear() && m==1 ? true: false);
	}
	
	/**
	 * 是否为 闰年。
	 * @return Number 如果此日期为 闰年 ，则返回 true
	 */
	public function isLeapYear(Void):Boolean{
		var y:Number = this.getYear();
		return(((y%4 == 0) && (y%100 != 0) || (y%400 == 0)) ? true: false);
	}
}