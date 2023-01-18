import net.manaca.lang.BObject;
import net.manaca.util.StringUtil;
import net.manaca.globalization.Locale;
import net.manaca.ui.font.Fonts;

/**
 * 字体显示对象，用于将文字显示到指定文本框
 * @author Wersling
 * @version 1.0, 2006-4-27
 */
class net.manaca.ui.textField.TextDisplay extends BObject {
	private var className : String = "net.manaca.ui.textField.TextDisplay";
	private static var _instance : TextDisplay;
	public static function get Instance () : TextDisplay
	{
		if (_instance == null ){
			_instance = new TextDisplay ();
		}
		return _instance;
	}
	private function TextDisplay() {
		super();
	}
	
	/**
	 * 设置文本
	 * @see setText(textField,text,[format,locale])
	 * @param textField 文本框对象
	 * @param text 文本同
	 * @param format TextField
	 */
	public function setText(textField : TextField, text : String,format:TextFormat):Void
	{
		if(text ==undefined || text == null) text = "";
		if(text.indexOf("undefined") > -1) text = StringUtil.replace(text,"undefined","");
		textField.text = text;
		if(format != undefined)textField.setTextFormat (format);
	}
	
	/**
	 * 设置具有HTML格式的文本
	 * @see setHtmlText(textField,text,[format,locale])
	 * @param textField 文本框对象
	 * @param text 文本同
	 * @param format TextField
	 */
	public function setHtmlText(textField : TextField, text : String,format:TextFormat):Void{
		if(text ==undefined || text == null) text = "";
		if(text.indexOf("undefined") > -1) text = StringUtil.replace(text,"undefined","");
		textField.html = true;
		textField.multiline = true;
		textField.htmlText = text;
		if(format != undefined)textField.setTextFormat (format);
	}
	
	/** 
	 * 返回有指定区域的字体的文本格式对象
	 * @param locale 为空则返回默认区域字体TextFormat
	 */
	static public function getFormat (locale:Locale) : TextFormat
	{
		var _textFormat:TextFormat = new TextFormat();
		if(locale) {
			_textFormat.font = Fonts.getFontForLocale(locale);
		}else{
			_textFormat.font = Fonts.getFontForLocale(Locale.getDefault());
		}
		return _textFormat;
	}
}