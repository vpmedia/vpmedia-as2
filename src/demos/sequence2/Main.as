/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.*;
import com.blitzagency.worldspace.cameras.*;
import mx.utils.Delegate;

class demos.sequence2.Main extends MovieClip{
	
	private var space:Space;
	private var spaceView:SpaceView;
	private var camera:FPSCamera;
	public var totalItems:Number = 50;
	private var tracer:MovieClip;
	private var loadIndex:Number = 0;
	private var mcl:MovieClipLoader;
	private var preloader:MovieClip;
	
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
			var mc:MovieClip = this.createEmptyMovieClip("clip"+i,this.getNextHighestDepth());
			var spaceMovieClip:SpaceMovieClip = new SpaceMovieClip(mc,spaceObject);
			spaceView.push(spaceMovieClip);
		}
		this.attachMovie("preloader","preloader",this.getNextHighestDepth());
		preloader._x = preloader._width / -2;
		loadImageSequence();
	}
	
	private function loadImageSequence():Void{
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		mcl.loadClip("icon"+random(5)+".swf",this["clip"+loadIndex]);
	}
	
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void{
		var percent:Number = Math.round((bytesLoaded*100/bytesTotal)/totalItems + (100/totalItems*loadIndex));
		preloader.loadProgress(percent);
	}
	
	private function onLoadInit(target:MovieClip):Void{
		target._xscale = 0;
		target._yscale = 0;
		mcl.removeListener(this);
		delete mcl;
		loadIndex++;
		if(loadIndex<totalItems){
			loadImageSequence();
		}else{
			preloader.removeMovieClip();
			onEnterFrame = render;
		}
	}
		
	private function render():Void{
		space.update();
		spaceView.render();
		tracer.debug(camera);
	}
	
}
