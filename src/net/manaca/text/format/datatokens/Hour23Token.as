import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 一天中的小时数（0-23）
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.Hour23Token extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.Hour23Token";
	private var defaultChar:String = "H";
	public function Hour23Token(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		var h:Number = date.getHour();
		return super.format(repeats, h);
	}
}