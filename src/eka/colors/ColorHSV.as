
class eka.colors.ColorHSV {
	
	//  ------o Author Properties
	
	public static var className : String = "ColorHSV" ;
	public static var classPackage : String = "eka.colors";
	public static var version : String = "1.0.0";
	public static var author : String = "eKameleon";
	public static var link : String = "http://niko.informatif.org" ;
	
	//  ------o Public Static Methods
	
	public static function rgb2hsv ( r:Number, g:Number ,b:Number):Object {
		var temp:Array = ["r:" + r,"g:" + g,"b:"+b].sort(fsort);
		var order:Array =[ temp[0].split(':')[0] , temp[1].split(':')[0] , temp[2].split(':')[0] ];
		var o:Object= {r:r,g:g,b:b} ;
		var v:Number = o[order[0]] * 100 /255 ;
		o.r *= 100 / v ;
		o.g *= 100 / V ;
		o.b *= 100 / V ;
		var s:Number =  (255 - o[order[2]]) * 100 / 255 ; // saturation
		o[order[1]] = Math.round ( 255* (1 - (255-o[order[1]])/(255-o[order[2]]) ));
		o[order[0]]= 255 ; o[order[2]] = 0 ;
		return( { h:o , s:s<<0 ,v:v<<0} ) ;
	}
	
	public static function hsv2rgb ( oColor, s:Number, v:Number) :Object {
		var tmp:Array = ["r:"+oColor.r,"g:"+oColor.g,"b:"+oColor.b].sort(_fsort) ;
		var order:Array = [ tmp[0].split(':')[0] , tmp[1].split(':')[0] , tmp[2].split(':')[0] ];
		var o:Object = { r:oColor.r , g:oColor.g , b:oColor.b } ;
		o[order[2]] += ( 100 - s ) * 2.55 ;
		o[order[1]] += ( 255 - o[order[1]] ) * ( 100 - s ) / 100 ;
		o[order[0]] *= v / 100 ; 
		o[order[1]] *= v / 100 ; 
		o[order[2]] *= v / 100 ;
		return o ;
	}
	
	//  ------o Private Static Methods
	
	private static function _fsort ( a:String , b:String ) :Number {
		var val1:Number = Number(a.split(':')[1]);
		var val2:Number = Number(b.split(':')[1]);
		if (val1 > val2) return -1;
		else if (val1 < val2) return 1;
		else return 0;
	}
	
}
