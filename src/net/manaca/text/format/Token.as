import net.manaca.lang.BObject;
import net.manaca.text.format.AbstractFormat;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-1-18
 */
class net.manaca.text.format.Token extends BObject {
	private var className : String = "net.manaca.text.format.Token";
	//默认标识字符
	private var defaultChar:String;
	//当前字符
	public var character:String;
	//字符编码
	public var code:Number;
	/**
	 * 构造函数
	 * @param characterArg 可执行的字符
	 */
	public function Token(characterArg:String) {
		super();
		character = ((characterArg == undefined) ? defaultChar : characterArg);
		code = character.charCodeAt(0);
	}
	/**
	 * 格式化，并不是没个 Token.format 都需要这样多的参数
	 * @param repeats 要格式的字符长度
	 * @param data 参考依据
	 * @param format 格式化对象
	 * @param index 字符索引位置
	 * @param store
	 */
	public function format (repeats:Number, data:Object, format:AbstractFormat, index:Number, store:Object):String{
		return null;
	}
	/**
	 * 还原
	 * @param repeats 要还原的字符长度
	 * @param str 
	 * @param format 格式化对象
	 * @param index 字符索引位置
	 */
	public function parse (repeats:Number, str:String, format:AbstractFormat, index:Number):Number{
		return null;
	}
}