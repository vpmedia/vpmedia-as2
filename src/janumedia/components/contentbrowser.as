import janumedia.application;
import UI.controls.*;
import flash.net.FileReference;
class janumedia.components.contentbrowser extends MovieClip {
	private var bg, list:MovieClip;
	private var titleInput, answerInput, qType, combo, btnUpload, btnOpen, btnCancel;
	private var label_1, label_2, label_3:TextField;
	private var fileRef:FileReference;
	private var doc:Boolean;
	private var intervalID:Number;
	private var owner, data:Object;
	private var so:SharedObject;
	private var nc:NetConnection;
	function contentbrowser() {
		var w = 560;
		var h = 450;
		var x = (Stage.width-w)/2;
		var y = (Stage.height-h)/2;
		this.attachMovie("podType3", "bg", 10);
		this.createTextField("label_1", 11, 2, 2, 1, 1);
		this.attachMovie("DataGrid", "list", 12, {_x:4, _y:bg.midLeft._y+24+8});
		this.attachMovie("ComboBox", "combo", 14, {_x:4, _y:bg.midLeft._y+4});
		this.attachMovie("Button", "btnUpload", 15, {_x:4});
		this.attachMovie("Button", "btnOpen", 16, {_x:4});
		this.attachMovie("Button", "btnCancel", 17);
		//
		fileRef = new FileReference();
		fileRef.addListener(this);
		//
		setPos(x, y);
		bg.setSize(w, h);
		bg.isNonResize = true;
		bg.setTitle("Browser Content");
		//
		combo.setSize(120, 24);
		combo.addItem({label:"Shared Content", data:0});
		combo.addItem({label:"User Content", data:1});
		combo.addItem({label:"My Content", data:2});
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
		label_1.text = "Loading content...";
		btnUpload.setSize(70, 24);
		btnUpload.label = "upload";
		btnOpen.setSize(70, 24);
		btnCancel.setSize(70, 24);
		btnOpen.label = "Open";
		btnCancel.label = "Cancel";
		btnUpload.addListener("click", onUpload, this);
		btnOpen.addListener("click", open, this);
		btnCancel.addListener("click", cancel, this);
		btnCancel._x = w-btnCancel._width-4;
		btnOpen._x = btnCancel._x-btnOpen._width-4;
		btnUpload._y = btnOpen._y=btnCancel._y=h-bg.bottomLeft._height+4;
		list.setSize(w-8, h-bg.bottomLeft._height-list._y);
		list.addColumn("name", "Name", list.width*.6, "Name", 4);
		list.addColumn("type", "Type", list.width*.37, "Type", 4);
		list.addColumn("size", "File Size", list.width*0.1, "File File", 4);
		list.addColumn("path", "Path File", list.width*0.1, "Path File", 4);
		list.addColumn("fileid", "File Id", list.width*0.1, "File Id", 4);
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
		var link = url != undefined ? url : "data.php?action=content";
		var folder = fl != undefined ? fl : "Shared Contents";
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
					var f = o.file.substr(o.file.lastIndexOf("/")+1, o.file.length);
					var filename = o.type == "Folder" ? f.split("_defaultfolder").join("") : f;
					if (o.type != "Folder") {
						filename = filename.substr(filename.indexOf("_")+1, filename.length);
					}
					var dir = o.file.substr(0, o.file.lastIndexOf("/")+1);
					var label = filename.substr(filename.indexOf("_")+1, filename.length)+" ("+o.size+" kb )";
					if (filename != "") {
						if (self.doc) {
							if (o.type == "Flash File" || o.type == "Image") {
								self.list.addItem({name:filename, type:o.type, size:o.size+" kb", path:o.file, fileid:o.id}, true);
							}
						} else {
							self.list.addItem({name:filename, type:o.type, size:o.size+" kb", path:o.file, fileid:o.id}, true);
						}
					}
				}
			} else {
				//form.title.text = "Files Loaded failed";
			}
		};
		xml.load(_global.host+link);
		label_1.text = "Loading content...";
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
			loadContent("data.php?action=usercontent", "Users Contents");
			break;
		case 2 :
			this._visible = true;
			loadContent("data.php?action=mycontent", "My Contents");
			break;
		}
	}
	function onUpload() {
		fileRef.browse([{description:"Flash Files", extension:"*.swf"}, {description:"Image Files", extension:"*.jpg;*.gif;*.png"}, {description:"Flash Video Files", extension:"*.flv"}]);
	}
	function open() {
		//_global.tt(list.selectedItem.path);
		if (list.selectedItem.type != "Folder") {
			if (doc) {
				//_global.sharedWindow.onSharedDocument(list.selectedItem.path);
				_global.sharedWindow.onPresentationSelected([list.selectedItem.path]);
			} else {
				_global.sharedFiles.addFile(list.selectedItem);
			}
			hide();
		} else {
			//_global.tt("open folder");
			loadContent("data.php?action=usercontent&folderid="+list.selectedItem.fileid, "Users Contents", list.selectedItem.name);
		}
	}
	function cancel() {
		if (doc) {
			_global.sharedWindow.selectLastIndex();
		}
		hide();
	}
	function onSelectFile() {
		btnOpen.enabled = true;
	}
	function show(d:Boolean) {
		doc = d;
		bg.setTitle(doc ? "Browser Documents" : "Browser Content");
		this._visible = true;
		//openSharedContent();
		combo.selectedIndex = 0;
		loadContent();
		_global.stageCover.drawRec();
	}
	function hide() {
		this._visible = false;
		_global.stageCover.clearRec();
	}
	// file reference event trigger
	// event trigger
	function onSelect(f:FileReference) {
		//_global.tt("onSelect "+f.name);
		f.upload(_global.host+"doprocess.php?act=upload&id="+_global.webID);
	}
	function onOpen(f:FileReference):Void {
		bg.setTitle("Preparing to upload "+f.name);
	}
	function onCancel(f:FileReference):Void {
		_global.tt("onCancel");
	}
	function onProgress(f:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
		var a = Math.floor((bytesLoaded/bytesTotal)*100)+"%";
		bg.setTitle("Uploading "+f.name+"..."+a);
	}
	function onComplete(f:FileReference):Void {
		bg.setTitle("Uploading "+f.name+" complete, now refreshing list...");
		loadContent();
	}
	// error triger
	function onHTTPError(f:FileReference, httpError:Number):Void {
		_global.tt("onHTTPError "+httpError);
	}
	function onIOError(f:FileReference):Void {
		_global.tt("onIOError: "+f.name);
	}
}
