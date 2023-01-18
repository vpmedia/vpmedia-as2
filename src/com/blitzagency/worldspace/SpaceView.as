/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.SpaceMovieClip;
import com.blitzagency.worldspace.SpaceCamera;
import com.blitzagency.worldspace.SpaceObject;

class com.blitzagency.worldspace.SpaceView extends Array{
	
	public var camera:SpaceCamera;
	
	public function SpaceView(){
		this.push.apply(this, arguments);
		camera = new SpaceCamera(0,0,0,0,0,0,500);
	}
	
	public function render(){
		var i:Number = this.length;
		while (-1<--i){
			var spaceMovieClip:SpaceMovieClip = this[i];
			spaceMovieClip.render(camera);
		}
	}
	
}