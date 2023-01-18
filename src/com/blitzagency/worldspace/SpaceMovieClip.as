/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.SpaceObject;
import com.blitzagency.worldspace.SpaceCamera;

class com.blitzagency.worldspace.SpaceMovieClip {
	
	public var targetObject:Object;
	public var spaceObject:SpaceObject;
	
	public function SpaceMovieClip(targetObject:Object,spaceObject:SpaceObject){
		this.targetObject = targetObject;
		this.spaceObject = spaceObject;
	}
	
	public function render(camera:SpaceCamera):Void{
		// position
		var x:Number = spaceObject.x - camera.x;
		var y:Number = spaceObject.y - camera.y;
		var z:Number = spaceObject.z - camera.z;
		
		//y axis rotation
		var radians:Number = camera.ty*(Math.PI/180);
		var xTemp:Number = Math.sin(radians)*z + Math.cos(radians)*x;
		var zTemp:Number = Math.cos(radians)*z - Math.sin(radians)*x;
		x = xTemp;
		z = zTemp;

		//x axis rotation
		var radians:Number = camera.tx*(Math.PI/180);
		var yTemp:Number = Math.cos(radians)*y - Math.sin(radians)*z;
		var zTemp:Number = Math.sin(radians)*y + Math.cos(radians)*z;
		y = yTemp;
		z = zTemp;
		
		//z axis rotation
		var radians:Number = camera.tz*(Math.PI/180);
		var xTemp = Math.cos(radians)*x + Math.sin(radians)*y;
		var yTemp = Math.sin(radians)*x - Math.cos(radians)*y;
		x = xTemp;
		y = yTemp;
		
		// rotations
		var tx:Number = convertAngleTo360(camera.tx - spaceObject.tx + 270);
		var ty:Number = convertAngleTo360(camera.ty - spaceObject.ty + 270);
		var tz:Number = convertAngleTo360(camera.tz - spaceObject.tz + 270);

		// scale factor
		var scale:Number = camera.fl/(camera.fl+z);
		
		// create new spaceObject for update
		var updateObject:SpaceObject = new SpaceObject(x,y,z,tx,ty,tz);
		updateTargetObject(updateObject,scale);
	}

	private function convertAngleTo360(value:Number):Number{
		var number:Number = value;
		for(var i:Number=0;number>=360;i++){
			number -= 360;
		}
		for(var j:Number=0;number<0;j++){
			number += 360;
		}
		return number;
	}

	private function updateTargetObject(spaceObject:SpaceObject,scale:Number):Void{
		var frame:Number = Math.round(spaceObject.ty*(targetObject._totalframes-1)/360);
		targetObject.gotoAndStop(frame+1);
		
		// position
		targetObject._x = scale * spaceObject.x;
		targetObject._y = scale * spaceObject.y;
		
		// scale
		if(scale>1){
			targetObject._xscale = 0;
			targetObject._yscale = 0;
		}else{
			targetObject._xscale = scale*100;
			targetObject._yscale = scale*100;
		}
					
		// visibility
		targetObject._visible = (spaceObject.z > 0);
		
		// depth
		var depth:Number = scale * 16000;
		targetObject.swapDepths(depth);
	}
	
}