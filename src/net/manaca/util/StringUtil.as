import net.manaca.lang.exception.IllegalArgumentException;
/**
 * 字符串增强类，增强的字符串操作类，添加了一些常用的字符串处理方法，静态类
 * @author Wersling 
 * @version 1.0, 2005-10-22
 */
class net.manaca.util.StringUtil {
	//默认的转义符Map
	public static var DEFAULT_ESCAPE_MAP:Array = 
		["\\t", "\t", "\\n", "\n", "\\r", "\r", "\\\"", "\"", "\\\\", "\\", "\\'", "\'", "\\f", "\f", "\\b", "\b", "\\", ""];
	/**
	 * 私有构造函数。（不可实例化）
	 */
	private function StringUtil(Void){}
	
	/**
	 * 字符串替换，将字符串中某些字符替换为其他字符。
	 * @param string	要替换的字符原
	 * @param what		要查找的字符
	 * @param to		要替换的字符.
	 * @return String where all occurencies are replaced.
	 */
	public static function replace(string:String, what:String, to:String):String
	{
		return string.split(what).join(to);
	}
	
	/**
	 * HTML编码，将特殊字符过滤为html可以显示的字符
	 * @param String 需要编码的字符串
	 * @return String 编码后的字符串
	 */
	public static function htmlEncode(string:String):String {
		string = replace(string,"&","&amp;");
		string = replace(string,"\"","&quot;");
		string = replace(string,"'","&apos;");
		string = replace(string,"<","&lt;");
		string = replace(string,">","&gt;");
		return string;
	}
	
	/**
	 * 将一个类似于:#000000的颜色值字符转为RGB数值
	 * @param Scor 类似于:#000000的颜色值字符
	 * @return Number RGB数值
	 */
	public static function htmlToColor(string:String):Number {
		var s:String = replace(string,"#","0x");
		return parseInt (s, 16);
	}
	/**
	 * 将一个颜色值转为html支持的颜色字符串
	 * @param color 颜色数值
	 * @return String 类似#000000的字符串
	 */
	public static function colorToHtml(color:Number):String {
		return "#" + color.toString(16);
	}
	/**
	 * 移除字符串前后所有的空字符，包括" "、"\n"、"\t\n"。
	 * @param	string 需要处理的字符
	 * @return String
	 */
	public static function trim(string:String):String
	{
		return leftTrim(rightTrim(string));
	}
	
	/**
	 * 移除字符串前面所有的空字符，包括" "、"\n"、"\t\n"。
	 * @param	string 需要处理的字符
	 * @return String
	 */
	public static function leftTrim(string:String):String
	{
		return leftTrimForChars(string, "\n\t\n ");
	}

	/**
	 * 移除字符串后面所有的空字符，包括" "、"\n"、"\t\n"。
	 * @param	string 需要处理的字符
	 * @return String
	 */	
	public static function rightTrim(string:String):String
	{
		return rightTrimForChars(string, "\n\t\n ");
	}
	
	/**
	 * 移除字符串前面符合条件的多个字符
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.leftTrimForChars("ymoynkeym", "ym")); // oynkeym
	 *   trace(StringUtil.leftTrimForChars("monkey", "mo")); // nkey
	 *   trace(StringUtil.leftTrimForChars("monkey", "om")); // nkey
	 * </CODE>
	 * 
	 * @param string 查询的字符
	 * @param chars 需要移除的字符
	 * @return Trimmed string.
	 */
	public static function leftTrimForChars(string:String, chars:String):String
	{
		var from:Number = 0;
		var to:Number = string.length;
		while (from < to && chars.indexOf(string.charAt(from)) >= 0){
			from++;
		}
		return (from > 0 ? string.substr(from, to) : string);
	}
	
