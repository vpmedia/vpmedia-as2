﻿/** * 3D Stage Class * @author tPS * @version 1 **/import com.lo9ic.Quaternion;import com.tPS.threeD.camera.Lens;import com.tPS.threeD.iRenderable;import com.tPS.threeD.Abstract3dRenderer;import com.tPS.threeD.UiElement3D;class com.tPS.threeD.Stage3D implements iRenderable {	//props	private var lens:Lens;	private var center:Quaternion;	private var homeClip:MovieClip;	private var cast:Array;	private var renderer:Abstract3dRenderer;	function Stage3D($homeClip:MovieClip){		//Eventsource initialize		AsBroadcaster.initialize();		renderer = Abstract3dRenderer.initialize();		//setClip		homeClip = $homeClip;		//homeClip.cacheAsBitmap = true;		//homeClip.opaqueBackground = 0x000000;		init();	}	private function init(){		lens = new Lens();		center = new Quaternion();		cast = [];		trace("Stage 3D initialized");				var trgt = this;		homeClip.onEnterFrame = function(){			//trgt.render();		}	}	public function addActor($actor:UiElement3D):Void{		cast.push($actor);	}	function render():Void{		renderer.render(this);	}		public function set _lens($lens:Lens):Void{		lens = $lens;	}	public function getCast(Void):Array{		return cast;	}	public function getLens(Void):Lens{		return lens;	}		public function get _stageMC():MovieClip{		return homeClip;	}}