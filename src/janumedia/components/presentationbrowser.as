import janumedia.application;
import UI.controls.*;
class janumedia.components.presentationbrowser extends MovieClip {
	private var bg, list:MovieClip;
	private var titleInput, answerInput, qType, combo, btnUpload, btnOpen, btnCancel;
	private var label_1, label_2, label_3:TextField;
	private var intervalID:Number;
	private var owner, data:Object;
	private var so:SharedObject;
	private var nc:NetConnection;
	function presentationbrowser() {
		var w = 560;
		var h = 450;
		var x = (Stage.width-w)/2;
		var y = (Stage.height-h)/2;
		this.attachMovie("podType3", "bg", 10);
		this.createTextField("label_1", 11, 2, 2, 1, 1);
		this.attachMovie("DataGrid", "list", 12, {_x:4, _y:bg.midLeft._y+24+8});
		this.attachMovie("ComboBox", "combo", 14, {_x:4, _y:bg.midLeft._y+4});
		//this.attachMovie("Button", "btnUpload", 15, {_x:4});
		this.attachMovie("Button", "btnOpen", 16, {_x:4});
		this.attachMovie("Button", "btnCancel", 17);
		//
		setPos(x, y);
		bg.setSize(w, h);
		bg.isNonResize = true;
		bg.setTitle("Browser Presentation");
		//
		combo.setSize(150, 24);
		combo.addItem({label:"Shared Presentation", data:0});
		combo.addItem({label:"User Presentation", data:1});
		combo.addItem({label:"My Presentation", data:2});
		combo.addListener("change", onComboBoxOpen, this);
		combo.selectedIndex = 0;
		var fmt:TextFormat = new TextFormat();
		fmt.font = "Verdana";
		fmt.size = 10;
		label_1.setNewTextFormat(fmt);
		label_1.autoSize = true;
		label_1.selectable = false;
		label_1._x = combo._x+combo._width+4;
		label_1._y = combo._y+2;
		label_1.text = "Loading presentation...";
		//btnUpload.setSize(70,24);
		//btnUpload.label = "upload";
		btnOpen.setSize(70, 24);
		btnCancel.setSize(70, 24);
		btnOpen.label = "Open";
		btnCancel.label = "Cancel";
		btnOpen.addListener("click", open, this);
		btnCancel.addListener("click", cancel, this);
		btnCancel._x = w-btnCancel._width-4;
		btnOpen._x = btnCancel._x-btnOpen._width-4;
		btnUpload._y = btnOpen._y=btnCancel._y=h-bg.bottomLeft._height+4;
		list.setSize(w-8, h-bg.bottomLeft._height-list._y);
		list.addColumn("name", "Name", list.width*.5, "Name", 4);
		list.addColumn("type", "Type", list.width*.3, "Type", 4);
		list.addColumn("total", "Total Files", list.width*.18, "Total Files", 4);
		list.addColumn("pid", "Data Id", list.width*0.1, "Data Id", 4);
		list.addColumn("data", "Data", list.width*0.1, "Data", 4);
		list.addListener("change", onSelectFile, this);
		Stage.addListener(this);
		onResize();
		hide();
	}
	function onResize() {
		setPos((Stage.width-this._width)/2, (Stage.height-this._height)/2);
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function loadContent(url:String, fl:String, sb:String) {
		list.removeAll();
		btnOpen.enabled = false;
		var self = this;
		var link = url != undefined ? url : "data.php?action=presentation";
		var folder = fl != undefined ? fl : "Shared Presentations";
		var subfolder = sb != undefined ? sb : "";
		var xml:XML = new XML();
		xml.ignoreWhite = true;
		xml.onLoad = function(ok) {
			clearInterval(self.intervalID);
			if (ok) {
				// _global.tt(unescape(this.toString()));
				self.label_1.text = folder+"/"+subfolder+"...";
				var data = this.firstChild.childNodes;
				for (var i = 0; i<data.length; i++) {
					var o = data[i].attributes;
					var p = o.name.substr(o.name.lastIndexOf("/")+1, o.name.length);
					var pname = o.type == "Folder" ? p.split("_defaultfolder").join("") : p;
					var dir = o.name.substr(0, o.name.lastIndexOf("/")+1);
					var label = pname.substr(pname.indexOf("_")+1, pname.length)+" ("+o.size+" kb )";
					var items = new Array();
					//_global.tt(data[i].childNodes.length);
					for (var a = 0; a<data[i].childNodes.length; a++) {
						//_global.tt(data[i].childNodes[a].attributes.file);
						items.push(data[i].childNodes[a].attributes.file);
						//items
					}
					self.list.addItem({name:pname, type:o.type, total:o.total, pid:o.id, data:items}, true);
				}
			} else {
				//form.title.text = "Files Loaded failed";
			}
		};
		xml.load(_global.host+link);
		label_1.text = "Loading presentation...";
		intervalID = setInterval(this, "dataProgress", 100, xml);
	}
	private function dataProgress(doc) {
		var loaded = doc.getBytesLoaded();
		var total = doc.getBytesTotal();
		// == undefined ? 0 : doc.getBytesTotal();
		var percent = Math.floor((loaded/total)*100);
		var info = isNaN(percent) ? "Loading Files..." : "Loading Files "+percent+"%";
		//_global.tt(info);
	}
	private function onComboBoxOpen() {
		switch (combo.selectedItem.data) {
		case 0 :
		default :
			loadContent();
			break;
		case 1 :
			loadContent("data.php?action=userpresentation", "Users Presentations");
			break;
		case 2 :
			this._visible = true;
			loadContent("data.php?action=mypresentation", "My Presentations");
			break;
		}
	}
	function open() {
		//_global.tt(list.selectedItem.path);
		if (list.selectedItem.type != "Folder") {
			_global.sharedWindow.onPresentationSelected(list.selectedItem.data);
			hide();
		} else {
			//_global.tt("open folder");
			loadContent("data.php?action=userpresentation&folderid="+list.selectedItem.pid, "Users Presentations", list.selectedItem.name);
		}
	}
	function cancel() {
		_global.sharedWindow.selectLastIndex();
		hide();
	}
	function onSelectFile() {
		btnOpen.enabled = true;
	}
	function show() {
		this._visible = true;
		//openSharedPresentation();
		combo.selectedIndex = 0;
		loadContent();
		_global.stageCover.drawRec();
	}
	function hide() {
		this._visible = false;
		_global.stageCover.clearRec();
	}
}
