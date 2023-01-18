import net.manaca.lang.BObject;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.lang.exception.UnsupportedOperationException;

/**
 * 为历法提供一些基本的方法
 * @author Wersling
 * @version 1.0, 2006-1-14
 */
class net.manaca.globalization.calendar.AbstractCalendar extends BObject implements ICalendar{
	private var className : String = "net.manaca.globalization.calendar.AbstractCalendar";
	private var _date : Date;
	private function AbstractCalendar(date:Date) {
		super();
		if(!date){
			_date = new Date();
		}else{
			_date = date;
		}
	}
	
	/**
	 * 返回一个新的添加指定 天数 的 {@link ICalendar}。
	 * @param days 要添加的天数
	 * @return ICalendar 添加指定 天数 后的{@link ICalendar}
	 */
	public function addDays(days:Number):ICalendar{
		return addMilliseconds(days*24*60*60*1000);
	}
	
	/**
	 * 返回一个新的添加指定 小时数  的 {@link ICalendar}。
	 * @param hours 要添加的小时数 
	 * @return ICalendar 添加指定 小时数  后的{@link ICalendar}
	 */
	public function addHours(hours:Number):ICalendar{
		return addMilliseconds(hours*60*60*1000);
	}
	
	/**
	 * 返回一个新的添加指定 毫秒数 的 {@link ICalendar}。
	 * @param milliseconds 要添加的毫秒数
	 * @return ICalendar 添加指定 毫秒数 后的{@link ICalendar}
	 */
	public function addMilliseconds(milliseconds:Number):ICalendar{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回一个新的添加指定 分钟数 的 {@link ICalendar}。
	 * @param minutes 要添加的分钟数
	 * @return ICalendar 添加指定 分钟数 后的{@link ICalendar}
	 */
	public function addMinutes(minutes:Number):ICalendar{
		return addMilliseconds(minutes*60*1000);
	}
	
	/**
	 * 返回一个新的添加指定 月数 的 {@link ICalendar}。
	 * @param months 要添加的月数
	 * @return ICalendar 添加指定 月数 后的{@link ICalendar}
	 */
	public function addMonths(months:Number):ICalendar{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回一个新的添加指定 秒数 的 {@link ICalendar}。
	 * @param seconds 要添加的秒数
	 * @return ICalendar 添加指定 秒数 后的{@link ICalendar}
	 */
	public function addSeconds(seconds:Number):ICalendar{
		return addMilliseconds(seconds*1000);
	}
	
	/**
	 * 返回一个新的添加指定 周数 的 {@link ICalendar}。
	 * @param weeks 要添加的周数
	 * @return ICalendar 添加指定 周数 后的{@link ICalendar}
	 */
	public function addWeeks(weeks:Number):ICalendar{
		return addMilliseconds(weeks*7*24*60*60*1000);
	}
	
	/**
	 * 返回一个新的添加指定 年数 的 {@link ICalendar}。
	 * @param years 要添加的年数
	 * @return ICalendar 添加指定 年数 后的{@link ICalendar}
	 */
	public function addYears(years:Number):ICalendar{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回月份的天数
	 * @return Number 月份的天数
	 */
	public function getDaysInMonth(Void):Number{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回年份的天数
	 * @return Number 年份的天数
	 */
	public function getDaysInYear(Void):Number{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回年份中的月数
	 * @return Number 年份中的月数
	 */
	public function getMonthsInYear (Void):Number{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回年份中的第几个星期
	 * @return Number 年份中的第几个星期
	 */
	public function getWeekOfYear(Void):Number{
		return null;
	}
	
	/**
	 * 返回月份中的第几个星期几
	 * @return Number 月份中的第几个星期几
	 */
	public function getWeekInMonths(Void):Number{
		return Math.ceil(this.getDay()/7);
	}
	
	/**
	 * 返回小时值（0 到 23 之间的整数）。
	 * @return Number 返回此 {@link ICalendar} 的 小时值
	 */
	public function getHour(Void):Number{
		return _date.getHours();
	}
	
	/**
	 * 返回 毫秒值（0 到 999 之间的整数）。
	 * @return Number 返回此 {@link ICalendar} 的 毫秒值
	 */
	public function getMilliseconds(Void):Number{
		return _date.getMilliseconds();
	}
	
	/**
	 * 返回 分钟值。
	 * @return Number 返回此 {@link ICalendar} 的 分钟值
	 */
	public function getMinute(Void):Number{
		return _date.getMinutes();
	}
	
	/**
	 * 返回 月份。
	 * @return Number 返回此 {@link ICalendar} 的 月份
	 */
	public function getMonth (Void):Number{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回 秒值。
	 * @return Number 返回此 {@link ICalendar} 的 秒值
	 */
	public function getSecond(Void):Number{
		return _date.getSeconds();
	}
	
	/**
	 * 返回 星期几。
	 * @return Number 返回此 {@link ICalendar} 的 星期几
	 */
	public function getWeek(Void) : Number {
		return  _date.getDay();
	}
	
	/**
	 * 返回 年份。
	 * @return Number 返回此 {@link ICalendar} 的 年份
	 */
	public function getYear(Void):Number{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回 日期。
	 * @return Number 返回此 {@link ICalendar} 的 日期
	 */
	public function getDay (Void):Number{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 返回一个公历的Date
	 * @return Date 公历的Date
	 */
	public function getDate(Void):Date{
		return _date;
	}
	
	/**
	 * 返回自 1970 年 1 月 1 日午夜（通用时间）以来的毫秒数。
	 * @return Number 毫秒数
	 */
	public function getTime() : Number{
		return _date.getTime();
	}
	
	/**
	 * 以毫秒为单位设置自 1970 年 1 月 1 日 午夜以来的日期，并以毫秒为单位返回新时间。
	 * @param millisecond 以毫秒为单位的时间
	 * @return Number 新时间
	 */
	public function setTime(millisecond:Number) : Number{
		return _date.setTime(millisecond);
	}
	
	/**
	 * 是否为 闰日。
	 * @return Number 如果此日期为 闰日 ，则返回 true
	 */
	public function isLeapDay(Void):Boolean{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 是否为 闰月。
	 * @return Number 如果此日期为 闰月 ，则返回 true
	 */
	public function isLeapMonth(Void):Boolean{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}
	
	/**
	 * 是否为 闰年。
	 * @return Number 如果此日期为 闰年 ，则返回 true
	 */
	public function isLeapYear(Void):Boolean{
		throw new UnsupportedOperationException("此方法将在其子类中实现",this,arguments);
		return null;
	}


}