import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * am/pm 中的小时数（0-11）
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.Hour11Token extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.Hour11Token";
	private var defaultChar:String = "K";
	public function Hour11Token(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		var h:Number = date.getHour()%12;
		return super.format(repeats, h);
	}
}