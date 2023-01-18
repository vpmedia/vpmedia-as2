import net.manaca.text.format.AbstractFormat;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.text.format.numbertokens.IntegerToken;

/**
 * 月
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.MonthToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.MonthToken";
	private var defaultChar:String = "M";
	public function MonthToken(characterArg : String) {
		super(characterArg);
	}
	/**
	 * 允许存在1,2,3,4位，分别表示为
	 * M		: 1、12
	 * MM	: 01、12
	 * MMM	: 短日期，如 Tue、一
	 * MMMM	: 长日期，如 Tuesday、一月
	 */
	public function format (repeats:Number, data:ICalendar, format:AbstractFormat) : String {
		var month:Number = data.getMonth();
		switch(repeats){
		case 1:
			return super.format(repeats,month+1);
		case 2:
			return super.format(repeats,month+1);
		case 3:
			return format.getLocale().cultureInfo.shortMonthNames[month];
		default:
			return format.getLocale().cultureInfo.monthNames[month];
		}
	}
}