	/**
	 * 移除字符串后面符合条件的多个字符
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // ymoynke
	 *   trace(StringUtil.rightTrimForChars("monkey***", "*y")); // monke
	 *   trace(StringUtil.rightTrimForChars("monke*y**", "*y")); // monke
	 * </CODE>
	 * 
	 * @param string 查询的字符
	 * @param chars 需要移除的字符
	 * @return Trimmed string.
	 */
	public static function rightTrimForChars(string:String, chars:String):String
	{
		var from:Number = 0;
		var to:Number = string.length - 1;
		while (from < to && chars.indexOf(string.charAt(to)) >= 0) {
			to--;
		}
		return (to >= 0 ? string.substr(from, to+1) : string);
	}
	
	/**
	 * 移除字符串前面单个字符
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.leftTrimForChar("yyyymonkeyyyy", "y"); // monkeyyyy
	 * </CODE>
	 * 
	 * @param string 查询的字符
	 * @param 需要移除的字符
	 * @throws IllegalArgumentException if you try to remove more that one char.
	 * @return string 处理后的字符
	 */
	public static function leftTrimForChar(string:String, char:String):String
	{
		if(char.length != 1) {
			throw new IllegalArgumentException("第二个属性char [" + char + "] 只能是一个字符。",eval["th"+"is"],arguments);
		}
		return leftTrimForChars(string, char);
	}
	
	/**
	 * 移除字符串后面单个字符
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.rightTrimForChar("yyyymonkeyyyy", "y"); // yyyymonke
	 * </CODE>
	 * 
	 * @param string 查询的字符
	 * @param 需要移除的字符
	 * @throws IllegalArgumentException if you try to remove more that one char.
	 * @return string 处理后的字符
	 */
	public static function rightTrimForChar(string:String, char:String):String
	{
		if(char.length != 1) {
			throw new IllegalArgumentException("第二个属性char [" + char + "] 只能是一个字符。",eval["th"+"is"],arguments);
		}
		return rightTrimForChars(string, char);
	}
 
    /**
     * 验证E-Mail地址
     * @param 需要验证的Email地址
     * @return true 如果是正确的地址则返回true
    */
	public static function checkEmail(string:String):Boolean {
		// The min Size of an Email is 6 Chars "a@b.cc";
		if (string.length < 6) {
			return false;
		}
		// There must be exact one @ in the Content
		if (string.split('@').length > 2 || string.indexOf('@') < 0) {
			return false;
		}
		// There must be min one . in the Content before the last @
		if (string.lastIndexOf('@') > string.lastIndexOf('.')) {
			return false;
		}
		// There must be min two Characters after the last .
		if (string.lastIndexOf('.') > string.length - 3) {
			return false;
		}
		// There must be min two Characters between the @ and the last .
		if (string.lastIndexOf('.') <= string.lastIndexOf('@') + 1) {
			return false;
		}
		return true;
	}
	
	/**
	 * 检查字符串的长度是否大于等于定义的长度
	 * @param string 需要检查的字符串
	 * @param length 长度
	 * @throws IllegalArgumentException if required length is smaller 0.
	 * @return true 如果大于等于定义的长度，则返回 True
	 */
	public static function assureLength(string:String, length:Number):Boolean
	{
		if (length < 0 || (!length && length !== 0)) {
			throw new IllegalArgumentException("第二个属性length [" + length + "] 应大于等于0。",eval["th"+"is"],arguments);
		}
		return (string.length >= length);
	}
	
