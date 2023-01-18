import net.manaca.lang.BObject;
import net.manaca.data.Cloneable;
import net.manaca.io.Serializable;
import net.manaca.lang.IObject;
import net.manaca.globalization.Locale;
import net.manaca.text.format.Token;

/**
 * Format 是一个用于格式化语言环境敏感的信息（如日期、消息和数字）的抽象基类。
 * 
 *     通常，一个 format 的 parseObject 方法必须能分析任何由其 format 方法格式化的
 * 字符串。不过，也可能存在不能分析的异常情况。例如，format 方法可能创建中间无
 * 分隔符的两个相邻整数，在这种情况下，parseObject 无法判断哪个数字属于哪个数。
 * 
 * 子类化
 * Java 2 平台为格式化日期、消息和数字分别提供了三个特殊的 Format 的子类：
 * DateFormat、MessageFormat 和 NumberFormat。
 * 
 * @author Wersling
 * @version 1.0, 2006-1-17
 */
class net.manaca.text.format.AbstractFormat extends BObject implements Cloneable,Serializable{
	private var className : String = "net.manaca.text.format.Format";
	//需要格式的样式
	private var template:String = "";
	//区域化包
	private var locale:Locale;
	//所有可替换字符表
	private var tokenTable:Object;
	//所有可替换字符数据，与tokenTable存储方式不同
	private var tokens:Array;
	/**
	 * 构造函数
	 * @param templateArg 需要格式的样式
	 * @param locale 区域包
	 */
	private function AbstractFormat(template:String, locale:Locale) {
		super();
		if(!locale) {
			this.locale = Locale.getDefault();
		}else{
			this.locale = locale;
		}
		this.template = template;
	}
	/**
	 * 实现Cloneable接口，创建并返回此对象的一个副本。
	 * @return was.lang.IObject
	 * @roseuid 43845C4C0213
	 */
	public function clone():IObject{
		return new AbstractFormat();
	}
	
	public function getLocale():Locale{
		return locale;
	}
	
	/**
	 * 格式化一个对象以生成一个字符串。
	 * @param obj 需要格式化的对象
	 * @return String 根据语言包等设置格式化的字符串
	 */
	public function format(obj:Object):String{
		return doFormat(obj);
	}
	
	/**
	 * 格式化一个对象以生成一个字符串。
	 * @param source 必须分析的字符串
	 * @return Object 从字符串进行分析的一个 Object
	 */
	public function parseObject(source:String):Object{
		return doParse(source);
	}
	
	private function doFormat (data:Object) : String {
		//字符长度
		var __currentIndex = template.length;
		//所有字符
		var tmp:String = template;
		//记录字符
		var character:String;
		//字符编码
		var code:Number;
		var tok:Token;
		//所有可解释的字符
		var allToks:Object = tokenTable;
		var __result:String = "";
		while(__currentIndex--){
			__character = character = tmp.charAt(__currentIndex);
			__code = code = character.charCodeAt(0);

			if(tok = allToks[code]){
				var tempIndex = __currentIndex;
				while(tmp.charCodeAt(--__currentIndex)==code);
				__result = tok.format(tempIndex - (__currentIndex++), data, this, tempIndex) + __result;
			}else{
				__result = character + __result;
			}
		}
		return __result;
	}
	
	private function doParse(str:String, data:Object):Object{
		return null;
	}
	private var __character:String;
	private var __code:Number;
}