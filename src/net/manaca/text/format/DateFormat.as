import net.manaca.text.format.AbstractFormat;
import net.manaca.globalization.Locale;
import net.manaca.globalization.calendar.ICalendar;
import net.manaca.text.format.NumberFormat;
import net.manaca.globalization.TimeZone;
import net.manaca.text.format.Token;
import net.manaca.text.format.datatokens.*;

/**
 * DateFormat 是日期/时间格式化子类的抽象类,它以与语言无关的方式格式化并分析
 * 日期或时间。日期/时间格式化子类（如 SimpleDateFormat）允许进行格式化（也就
 * 是日期 -> 文本）、分析（文本-> 日期）和标准化。将日期表示为 Date 对象，或
 * 者表示为从 GMT（格林尼治标准时间）1970 年，1 月 1 日 00:00:00 这一刻开始
 * 的毫秒数。 
 * 
 * DateFormat 提供了很多类方法，以获得基于默认或给定语言环境和多种格式化风格
 * 的默认日期/时间 Formatter。格式化风格包括 FULL、LONG、MEDIUM 和 SHORT。方
 * 法描述中提供了使用这些风格的更多细节和示例。 
 * 
 * DateFormat 可帮助进行格式化并分析任何语言环境的日期。对于月、星期，
 * 甚至日历格式（阴历和阳历），其代码可完全与语言环境的约定无关。 
 * 
 * 要格式化一个当前语言环境下的日期，可使用某个静态工厂方法： 
 * myString = DateFormat.getDateInstance().format(myDate);
 * 如果格式化多个日期，那么获得该格式并多次使用它是更为高效的做法，这样系统就不必多次获取有关环境语言和国家约定的信息了。 
 * 
 * @code 
		DateFormat df = DateFormat.getDateInstance();
			for (int i = 0; i < myDate.length; ++i) {
			output.println(df.format(myDate[i]) + "; ");
		}
 * 
 * 要格式化不同语言环境的日期，可在 getDateInstance() 的调用中指定它。 
 *  DateFormat df = DateFormat.getDateInstance(DateFormat.LONG, Locale.FRANCE);
 *  还可使用 DateFormat 进行分析。 
 *  myDate = df.parse(myString);
 *  
 *  使用 getDateInstance 来获得该国家的标准日期格式。另外还提供了一些其他静
 *  态工厂方法。使用 getTimeInstance 可获得该国家的时间格式。使用 getDateT
 *  imeInstance 可获得日期和时间格式。可以将不同选项传入这些工厂方法，以控制
 *  结果的长度（从 SHORT 到 MEDIUM 到 LONG 再到 FULL）。确切的结果取决于语言
 *  环境，但是通常： 
 *  
 * SHORT 完全为数字，如 12.13.52 或 3:30pm 
 * MEDIUM 较长，如 Jan 12, 1952 
 * LONG 更长，如 January 12, 1952 或 3:30:32pm 
 * FULL 是完全指定，如 Tuesday, April 12, 1952 AD 或 3:30:42pm PST。 
 * 
 * 如果愿意，还可以在格式上设置时区。如果想对格式化或分析施加更多的控制（
 * 或者给予用户更多的控制），可以尝试将从工厂方法所获得的 DateFormat 强制转
 * 换为 SimpleDateFormat。这适用于大多数国家；只是要记住将其放入一个 try 代
 * 码块中，以防遇到特殊的格式。 
 * 
 * 还可以使用借助 ParsePosition 和 FieldPosition 的分析和格式化方法形式来 
 * 逐步地分析字符串的各部分。 
 * 
 * 对齐任意特定的字段，或者找出字符串在屏幕上的选择位置。
 * 
 * @author Wersling
 * @version 1.0, 2006-1-17
 */
