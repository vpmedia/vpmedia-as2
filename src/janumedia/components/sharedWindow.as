import UI.controls.*;
class janumedia.components.sharedWindow extends MovieClip {
	var bg, list, btnPreview, btnNext, btnPrev, sharedmc, sOption, pOption, fxList:MovieClip;
	var originalTitle:String;
	var lastSharedIndex:Number;
	var doc:Boolean;
	var owner, data:Object;
	var so:SharedObject;
	var nc:NetConnection;
	function sharedWindow() {
		_global.sharedWindow = this;
		this.attachMovie("podType3", "bg", 10);
		this.attachMovie("ScrollPane", "sharedmc", 11, {_x:4, _y:bg.midLeft._y+4});
		this.attachMovie("ComboBox", "sOption", 14);
		if (_global.userMode<=1) {
			this.attachMovie("ComboBox", "list", 12, {_x:4});
			this.attachMovie("ComboBox", "fxList", 16);
			this.attachMovie("Button", "btnPrev", 17);
			this.attachMovie("Button", "btnNext", 18);
			this.attachMovie("Button", "btnPreview", 19);
			list.setSize(150, 20);
			list.addItem({label:"Share...", data:0});
			list.addItem({label:"My Computer Screen", data:1});
			list.addItem({label:"Presentation", data:2});
			list.addItem({label:"My Documents", data:3});
			list.addListener("change", onSharedSelected, this);
			list.addListener("open", onComboBoxOpen, this);
			list.selectedIndex = 0;
			fxList._x = list._x+list._width+4+70+4;
			//sOption._x + sOption._width + 4;
			fxList.setSize(120, 2);
			fxList._visible = false;
			btnPreview._x = fxList._x;
			btnPreview.setSize(120, 24);
			btnPreview.label = "Preview";
			btnPreview.preview = false;
			btnPreview._visible = false;
			btnPreview.addListener("click", onPreviewOption, this);
			btnPrev._x = fxList._x+fxList._width+4;
			btnPrev.setSize(24, 24);
			btnPrev.icon = "icon_prev";
			btnPrev._visible = false;
			btnPrev.addListener("click", prevFile, this);
			btnNext._x = btnPrev._x+btnPrev._width+4;
			btnNext.setSize(24, 24);
			btnNext.icon = "icon_next";
			btnNext._visible = false;
			btnNext.addListener("click", nextFile, this);
		}
		sOption.setSize(70, 20);
		sOption._x = _global.userMode>1 ? 8 : list._x+list._width+4;
		sOption._alpha = _global.userMode>1 ? 50 : 100;
		sOption.addItem({label:"Stretch", data:0});
		sOption.addItem({label:"Center", data:1});
		sOption.addItem({label:"Scroll", data:2});
		sOption.addListener("change", onScrollOption, this);
		sOption.addListener("open", onComboBoxOpen, this);
		sOption.selectedIndex = 1;
		sharedmc.content = "defaultSharedContent";
		// scaller / scretch
		bg.addScaller(this);
		// fms
		var owner = this;
		nc = _global.nc;
		so = _global.sharedw_so;
		so.onSync = function(list:Array) {
			var p:sharedWindow = owner;
			p.onSync(list);
		};
		so.connect(nc);
	}
	function onSync(list:Array) {
		loadSharedW(so.data.sharedMode);
		for (var i in so.data) {
			// _global.tt(i +" : "+ so.data[i]);
		}
	}
	function setSize(w:Number, h:Number, callback:Boolean) {
		sharedmc.setSize(w-8, _global.userMode>1 ? h-bg.bottomLeft._height+4 : bg.midLeft._height-4);
		list._y = fxList._y=btnPreview._y=btnNext._y=btnPrev._y=h-bg.bottomLeft._height+4;
		sOption._y = _global.userMode>1 ? h-bg.bottomLeft._height-2 : list._y;
	}
	function setPos(x, y) {
		_x = x;
		_y = y;
	}
	function onComboBoxOpen() {
		bg.setOnTop();
	}
	function onSharedSelected() {
		var index:Number = list.selectedItem.data;
		switch (index) {
		default :
			lastSharedIndex = index;
			nc.call("submitSharedW", null, list.selectedItem.data);
			break;
		case 1 :
			_global.screenSharingWizard.show();
			break;
		case 2 :
			_global.presentationBrowser.show();
			break;
		case 3 :
			_global.contentBrowser.show(true);
		}
	}
	function onScrollOption() {
		//if(list.selectedItem.data == 1 || list.selectedItem.data == 2  || list.selectedItem.data == 3 ) {
		//this._parent._parent.bg.onResize();
		sharedmc.content.setup();
		//}
	}
	function onPreviewOption() {
		if (btnPreview.preview) {
			btnPreview.label = "Preview";
			btnPreview.preview = false;
			sharedmc.content.stopPreview();
			//sharedmc.content.stopRecieve();
		} else {
			//btnPreview.enabled = false;
			sharedmc.content.previewIt();
			//sharedmc.content.getScreenSharing();
		}
	}
	function prevFile() {
		sharedmc.content.previous();
	}
	function nextFile() {
		sharedmc.content.next();
	}
	function selectLastIndex() {
		//_global.tt("lastindex : "+lastSharedIndex);
		list.selectedIndex = lastSharedIndex == undefined ? 0 : lastSharedIndex;
	}
	function onScreenSharingSelected() {
		lastSharedIndex = list.selectedItem.data;
		bg.setTitle(" Submiting Desktop Screen Sharing...");
		sharedmc.content.close();
		sharedmc.content = "screenvideo";
		sharedmc.content.openScreenSharing();
		sharedmc.refresh();
		pOption._visible = false;
		fxList._visible = false;
		btnPrev._visible = false;
		btnNext._visible = false;
		//nc.call("submitSharedW", null, list.selectedItem.data);
	}
	function onPresentationSelected(files:Array) {
		lastSharedIndex = list.selectedItem.data;
		bg.setTitle(" Submiting New Presentations...");
		nc.call("submitSharedW", null, list.selectedItem.data, files);
	}
	function onSharedDocument(url:String) {
		_global.tt("share doc: "+url);
		sharedmc.content.close();
		sharedmc.content = _global.host+url;
		//nc.call("submitSharedW", null, list.selectedItem.data, url);
	}
	function loadSharedW(o:Object) {
		list.removeItemAt(0);
		list.addItemAt(0, {label:o.userid == _global.webID ? "Stop Shared" : "Share...", data:0});
		//list.selectedIndex = o.num;
		//sharedmc.content.close();
		//sharedmc.content = "";
		doc = o.num == 3 ? true : false;
		//_global.tt("is doc : "+doc+" , selected index : "+o.num);
		switch (o.num) {
		case 1 :
			if (o.userid != _global.webID) {
				bg.setTitle("Starting Screen Sharing");
				sharedmc.content = "screenvideo";
				btnPreview._visible = false;
				sharedmc.content.getScreenSharing();
				sharedmc.refresh();
				pOption._visible = false;
				fxList._visible = false;
				btnPrev._visible = false;
				btnNext._visible = false;
			} else {
				//sharedmc.content.getScreenSharing();
				btnPreview._visible = true;
				btnPreview.enabled = true;
			}
			break;
		case 2 :
		case 3 :
			bg.setTitle("Loading Presentation...");
			sharedmc.content = "presentation";
			sharedmc.refresh();
			btnPreview._visible = false;
			//_global.tt(o.userid +" : "+ _global.webID);
			pOption._visible = o.num == 3 ? false : o.userid == _global.webID ? true : false;
			fxList._visible = o.num == 3 ? false : o.userid == _global.webID ? true : false;
			btnPrev._visible = o.userid == _global.webID ? true : false;
			btnNext._visible = o.userid == _global.webID ? true : false;
			btnPrev._x = fxList._visible ? btnPrev._x=fxList._x+fxList._width+4 : sOption._x+sOption._width+4;
			btnNext._x = btnPrev._x+btnPrev._width+4;
			break;
		default :
			// _global.tt("clear content");
			list.removeItemAt(0);
			list.addItemAt(0, {label:"Share...", data:0});
			if (o.userid == _global.webID) {
				list.selectedIndex = o.num;
			}
			bg.setTitle("Shared Window");
			sharedmc.content = "defaultSharedContent";
			sharedmc.refresh();
			btnPreview._visible = false;
			pOption._visible = false;
			fxList._visible = false;
			btnPrev._visible = false;
			btnNext._visible = false;
			break;
		}
	}
	function get isDoc():Boolean {
		return doc;
	}
}
