/**
* @author Patrick Matte
* last revision January 30th 2006
*/

class com.blitzagency.worldspace.SpaceCamera extends com.blitzagency.worldspace.SpaceObject{

	public var fl:Number;
	
	public function SpaceCamera(x:Number,y:Number,z:Number,tx:Number,ty:Number,tz:Number,fl:Number){
		super(x,y,z,tx,ty,tz);
		this.fl = (fl==undefined)?300:fl;
	}
		
	public function toString():String{
		return("(x="+x+", y="+y+", z="+z+", tx="+tx+", ty="+ty+", tz="+tz+", fl="+fl+")");
	}
		
}