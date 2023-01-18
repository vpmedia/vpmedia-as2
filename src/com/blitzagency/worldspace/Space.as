/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.SpaceObject;

class com.blitzagency.worldspace.Space extends Array{
	
	public function Space(){}
	
	public static function createRandomObject(width:Number,height:Number,depth:Number):SpaceObject{
		var xRandom:Number = (random(2)==0)?1:-1;
		var x:Number = random(width) * xRandom;
		
		var yRandom:Number = (random(2)==0)?1:-1;
		var y:Number = random(height) * yRandom;
		
		var zRandom:Number = (random(2)==0)?1:-1;
		var z:Number = random(depth) * zRandom;
		
		var tx:Number = random(360);
		var ty:Number = random(360);
		var tz:Number = random(360);
		
		var spaceObject:SpaceObject = new SpaceObject(x,y,z,tx,ty,tz);
		return spaceObject;
	}
	
	public function update():Void{
		var i:Number = this.length;
		while (-1<--i){
			var spaceObject:SpaceObject = SpaceObject(this[i]);
			spaceObject.update();
		}
	}
	
}