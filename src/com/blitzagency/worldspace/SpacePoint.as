/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import flash.geom.Point;

class com.blitzagency.worldspace.SpacePoint{
	
	public var x:Number;
	public var y:Number;
	public var z:Number;

	public function SpacePoint(x:Number,y:Number,z:Number){
		this.x = (x == undefined)?0:x;
		this.y = (y == undefined)?0:y;
		this.z = (z == undefined)?0:z;
	}
	
	public function toString():String{
		return("(x="+x+", y="+y+", z="+z+")");
	}
	
	public static function polar(len:Number,angle:Number):Point{
		var radians:Number = angle*(Math.PI/180);
		var x:Number = len * Math.cos(radians);
		var y:Number = len * Math.sin(radians);
		return new Point(x,y);
	}

}