import net.manaca.text.format.Token;

/**
 * 为数字格式化提供一些基本方法，要使用这些方法，必须继承此类
 * @author Wersling
 * @version 1.0, 2006-1-19
 */
class net.manaca.text.format.numbertokens.NumFormatBaseToken extends Token {
	private var className : String = "net.manaca.text.format.numbertokens.NumFormatBaseToken";
	private function NumFormatBaseToken(characterArg : String) {
		super(characterArg);
	}
	
	private function numToLongString(n:Number, dontAddZeros:Boolean) : String {
		var eInd : Number;
		var nExp : Number;
		var nMan : String;
		var n : Number;
		var m : Number;
		var nStr:String = String(n);
		eInd = nStr.indexOf("e");
		if(eInd > -1){
			nExp = parseInt(nStr.substr(eInd+1));
			nMan = nStr.charAt(0) + nStr.substr(2,eInd-2);
			if(dontAddZeros){
				return nMan;
			}
			n = nMan.length;
			if(nExp > 0){
				return padRight(nMan, "0", nExp - n + 1);
			}else{
				return "0." + padLeft(nMan, "0", -1-nExp);
			}
		}else{
			return nStr;
		}
	}
	
	private function scrapeUnlimitedInteger(str:String, minDigits:Number, ignoreChars:String):Number{
		var n:Number = str.length;
		var numChars:Number = 0;
		var tmpStr:String = "";
		var num;
		var ch:String;
		while(n--){
			ch = str.charAt(n);
			// keep going until we hit a non-number
			if(isNaN(ch)){
				if(ignoreChars.indexOf(ch) == -1){
					break;
				}
			}else{
				// this is the number
				tmpStr = ch+tmpStr;
			}
			numChars++;
		}
		
		if(tmpStr.length<minDigits){
			//parseError = 1;
			//value = null;
			return -1;
		}else{
			//value = parseInt(tmpStr,10);
			return numChars;
		}		
	}
	
	/**
	 * 在左添加指定长度的指定字符
	 * @param subject 原是字符
	 * @param padding 要添加的字符
	 * @param n 字符长度
	 * @return String 添加指定长度的指定字符
	 */
	private function padLeft (subject:String, padding:String, n:Number) : String {
		if(n<1) return subject;
		while(n--){
			subject = padding + subject;
		}
		return subject;
	}
	/**
	 * 在右添加指定长度的指定字符
	 * @param subject 原是字符
	 * @param padding 要添加的字符
	 * @param n 字符长度
	 * @return String 添加指定长度的指定字符
	 */
	private function padRight (subject:String, padding:String, n:Number) : String {
		if(n<1) return subject;
		while(n--){
			subject += padding;
		}
		return subject;
	}
	
	private function log10 (n:Number) : Number {
		return Math.log(n)/Math.log(10);
	}
	
	private function get10Exp(n:Number) : Number {
		return Math.floor(log10(n));
	}
}