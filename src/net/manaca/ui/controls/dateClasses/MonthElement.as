import net.manaca.data.list.ArrayList;
import net.manaca.globalization.calendar.GregorianCalendar;
import net.manaca.globalization.calendar.ChinaCalendar;
import net.manaca.text.format.DateFormat;
import net.manaca.globalization.Locale;
import net.manaca.globalization.calendar.ChinaCalendarEnum;
import net.manaca.ui.controls.dateClasses.DayElement;
/**
 * 一个月的信息
 * @author Wersling
 * @version 1.0, 2006-1-15
 */
class net.manaca.ui.controls.dateClasses.MonthElement extends ArrayList{
	private var className : String = "net.manaca.ui.controls.dateClasses.MonthElement";
	private var _year : Number;
	private var _month : Number;
	private var _firstWeek : Number;
	/**
	 * 构造函数
	 * @param year 指定年
	 * @param month 指定月(0-11)
	 */
	public function MonthElement(year:Number,month:Number) {
		super();
		this.year = year;
		this.month = month;
		basedDayList();
	}
	private function basedDayList():Void{
		
		var _gc:GregorianCalendar = new GregorianCalendar(new Date(year,month,1));
		//获得本月长度
		var _Dlength:Number = _gc.getDaysInMonth();
		//设置开始星期
		firstWeek = _gc.getWeek();
		
		//今日
		var _nowDate:Date = new Date();
		if(year == _nowDate.getFullYear() && month == _nowDate.getMonth()){
			var _today:Number = new Date().getDate();
		}
		//节气;
		if(Locale.getDefault().getLanguage() == "zh-CN"){
			var _tmp1 = ChinaCalendarEnum.sTerm(year,month*2) - 1;
			var _tmp2 = ChinaCalendarEnum.sTerm(year,month*2+1)-1;
		}
		
		for (var i : Number = 1; i < _Dlength+1; i++) {
			var _de:DayElement =  new DayElement(year,month,i);
			if( i == _today){
				_de.isToday = true;
			}
			if( i == _tmp1){
				_de.solarTerms = ChinaCalendarEnum.solarTerm[month*2];
			}
			if( i == _tmp2){
				_de.solarTerms = ChinaCalendarEnum.solarTerm[month*2+1];
			}
			this.push(_de);
		}
	}
	/**
	 * 设置和获取年
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set year(value:Number) :Void
	{
		_year = value;
	}
	public function get year() :Number
	{
		return _year;
	}
	/**
	 *设置和获取月
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set month(value:Number) :Void
	{
		_month = value;
	}
	public function get month() :Number
	{
		return _month;
	}
	/**
	 * 设置和获取一号为星期几
	 * @param  value  参数类型：Number 
	 * @return 返回值类型：Number 
	 */
	public function set firstWeek(value:Number) :Void
	{
		_firstWeek = value;
	}
	public function get firstWeek() :Number
	{
		return _firstWeek;
	}
	
	public function toString():String{
		return year+":"+month;
	}
}