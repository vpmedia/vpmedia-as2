import net.manaca.lang.BObject;
import net.manaca.globalization.calendar.GregorianCalendar;
import net.manaca.globalization.calendar.ChinaCalendar;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.globalization.Locale;

/**
 * 一天的信息
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.ui.controls.dateClasses.DayElement extends BObject {
	private var className : String = "net.manaca.ui.controls.dateClasses.DayElement";
	private var _year : Number;
	private var _month : Number;
	private var _day : Number;
	private var _gc : GregorianCalendar;
	private var _cc : ICalendar;

	private var _solarTerms : String;

	private var _isToday : Boolean;
	/**
	 * 构造函数
	 * @param year 指定年
	 * @param month 指定月(0-11)
	 * @param day 指定日期
	 */

	public function DayElement(year : Number, month : Number, day : Number) {
		super();
		_year = year;
		_month = month;
		_day = day;
		basedDay();
		_solarTerms = null;
		_isToday = false;
	}

	private function basedDay() : Void{
		var _d : Date = new Date(_year,_month,_day);
		_gc = new GregorianCalendar(_d);
		if(Locale.getDefault().getLanguage() == "zh-CN") _cc = new ChinaCalendar(_d);
	}
	/**
	 * 获取这一天公历
	 */

	public function getGregorianCalendar(Void) : GregorianCalendar{
		return _gc;
	}
	
	/**
	 * 获取这一天本地历法
	 */
	public function getLocaleCalendar(Void) : ICalendar{
		return _cc;
	}
//	
//	/**
//	 * 获取年
//	 * @return 返回值类型：Number 
//	 */
//
//	public function get year() :Number
//	{
//		return _year;
//	}
//	/**
//	 * 获取月
//	 * @return 返回值类型：Number 
//	 */
//
//	public function get month() :Number
//	{
//		return _month;
//	}
//	/**
//	 * 获取日
//	 * @return 返回值类型：Number 
//	 */
//
//	public function get day() :Number
//	{
//		return _day;
//	}
//	
//	/**
//	 * 获取星期
//	 * @return 返回值类型：Number 
//	 */
//	public function get week() :Number
//	{
//		return _gc.getWeek();
//	}
//	
//	/**
//	 * 获取农历年
//	 * @return 返回值类型：Number 
//	 */
//
//	public function get localeyear() :Number
//	{
//		return _cc.getYear();
//	}
//	/**
//	 * 获取农历月
//	 * @return 返回值类型：Number 
//	 */
//
//	public function get localemonth() :Number
//	{
//		return _cc.getMonth();
//	}
//	
//	/**
//	 * 获取农历日
//	 * @return 返回值类型：Number 
//	 */
//	public function get localeday() :Number
//	{
//		return _cc.getDay();
//	}
//	
//	/**
//	 * 获取农历是否为润月
//	 * @return 返回值类型：Number 
//	 */
//	public function get isLeap() :Boolean
//	{
//		return _cc.isLeapMonth();
//	}
//	
//	/**
//	 * 获取本地的节日
//	 * @return 返回值类型：Number 
//	 */
//	public function get localeFestival() :String
//	{
//		return null;
//	}
//	
//	/**
//	 * 获取国际节日
//	 * @return 返回值类型：Number 
//	 */
//	public function get GcFestival() :String
//	{
//		return null;
//	}
//	

	/**
	 * 获取节气
	 * @param  value  参数类型：String 
	 * @return 返回值类型：String 
	 */
	public function set solarTerms(value:String) :Void
	{
		_solarTerms = value;
	}
	public function get solarTerms() :String
	{
		return _solarTerms;
	}
	
	/**
	 * 是否今天
	 * @param  value  参数类型：Boolean 
	 * @return 返回值类型：Boolean 
	 */
	public function set isToday(value:Boolean) :Void
	{
		_isToday = value;
	}
	public function get isToday() :Boolean
	{
		return _isToday;
	}
}