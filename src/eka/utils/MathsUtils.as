
class eka.utils.MathsUtils {
	
	//  ------o Author Properties
	
	public static var className : String = "MathsUtils" ;
	public static var classPackage : String = "eka.utils";
	public static var version : String = "1.0.1";
	public static var author : String = "eKameleon";
	public static var link : String = "http://www.ekameleon.net" ;
	
	//  ------o Public Static Methods
	
	static public function clamp(value:Number, min:Number, max:Number):Number {
		var n:Number = value ;
		if (min) n = Math.max(n, min) ;
		if (max) n = Math.min(n, max) ;
		return n ;
	}

}
