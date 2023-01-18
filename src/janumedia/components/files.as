import janumedia.application;
import janumedia.components.contentBrowser;
import UI.controls.*;
import flash.net.FileReference;
class janumedia.components.files extends MovieClip {
	private var bg, upload, download, remove:MovieClip;
	private var list;
	private var fileRef:FileReference;
	private var owner, data:Object;
	private var so:SharedObject;
	private var nc:NetConnection;
	function files() {
		_global.sharedFiles = this;
		this.attachMovie("podType3", "bg", 10);
		this.attachMovie("List", "list", 11, {_x:4, _y:bg.midLeft._y+4});
		this.attachMovie("Button", "download", 13);
		fileRef = new FileReference();
		fileRef.addListener(this);
		download.setSize(24, 24);
		download.icon = "icon_save";
		download.defaultw = 160;
		download.defaulth = 24;
		download.enabled = false;
		download.addListener("click", saveToComputer, this);
		list.setSize(bg._width-8, bg.midLeft._height);
		list.render = "iconListRender";
		list.rowColors = [15595519, 16777215];
		list.addListener("change", onSelectFile, this);
		if (_global.userMode<=1) {
			this.attachMovie("ComboBox", "upload", 12, {_x:4});
			this.attachMovie("Button", "remove", 14);
			upload.setSize(180, 20);
			upload.defaultw = 160;
			upload.defaulth = 20;
			upload.addItem({label:"Upload File", data:0});
			upload.addItem({label:"Select From My Computer", data:1});
			upload.addItem({label:"Select From Content Library", data:2});
			upload.addListener("change", onUploadOption, this);
			upload.addListener("open", onComboBoxOpen, this);
			upload.selectedIndex = 0;
			remove.setSize(24, 24);
			remove.icon = "icon_delete";
			remove.addListener("click", removeFile, this);
			remove.enabled = false;
		}
		// scaller / scretch 
		bg.addScaller(this);
		// fms
		var owner = this;
		nc = _global.nc;
		nc.loadFiles = function(arr:Array) {
			var f:files = owner;
			f.loadFiles(arr);
		};
		so = _global.files_so;
		so.onFileAdded = function(o:Object) {
			var f:files = owner;
			f.onFileAdded(o);
		};
		so.onFileDeleted = function(i:Number) {
			var f:files = owner;
			f.onFileDeleted(i);
		};
		so.connect(nc);
		nc.call("loadFiles", null);
	}
	function setSize(w:Number, h:Number) {
		list.setSize(w-8, bg.midLeft._height-4);
		upload._y = download._y=remove._y=h-bg.bottomLeft._height+4;
		download._x = _global.userMode>1 ? 4 : upload._x+upload._width+4;
		//download._y = upload._y;
		remove._x = download._x+download._width+4;
		//remove._y = upload._y;
	}
	function setPos(x:Number, y:Number) {
		this._x = x;
		this._y = y;
	}
	function onComboBoxOpen() {
		bg.setOnTop();
	}
	function onSelectFile() {
		//_global.tt("onSelectFile");
		download.enabled = true;
		remove.enabled = true;
	}
	function saveToComputer() {
		//_global.tt(list.selectedItem.path);
		getURL(_global.host+list.selectedItem.data, "_blank");
	}
	function removeFile() {
		//list.removeItemAt(list.selectedIndex);
		_global.infoBox.title = "Warning..";
		_global.infoBox.content = "alert_deleteFile";
		_global.infoBox.content.mesg = "Are you sure want to delete "+newline+list.selectedItem.file;
		_global.infoBox.content.fileid = list.selectedIndex;
	}
	function onRemoveFile(i) {
		//list.removeItemAt(i);
		nc.call("deleteFile", null, i);
	}
	function loadFiles(arr:Array) {
		for (var i = 0; i<arr.length; i++) {
			var o:Object = arr[i];
			var filename = o.file.substr(o.file.indexOf("_")+1, o.file.length);
			//list.addItem({file:filename, size:o.size, path:o.path},true);
			switch (filename.substr(filename.lastIndexOf(".")+1, filename.length)) {
			case "swf" :
				var icon:String = "icon_swf";
				break;
			case "jpg" :
			case "jpeg" :
			case "gif" :
			case "bmp" :
			case "tga" :
			case "tiff" :
			case "psd" :
				var icon:String = "icon_image";
				break;
			case "doc" :
				var icon:String = "icon_doc";
				break;
			case "xls" :
				var icon:String = "icon_xls";
				break;
			case "pdf" :
				var icon:String = "icon_pdf";
				break;
			case "zip" :
			case "rar" :
				var icon:String = "icon_zip";
				break;
			case "txt" :
			default :
				var icon:String = "icon_txt";
				break;
			}
			//_global.tt(filename);
			list.addItem({label:filename+" ("+o.size+")", data:o.path, icon:icon});
		}
		if (arr.length>0) {
			bg.setTitle("Files Share Loaded");
		}
	}
	function addFile(o:Object) {
		//_global.tt("add : "+o.name);
		//list.addItem({file:o.name, size:o.size, path:o.path},true);
		nc.call("addFile", null, {file:o.name, size:o.size, path:o.path});
	}
	function onFileAdded(o:Object) {
		bg.setTitle("Files Share Updated");
		var filename = o.file.substr(o.file.indexOf("_")+1, o.file.length);
		//list.addItem({file:filename, size:o.size, path:o.path},true);
		switch (filename.substr(filename.lastIndexOf(".")+1, filename.length)) {
		case "swf" :
			var icon:String = "icon_swf";
			break;
		case "jpg" :
		case "jpeg" :
		case "gif" :
		case "bmp" :
		case "tga" :
		case "tiff" :
		case "psd" :
			var icon:String = "icon_image";
			break;
		case "doc" :
			var icon:String = "icon_doc";
			break;
		case "xls" :
			var icon:String = "icon_xls";
			break;
		case "pdf" :
			var icon:String = "icon_pdf";
			break;
		case "zip" :
		case "rar" :
			var icon:String = "icon_zip";
			break;
		case "txt" :
		default :
			var icon:String = "icon_txt";
			break;
		}
		//_global.tt(filename);
		list.addItem({label:filename+" ("+o.size+")", data:o.path, icon:icon});
	}
	function onFileDeleted(i:Number) {
		bg.setTitle("Files Share Updated");
		list.removeItemAt(i);
	}
	function onUploadOption() {
		if (upload.selectedItem.data == 1) {
			fileRef.browse([{description:"Document Files", extension:"*.doc;*.txt;*.pdf;*.chm;*.ppt;*.zip;*.rar;*.sit"}, {description:"Flash Files", extension:"*.swf"}, {description:"Image Files", extension:"*.jpg;*.gif;*.png"}, {description:"Video Files", extension:"*.avi;*.mpg"}]);
		} else if (upload.selectedItem.data == 2) {
			_global.contentBrowser.show();
		}
		// reset selected to default; 
		upload.selectedIndex = 0;
	}
	// file reference event trigger
	// event trigger
	private function onSelect(f:FileReference) {
		//_global.tt("onSelect "+f.name);
		//_global.tt(_global.host);
		f.upload(_global.host+"doprocess.php?act=upload&id="+_global.webID);
	}
	private function onOpen(f:FileReference):Void {
		_global.sharedFiles.bg.setTitle("Preparing to upload "+f.name);
		//_global.tt("onOpen "+f.name);
		//form.title.text = "Preparing for Upload "+f.name;
		//form.addBtn.enabled = false;
	}
	private function onCancel(f:FileReference):Void {
		_global.tt("onCancel");
	}
	private function onProgress(f:FileReference, bytesLoaded:Number, bytesTotal:Number):Void {
		var a = Math.floor((bytesLoaded/bytesTotal)*100)+"%";
		//_global.tt("uploading..."+a);
		_global.sharedFiles.bg.setTitle("Uploading "+f.name+"..."+a);
		//form.title.text = "Uploading..."+ Math.floor( (bytesLoaded/bytesTotal)*100 ) + "%";
	}
	private function onComplete(f:FileReference):Void {
		//_global.tt("complete uploading "+f.name);
		_global.sharedFiles.bg.setTitle("Uploading "+f.name+" complete, now share to all...");
		nc.call("getLastUploadFile", null);
		/*form.title.text = "Upload Completed";
		form.addBtn.enabled = true;
		// refresh list
		loadData(true);*/
	}
	// error triger
	private function onHTTPError(f:FileReference, httpError:Number):Void {
		_global.tt("onHTTPError "+httpError);
	}
	private function onIOError(f:FileReference):Void {
		_global.tt("onIOError: "+f.name);
	}
}
