import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 毫秒
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.MilliSecondToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.MilliSecondToken";
	private var defaultChar:String = "S";
	public function MilliSecondToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		return super.format(repeats, date.getMilliseconds());
	}
}