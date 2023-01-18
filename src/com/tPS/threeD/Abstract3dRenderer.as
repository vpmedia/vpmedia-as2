﻿/** * 3D Renderer Class * @author tPS * @version 1 **/import com.lo9ic.Quaternion;import com.tPS.threeD.camera.Lens;import com.tPS.threeD.Stage3D;import com.tPS.threeD.iRenderable;import com.tPS.threeD.UiElement3D;import app.ui.SimpleScreen3D;class com.tPS.threeD.Abstract3dRenderer{	static private var instance:Abstract3dRenderer;	private var isMouseSensitive:Boolean;	private function Abstract3dRenderer(){		isMouseSensitive = true;	}	static public function initialize():Abstract3dRenderer{		if(instance == undefined){			instance = new Abstract3dRenderer();		}		return instance;	}	public function render($stage:Stage3D):Void{		var cast = $stage.getCast();		var lens = $stage._lens		for(var i=0; i<cast.length; i++){			project2Screen(cast[i],lens);		}				//sortDepth(cast);	}	public function project2Screen($actor:SimpleScreen3D,$lens:Lens):Void{		var piv = $actor._pivot;		var yPos:Number = (isMouseSensitive) ? 220 + (_root._ymouse - Stage.height/2)/4 : 220;		var xPos:Number = piv.x;		_root.background._y = (isMouseSensitive) ? 18 - (_root._ymouse - Stage.height/2)/20 : 18;		_root.background._x = (isMouseSensitive) ? -(_root._xmouse - Stage.width/2)/60 : 0;		piv.fromPoint(xPos,yPos,piv.z);		var screenX:Number = $lens._f * piv.x / (piv.z - $lens._f);		var screenY:Number = $lens._f * piv.y / (piv.z - $lens._f);		var screenX2:Number = $lens._f * (piv.x+$actor._width) / (piv.z - $lens._f);		var screenWidth:Number = screenX2 - screenX;		var screenScale = screenWidth/($actor._width/2)*-100;				if(isMouseSensitive){			if(_root._xmouse > 0 && _root._xmouse < Stage.width){				screenX += $lens._f * ((_root._xmouse - Stage.width/2)*.6) / (piv.z - $lens._f);			}		}		$actor.move(screenX,screenY,screenScale);	}	public function sortDepth($cast:Array):Void{		var ds:Array = $cast;		ds.sort(orderDepth);		for(var i=0; i<ds.length; i++){			var mc:MovieClip = ds[i]._clip;			//mc.swapDepths(i+10);		}	}	public function orderDepth(a,b):Number{		var piv1:Quaternion = a._pivot;		var piv2:Quaternion = b._pivot;		if(piv1.z > piv2.z){			trace("depth is bigger");			return 1;			break;		}else if(piv1.z < piv2.z){			trace("depth is smaller");			return -1;			break;		}else{			return 0;			break;		}	}		private function setMouseSense(isOn:Boolean):Void{		isMouseSensitive = isOn;	}		static function toggleMouseSensivity(isOn:Boolean):Void{		instance.setMouseSense(isOn);	}}