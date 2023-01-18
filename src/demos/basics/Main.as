/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.Space;
import com.blitzagency.worldspace.SpaceCamera;
import com.blitzagency.worldspace.SpaceObject;
import com.blitzagency.worldspace.SpaceMovieClip;
import com.blitzagency.worldspace.SpaceView;
import com.blitzagency.ui.BasicButton;
import mx.utils.Delegate;
import mx.transitions.Tween;
import mx.transitions.easing.*;


class demos.basics.Main extends MovieClip{

	public var totalItems:Number = 50;
	private var space:Space;
	private var spaceView:SpaceView;
	private var camera:SpaceCamera;
	
	private var xTween:Tween;
	private var yTween:Tween;
	private var zTween:Tween;
	private var index:Number = 0;

	private var tracer:MovieClip;
	
	public function Main(){}
	
	private function onLoad():Void{
		space = new Space();
		camera = new SpaceCamera(0,0,-5000,0,0,0,400);
		space.push(camera);
		spaceView = new SpaceView();
		spaceView.camera = camera;
		for (var i:Number=0; i<totalItems; i++){
			
			var spaceObject:SpaceObject = Space.createRandomObject(800,600,5000);
			space.push(spaceObject);
			
			var mc:MovieClip = this.attachMovie("clip","clip"+i,this.getNextHighestDepth(),{index:i});
			var basicButton:BasicButton = BasicButton(mc);
			basicButton.addEventListener("onRelease",Delegate.create(this,onButtonRelease));
			
			var spaceMovieClip:SpaceMovieClip = new SpaceMovieClip(mc,spaceObject);
			spaceView.push(spaceMovieClip);
		}
		Key.addListener(this);
	}
	
	private function onEnterFrame():Void{
		space.update();
		spaceView.render(camera);
		tracer.debug(camera)
	}
	
	private function onButtonRelease(eventObj:Object):Void{
		index = eventObj.target.index;
		var spaceMovieClip:SpaceMovieClip = SpaceMovieClip(spaceView[index]);
		moveCamera(spaceMovieClip.spaceObject);
	}
	
	private function moveCamera(spaceObject:SpaceObject):Void{
		xTween = new Tween(camera,"x",Strong.easeOut,camera.x,spaceObject.x,18,false);
		yTween = new Tween(camera,"y",Strong.easeOut,camera.y,spaceObject.y,18,false);
		zTween = new Tween(camera,"z",Strong.easeOut,camera.z,spaceObject.z-25,18,false);
	}
	
	private function onKeyDown():Void{
		if(Key.isDown(38) || Key.isDown(87)){
			index++;
			index = (index > totalItems-1)?0:index;
			var spaceObject:SpaceObject = SpaceObject(space[index]);
			moveCamera(spaceObject);
		}
		if(Key.isDown(40) || Key.isDown(83)){
			index--;
			index = (index < 0)?totalItems-1:index;
			var spaceObject:SpaceObject = SpaceObject(space[index]);
			moveCamera(spaceObject);
		}
	}
	
}
