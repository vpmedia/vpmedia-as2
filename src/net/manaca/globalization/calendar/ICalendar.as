/**
 * 对历法提供的一个基本接口
 * @author Wersling
 * @version 1.0, 2006-1-13
 */
interface net.manaca.globalization.calendar.ICalendar {
	/**
	 * 返回一个新的添加指定 天数 的 {@link ICalendar}。
	 * @param days 要添加的天数
	 * @return ICalendar 添加指定 天数 后的{@link ICalendar}
	 */
	public function addDays(days:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 小时数  的 {@link ICalendar}。
	 * @param hours 要添加的小时数 
	 * @return ICalendar 添加指定 小时数  后的{@link ICalendar}
	 */
	public function addHours(hours:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 毫秒数 的 {@link ICalendar}。
	 * @param milliseconds 要添加的毫秒数
	 * @return ICalendar 添加指定 毫秒数 后的{@link ICalendar}
	 */
	public function addMilliseconds(milliseconds:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 分钟数 的 {@link ICalendar}。
	 * @param minutes 要添加的分钟数
	 * @return ICalendar 添加指定 分钟数 后的{@link ICalendar}
	 */
	public function addMinutes(minutes:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 月数 的 {@link ICalendar}。
	 * @param months 要添加的月数
	 * @return ICalendar 添加指定 月数 后的{@link ICalendar}
	 */
	public function addMonths(months:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 秒数 的 {@link ICalendar}。
	 * @param seconds 要添加的秒数
	 * @return ICalendar 添加指定 秒数 后的{@link ICalendar}
	 */
	public function addSeconds(seconds:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 周数 的 {@link ICalendar}。
	 * @param weeks 要添加的周数
	 * @return ICalendar 添加指定 周数 后的{@link ICalendar}
	 */
	public function addWeeks(weeks:Number):ICalendar;
	
	/**
	 * 返回一个新的添加指定 年数 的 {@link ICalendar}。
	 * @param years 要添加的年数
	 * @return ICalendar 添加指定 年数 后的{@link ICalendar}
	 */
	public function addYears(years:Number):ICalendar;
	
	/**
	 * 返回指定月份的天数
	 * @return Number 月份的天数
	 */
	public function getDaysInMonth(Void):Number;
	
	/**
	 * 返回年份的天数
	 * @return Number 年份的天数
	 */
	public function getDaysInYear(Void):Number;
	
	/**
	 * 返回年份中的月数
	 * @return Number 年份中的月数
	 */
	public function getMonthsInYear (Void):Number;
	
	/**
	 * 返回年份中的第几个星期
	 * @return Number 年份中的第几个星期
	 */
	public function getWeekOfYear(Void):Number;
	
	/**
	 * 返回月份中的第几个星期几
	 * @return Number 月份中的第几个星期几
	 */
	public function getWeekInMonths(Void):Number;
	
	/**
	 * 返回小时值（0 到 23 之间的整数）。
	 * @return Number 返回此 {@link ICalendar} 的 小时值
	 */
	public function getHour(Void):Number;
	
	/**
	 * 返回 毫秒值（0 到 999 之间的整数）。
	 * @return Number 返回此 {@link ICalendar} 的 毫秒值
	 */
	public function getMilliseconds(Void):Number;
	
	/**
	 * 返回 分钟值。
	 * @return Number 返回此 {@link ICalendar} 的 分钟值
	 */
	public function getMinute(Void):Number;
	
	/**
	 * 返回 月份。
	 * @return Number 返回此 {@link ICalendar} 的 月份
	 */
	public function getMonth (Void):Number;
	
	/**
	 * 返回 秒值。
	 * @return Number 返回此 {@link ICalendar} 的 秒值
	 */
	public function getSecond(Void):Number;
	
	/**
	 * 返回 星期几。0 代表星期日，1 代表星期一
	 * @return Number 返回此 {@link ICalendar} 的 星期几
	 */
	public function getWeek(Void):Number;
	
	/**
	 * 返回 年份。
	 * @return Number 返回此 {@link ICalendar} 的 年份
	 */
	public function getYear(Void):Number;
	
	/**
	 * 返回 日期。
	 * @return Number 返回此 {@link ICalendar} 的 日期
	 */
	public function getDay (Void):Number;
	
	/**
	 * 返回一个公历的Date
	 * @return Date 公历的Date
	 */
	public function getDate(Void):Date;
	
	/**
	 * 返回自 1970 年 1 月 1 日午夜（通用时间）以来的毫秒数。
	 * @return Number 毫秒数
	 */
	public function getTime() : Number;
	
	/**
	 * 以毫秒为单位设置自 1970 年 1 月 1 日 午夜以来的日期，并以毫秒为单位返回新时间。
	 * @param millisecond 以毫秒为单位的时间
	 * @return Number 新时间
	 */
	public function setTime(millisecond:Number) : Number;
	
	/**
	 * 是否为 闰日。
	 * @return Number 如果此日期为 闰日 ，则返回 true
	 */
	public function isLeapDay(Void):Boolean;
	
	/**
	 * 是否为 闰月。
	 * @return Number 如果此日期为 闰月 ，则返回 true
	 */
	public function isLeapMonth(Void):Boolean;
	
	/**
	 * 是否为 闰年。
	 * @return Number 如果此日期为 闰年 ，则返回 true
	 */
	public function isLeapYear(Void):Boolean;
}