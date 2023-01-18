import net.manaca.text.format.Token;
import net.manaca.text.format.AbstractFormat;

/**
 * 序数
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.numbertokens.OrdinalToken extends Token {
	private var className : String = "net.manaca.text.format.numbertokens.OrdinalToken";
	public function OrdinalToken(characterArg : String) {
		super(characterArg);
	}
	//将一个数字变为序数词
	public function format (repeats:Number, data:Number, format:AbstractFormat) : String {
		var t:String = format.getLocale().cultureInfo.ordinals[data%10];
		return t==null ? "" : t;
	}
}