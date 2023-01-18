import net.manaca.globalization.Locale;
import net.manaca.globalization.culture.CultureInfo_en;
import net.manaca.globalization.culture.CultureInfo_zh_CN;
/**
 * 表示有关特定区域性的信息，包括区域性的名称、书写体系和使用的日历，
 * 以及有关对常用操作（如格式化日期和排序字符串）提供信息的区域性特定对象的访问。
 * @author Wersling
 * @version 1.0, 2006-1-11
 */
class net.manaca.globalization.culture.CultureInfo {
	private var className : String = "net.manaca.globalization.culture.CultureInfo";
//	/**
//	 * 货币转换地址列表
//	 */
	//static public var CurrencyList:Array = new Array ( "AFA-阿富汗尼", "ALL-阿尔巴尼亚币", "DZD-第纳尔", "ARS-比索", "AWG-弗罗林", "BSD-巴哈马币", "BHD-Bahraini Dinar", "BDT-孟加拉币", "BBD-巴巴多斯岛币", "BMD-百慕大币", "BTN-不丹币", "BOB-玻利维亚币", "BWP-博茨瓦纳币", "BRL-巴西币", "BND-文莱币", "BIF-布隆迪币", "KHR-柬埔寨瑞尔", "CAD-加拿大币", "CLP-智利比索", "COP-哥伦比亚币", "KMF-科摩罗币", "CRC-科隆", "HRK-Croatian Kuna", "CUP-Cuban Peso", "CYP-Cyprus Pound", "CZK-Czech Koruna", "DKK-Danish Krone", "XCD-东加勒比币", "EGP-埃及磅", "SVC-El Salvador Colon", "EEK-Estonian Kroon", "ETB-Ethiopian Birr", "FKP-Falkland Islands Pound", "GMD-Gambian Dalasi", "GHC-Ghanian Cedi", "GIP-直布罗陀币", "XAU-Gold Ounces", "GTQ-危地马拉币", "GNF-几内亚币", "GYD-圭亚那币", "HTG-Haiti Gourde", "HNL-Honduras Lempira", "HUF-Hungarian Forint", "ISK-Iceland Krona", "INR-Indian Rupee", "IDR-Indonesian Rupiah", "IQD-Iraqi Dinar", "ILS-Israeli Shekel", "JMD-Jamaican Dollar", "JOD-约旦币", "KZT-Kazakhstan Tenge", "KES-Kenyan Shilling", "KRW-Korean Won", "KWD-Kuwaiti Dinar", "LAK-Lao Kip", "LVL-拉脱维亚币", "LBP-Lebanese Pound", "LSL-莱索托币", "LRD-利比亚币", "LTL-立陶宛币", "MKD-马其顿币", "MGF-马达加斯加币", "MWK-马拉维币", "MYR-Malaysian Ringgit", "MVR-Maldives Rufiyaa", "MTL-Maltese Lira", "MRO-Mauritania Ougulya", "MUR-Mauritius Rupee", "MXN-Mexican Peso", "MDL-Moldovan Leu", "MNT-Mongolian Tugrik", "MAD-Moroccan Dirham", "MZM-莫桑比克币", "MMK-Myanmar Kyat", "NAD-纳米比亚币", "NPR-尼泊尔币", "ANG-Neth Antilles Guilder", "NZD-新西兰币", "NIO-Nicaragua Cordoba", "NGN-Nigerian Naira", "KPW-朝鲜圆", "NOK-Norwegian Krone", "OMR-Omani Rial", "PKR-Pakistani Rupee", "XPD-Palladium Ounces", "PAB-Panama Balboa", "PGK-Papua New Guinea Kina", "PYG-Paraguayan Guarani", "PEN-Peruvian Nuevo Sol", "PHP-菲律宾币", "XPT-Platinum Ounces", "PLN-Polish Zloty", "QAR-Qatar Rial", "ROL-Romanian Leu", "RUB-Russian Rouble", "WST-Samoa Tala", "STD-Sao Tome Dobra", "SAR-Saudi Arabian Riyal", "SCR-Seychelles Rupee", "XAG-Silver Ounces", "SGD-新加坡元", "SKK-Slovak Koruna", "SIT-Slovenian Tolar", "SBD-所罗门群岛币", "SOS-索马里币", "ZAR-南非币", "LKR-Sri Lanka Rupee", "SHP-St Helena Pound", "SDD-苏丹币", "SRG-Surinam Guilder", "SZL-Swaziland Lilageni", "SEK-瑞典币", "CHF-瑞士法郎", "SYP-叙利亚币", "TZS-坦桑尼亚先令", "THB-泰国铢", "TOP-Tonga Pa’anga", "TND-突尼斯币", "TRL-土耳其里拉","EUR-欧元", "USD-美元", "GBP-英镑","AUD-澳元", "JPY-日元","HKD-港币","MOP-中国澳元", "TWD-中国台币", "CNY-人民币"); 
	//语言代码eg en
	public var language : String;
	//地区代码eg UK
	public var country : String;
	//区域名称
	public var displayName:String;
	//英文名称
	public var englishName :String;
	//星期名称
	public var dayNames : Array;
	//短的星期名称
	public var shortDayNames : Array;
	//月份名称
	public var monthNames : Array;
	//短的月份名称
	public var shortMonthNames : Array;
	//日期名称
	public var todayNames:Array;
	//一星期开始的位置(0==sunday)
	public var firstDay : Number = 0;
	
	//默认的格式化时间
	public var monthDate : String = "do MM yyy";
	public var shortDate : String = "dd/MM/yy";
	public var mediumDate : String = "do MMM yyyy";
	public var longDate : String = "do MMMM yyyy";
	public var fullDate : String = "EEEE, do MMMM yyyy G";
	
	public var shortTime : String = "HH:mm";
	public var mediumTime : String = "HH:mm";
	public var longTime : String = "HH:mm:ss";
	public var fullTime : String = "HH:mm:ss ZZZ";

	public var amPmIndicator : Array = ["am", "pm"];
	public var eras : Array = ["BC", "AD"];
	
	//字符串
	public var decimalSeparator : String = ".";
	public var plusSymbol:String = "+";
	public var minusSymbol:String = "-";
	public var integerGroupSeparator : String = ",";
	public var integerGroupSize : Number = 3;
	
	//序数 eg th, st, nd, rd (in 0th, 1st, 2nd, rd,..)
	public var ordinals : Array;
	//货币单位 eg $
	public var currency : String;
	//货币代码 eg USD
	public var currencyCode : String;
	//货币格式ie -$10,000.00
	public var currencyFormat : String = "-CI.dd";
	//百分比格式
	public var percentageFormat : String = "-i%";
	//科学计数法格式
	public var scientificFormat : String = "-m'e'@e";
	//时区
	public var timezones : Array = [];
	//时区名称
	public var timezoneNames : Array = [];
	/**
	 * 获取表示操作系统中安装的区域性的 CultureInfo。
	 */
	static public function InstalledUICulture(){
		
	}
	
	/**
	 * 获取不依赖于区域性（固定）的 CultureInfo。
	 */
	static public function InvariantCulture ():CultureInfo{
		return null;
	}
	
	/**
	 * 返回指定区域的文明信息
	 */
	static public function getCulture (locale:Locale):CultureInfo{
		switch (locale.getLanguage()) {
		    case "en":
		        return new CultureInfo_en();
		        break;
		    case "zh-CN":
		        return new CultureInfo_zh_CN();
		        break;
		    default:
		        return null;
		}
	}
	
	
	
}