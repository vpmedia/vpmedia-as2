import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * am/pm 中的小时数（1-12）
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.Hour12Token extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.Hour12Token";
	private var defaultChar:String = "h";
	public function Hour12Token(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		var h:Number = date.getHour()%12;
		if(!h) h = 12;
		return super.format(repeats, h);
	}
}