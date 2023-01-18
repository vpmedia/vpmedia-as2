import net.manaca.globalization.Locale;
import net.manaca.text.format.AbstractFormat;
import net.manaca.util.StringUtil;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-27
 */
class net.manaca.text.format.MessageFormat extends AbstractFormat {
	private var className : String = "net.manaca.text.format.MessageFormat";
	/**
	 * 构造一个信息格式化对象
	 * @param template : String - 要格式化的字符模板
	 * @param locale : Locale -  区域 
	 */
	public function MessageFormat(template : String, locale : Locale) {
		super(template, locale);
	}
	/**
	 * 静态方法，格式化指定的字符
	 * @param template:String － 要格式化的字符模板
	 * @param result:Array - 格式化依据
	 */
	static function formatSingle(template:String,result:Array):String{
		return new MessageFormat(template).format(result);
	}
	/**
	 * 格式化指定的字符
	 * @param result:Array - 格式化依据
	 */
	public function format(result:Array):String{
		for (var i : Number = 0; i < result.length; i++) {
			template = template.split("{"+i+"}").join(result[i]);
		}
		return template;
	}
}