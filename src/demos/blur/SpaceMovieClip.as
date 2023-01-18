/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import flash.filters.BlurFilter;
import com.blitzagency.worldspace.SpaceObject;

class demos.blur.SpaceMovieClip extends com.blitzagency.worldspace.SpaceMovieClip{
	
	public function SpaceMovieClip(targetObject:Object,spaceObject:SpaceObject){
		super(targetObject,spaceObject);
	}
	
	private function updateTargetObject(spaceObject:SpaceObject,scale:Number):Void{
		super.updateTargetObject(spaceObject,scale);
		// blur
		var blurFactor:Number = (100-scale*100) * 0.1;
		var filter:BlurFilter = new BlurFilter(blurFactor, blurFactor, 2);
		var filterArray:Array = [filter];
		targetObject.filters = filterArray;
	}
	
}