	/**
	 * 检查字符串是否包含一系列的字符中的部分
	 * 
	 * Example:
	 * <CODE>
	 *   trace(StringUtil.contains("monkey", "kzj0")); // true
	 *   trace(StringUtil.contains("monkey", "yek")); // true
	 *   trace(StringUtil.contains("monkey", "a")); // false
	 * </CODE>
	 * 
	 * @param string 需要检查的字符串
	 * @param chars 需要包含的字符
	 * @return true 如果包含的字符中有一个在需要检查的字符中则返回True
	 */
	public static function contains(string:String, chars:String):Boolean {
		for (var i:Number = chars.length-1; i >= 0 ; i--) {
			if (string.indexOf(chars.charAt(i)) >= 0) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 检测某一字符串是否以某些字符开始
	 * @param string 需要检查的字符串
	 * @param searchString 需要查找的字符
	 * @return true 如果是以这些字符开始，则返回True
	 */
	public static function startsWith(string:String, searchString:String):Boolean {
		if (string.indexOf(searchString) == 0) {
			return true;
		}
		return false;
	}
	
	/**
	 * 检测某一字符串是否以某些字符结束
	 * @param string 需要检查的字符串
	 * @param searchString 需要查找的字符
	 * @return true 如果是以这些字符结束，则返回True
	 */
	public static function endsWith(string:String, searchString:String):Boolean {
		if (string.lastIndexOf(searchString) == (string.length - searchString.length)) {
			return true;
		}
		return false;
	}
	
	/**
	 * 字符串缩进
	 * Adds a space indent to a existing String.
	 * This method is useful for different kind of ASCII Output writing.
	 * It generates a dynamic size of space indents in front of every
	 * line inside a string.
	 * 
	 * Example:
	 * <CODE>
	 * var bigText = "My name is pretty important\n"
	 *              +"because i am a interesting\n"
	 *              +"small example for this\n"
	 *              +"documentation.";
	 * var result = StringUtil.addSpaceIndent(bigText, 3);
	 * </CODE>
	 * 
	 * Result contains now:
	 * <pre>   My name is pretty important
	 *    because i am a interesting
	 *    small example for this
	 *    documentation.</pre>
	 * 
	 * @param string String that contains lines that should get a space indent.
	 * @param indent Size of the Indent (will get floor'ed)
	 * @return String with a extended Indent.
	 */
	public static function addSpaceIndent(string:String, size:Number):String {
		var indentString:String = multiply(" ", size);
		return indentString+replace(string, "\n", "\n"+indentString);
	}
	
	/**
	 * 复制某一字符生成固定长度的字符串
	 * 
	 * Example:
	 * <CODE>
	 * trace("Result: "+StringUtil.multiply(">", 6); // Result: >>>>>>
	 * </CODE>
	 *
	 * @param string 需要复制的字符
	 * @param factor 复制次数
	 * @return 复制好的字符
	 */
	public static function multiply(string:String, factor:Number):String 
	{
		var result:String="";
		
		for(var i:Number = factor; i>0; i--) {
			result += string;
		}
		return result;
	}
	
	/**
	 * 替换转义字符
	 * <p>To be expected as keymap is a map like:
	 * <code>
	 *   ["keyToReplace1", "replacedTo1", "keyToReplace2", "replacedTo2", ... ]
	 * </code> 
	 * @param string 要转义的字符
	 * @param keyMap 转义字符Map
	 * @param ignoreUnicode 如果为真则忽略双字符编码
	 * @return String 返回一个新的字符
	 */
	public static function escape(string:String, keyMap:Array, ignoreUnicode:Boolean):String {
		if (!keyMap) {
			keyMap = DEFAULT_ESCAPE_MAP;
		}
		var i:Number = 0;
		var l:Number = keyMap.length;
		while (i<l) {
			string = string.split(keyMap[i]).join(keyMap[i+1]);
			i+=2;
		}
		if (!ignoreUnicode) {
			i = 0;
			l = string.length;
			while (i<l) {
				if (string.substring(i, i+2) == "\\u") {
					string = 
						string.substring(0,i) + 
						String.fromCharCode(
							parseInt(string.substring(i+2, i+6), 16)
						) +
						string.substring(i+6);
				}
				i++;
			}
		}
		return string;
	}
	/**
	 * 截取指定字符串中的字符，并返回新的字符串
	 * @param str 目标字符串
	 * @param start 开始字符
	 * @param end 结束字符
	 * @return String 返回处理后的新字符，如果没有找到，则返回 null
	 */
	public static function intercept (str : String, start : String,  end: String) : String{
		var t = str.indexOf (start);
		var s = str.indexOf (end);
		if (str.slice (t, s) != "") return str.slice (t, s);
		return null;
	}
	
	/**
	 *  Returns <code>true</code> if the specified string is
	 *  a single space, tab, carriage return, newline, or formfeed character.
	 */
    public static function isWhitespace(character:String):Boolean
    {
        switch (character)
        {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
                return true;

			default:
                return false;
        }
    }
    
}