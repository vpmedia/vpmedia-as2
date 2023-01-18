
class eka.colors.ColorRGB {
	
	//  ------o Author Properties
	
	public static var className : String = "ColorRGB" ;
	public static var classPackage : String = "eka.colors";
	public static var version : String = "1.0.0";
	public static var author : String = "eKameleon|Niko";
	public static var link : String = "http://niko.informatif.org" ;
	
	//  ------o Public Static Methods
	
	public static function rgb2hex(r:Number, g:Number, b:Number):Number  {
		return ((r << 16) | (g << 8) | b);
	}
   
	public static function hex2rgb(hex:Number):Object {
		var r,g,b,gb:Number ;
		r = hex>>16 ;
		gb = hex ^ r << 16 ;
		g = gb>>8 ;
		b = gb^g<<8 ;
		return {r:r,g:g,b:b} ;
	}
	
	public static function setRGBStr(c:Color, str:String) : Void {
		c.setRGB (parseInt (str.substr (-6, 6), 16));
	}

	public static function getRGBStr(c:Color):String {
		var str:String = c.getRGB().toString(16);
		var toFill:Number = 6 - str.length;
		while (toFill--) str = "0" + str ;
		return str.toUpperCase();
	}
	
}
