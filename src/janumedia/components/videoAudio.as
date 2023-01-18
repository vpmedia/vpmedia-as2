//import janumedia.application;
import UI.controls.*;
class janumedia.components.videoAudio extends MovieClip {
	var bg, btn, btnCam, btnMic, sCfree, sTfree, avgallery:MovieClip;
	var owner, data:Object;
	var isBroadcasted, publishCam, publishMic, autoTalk:Boolean;
	var nc:NetConnection;
	var ns:NetStream;
	var cam:Camera;
	var mic:Microphone;
	var micInterval:Number;
	function videoAudio() {
		_global.tt("[videoAudio] main");
		this.attachMovie("podType3", "bg", 10);
		this.attachMovie("ScrollPane", "avgallery", 11, {_x:4, _y:bg.midLeft._y+4});
		this.attachMovie("Button", "btnCam", 12, {_x:4});
		this.attachMovie("Button", "btnMic", 14, {_x:4+24+4});
		avgallery.content = "videoaudio_gallery";
		btnCam.icon = "icon_cam";
		btnCam.setSize(24, 24);
		btnCam.published = false;
		btnCam.addListener("click", doCamPublish, this);
		btnMic.icon = "icon_mic";
		btnMic.setSize(24, 24);
		btnMic.published = false;
		btnMic.addListener("click", doMicPublish, this);
		isBroadcasted = false;
		// scaller / scretch
		bg.addScaller(this);
		// fms
		nc = _global.nc;
		var self = this;
		cam = Camera.get();
		cam.onActivity = function(mode) {
			//self.toggleWebCam(mode);
		};
		//cam.setMode(160,120,25,true);
		//cam.setQuality(4000, 0);
		cam.setMotionLevel(30, 2000);
		//cam.setLoopback(true);
		mic = Microphone.get();
		mic.setSilenceLevel(30, 1000);
		mic.onActivity = onMicActivity;
		//mic.setRate(22);
		//mic.setUseEchoSuppression(true);
		_global.BandwithManager.manage(cam, mic);
		if (nc.camPublished) {
			doCamPublish();
		}
		if (nc.micPublished) {
			doMicPublish();
		}
	}
	function setSize(w:Number, h:Number) {
		_global.tt("[videoAudio] setSize");
		avgallery.setSize(w-8, bg.midLeft._height-4);
		btn._y = btnCam._y=btnMic._y=h-bg.bottomLeft._height+4;
		sCfree._y = sTfree._y=btn._y+2;
	}
	function setPos(x:Number, y:Number) {
		_global.tt("[videoAudio] setPos");
		this._x = x;
		this._y = y;
	}
	function onCamOption() {
		_global.tt("[videoAudio] onCamOption");
		ns.attachVideo(publishCam ? cam : null);
	}
	function onMicOption() {
		_global.tt("[videoAudio] onMicOption");
		ns.attachAudio(publishMic ? mic : null);
	}
	function onCFreeOption() {
		_global.tt("[videoAudio] onCFreeOption");
		_global.tt("cam selected "+sCfree.selected);
		ns.attachVideo(sCfree.selected ? cam : null);
	}
	function onSFreeOption() {
		_global.tt("[videoAudio] onSFreeOption");
		_global.tt("mic selected "+sTfree.selected);
		ns.attachAudio(sTfree.selected ? mic : null);
	}
	function doCamPublish() {
		_global.tt("[videoAudio] doCamPublish");
		if (isBroadcasted) {
			_global.tt("-already broadcasting");
			if (btnCam.published) {
				if (btnMic.published) {
					ns.attachVideo(null);
				} else {
					ns.close();
					nc.call("stopPublish", null);
					isBroadcasted = false;
				}
				nc.camPublished = false;
				publishCam = false;
			} else {
				nc.camPublished = true;
				ns.attachVideo(cam);
			}
		} else {
			_global.tt("-starting broadcasting");
			publishCam = true;
			ns = new NetStream(nc);
			ns.attachVideo(cam);
			ns.attachAudio(null);
			ns.publish("streamcam_"+_global.fmsID, "live");
			nc.camPublished = true;
			nc.call("startPublish", null);
			isBroadcasted = true;
		}
		btnCam.icon = btnCam.published ? "icon_cam" : "icon_cam_off";
		btnCam.published = btnCam.published ? false : true;
	}
	function doMicPublish() {
		_global.tt("[videoAudio] doMicPublish");
		if (isBroadcasted) {
			_global.tt("-already broadcasting");
			if (btnMic.published) {
				if (btnCam.published) {
					ns.attachAudio(null);
				} else {
					ns.close();
					nc.call("stopPublish", null);
					isBroadcasted = false;
				}
				publishMic = false;
				nc.micPublished = false;
				// stop update mic activity level
				clearInterval(micInterval);
			} else {
				nc.micPublished = true;
				ns.attachAudio(mic);
			}
		} else {
			_global.tt("-starting broadcasting");
			publishMic = true;
			ns = new NetStream(nc);
			ns.attachVideo(null);
			ns.attachAudio(mic);
			ns.publish("streamcam_"+_global.fmsID, "live");
			nc.micPublished = true;
			nc.call("startPublish", null);
			isBroadcasted = true;
			// update activity level
			micInterval = setInterval(this, "onMicActivityLevel", 100, this);
		}
		btnMic.icon = btnMic.published ? "icon_mic" : "icon_mic_off";
		btnMic.published = btnMic.published ? false : true;
	}
	function setOption(b:Boolean) {
		_global.tt("[videoAudio] setOption");
		//btnCam._visible = btnMic._visible = sCfree._visible = sTfree._visible = b ? true : false;
		sCfree.selected = sTfree.selected=b;
		//btnCam.enabled = btnMic.enabled = sTfree.enabled = b ? true : false;
	}
	function toggleWebCam(camMotionStatus) {
		_global.tt("[videoAudio] toggleWebCam");
		_global.tt("cam motion : "+camMotionStatus);
		if (!camMotionStatus) {
			//ns.attachVideo( null );
		} else {
			//ns.attachVideo( cam );
		}
	}
	function onMicActivity(activity) {
		_global.tt("[videoAudio] onMicActivity");
		//		_global.tt("onMicActivity : "+activity);
		if (activity) {
			_global.tt("Auto Talking");
			//ns.attachAudio( null );
		} else {
			_global.tt("Auto Quiet");
			//ns.attachAudio( mic );
		}
	}
	function onMicActivityLevel(n) {
		//	_global.tt("[videoAudio] onMicActivityLevel");
		//_global.tt(n);
		//_global.tt("mic.level: "+n.mic.activityLevel);
		var level = n == 0 ? 0 : n.mic.activityLevel;
		ns.send("updateAudioActivityBar", Math.round(level));
		/*
		//_global.tt("mic.level: "+_mic.activityLevel);
		_mc.level.mask._width = level;
		if(_root.camMe.is_published){
		// send it activity level on cam _stream
		_root.camMe.updateAudioActivityBar( level );
		}
		*/
	}
}
