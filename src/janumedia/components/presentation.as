import mx.transitions.TransitionManager;
import UI.controls.*;
import flash.net.FileReference;
class janumedia.components.presentation extends MovieClip {
	var fileList, fxName, fxList:Array;
	var curFile, curPage, totalPage, curfx, lastfx:Number;
	var parentMC, curMC, lastMC, mc1, mc2:MovieClip;
	var oriW, oriH, intervalID:Number;
	var isTweening:Boolean;
	var owner, data:Object;
	var so:SharedObject;
	var nc:NetConnection;
	function presentation(Void) {
		// _global.tt("presentation begin");
		this.createEmptyMovieClip("mc1", 10);
		this.createEmptyMovieClip("mc2", 11);
		mc1._lockroot = true;
		mc2._lockroot = true;
		parentMC = this._parent;
		fileList = new Array();
		fxName = ["Fade", "Iris", "Blinds", "Wipe", "Pixel Dissolve"];
		fxList = [mx.transitions.Fade, mx.transitions.Iris, mx.transitions.Blinds, mx.transitions.Wipe, mx.transitions.PixelDissolve];
		this._parent._parent.fxList.removeAll();
		for (var i = 0; i<fxName.length; i++) {
			this._parent._parent.fxList.addItem({label:fxName[i], data:i});
		}
		this._parent._parent.fxList.selectedIndex = 0;
		this._parent._parent.originalTitle = this._parent._parent.bg.title.text;
		// fms
		nc = _global.nc;
		so = _global.presentation_so;
		so.owner = this;
		so.onSync = function(list:Array) {
			var p:presentation = this.owner;
			p.onSync(list);
		};
		//onSync();
		so.connect(nc);
		this._parent._parent.bg.onResize();
	}
	function onSync(list:Array) {
		//_global.tt("onSync")
		loadPresentation(so.data.presentationData);
		/*for (var i in so.data) {
		_global.tt(i);
		}*/
	}
	function newPresentation(o:Object) {
		this._parent._parent.bg.setTitle("New Presentation ("+o.data.length+") has Submited");
		fileList = o.data;
		curFile = o.curPage;
		loadFile(_global.host+fileList[curFile]);
	}
	function loadPresentation(o:Object) {
		if (o.isFlashPaper) {
			curMC.setCurrentPage(o.page);
		} else {
			curfx = o.fx;
			curFile = o.link;
			curPage = o.page;
			totalPage = o.total;
			loadFile(_global.host+o.link);
		}
	}
	function loadFile(file) {
		clearInterval(intervalID);
		lastMC._width = lastMC.oriW;
		lastMC._height = lastMC.oriH;
		lastMC._alpha = 100;
		curMC = curMC == mc2 || curMC == undefined ? mc1 : mc2;
		lastMC = lastMC == mc1 || lastMC == undefined ? mc2 : mc1;
		lastfx = curfx;
		//curfx	= this._parent._parent.fxList.selectedIndex;
		curMC.unLoadMovie();
		var mcLoader:MovieClipLoader = new MovieClipLoader();
		mcLoader.addListener(this);
		mcLoader.loadClip(file, curMC);
	}
	function loadPageNum(n:Number, file:String) {
		curFile = n;
		//loadFile(_global.host+fileList[curFile]);
		if (file.substr(file.lastIndexOf(".")+1, file.length) == "swf") {
			_global.sharedWindow.sOption.selectedIndex = 1;
			_global.sharedWindow.sOption.enabled = false;
		}
		parentMC.refresh();
		loadFile(_global.host+file);
	}
	function onLoadInit(target_mc:MovieClip, httpStatus:Number):Void {
		//_global.tt("w:"+target_mc._width+" , h:"+target_mc._height);
		oriW = target_mc.oriW=target_mc._width;
		oriH = target_mc.oriH=target_mc._height;
		/*var fp = target_mc.getIFlashPaper();
		_global.tt( "is FlashPaper File : "+fp.getIFlashPaper() );
		for(var n in fp){
		_global.tt(n+"  : fp :  "+fp[n]);
		}*/
		setup();
	}
	function onLoadComplete(target_mc:MovieClip, httpStatus:Number):Void {
		if (_global.sharedWindow.isDoc) {
			//setup();
			return;
		}
		//setup(); 
		isTweening = true;
		var tm_out = new TransitionManager(lastMC);
		var tm_in = new TransitionManager(curMC);
		if (totalPage>1) {
			tm_out.startTransition({type:fxList[curfx], direction:mx.transitions.Transition.OUT, duration:4, easing:mx.transitions.easing.None.easeNone});
		}
		tm_in.startTransition({type:fxList[curfx], direction:mx.transitions.Transition.IN, duration:4, easing:mx.transitions.easing.Regular.easeOut});
		//var tmOUT = TransitionManager.start(lastMC, {type:fxList[curfx], direction:mx.transitions.Transition.OUT, duration:4, easing:mx.transitions.easing.None.easeNone});
		//var tmIN  = TransitionManager.start(curMC, {type:fxList[curfx], direction:mx.transitions.Transition.IN, duration:4, easing:mx.transitions.easing.Regular.easeOut});
		tm_in.addEventListener("allTransitionsInDone", this);
		lastMC.swapDepths(lastMC.getDepth()-100);
		curMC.swapDepths(lastMC.getDepth()+100);
	}
	function onLoadProgress(target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void {
		//_global.tt( "is FlashPaper : "+target.getIFlashPaper() );
		var a = Math.floor((bytesLoaded/bytesTotal)*100);
		//var n = fileList[curFile];
		//var name = n.substr(n.lastIndexOf("/")+1,n.length);
		var m = curFile.substr(curFile.lastIndexOf("/")+1, curFile.length);
		var filename = m.substr(m.indexOf("_")+1, m.length);
		var info = a<100 ? "Loading "+filename+" "+a+"%" : filename;
		//this._parent._parent.bg.setTitle((curFile+1)+" of "+fileList.length+" | "+info);
		this._parent._parent.bg.setTitle((curPage+1)+" of "+totalPage+" | "+info);
	}
	function allTransitionsInDone() {
		isTweening = false;
		lastMC._alpha = 0;
		/*if(this._parent._parent.pOption.selected){
		intervalID = setInterval(this,"next",8000);
		}
		*/
	}
	function previous() {
		var fp = curMC.getIFlashPaper();
		if (fp != undefined) {
			if (fp.m_currentPage == 1) {
				return;
			}
			nc.call("FP_gotoPage", null, fp.m_currentPage-1);
		} else {
			nc.call("loadPageNum", null, -1, this._parent._parent.fxList.selectedIndex);
			this._parent._parent.bg.setTitle("Requesting Previous Presentation Page...");
		}
	}
	function next() {
		var fp = curMC.getIFlashPaper();
		if (fp != undefined) {
			if (fp.m_currentPage == fp.m_numPagesLoaded) {
				return;
			}
			nc.call("FP_gotoPage", null, fp.m_currentPage+1);
		} else {
			nc.call("loadPageNum", null, 1, this._parent._parent.fxList.selectedIndex);
			this._parent._parent.bg.setTitle("Requesting Next Presentation Page...");
		}
	}
	function setup() {
		//_global.tt(isTweening);
		//_global.tt(oriW);
		//if(isTweening) return;
		//_global.tt( "is FlashPaper : "+curMC.getIFlashPaper() );
		var fp = curMC.getIFlashPaper();
		if (fp != undefined) {
			curMC._x = 0;
			curMC._y = 0;
			curMC.setSize(parentMC.width, parentMC.height);
			//parentMC.refresh();
			return;
		}
		switch (this._parent._parent.sOption.selectedItem.data) {
			// stretch
		case 0 :
		default :
			curMC._x = 0;
			curMC._y = 0;
			curMC._width = parentMC.width;
			curMC._height = parentMC.height;
			break;
			// center
		case 1 :
			if (curMC._width>curMC._height) {
				var w = parentMC.width;
				var h = (oriH/oriW)*w;
				if (h>parentMC.height) {
					var h = parentMC.height;
					var w = (oriW/oriH)*h;
				}
			} else {
				var h = parentMC.height;
				var w = (oriW/oriH)*h;
				if (w>parentMC.width) {
					var w = parentMC.width;
					var h = (oriH/oriW)*w;
				}
			}
			curMC._width = w;
			curMC._height = h;
			curMC._x = (parentMC.width-w)/2;
			curMC._y = (parentMC.height-h)/2;
			break;
			// scrolled
		case 2 :
			curMC._x = parentMC.width>oriW ? (parentMC.width-oriW)/2 : 0;
			curMC._y = parentMC.height>oriH ? (parentMC.height-oriH)/2 : 0;
			curMC._width = oriW;
			curMC._height = oriH;
			break;
		}
		//_global.tt("set to scrolled "+this._parent._parent.sOption.selected);
		parentMC.refresh();
	}
	function setOriginalSize() {
		curMC._x = 0;
		curMC._y = 0;
		curMC._width = oriW;
		curMC._height = oriH;
		parentMC.refresh();
	}
	function setSize(w:Number, h:Number) {
		setup();
	}
	public function setPosX(x:Number) {
		curMC._x = x;
	}
	public function setPosY(y:Number) {
		curMC._y = y;
	}
	public function get curMCwidth():Number {
		return curMC._width;
	}
	public function get curMCheight():Number {
		return curMC._height;
	}
	public function get isContentFlashPaper():Boolean {
		var fp = curMC.getIFlashPaper();
		_global.tt("is content FP : "+fp);
		return fp != undefined ? true : false;
	}
}
