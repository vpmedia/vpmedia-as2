import UI.controls.*;
class janumedia.components.screenvideo extends MovieClip {
	private var cam:Camera;
	var camList:Array;
	var mic:Microphone;
	var video:Video;
	var info, parentMC:MovieClip;
	var owner, data:Object;
	var nc:NetConnection;
	var ns_p:NetStream;
	var ns_r:NetStream;
	var publisher:Boolean;
	var isRecieving:Boolean;
	var streamdata:Object;
	var intervalID:Number;
	function screenvideo() {
		parentMC = this._parent;
		info._visible = false;
		// fms
		streamdata = null;
		isRecieving = false;
		var self = this;
		nc = _global.nc;
		nc.publish = function(stream:String) {
			var p:screenvideo = self;
			p.publish(stream);
		};
		nc.recieve = function(stream:String) {
			var r:screenvideo = self;
			r.recieve(stream);
		};
		_global.sharedWindow.bg.onResize();
	}
	function openScreenSharing() {
		nc.call("openScreenSharing", null);
	}
	function getScreenSharing() {
		info._visible = false;
		nc.call("getScreenSharing", null);
	}
	function publish(stream:String) {
		mic = Microphone.get();
		mic.setSilenceLevel(30, 1000);
		camList = Camera.names;
		cam = Camera.get(getScreenCaptureDriver());
		var self = this;
		cam.setMotionLevel(30, 2000);
		//cam.onActivity = function(mode) {
		//self.toggleWebCam(mode);
		//}
		cam.setMode(System.capabilities.screenResolutionX, System.capabilities.screenResolutionY, 7, true);
		//cam.setMode(160,160,30);
		cam.setQuality(120000, 0);
		//cam.setQuality(0, 90)
		//cam.setLoopback(true);
		//_global.tt("camW: "+cam.width+" , camH: "+cam.height);
		ns_p.close();
		ns_p = new NetStream(nc);
		ns_p.attachVideo(cam);
		//ns_p.attachAudio(mic);
		ns_p.publish(stream, "live");
		// send message to all
		nc.call("submitSharedW", null, _global.sharedWindow.list.selectedItem.data);
		_global.sharedWindow.bg.setTitle(" Your Desktop Screen Beeing Published");
		info._visible = true;
		setSize(true);
	}
	function previewIt() {
		cam.setLoopback(true);
		video.attachVideo(cam);
		isRecieving = true;
		info._visible = false;
		setSize();
		_global.sharedWindow.btnPreview.label = "Stop Preview";
		_global.sharedWindow.btnPreview.preview = true;
		_global.sharedWindow.btnPreview.enabled = true;
	}
	function stopPreview() {
		cam.setLoopback(false);
		video.attachVideo(null);
		video.clear();
		isRecieving = false;
		info._visible = true;
		setSize(true);
		_global.sharedWindow.bg.setTitle(" Your Desktop Screen Beeing Published");
	}
	function recieve(data:Object) {
		_global.tt("recieve : "+data.streamname);
		ns_r.close();
		ns_r = new NetStream(nc);
		video.attachVideo(ns_r);
		video.smoothing = true;
		video.deblocking = 2;
		ns_r.play(data.streamname, -1);
		ns_r.receiveVideo(true);
		ns_r.receiveAudio(false);
		isRecieving = true;
		info._visible = false;
		streamdata = data;
		var owner = this;
		ns_r.onStatus = function(info) {
			_global.tt(info.code);
			switch (info.code) {
			case "NetStream.Failed" :
				var mesg = "Failed, Can't Play for Screen Sharing Video Stream";
				clearInterval(owner.intervalID);
				_global.infoBox.title = "Error, "+info.code;
				_global.infoBox.content = "alert_serverMesg";
				_global.infoBox.content.mesg = mesg;
				_global.sharedWindow.bg.setTitle(mesg);
				break;
			}
		};
		// get available meta data from current stream video
		ns_r.onMetaData = function(metainfo) {
			for (var n in metainfo) {
				_global.tt(n+" , "+metainfo[n]);
			}
		};
		setSize();
		//_global.tt(streamdata.ownerID +" : "+ _global.fmsID);
		// set button
		if (streamdata.ownerID == _global.webID) {
			_global.sharedWindow.btnPreview.label = "Stop Preview";
			_global.sharedWindow.btnPreview.preview = true;
			_global.sharedWindow.btnPreview.enabled = true;
		}
	}
	function stopRecieve() {
		video.attachVideo(null);
		video.clear();
		ns_r.play(false);
		ns_r.close();
		isRecieving = false;
		streamdata = null;
		info._visible = true;
		setSize(true);
	}
	function toggleWebCam(camMotionStatus) {
		_global.tt("toggle web cam "+camMotionStatus);
		if (!camMotionStatus) {
			ns_p.attachVideo(null);
			video.attachVideo(null);
		} else {
			ns_p.attachVideo(cam);
			if (isRecieving) {
				video.attachVideo(cam);
			}
		}
	}
	function getScreenCaptureDriver():Number {
		for (var i = 0; i<camList.length; i++) {
			if (camList[i] == "VHScrCap") {
				return i;
			}
		}
		return 0;
	}
	function setSize(p:Boolean) {
		clearInterval(intervalID);
		switch (this._parent._parent.sOption.selectedItem.data) {
			// stretch
		case 0 :
		default :
			video._x = 0;
			video._y = 0;
			video._width = parentMC.width;
			video._height = parentMC.height;
			break;
			// center
		case 1 :
			if (video._width>video._height) {
				var w = parentMC.width;
				var h = (video.height/video.width)*w;
				if (h>parentMC.height) {
					var h = parentMC.height;
					var w = (video.width/video.height)*h;
				}
			} else {
				var h = parentMC.height;
				var w = (video.width/video.height)*h;
				if (w>parentMC.width) {
					var w = parentMC.width;
					var h = (video.height/video.width)*w;
				}
			}
			video._width = w;
			video._height = h;
			video._x = (parentMC.width-w)/2;
			video._y = (parentMC.height-h)/2;
			break;
			// scrolled
		case 2 :
			video._x = parentMC.width>video.width ? (parentMC.width-video.width)/2 : 0;
			video._y = parentMC.height>video.height ? (parentMC.height-video.height)/2 : 0;
			video._width = video.width;
			video._height = video.height;
			_global.sharedWindow.bg.size(_global.sharedWindow.bg.width, _global.sharedWindow.bg.height, true, true);
			break;
		}
		if (isRecieving) {
			//_global.tt( video.width+" "+streamdata.owner+" | Attaching Screen Sharing Video...please wait! "+video.height );
			if (video.width == 0 || video.height == 0) {
				// local preview
				if (streamdata == null) {
					_global.sharedWindow.bg.setTitle(" Attaching Screen Sharing Video...please wait!");
					// streaming preview
				} else {
					_global.sharedWindow.bg.setTitle(" "+streamdata.owner+" | Attaching Screen Sharing Video...please wait!");
				}
				if (!p) {
					intervalID = setInterval(this, "setSize", 2000);
				}
			} else {
				if (streamdata == null) {
					_global.sharedWindow.bg.setTitle(" Previewing Screen Sharing");
				} else {
					_global.sharedWindow.bg.setTitle(" "+streamdata.owner+" | Playing Screen Sharing");
				}
				clearInterval(intervalID);
			}
		}
		info._x = (parentMC.width-info._width)/2;
		info._y = (parentMC.height-info._height)/2;
		parentMC.refresh();
	}
	function setup() {
		_global.tt("set Size : "+this._parent._parent.sOption.selectedItem.data);
		setSize();
	}
	function set _x(x) {
		this._x = x;
	}
	function set _y(y) {
		this._y = y;
	}
	function set _width(w) {
		this.video._width = w;
	}
	function set _height(h) {
		this.video._height = h;
	}
	function get _x() {
		return this._x;
	}
	function get _y() {
		return this._y;
	}
	function get _width() {
		return this.video._width;
	}
	function get _height() {
		return this.video._height;
	}
	function close() {
		//_global.tt("close stream screen sharing video window")
		stopRecieve();
		ns_p.close();
		ns_r.close();
	}
	/*function onUnLoad(){
	_global.tt("onUnLoad screenvideo");
	}*/
}
