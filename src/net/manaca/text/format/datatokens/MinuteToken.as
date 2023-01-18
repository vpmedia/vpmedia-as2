import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 分
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.MinuteToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.MinuteToken";
	private var defaultChar:String = "m";
	public function MinuteToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		return super.format(repeats, date.getMinute());
	}
}