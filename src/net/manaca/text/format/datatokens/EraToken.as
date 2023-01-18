import net.manaca.text.format.Token;
import net.manaca.text.format.AbstractFormat;

/**
 * 公元纪年
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.EraToken extends Token {
	private var className : String = "net.manaca.text.format.datatokens.EraToken";
	private var defaultChar:String = "G";
	public function EraToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:Date, format:AbstractFormat) : String {
		return format.getLocale().cultureInfo.eras[date.getYear() > 0 ? 1 : 0];
	}
}