class net.manaca.text.format.DateFormat extends AbstractFormat {
	private var className : String = "net.manaca.text.format.DateFormat";
	/**
	 * 构造函数
	 * @param templateArg 需要格式化时间的样式
	 * <br>
	 * <pre>G - 纪元
	 * 		y - 年
	 * 		M - 月
	 * 		d - 日
	 * 		E - 星期中的天数
	 * 		a - Am/pm 标记
	 * 		w - 年中的周数
	 * 		W - 月份中的周数
	 * 		D - 年中的天数
	 * 		F - 月份中的星期
	 * 		H - 一天中的小时数（0-23）
	 * 		k - 一天中的小时数（1-24）
	 * 		K - am/pm 中的小时数（0-11）
	 * 		h - am/pm 中的小时数（1-12）
	 * 		m - 分
	 * 		s - 秒
	 * 		S - 毫秒
	 * 		z - 时区
	 * 		Z - 时区  RFC 822
	 * </pre>
	 * @param locale 
	 */
	public function DateFormat(templateArg:String, locale:Locale) {
		super(templateArg,locale);
		if(templateArg == undefined){
			template = getDateTimeTemplate(DEFAULT,DEFAULT,this.locale);
		}
		var tokList:Array = [];
		var tokTable:Object = {};
		DateFormat.prototype.tokens = tokList;
		DateFormat.prototype.tokenTable = tokTable;
		createTokens(tokTable, tokList);
	}
	
	/**
	 * 格式化一个对象以生成一个字符串。
	 * @param obj 需要格式化的对象
	 * @return String 根据语言包等设置格式化的字符串
	 */
	public function format(date:ICalendar):String{
		return super.format(date);
	}
	
	/**
	 * 返回所有语言环境的数组
	 */
	public static function getAvailableLocales():Array{
		return Locale.getAvailableLocales();
	}
	
	/**
	 * 获得日期 formatter.
	 */
	public static function getDateInstance(style:Number, aLocale:Locale):DateFormat{
		return null;
	}
	/**
	 * 获得日期/时间 formatter
	 */
	public static function getDateTimeInstance(style:Number, aLocale:Locale):DateFormat{
		return null;
	}
	
	/**
	 * 获得为日期和时间使用 SHORT 风格的默认日期/时间 formatter。
	 */
	public static function getInstance():DateFormat{
		return null;
	}
	
	/**
	 * 获得时间 formatter
	 */
	public static function getTimeInstance(style:Number, aLocale:Locale):DateFormat{
		return null;
	}
	
	
	/**
	 * 获得时区。
	 */
	public function getTimeZone(): TimeZone{
		return null;
	}
	
	/**
	 * 告知日期/时间分析是否为不严格的。
	 */
	public function isLenient():Boolean{
		return null;
	}
	
	/**
	 * 获得此日期/时间 formatter 用于格式化和分析时间的数字 formatter。
	 */
	public function getNumberFormat():NumberFormat{
		return null;
	}
	
