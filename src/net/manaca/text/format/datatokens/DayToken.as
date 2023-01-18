import net.manaca.globalization.calendar.ICalendar;
import net.manaca.text.format.AbstractFormat;
import net.manaca.text.format.numbertokens.IntegerToken;

/**
 * 日期
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.DayToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.DayToken";
	private var defaultChar:String = "d";
	public function DayToken(characterArg : String) {
		super(characterArg);
	}
	/**
	 * 允许存在1,2,3位，分别表示为
	 * d		: 1、12
	 * dd	: 01、12
	 * ddd	: localeInfo 中的todayNames，如 初一
	 */
	public function format (repeats:Number, date:ICalendar, format:AbstractFormat) : String {
		var _d:Number = date.getDay();
		if(repeats > 3) repeats = 1;
		switch(repeats){
		case 3:
			return format.getLocale().cultureInfo.todayNames[date.getDay()];
		default:
			return super.format(repeats,_d);
		}
	}
}