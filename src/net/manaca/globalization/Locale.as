import net.manaca.data.Cloneable;
import net.manaca.lang.BObject;
import net.manaca.io.Serializable;
import net.manaca.lang.IObject;
import net.manaca.lang.exception.IllegalArgumentException;
import net.manaca.lang.exception.NoSuchElementException;
import net.manaca.globalization.NoConstructObjectException;
import net.manaca.globalization.culture.CultureInfo;

/**
 * Locale 对象表示了特定的地理、政治和文化地区。需要 Locale 来执行其任务的操作称
 * 为语言环境敏感的 操作，它使用 Locale 为用户量身定制信息。例如，显示一个数值就
 * 是语言环境敏感的操作，应该根据用户的国家、地区或文化的风俗/传统来格式化该数值。 
 * @author Wersling
 * @version 1.0, 2006-1-16
 */
class net.manaca.globalization.Locale extends BObject implements Cloneable,Serializable {
	private var className : String = "net.manaca.globalization.Locale";
	private var _language:String;
	private var _country:String;
	private var _variant:String;
	private var _cultureInfo : CultureInfo;
	private static var _LocaleList:Object;
	//默认
	private static var _defaultLocale:Locale = null;
	/**
	 * 构造函数
	 * @param language 语言代码值
	 * @param country 国家代码值
	 * @param variant
	 */
	public function Locale(language:String, country:String, variant:String) {
		super();
		if(language == undefined) throw new IllegalArgumentException("缺少必要参数",this,arguments) ;
		if(country == undefined) country = "";
		if(variant == undefined || variant == "") variant = System.capabilities.os;
		_language = language;
		_country = country;
		_variant = variant;
		if(_LocaleList == undefined ){
			_LocaleList = new Object();
			_LocaleList[_language] = this;
		}else{
			_LocaleList[_language] = this;
		}
	}
	/** 重写 Cloneable */
	public function clone():Locale{
		return null;
	}
	
	/**
	 * 如果该 Locale 等于另一个对象，则返回 true。
	 */
	public function equals():Boolean{
		return null;
	}
	
	/**
	 * 返回所有已安装语言环境的数组。
	 */
	public static function getAvailableLocales():Array{
		var a:Array = new Array();
		for(var i in _LocaleList){
			a.push(_LocaleList[i]);	
		}
		return a;
	}
	
	/**
	 * 返回此语言环境的国家/地区代码，将为空字符串或大写的 ISO 3166 两字母代码。
	 */
	public function getCountry():String{
		return _country;
	}
	
	/**
	 * 获得此 Flash 实例的当前默认语言环境。
	 * @return 默认语言环境，如果没有则返回系统编码的语言环境
	 */
	public static function getDefault():Locale{
		if(_defaultLocale != null) return _defaultLocale;
		if(Locale.getLocale(System.capabilities.language) != null) return Locale.getLocale(System.capabilities.language);
		return new Locale("en","","");
	}
	
	/**
	 * 设置此 Flash 实例的当前默认语言环境。
	 */
	public static function setDefault(locale:Locale):Void{
		if(locale) _defaultLocale = locale;
	}
	
	/**
	 * 获得此 Flash 实例的平台和版本信息。
	 */
	public function getVersion():String{
		return (System.capabilities.version);
	}
	
	/**
	 * 返回适合向用户显示的语言环境国家名。
	 */
	public function getDisplayCountry():String{
		return getDefault().getCountry();
	}
	
	/**
	 * 返回适合向用户显示的语言环境语言名。
	 */
	public function getDisplayLanguage():String{
		return getDefault().getLanguage();
	}
	
	/**
	 * 返回适合向用户显示的语言环境名。
	 */
	public function getDisplayName():String{
		return null;
	}
	
	/**
	 * 返回适合向用户显示的语言环境变量代码名。
	 */
	public function getDisplayVariant():String{
		return getDefault().getVariant();
	}
	
	/**
	 * 返回此语言环境的语言代码，可以是空字符串或小写的 ISO 639 代码。
	 */
	public function getLanguage():String{
		return _language;
	}
	
	/**
	 * 返回此语言环境的变量代码。
	 */
	public function getVariant():String{
		return _variant;
	}
	
	/**
	 * 返回指定语言的 Locale
	 * @param language 要返回语言编号
	 * @return Locale 指定语言的 Locale
	 */
	public static function getLocale(language:String):Locale{
		if(_LocaleList[language]) return _LocaleList[language];
		return null;
	}
	
	/**
	 * 使用由下划线分隔的语言、国家和变量来获取整个语言环境的编程名称。
	 */
	public function toString():String{
		return _language +"_"+ _country +"_"+ _variant;
	}
	
	/**
	 * 返回文明信息。
	 */
	public function get cultureInfo():CultureInfo{
		if(_cultureInfo) return _cultureInfo;
		
		_cultureInfo = CultureInfo.getCulture(this);
		
		if(_cultureInfo){
			 return _cultureInfo;
		}else{
			throw new NoConstructObjectException("不能构造此区域对象，原因在于缺少必要的环境信息",this,arguments);
			return null;
		}
	}
	
	/**
	 * TODO 还有更多需要加入，参考Flash帮助和
	 * http://www.unicode.org/unicode/onlinedat/languages.html
	 * http://www.iso.org/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html
	 */
	//捷克
	//static public var CZECH_REPUBLIC:Locale = new Locale("cs","CZ","");
	//丹麦
	//static public var DENMARK:Locale = new Locale("da","DK","");
	//英语
	static public var ENGLISH:Locale = new Locale("en","","");
	//中国
	static public var CHINA:Locale = new Locale("zh-CN","","");

	
	//中国台湾
	//static public var CHINA_TAIWAN:Locale = new Locale("zh-TW","TW","");
	
}