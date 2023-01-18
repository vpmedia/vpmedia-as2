
/* -----  DateUtils

	Name : DateUtils
	Package : eka.utils
	Version : 1.0.0
	Date : 2005-03-17
	Author : ekameleon
	URL : http://www.ekameleon.net
	
	STATIC METHODS
		- getDaysInMonth : retourne le nombre de jours dans un mois défini en paramètre et en fonction d'une année donnée.
		- getFirstDay  : retourne sous forme de nom complet ou sous forme abrégée le nom du premier jour du mois défini en paramètre.
		- getFormatedDate (y:Number, m:Number, d:Number) : Renvoi une chaine de caractère de la forme : YYYY-MM-DD (ex : 2004-03-01)

----------------------------- */

class eka.utils.DateUtils {

	// ----o Author Properties

	public static var className:String= "DateUtils" ;
	public static var classPackage:String= "eka.utils";
	public static var version:String= "1.0.0";
	public static var author:String= "ekameleon";
	public static var link:String= "http://www.ekameleon.net" ;

	// ----o Public Properties

	public static var afullday:Array  = ["dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi"] ;
	public static var aday:Array  = ["di", "lu", "ma", "me", "je", "ve", "sa"] ;
	public static var amonth:Array = ["janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"];

	// ----o Public Methods

	public static function getFormatedDate(y:Number, m:Number, d:Number):String {
		return y + "-" + ( (m++<=9) ? ("0" + m) : m ) + "-" + ( (d<=9) ? ("0" + d) : d ) ;
	}

	public static function getCurrentDate (y, m, d) { return new Date () }

	public static function getFirstDay ( p_y:Number , p_m:Number, nameFlag:Boolean) {
		var d = (new Date (p_y, p_m)).getDay() ;
		return nameFlag ? afullday[d] : d ;
	}


	public static function getDaysInMonth (y:Number, m:Number):Number {
		var monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] ;
		if (((y%4 == 0) && !(y%100 == 0) ) || (y%400 == 0)) monthDays[1] = 29 ;
		return monthDays[m] ;
	}

	public static function getCurrentCalendar(Void):Array {
		var d:Date = new Date() ;
		return getCalendar(d.getFullYear(), d.getMonth()) ;
	}

	public static function getCalendar (y:Number, m:Number):Array {
		var min:Number = getFirstDay (y , m) ;
		var max:Number = min + getDaysInMonth (y, m) ;
		var ar = new Array () ;
		for (var i = 0 ; i < max ; i++) {
			ar[i] = (i < min) ? null : (i - min + 1) ;
		}
		return ar ;
	}

}
