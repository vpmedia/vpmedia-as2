
class eka.utils.ColorUtils {
	
	//  ------o Author Properties
	
	public static var className : String = "ColorUtils" ;
	public static var classPackage : String = "eka.utils";
	public static var version : String = "1.0.0";
	public static var author : String = "eKameleon";
	public static var link : String = "http://www.ekameleon.net" ;
	
	//  ------o Public Static Methods
	
	public static function invert(c:Color):Void {
		var t:Object = c.getTransform();
		c.setTransform ( {
			ra : -t.ra , ga : -t.ga , ba : -t.ba ,
			rb : 255 - t.rb , gb : 255 - t.gb , bb : 255 - t.bb 
		} ) ;
	}

	public static function reset(c:Color):Void { 
		c.setTransform ({ra:100, ga:100, ba:100, rb:0, gb:0, bb:0}) ;
	}	
	
}
