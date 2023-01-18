import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 一天中的小时数（1-24）
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.Hour24Token extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.Hour24Token";
	private var defaultChar:String = "k";
	public function Hour24Token(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:ICalendar) : String {
		var h:Number = date.getHour();
		if(!h) h = 24;
		return super.format(repeats, h);
	}
}