import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 秒
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.SecondToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.SecondToken";
	private var defaultChar:String = "s";
	public function SecondToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		return super.format(repeats, date.getSecond());
	}
}