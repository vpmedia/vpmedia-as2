import net.manaca.globalization.culture.CultureInfo;
/**
 * 中文语言包
 * @author Wersling
 * @version 1.0, 2006-1-16
 */
class net.manaca.globalization.culture.CultureInfo_zh_CN extends CultureInfo{
	//语言代码 eg en
	public var language : String = "zh-CN";
	//地区代码 eg UK
	public var country : String = "CN";
	
	//星期名称
	public var dayNames : Array = ["星期日","星期一", "星期二", "星期三", "星期四","星期五","星期六"];
	//短的星期名称
	public var shortDayNames : Array = ["日", "一", "二", "三", "四", "五", "六"];
	//月份名称
	public var monthNames : Array = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
	//短的月份名称
	public var shortMonthNames : Array = ["一","二","三","四","五","六","七","八","九","十","十一","十二"];
	//日期名称
	public var todayNames:Array = new Array("零","初一","初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","廿十","廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","卅十","卅一");

	//习惯数词
	public var str:Array = new Array("初","十","廿","卅","");
	
	//一星期开始的位置(0==sunday)
	public var firstDay : Number = 0;
	
	//默认的格式化时间
	public var monthDate : String = "yyyy年M月";
	public var shortDate : String = "yy/MM/dd";
	public var mediumDate : String = "yyyy/MM/dd";
	public var longDate : String = "yyyy年M月d日";
	public var fullDate : String = "yyyy年MM月dd日 EEEE";
	
	public var shortTime : String = "HH:mm";
	public var mediumTime : String = "HH:mm";
	public var longTime : String = "HH:mm:ss";
	public var fullTime : String = "HH:mm:ss";

	public var amPmIndicator : Array = ["上午", "下午"];
	public var eras : Array = ["公元前", "公元"];
	
	//字符串
//	public var decimalSeparator : String = ".";
//	public var plusSymbol:String = "+";
//	public var minusSymbol:String = "-";
//	public var integerGroupSeparator : String = ",";
//	public var integerGroupSize : Number = 3;
	
	//序数 eg th, st, nd, rd (in 0th, 1st, 2nd, rd,..)
	public var ordinals : Array;
	//货币单位 eg $
	public var currency : String = "￥";
	//货币代码 eg USD
	public var currencyCode : String = "RMB";
	//货币格式ie -$10,000.00
	public var currencyFormat : String = "-CI";
	//百分比格式
//	public var percentageFormat : String = "-i%";
	//科学计数法格式
//	public var scientificFormat : String = "-m'e'@e";
	//时区
	public var timezones : Array = [];
	//时区名称
	public var timezoneNames : Array = [];
}