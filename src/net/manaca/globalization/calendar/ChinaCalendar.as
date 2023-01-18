import net.manaca.data.Cloneable;
import net.manaca.globalization.calendar.AbstractCalendar;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.globalization.calendar.ChinaCalendarEnum;
import net.manaca.lang.exception.UnsupportedOperationException;
/**
 * 中国农历
 * @author Wersling
 * @version 1.0, 2006-1-14
 */
class net.manaca.globalization.calendar.ChinaCalendar extends AbstractCalendar implements Cloneable,ICalendar {
	private var className : String = "net.manaca.globalization.calendar.ChinaCalendar";
	private var year:Number;
	private var month:Number;
	private var day:Number;
	private var dayCyl:Number;
	private var monCyl:Number;
	private var yearCyl:Number;
	private var leap:Number;
	private var isLeap:Boolean;
	
	/** 历法类型 */
	public static var CALENDAR_TYPE:String = "CH";
	/**
	 * 构造函数
	 */
	public function ChinaCalendar(date : Date) {
		super(date);
		init();
	}
	
	/**
	 * 用于处理数据，在构造时使用
	 */
	private function init():Void{
		leap = 0;
		var i;
		var temp = 0;
		var baseDate;
		var offset:Number;
		var objDate:Date = _date;
		baseDate = new Date(1900, 0, 31);
		// 等到1900-1-31之后的总天数
		offset = (objDate-baseDate)/86400000;
		dayCyl = offset+40;
		monCyl = 14;
		
		//优化计算
		if(objDate.getFullYear() > 2005){
			offset -= 38360;
			monCyl = 1274;
			for (i = 2005; i<2100 && offset>0; i++) {
				temp = ChinaCalendarEnum.lYearDays(i);
				offset -= temp;
				monCyl += 12;
			}
		}else if(objDate.getFullYear() > 2000){
			offset -= 36529;
			monCyl = 1214;
			for (i = 2000; i<2100 && offset>0; i++) {
				temp = ChinaCalendarEnum.lYearDays(i);
				offset -= temp;
				monCyl += 12;
			}
		}else{//从1900年递减，在小于等于0的时候则可以得到农历年了
//			var m = 0;
			for (i=1900; i<2100 && offset>0; i++) {
				temp = ChinaCalendarEnum.lYearDays(i);
//				m += ChinaCalendarEnum.lYearDays(i);
				offset -= temp;
				monCyl += 12;
			}
		}
//		Tracer.debug('m: ' + m);
//		Tracer.debug('monCyl: ' + monCyl);
		//小于补差
		if (offset<0) {
			offset += temp;
			i--;
			monCyl -= 12;
		}
		
		year = i;
		yearCyl = i-1864;
		//闰哪个月
		leap = ChinaCalendarEnum.leapMonth(i);
		isLeap = false;
		
		for (i=1; i<13 && offset>0; i++) {
			//闰月
			if (leap>0 && i == (leap+1) && isLeap == false) {
				--i;
				isLeap = true;
				temp = ChinaCalendarEnum.leapDays(year);
			} else {
				temp = ChinaCalendarEnum.monthDays(year, i);
			}
			//解除闰月
			if (isLeap == true && i == (leap+1)) {
				isLeap = false;
			}
			offset -= temp;
			if (isLeap == false) {
				monCyl++;
			}
		}
		
		if (offset == 0 && leap>0 && i == leap+1) {
			if (isLeap) {
				isLeap = false;
			} else {
				isLeap = true;
				--i;
				--monCyl;
			}
		}
		if (offset<0) {
			offset += temp;
			--i;
			--monCyl;
		}
		month = i-1;
		day = int(offset+1);
	}
	
	/**
	 * 返回一个新的添加指定 毫秒数 的 {@link ICalendar}。
	 * @param milliseconds 要添加的毫秒数
	 * @return ICalendar 添加指定 毫秒数 后的{@link ICalendar}
	 */
	public function addMilliseconds(milliseconds:Number):ICalendar{
		var d:Date = new Date();
		d.setTime(this.getTime()+milliseconds);
		var ic:ChinaCalendar = new ChinaCalendar(d);
		return ic;
	}

	/**
	 * 返回一个新的添加指定 月数 的 {@link ICalendar}。
	 * @param months 要添加的月数
	 * @return ICalendar 添加指定 月数 后的{@link ICalendar}
	 */
	public function addMonths(months:Number):ICalendar{
		return new ChinaCalendar(new Date(this.getDate().getFullYear(),this.getDate().getMonth()+months,this.getDate().getDate(),this.getHour(),this.getMinute(),this.getSecond(),this.getMilliseconds()));
	}
	
	/**
	 * 返回一个新的添加指定 年数 的 {@link ICalendar}。
	 * @param years 要添加的年数
	 * @return ICalendar 添加指定 年数 后的{@link ICalendar}
	 */
	public function addYears(years:Number):ICalendar{
		return new ChinaCalendar(new Date(this.getDate().getFullYear()+years,this.getDate().getMonth(),this.getDate().getDate(),this.getHour(),this.getMinute(),this.getSecond(),this.getMilliseconds()));
	}
	
	/**
	 * 返回月份的天数
	 * @return Number 月份的天数
	 */
	public function getDaysInMonth(Void):Number{
		var y:Number = this.getYear();
		var m:Number = this.getMonth();
		return ChinaCalendarEnum.monthDays(y,m);
	}
	
	/**
	 * 返回年份的天数
	 * @return Number 年份的天数
	 */
	public function getDaysInYear(Void):Number{
		var y:Number = this.getYear();
		return ChinaCalendarEnum.lYearDays(y);
	}
	
	/**
	 * 返回年份中的月数
	 * @return Number 年份中的月数
	 */
	public function getMonthsInYear (Void):Number{
		return isLeapYear() ? 13 : 12;
	}
	
	/**
	 * 返回 月份。
	 * @return Number 返回此 {@link ICalendar} 的 月份
	 */
	public function getMonth (Void):Number{
		return month;
	}
	
	/**
	 * 返回 年份。
	 * @return Number 返回此 {@link ICalendar} 的 年份
	 */
	public function getYear(Void):Number{
		return year;
	}
	
	/**
	 * 返回 日期。
	 * @return Number 返回此 {@link ICalendar} 的 日期
	 */
	public function getDay (Void):Number{
		return day;
	}
	
	/**
	 * 返回 干支月份。
	 * @return Number 返回此 {@link ICalendar} 的 干支月份
	 */
	public function getMonthCyl (Void):Number{
		return monCyl;
	}
	
	/**
	 * 返回 干支年份。
	 * @return Number 返回此 {@link ICalendar} 的 干支年份
	 */
	public function getYearCyl(Void):Number{
		return yearCyl;
	}
	
	/**
	 * 返回 干支日期。
	 * @return Number 返回此 {@link ICalendar} 的 干支日期
	 */
	public function getDayCyl (Void):Number{
		return dayCyl;
	}
	
	/**
	 * 是否为 闰日。
	 * @return Number 如果此日期为 闰日 ，则返回 true
	 */
	public function isLeapDay(Void):Boolean{
		throw new UnsupportedOperationException("此方法还没有实现",this,arguments);
		return null;
	}
	
	/**
	 * 是否为 闰月。
	 * @return Number 如果此日期为 闰月 ，则返回 true
	 */
	public function isLeapMonth(Void):Boolean{
		return isLeap;
	}
	
	/**
	 * 是否为 闰年。
	 * @return Number 如果此日期为 闰年 ，则返回 true
	 */
	public function isLeapYear(Void):Boolean{
		return leap > 0;
	}
}