﻿/*************************************			GenericButton			**		Abstract Button Class		***************************************	created by tPS 10.08.2005		** *	edited by tPS 03.06.2006		*************************************/import com.tPS.event.Delegate;import com.mosesSupposes.fuse.ZigoEngine;import com.robertpenner.easing.Quad;import classes.util.Tracking;class  com.tPS.ui.GenericButton extends com.tPS.event.AeventSource{	//props	private var dataHolder:XML;	private var enabled,isActive:Boolean;	private var buttonSound:Sound;	private var _rt:MovieClip;	//constructor	function GenericButton($rt:MovieClip){		//init		_rt = $rt;	}	//methods	private function init():Void{		enabled = true;		isActive = false;		_rt.trackAsMenu = true;		addButtonActions();	}	public function onRolledOver(){		if(enabled){			highLight();		}	}	public function onRolledOut(){		if(enabled){			deLight();		}	}	public function onReleased(){		if(enabled){			deLight();			//event dispatch			broadcastMessage("submit",this);						if(dataHolder.attributes.tag != undefined)				Tracking.send(dataHolder.attributes.tag);		}	}		public function onPressed() : Void {	}	private function highLight(){	}	private function deLight(){	}	public function blendIn(){	}	public function blendOut(){	}	private function addButtonActions():Void{		_rt.onRollOver = Delegate.create(this,onRolledOver);		_rt.onRollOut = Delegate.create(this,onRolledOut);		_rt.onRelease = Delegate.create(this,onReleased);				_rt.onPress = Delegate.create(this,onPressed);	}	public function set _enabled($bol:Boolean){		enabled = $bol;		_rt.useHandCursor = $bol;		if(!enabled){			blendOut();		}else{			blendIn();		}	}	public function set _dataHolder($dh:XML){		dataHolder = $dh;		init();	}	public function get _dataHolder():XML{		return dataHolder;	}	public function get _clip():MovieClip{		return _rt;	}		public function set _clip( $rt:MovieClip ) : Void {		_rt = $rt;	}}