class janumedia.components.videoaudio_gallery extends MovieClip {
	var parentMC, info, cameramc:MovieClip;
	var avList:Object;
	var avwidth, oriW, oriH:Number;
	var owner, data:Object;
	var so:SharedObject;
	var nc:NetConnection;
	function videoaudio_gallery() {
		parentMC = this._parent;
		this.createEmptyMovieClip("cameramc", 10);
		cameramc.attachMovie("videoaudio_gallery_info", "info", 0);
		cameramc.info._visible = true;
		avList = {};
		setSize();
		// fms
		var owner = this;
		nc = _global.nc;
		so = _global.videoaudio_so;
		// clear 1st
		so.close();
		so.onSync = function(list) {
			owner.onSync(list);
		};
		// do reconnect
		so.connect(nc);
	}
	function addvideo(o:Object) {
		//_global.tt("add new video id "+o.id);
		var mc = cameramc.attachMovie("videoaudio_gallery_item", "av_"+o.id, 10+o.id);
		mc.ns = new NetStream(nc);
		mc.video.attachVideo(mc.ns);
		mc.title.autoSize = true;
		mc.title.text = o.username;
		mc.ns.play("streamcam_"+o.id, -1);
		mc.ns.owner = this;
		mc.ns.onStatus = function(info) {
			_global.tt(info.code);
		};
		mc.ns.updateAudioActivityBar = function(level) {
			_global.tt(mc+" sound level : "+level);
			mc.micLevelBar.bar._width = level*(mc.oriBarW/100);
		};
		mc.onRollOver = function() {
			//this.gotoAndStop(2);
		};
		mc.onRollOut = function() {
			//this.gotoAndStop(1);
		};
		mc.oriBarW = mc.micLevelBar._width;
		mc.micLevelBar.bar._width = 0;
		avwidth = mc._width;
		avList[o.id] = mc;
		arrange();
	}
	function delvideo(id:Number) {
		avList[id].ns.close();
		avList[id].removeMovieClip();
		delete avList[id];
		arrange();
	}
	function onSync(list) {
		for (var i = 0; i<list.length; i++) {
			_global.tt("onSync : "+list[i].name+" - "+list[i].code);
			if (list[i].code == "delete") {
				delvideo(list[i].name);
			} else {
				//if(list[i].name != undefined && list[i].oldValue == null){
				if (list[i].name != undefined) {
					addvideo(so.data[list[i].name]);
				}
			}
		}
	}
	function arrange() {
		/*if(oriW != undefined && oriH != undefined){
		cameramc._width  = oriW
		cameramc._height = oriH;
		}*/
		var x = 0;
		var y = 0;
		var row = 0;
		var colum = 0;
		var space = 0;
		var total = 0;
		var bgw = parentMC.width;
		var maxcolum = Math.floor(bgw/avwidth);
		if (parentMC.width<parentMC.height) {
			maxcolum -= 1;
		}
		maxcolum = maxcolum<0 ? 0 : maxcolum;
		for (var i in avList) {
			var mc = avList[i];
			mc._x = x+(colum*mc._width);
			mc._y = y+(row*mc._height);
			if (row>0) {
				mc._y += (row*space);
			}
			if (colum == maxcolum) {
				row++;
				mc._x += (colum*space);
				colum = 0;
			} else {
				if (colum>0) {
					mc._x += (colum*space);
				}
				colum++;
			}
			total++;
		}
		oriW = cameramc._width;
		oriH = cameramc._height;
		cameramc.info._visible = total>0 ? false : true;
		setSize();
	}
	function setSize(w:Number, h:Number) {
		parentMC.refresh();
		cameramc._x = (parentMC.width-this._width)/2;
		cameramc._y = (parentMC.height-this._height)/2;
		/*
		if(this._parent._parent.sOption.selected && cameramc.info._visible){
		cameramc._x = parentMC.width > oriW ? (parentMC.width-oriW)/2 : 0;
		cameramc._y = parentMC.height > oriH ? (parentMC.height-oriH)/2 : 0;
		cameramc._width  = oriW
		cameramc._height = oriH;
		} else {
		if(cameramc._width > cameramc._height){
		var w = parentMC.width;
		var h = (oriH/oriW)*w;
		if(h > parentMC.height){
		var h = parentMC.height;
		var w = (oriW/oriH)*h;
		}
		} else {
		var h = parentMC.height;
		var w = (oriW/oriH)*h;
		if(w > parentMC.width){
		var w = parentMC.width;
		var h = (oriH/oriW)*w;
		}
		}
		cameramc._width	= w;
		cameramc._height = h;
		cameramc._x = (parentMC.width-w)/2;
		cameramc._y = (parentMC.height-h)/2;
		}
		*/
	}
}
