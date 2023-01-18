import net.manaca.text.format.Token;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.text.format.AbstractFormat;

/**
 * 月份中的星期
 * @author Wersling
 * @version 1.0, 2006-4-29
 */
class net.manaca.text.format.datatokens.WeekInMonthToken extends Token {
	private var defaultChar:String = "F";
	public function WeekInMonthToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, data:ICalendar, format:AbstractFormat) : String {
		return String(data.getWeekInMonths());
	}
}