import net.manaca.text.format.Token;
import net.manaca.text.format.AbstractFormat;

/**
 * 上午与下午
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.AmPmToken extends Token {
	private var className : String = "net.manaca.text.format.datatokens.AmPmToken";
	private var defaultChar:String  = "a";
	public function AmPmToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, data:Date, format:AbstractFormat):String {
		return format.getLocale().cultureInfo.amPmIndicator[data.getHours() < 12 ? 0 : 1].toLowerCase();
	}
}