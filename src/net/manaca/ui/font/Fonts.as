import net.manaca.lang.BObject;
import net.manaca.ui.font.IFont;
import net.manaca.globalization.Locale;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-4-27
 */
class net.manaca.ui.font.Fonts extends BObject implements IFont {
	private var className : String = "net.manaca.ui.font.Font";
	private var _font_name : String;
	public function Fonts(name:String) {
		super();
		_font_name = name;
	}
	/**
	 * 返回字体名称
	 */
	public function getName() : String {
		return _font_name;
	}
	/**
	 * 返回客户机器安装字体名称列表
	 * @return Array 字体名称列表
	 */
	static public function getFontListInClient():Array{
		return TextField.getFontList();
	}
	
	/**
	 * 返回指定区域支持的字体名称
	 */
	static public function getFontForLocale(locale:Locale):String{
		switch (locale.getLanguage()) {
	    case "en":
	        return "Arial,Times New Roman";
	        break;
	    case "zh-CN":
	        return "宋体,Arial,Times New Roman";
	        break;
	    default:
	        return "宋体,Arial,Times New Roman";
		}
	}
}