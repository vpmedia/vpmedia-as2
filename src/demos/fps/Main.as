/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.*;
import com.blitzagency.worldspace.cameras.*;
import mx.utils.Delegate;


class demos.fps.Main extends MovieClip{

	public var totalItems:Number = 50;
	private var space:Space;
	private var spaceView:SpaceView;
	private var camera:FPSCamera;
	
	private var tracer:MovieClip;
	
	public function Main(){}
	
	private function onLoad():Void{
		camera = new FPSCamera(0,0,-5000,0,0,0,400);
		
		space = new Space();
		space.push(camera);
		
		spaceView = new SpaceView();
		spaceView.camera = camera;
		
		for (var i:Number=0; i<totalItems; i++){
			var spaceObject:SpaceObject = Space.createRandomObject(800,600,5000);
			space.push(spaceObject);
			var mc:MovieClip = this.attachMovie("clip","clip"+i,this.getNextHighestDepth(),{index:i});
			var spaceMovieClip:SpaceMovieClip = new SpaceMovieClip(mc,spaceObject);
			spaceView.push(spaceMovieClip);
		}
	}
	
	private function onEnterFrame():Void{
		space.update();
		spaceView.render();
		tracer.debug(camera)
	}
		
}
