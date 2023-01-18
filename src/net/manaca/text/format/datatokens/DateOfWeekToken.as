import net.manaca.text.format.Token;
import net.manaca.text.format.AbstractFormat;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 一周的星期
 * @author Wersling
 * @version 1.0, 2006-4-27
 */
class net.manaca.text.format.datatokens.DateOfWeekToken extends Token {
	private var className : String = "net.manaca.text.format.datatokens.DateOfWeekToken";
	private var defaultChar:String = "E";
	public function DateOfWeekToken(characterArg : String) {
		super(characterArg);
	}
	/**
	 * 允许存在1,2,3,4位，分别表示为
	 * E	: 一、Sun
	 * EE	: 星期一、Sunday
	 */
	public function format (repeats:Number, data:ICalendar, format:AbstractFormat) : String {
		var _week:Number = data.getWeek();
		switch(repeats){
		case 1:
			return format.getLocale().cultureInfo.shortDayNames[_week];
		default:
			return format.getLocale().cultureInfo.dayNames[_week];
		}
	}
}