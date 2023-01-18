import net.manaca.text.format.AbstractFormat;
import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 格式年
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.YearToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.YearToken";
	private var defaultChar:String = "y";
	public function YearToken(characterArg : String) {
		super(characterArg);
	}
	//只允许有两位或者四位，分别返回:01,2006格式字符
	public function format(repeats:Number, date:ICalendar, format:AbstractFormat):String{
		if(repeats == 1){
			repeats = 2;
		}else if (repeats == 3){
			repeats = 4;
		}
		return super.format(repeats, repeats < 3 ? Math.abs(date.getYear())%100 : date.getYear());
	}
}