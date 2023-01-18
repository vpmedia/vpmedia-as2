import net.manaca.text.format.Token;
import net.manaca.text.format.AbstractFormat;
import net.manaca.text.format.numbertokens.IntegerToken;

/**
 * 按照RFC 822 time zone
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.datatokens.TimezoneRfcToken extends IntegerToken {
	private var className : String = "net.manaca.text.format.datatokens.TimezoneRfcToken";
	private var defaultChar:String = "Z";
	public function TimezoneRfcToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, date:Date, format:AbstractFormat) : String {
		var n:Number = -new Date().getTimezoneOffset()/60*100;
		var s:String = "";
		if(n>0) {
			
		}
		return n.toString();
	}
}