	/**
	 * 获取指定级别的时间和时期格式
	 */
	private static function getDateTimeTemplate (dateVerbosity:Number, timeVerbosity:Number, locale:Locale) : String {
		return getDateTemplate(dateVerbosity, locale)+ " " + getTimeTemplate(timeVerbosity, locale);
	}
	/**
	 * 获取指定级别的时期格式
	 */
	private static function getDateTemplate (dateVerbosity:Number, locale:Locale) : String {
		switch (dateVerbosity){
		case LONG:
			return locale.cultureInfo.longDate;
		case SHORT:
			return locale.cultureInfo.shortDate;
		case FULL:
			return locale.cultureInfo.fullDate;
		case MEDIUM:
		default:
			return locale.cultureInfo.mediumDate;
		}
	}
	/**
	 * 获取指定级别的时间格式
	 */
	private static function getTimeTemplate (timeVerbosity:Number, locale:Locale) : String {
		switch (timeVerbosity){
		case LONG:
			return locale.cultureInfo.longTime;
		case SHORT:
			return locale.cultureInfo.shortTime;
		case FULL:
			return locale.cultureInfo.fullTime;
		case MEDIUM:
		default:
			return locale.cultureInfo.mediumTime;
		}
	}
	/**
	 * 为此 DateFormat 对象的日历设置时区
	 */
	public function setTimeZone(zone:TimeZone):Void{
		//return null;
	}
	public static function addToken(tokenTable:Object, orderdTokenList:Array, token:Token):Void{
		tokenTable[token.code] = token;
		orderdTokenList.push(token);
	}
	private static function createTokens (tokTable:Object, tokList:Array):Void {
		addToken(tokTable, tokList, new EraToken(ERA_FIELD));
		addToken(tokTable, tokList, new YearToken(YEAR_FIELD));
		addToken(tokTable, tokList, new MonthToken(MONTH_FIELD));
		addToken(tokTable, tokList, new DayInYearToken(DATE_IN_YEAR_FIELD));
		addToken(tokTable, tokList, new DayToken(DATE_IN_MONTH_FIELD));
		addToken(tokTable, tokList, new AmPmToken(AM_PM_FIELD));
		addToken(tokTable, tokList, new Hour11Token(HOUR0_FIELD));
		addToken(tokTable, tokList, new Hour12Token(HOUR1_FIELD));
		addToken(tokTable, tokList, new Hour23Token(HOUR_OF_DAY0_FIELD));
		addToken(tokTable, tokList, new Hour24Token(HOUR_OF_DAY1_FIELD));
		addToken(tokTable, tokList, new MinuteToken(MINUTE_FIELD));
		addToken(tokTable, tokList, new SecondToken(SECOND_FIELD));
		addToken(tokTable, tokList, new MilliSecondToken(MILLISECOND_FIELD));
		addToken(tokTable, tokList, new TimezoneRfcToken(TIMEZONE_RFC_FIELD));
		addToken(tokTable, tokList, new DateOfWeekToken(DATE_OF_WEEK_FIELD));
		addToken(tokTable, tokList, new WeekInMonthToken(WEEK_IN_MONTH_FIELD));
	}
	
	//转义标记
	public static var ERA_FIELD 				= "G";  //Era 标志符  Text  AD  
	public static var YEAR_FIELD				= "y";  //年  Year  1996; 96  
	public static var MONTH_FIELD				= "M";  //年中的月份  Month  July; Jul; 07  
	public static var WEEK_OF_YEAR_FIELD		= "w";  //年中的周数  Number  27  
	public static var WEEK_OF_MONTH_FIELD		= "W";  //月份中的周数  Number  2  
	public static var DATE_IN_YEAR_FIELD		= "D";  //年中的天数  Number  189  
	public static var DATE_IN_MONTH_FIELD		= "d";  //月份中的天数  Number  10  
	public static var WEEK_IN_MONTH_FIELD 		= "F";  //月份中的星期  Number  2  
	public static var DATE_OF_WEEK_FIELD		= "E";  //星期中的天数  Text  Tuesday; Tue  
	public static var AM_PM_FIELD				= "a";  //Am/pm 标记  Text  PM  
	public static var HOUR_OF_DAY0_FIELD		= "H";  //一天中的小时数（0-23）  Number  0  
	public static var HOUR_OF_DAY1_FIELD		= "k";  //一天中的小时数（1-24）  Number  24  
	public static var HOUR0_FIELD				= "K";  //am/pm 中的小时数（0-11）  Number  0  
	public static var HOUR1_FIELD				= "h";  //am/pm 中的小时数（1-12）  Number  12  
	public static var MINUTE_FIELD				= "m";  //小时中的分钟数  Number  30  
	public static var SECOND_FIELD				= "s";  //分钟中的秒数  Number  55  
	public static var MILLISECOND_FIELD			= "S";  //毫秒数  Number  978  
	public static var TIMEZONE_GMT_FIELD		= "z";  //时区  General time zone  Pacific Standard Time; PST; GMT-08:00  
	public static var TIMEZONE_RFC_FIELD		= "Z";  //时区  RFC 822 time zone  -0800  
	
	//格式化风格
	public static var FULL:Number = 0; //完全为数字，如 12.13.52 或 3:30pm
	public static var LONG:Number = 1;//较长，如 Jan 12, 1952
	public static var MEDIUM:Number = 2;//January 12, 1952 或 3:30:32pm
	public static var SHORT:Number = 3;//Tuesday, April 12, 1952 AD 或 3:30:42pm PST。
	//默认格式化风格
	public static var DEFAULT:Number = 2;
}