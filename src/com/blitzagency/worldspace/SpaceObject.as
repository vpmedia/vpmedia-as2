/**
* @author Patrick Matte
* last revision January 30th 2006
*/

class com.blitzagency.worldspace.SpaceObject extends com.blitzagency.worldspace.SpacePoint{
	
	public var tx:Number;
	public var ty:Number;
	public var tz:Number;

	public function SpaceObject(x:Number,y:Number,z:Number,tx:Number,ty:Number,tz:Number){
		super(x,y,z);
		this.tx = (tx == undefined)?0:tx;
		this.ty = (ty == undefined)?0:ty;
		this.tz = (tz == undefined)?0:tz;
	}
	
	public function update(){}
	
	public function toString():String{
		return("(x="+x+", y="+y+", z="+z+", tx="+tx+", ty="+ty+", tz="+tz+")");
	}
	
}