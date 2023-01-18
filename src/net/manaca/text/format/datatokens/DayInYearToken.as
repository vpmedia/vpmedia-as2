import net.manaca.text.format.numbertokens.IntegerToken;
import net.manaca.globalization.calendar.ICalendar;

/**
 * 年中的天数
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.DayInYearToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.DayInYearToken";
	private var defaultChar:String = "D";
	public function DayInYearToken(characterArg : String) {
		super(characterArg);
	}
	/**
	 * TODO 此方法目前只是还回Date格式的日期差，没有针对历法进行返回
	 */
	public function format (repeats:Number, date:ICalendar) : String {
		var data:Date = date.getDate();
		var jan1st:Date = new Date(0);
		jan1st.setFullYear(data.getFullYear());
		var dayNum:Number = Math.ceil((data - jan1st)/(1000*60*60*24));
		return super.format(repeats, dayNum);
	}
}