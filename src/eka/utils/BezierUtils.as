
/* ----------------

	Name : BezierUtils
	Package : eka.utils
	Version : 1.0.0
	Date :  2005-04-26
	Author : eKameleon
	URL : http://www.ekameleon.net

	STATICS METHODS

		intersect2Lines(p1, p2, p3, p4) 
		
		midLine(p1, p2) 
		
		bezierSplit(p0, p1, p2, p3) 

	THANKS
		Robert Penner

----------------*/

class eka.utils.BezierUtils {
	
	//  ------o Author Properties
	
	public static var className : String = "BezierUtils" ;
	public static var classPackage : String = "eka.utils";
	public static var version : String = "1.0.0";
	public static var author : String = "eKameleon";
	public static var link : String = "http://www.ekameleon.net" ;
	
	//  ------o Public Static Methods

	static public function intersect2Lines(p1, p2, p3, p4) {
		var x1:Number = p1.x ;
		var y1:Number = p1.y ;
		var x4:Number = p4.x ;
		var y4:Number = p4.y ;
		var dx1:Number = p2.x - x1 ;
		var dx2:Number = p3.x - x4 ;
		var m1:Number = (p2.y - y1) / dx1 ;
		var m2:Number = (p3.y - y4) / dx2 ;
		if (!dx1) return { x:x4, y:m1 * (x4 - x1) + y1 } ; // infinity
		var xInt:Number = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2) ;
		var yInt:Number = m1 * (xInt - x1) + y1 ;
		return { x:xInt, y:yInt } ;
	}
	
	static public function midLine(p1, p2) {
		return {
			x : (p1.x + p2.x) / 2 ,
			y : (p1.y + p2.y) / 2 
		}
	}
	
	static public function bezierSplit(p0, p1, p2, p3) {
		var p01 = midLine(p0, p1);
		var p12 = midLine(p1, p2);
		var p23 = midLine(p2, p3);
		var p02 = midLine(p01, p12);
		var p13 = midLine(p12, p23);
		var p03 = midLine(p02, p13);
		return {
			b0: {a:p0,  b:p01, c:p02, d:p03} ,
			b1: {a:p03, b:p13, c:p23, d:p3 }  
		} ;
	}
}
