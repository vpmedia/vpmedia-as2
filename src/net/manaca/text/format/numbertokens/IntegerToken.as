import net.manaca.text.format.numbertokens.NumFormatBaseToken;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.numbertokens.IntegerToken extends NumFormatBaseToken {
	private var className : String = "net.manaca.text.format.numbertokens.IntegerToken";
	
	public function IntegerToken(characterArg : String) {
		super(characterArg);
	}
	public function format (repeats:Number, data:Number) : String {
		var intStr:String = numToLongString(Math.floor(Math.abs(data)));
		return padLeft(intStr, "0", Math.max(repeats - intStr.length, 0));
	}

	
	public function parse (repeats:Number, str:String):Number {
		var len:Number = scrapeUnlimitedInteger(str, repeats, "");
		return len;
	}
}