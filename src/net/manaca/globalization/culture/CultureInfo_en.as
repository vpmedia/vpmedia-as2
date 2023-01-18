import net.manaca.globalization.culture.CultureInfo;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-1-18
 */
class net.manaca.globalization.culture.CultureInfo_en extends CultureInfo {
	private var className : String = "net.manaca.globalization.culture.CultureInfo_en";
	public function CultureInfo_en() {
		super();
	}
	public var dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	public var shortDayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	public var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	public var shortMonthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	
	public var monthDate : String = "MMM yyyy";
	public var shortDate : String = "dd/MM/yy";
	public var mediumDate : String = "dd MMM yyyy";
	public var longDate : String = "dd MMMM yyyy";
	public var fullDate : String = "EEEE, dd MMMM yyyy G";
	
	public var shortTime : String = "HH:mm";
	public var mediumTime : String = "HH:mm";
	public var longTime : String = "HH:mm:ss";
	public var fullTime : String = "HH:mm:ss ZZZ";
	//日期名称
	public var todayNames:Array = new Array(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31);
	public var ordinals : Array = ["th", "st", "nd", "rd", "th", "th", "th", "th", "th", "th"];
}