/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.cameras.*;
import com.blitzagency.worldspace.*;
import demos.bitmapData.Clip;
import demos.bitmapData.MovieClipReference;
import flash.geom.Point;

class demos.bitmapData.Main extends MovieClip{
	
	private var space:Space;
	private var spaceView:SpaceView;
	private var camera:FPSCamera;
	public var totalItems:Number = 5;
	
	private var tracer:MovieClip;
	
	public function Main(){}
	
	private function onLoad():Void{
		space = new Space();
		spaceView = new SpaceView();
		camera = new FPSCamera(0,0,-1500,0,0,0,400);
		space.push(camera);
		spaceView.camera = camera;
		
		var angle:Number = 270;
		var radius:Number = 800;
		for (var i:Number=0; i<totalItems; i++){
			var point:Point = SpacePoint.polar(radius,angle);
			var x:Number = Math.round(point.x*10)/10;
			var z:Number = Math.round(point.y*10)/10;
			var spaceObject:SpaceObject = new SpaceObject(x,0,z,0,angle,0);
			space.push(spaceObject);
			angle += 360/totalItems;
			
			var mc:MovieClip = this.attachMovie("clip"+i,"clip"+i,this.getNextHighestDepth(),{index:i});
			var clip:Clip = Clip(mc);
			var movieclipReference:MovieClipReference = new MovieClipReference(clip);
			var spaceMovieClip = new SpaceMovieClip(movieclipReference,spaceObject);
			spaceView.push(spaceMovieClip);
		}
	}
		
	private function onEnterFrame():Void{
		space.update();
		spaceView.render();
		tracer.debug(camera)
	}
	
}
