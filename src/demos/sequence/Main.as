/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import com.blitzagency.worldspace.cameras.*;
import com.blitzagency.worldspace.*;
import flash.geom.Point;

class demos.sequence.Main extends MovieClip{
	
	private var space:Space;
	private var spaceView:SpaceView;
	private var camera:FPSCamera;
	public var totalItems:Number = 5;
	private var tracer:MovieClip;
	private var loadIndex:Number = 0;
	private var mcl:MovieClipLoader;
	private var preloader:MovieClip;
	
	public function Main(){}
	
	private function onLoad():Void{
		space = new Space();
		camera = new FPSCamera(0,150,-1500,-20,0,0,400);
		space.push(camera);
		spaceView = new SpaceView();
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
		mcl.loadClip("icon"+loadIndex+".swf",this["clip"+loadIndex]);
	}
	
	private function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void{
		var percent:Number = Math.round((bytesLoaded*100/bytesTotal)/5 + (100/5*loadIndex));
		preloader.loadProgress(percent);
	}
	
	private function onLoadInit(target:MovieClip):Void{
		target._xscale = 0;
		target._yscale = 0;		
		loadIndex++;
		if(loadIndex<totalItems){
			loadImageSequence();
		}else{
			preloader.removeMovieClip();
			for(var i=0;i<totalItems;i++){
				var mc:MovieClip = this["clip"+i];
			}
			onEnterFrame = render;
		}
	}
		
	private function render():Void{
		space.update();
		spaceView.render();
		tracer.debug(camera);
	}
	
}
