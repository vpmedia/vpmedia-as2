/**
 * FileBrowser
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */
 

import de.betriebsraum.gui.*;
import de.betriebsraum.cms.filebrowser.*;
import de.betriebsraum.remoting.RemotingHandler;

import mx.controls.*;
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import flash.net.FileReferenceList;
import flash.net.FileReference;


class de.betriebsraum.cms.filebrowser.FileBrowser {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	
		
	private var container_mc:MovieClip;
	private var fb_mc:MovieClip;	
	private var uploadCombo:ComboBox;
	private var browseCombo:ComboBox;
	private var uploadList:List;
	private var browseList:List;
	private var refreshCheck:CheckBox;	
	private var thumbCheck:CheckBox;
	private var thumbDetails_mc:MovieClip;
	private var preview_mc:MovieClip;
	private var initID:Number;	
		
	private var config:Config;
	private var rh:RemotingHandler;
	private var statusBox:StatusBox;
	private var mcl:MovieClipLoader;	
	private var fileRef:FileReferenceList;
	private var fileQueue:FileQueue;
	
	
	public function FileBrowser(target:MovieClip, depth:Number, x:Number, y:Number) {
		
		container_mc = target.createEmptyMovieClip("container_mc"+depth, depth);
		container_mc._x = x;
		container_mc._y = y;
		
		createChildren();
		
		initID = setInterval(Delegate.create(this, checkInit), 10);
		EventDispatcher.initialize(this);
		
	}
	
	
	private function createChildren():Void {		
		
		fb_mc = container_mc.attachMovie("mc_fileBrowser", "fileBrowser_mc", 0);
		uploadCombo = fb_mc.uploadCombo;
		browseCombo = fb_mc.browseCombo;		
		uploadList = fb_mc.uploadList;
		browseList = fb_mc.browseList;	
		thumbDetails_mc = fb_mc.thumbDetails_mc;
		preview_mc = fb_mc.preview_mc;		
		refreshCheck = fb_mc.refreshCheck;
		thumbCheck = fb_mc.thumbCheck;
		
		fb_mc.ok_mc._visible = false;
		fb_mc.cancel_mc._visible = false;
		
	}
	
	
	/***************************************************************************
	// Init
	***************************************************************************/
	private function checkInit():Void {		
		if (uploadCombo.addItem != undefined) init();	
	}	
	
	
	private function init():Void {
		
		clearInterval(initID);		
		config = Config.getInstance();	
	
		initAssets();
		initStatusBox();
		initRemotingHandler();
		initFileStuff();				
		initTooltips();	
		initPreview();
		
		onThumbCheckClick();
		
		statusBox.create(config.loadTitle, config.loadMessage, ["load"]);
		rh.call("getFolders", [config.uploadDir]);				
		
	}
	
	
	private function initAssets():Void {
		
		uploadList.multipleSelection = true;
		uploadList.iconFunction = function(item:Object) { return "fileIcon"+FileReference(item.data).type; };
		
		browseCombo.addEventListener("change", Delegate.create(this, onBrowseComboChange));
		browseCombo.addEventListener("close", Delegate.create(this, onBrowseComboClose));
		
		browseList.multipleSelection = true;
		browseList.iconFunction = function(item:Object) { return "fileIcon"+item.substr(item.lastIndexOf("."), item.length); };
		browseList.addEventListener("change", Delegate.create(this, onBrowseListChange));
		
		thumbCheck.addEventListener("click", Delegate.create(this, onThumbCheckClick));	
		thumbDetails_mc.presetsCombo.addEventListener("change", Delegate.create(this, onThumbPresetsChange));
		thumbDetails_mc.size_txt.restrict = "0-9";		
		thumbDetails_mc.size_txt.maxChars = 4;			
		
		fb_mc.browse_mc.onRelease = Delegate.create(this, onBrowseClick);		
		fb_mc.remove_mc.onRelease = Delegate.create(this, onRemoveClick);
		fb_mc.upload_mc.onRelease = Delegate.create(this, onUploadClick);
		fb_mc.refresh_mc.onRelease = Delegate.create(this, onRefreshClick);
		fb_mc.download_mc.onRelease = Delegate.create(this, onDownloadClick);
		fb_mc.delete_mc.onRelease = Delegate.create(this, onDeleteClick);
		fb_mc.view_mc.onRelease = Delegate.create(this, onViewClick);
		fb_mc.nonused_mc.onRelease = Delegate.create(this, onNonusedClick);
		fb_mc.ok_mc.onRelease = Delegate.create(this, onOkClick);
		fb_mc.cancel_mc.onRelease = Delegate.create(this, onCancelClick);		
		
	}
	
	
	private function initStatusBox():Void {
		
		statusBox = new StatusBox("mc_statusBox", container_mc, 1000, 0, -10);
		statusBox.setModalProps(0xFFFFFF, 50);
		statusBox.setFadingProps(0, 100, 0.5, "modal");
		statusBox.setButtonProps(config.okLabel, config.cancelLabel, "center", 10, 5);
		
	}
	
	
	private function initRemotingHandler():Void {

		rh = new RemotingHandler(config.gatewayUrl, "FileBrowser");
		
		rh.addEventListener("onGetFolders", Delegate.create(this, onGetFolders));
		rh.addEventListener("onGetFiles", Delegate.create(this, onGetFiles));
		rh.addEventListener("onDeleteFiles", Delegate.create(this, onDeleteFiles));	
		rh.addEventListener("onGetNonusedFiles", Delegate.create(this, onGetNonusedFiles));	
		
	}
	
	
	private function initFileStuff():Void {
		
		fileRef = new FileReferenceList();
		fileRef.addListener(this);	
		
		fileQueue = new FileQueue();
		fileQueue.addEventListener("onQueueStart", Delegate.create(this, onQueueStart));
		fileQueue.addEventListener("onItemProgress", Delegate.create(this, onItemProgress));
		fileQueue.addEventListener("onItemComplete", Delegate.create(this, onItemComplete));
		fileQueue.addEventListener("onQueueComplete", Delegate.create(this, onQueueComplete));
		
	}
	
	
	private function initTooltips():Void {
		
		var tt:TooltipManager = TooltipManager.getInstance();
		tt.init(fb_mc, 0);
		
		tt.addTip(fb_mc.browse_mc, config.browseTip);
		tt.addTip(fb_mc.remove_mc, config.removeTip);
		tt.addTip(fb_mc.refresh_mc, config.refreshTip);
		tt.addTip(fb_mc.download_mc, config.downloadTip);
		tt.addTip(fb_mc.nonused_mc, config.nonusedTip);
		tt.addTip(fb_mc.delete_mc, config.deleteTip);
		tt.addTip(fb_mc.upload_mc, config.uploadTip);
		tt.addTip(fb_mc.view_mc, config.viewTip);
		
	}
	
	
	private function initPreview():Void {
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);	
		
		showPreloader(false);	
				
	}
	
	
	/***************************************************************************
	// StatusBox
	***************************************************************************/
	private function onServiceCall():Void {
		statusBox.create(config.loadTitle, config.loadMessage, ["load"]);		
	}
	
	private function onServiceResult():Void {
		statusBox.destroy();		
	}
	
	
	private function onServiceFault():Void {
		statusBox.create(config.errorTitle, config.errorMessage, ["ok"]);		
	}
	
	
	/***************************************************************************
	// Actions
	***************************************************************************/
	private function onGetFolders(evObj:Object):Void {
		
		uploadCombo.dataProvider = evObj.result;
		browseCombo.dataProvider = evObj.result;		
			
		onRefreshClick();
		
		rh.addEventListener("onServiceCall", Delegate.create(this, onServiceCall));
		rh.addEventListener("onServiceResult", Delegate.create(this, onServiceResult));	
		rh.addEventListener("onServiceFault", Delegate.create(this, onServiceFault));
		
	}
	
	
	private function onBrowseComboChange():Void {
		
	}
	
	
	private function onBrowseComboClose():Void {
		rh.call("getFiles", [config.uploadDir+selectedFolder]);
	}
	
	
	private function onGetFiles(evObj:Object):Void {
		browseList.dataProvider = evObj.result;
	}
	
	
	private function onBrowseListChange():Void {
		if (refreshCheck.selected) onViewClick();	
	}
	
	
	private function onRefreshClick():Void {
		onBrowseComboClose();
	}
	
	
	public function onDeleteClick(userIDs:Array):Void {
		
		if (selectedFiles == null || selectedFiles.length == 0) {
			statusBox.create(config.infoTitle, config.noFilesSelectedMessage, ["ok"]);
			return;
		}
		
		statusBox.autoDestroy = false;		
		statusBox.create(config.confirmDeleteTitle, config.confirmDeleteMessage, ["ok", "cancel"]);
		statusBox.setOkHandler(deleteOk, this);		
		
	}
	
	
	private function deleteOk():Void {

		statusBox.autoDestroy = true;		
		rh.call("deleteFiles", [config.uploadDir+selectedFolder+"/", selectedFiles]);
		
	}
	
	
	private function onDeleteFiles(evObj:Object):Void {
		
		onRefreshClick();	
		onViewClick();
		preview_mc.info_txt.text = "";
			
	}
	
	
	private function onNonusedClick():Void {		
		rh.call("getNonusedFiles", [config.uploadDir, selectedFolder]);		
	}
	
	
	private function onGetNonusedFiles(evObj:Object):Void {
		
		var selectedIndices:Array = new Array();
		
		for (var i:Number=0; i<browseList.length; i++) {
			for (var j:Number=0; j<evObj.result.length; j++) {
				if (selectedFolder+"/"+browseList.getItemAt(i) == evObj.result[j]) {
					selectedIndices.push(i);
				}				
			}			
		}
		
		if (selectedIndices.length == 0) {
			statusBox.create(config.infoTitle, config.nonusedFilesMessage, ["ok"]); 
		} else {		
			browseList.selectedIndices = selectedIndices;
		}
		
	}	
	
	
	private function onOkClick():Void {
		dispatchEvent({type:"onOkClick", target:this, folder:selectedFolder, file:selectedFile});	
	}
	
	
	private function onCancelClick():Void {
		dispatchEvent({type:"onCancelClick", target:this});	
	}
	
	
	/***************************************************************************
	// Thumbnails
	***************************************************************************/
	private function onThumbCheckClick():Void {
		thumbDetails_mc._visible = thumbCheck.selected;	
	}
	
	
	private function onThumbPresetsChange():Void {
		
		var selectedData:Array = thumbDetails_mc.presetsCombo.selectedItem.data.split("|");
		thumbDetails_mc.thumbGroup.selection = thumbDetails_mc[selectedData[0]];
		thumbDetails_mc.size_txt.text = selectedData[1] ? selectedData[1] : "";		
		
	}
	
	
	/***************************************************************************
	// Preview
	***************************************************************************/
	private function onViewClick():Void {
	
		var file:String = selectedFile;
		var extension:String = file.substr(file.lastIndexOf("."), file.length);
		
		if (extension == ".jpg" || extension == ".jpeg" || extension == ".gif" || extension == ".png" || extension == ".swf") {
			mcl.loadClip(config.viewDir+selectedFolder+"/"+file, preview_mc.holder_mc);
		}	
		
	}
	
	
	private function onLoadStart():Void {
		
		preview_mc.holder_mc._x = 1;
		preview_mc.holder_mc._y = 1;		
		preview_mc.holder_mc._visible = false;
		
		showPreloader(true);
		
		preview_mc.info_txt.text = "";
		
	}
	
	
	private function onLoadProgress(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void {
		preview_mc.preloader_mc.bar_mc._xscale = Math.round((loadedBytes/totalBytes) * 100);		
	}		
	
	
	private function onLoadInit():Void {
						
		var rect:Rectangle = new Rectangle(preview_mc, 0, 1, 1);
		preview_mc.holder_mc.setMask(rect.draw(preview_mc.bg_mc._width-2, preview_mc.bg_mc._height-2, {alpha:0}));
		preview_mc.holder_mc._visible = true;
		
		var dragable:Dragable = new Dragable(false, preview_mc.holder_mc, null, preview_mc.bg_mc);
		
		preview_mc.info_txt.text = String(preview_mc.holder_mc._width)+"x"+String(preview_mc.holder_mc._height);	
	
	}
	
	
	private function showPreloader(mode:Boolean):Void {
		preview_mc.preloader_mc._visible = mode;	
	}
	
	
	/***************************************************************************
	// FileReference
	***************************************************************************/	
	private function onBrowseClick():Void {		
		if(!fileRef.browse(config.fileTypes)) statusBox.create(config.errorTitle, config.browseFilesErrorMessage, ["ok"]);
	}
	
	
	private function onSelect(fileRef:FileReferenceList):Void {
		
		for (var i:Number=0; i<fileRef.fileList.length; i++) {			
			var file:FileReference = FileReference(fileRef.fileList[i]);
			uploadList.addItem({label:file.name+", "+file.size+" Bytes (~"+Math.round(file.size/1024)+" Kb)", data:file});			
		}
		
		if (removeDuplicateFiles() || removeForbiddenTypes()) {
			statusBox.create(config.infoTitle, config.cleanUpFilesMessage, ["ok"]);			
		}
	    
	}
	
	
	private function removeDuplicateFiles():Boolean {
		
		var removed:Boolean = false;	
		
		for (var i:Number=0; i<uploadList.dataProvider.length; i++) {	
					
			for (var j:Number=0; j<uploadList.dataProvider.length; j++) {
				if ((uploadList.dataProvider[i].data.name == uploadList.dataProvider[j].data.name) && (i !== j)) {
					uploadList.removeItemAt(i);	
					removed = true;	
				}		
			}
			
		}
		
		return removed;	
		
	}
	
	
	private function removeForbiddenTypes():Boolean {
		
		var allTypesStr:String = config.fileTypes[0].extension+";"+config.fileTypes[0].macType;
		var allTypesArr:Array = allTypesStr.split(";");
				
		var removed:Boolean = false;
		
		for (var i:Number=0; i<uploadList.dataProvider.length; i++) {
			
			var found:Boolean = false;	
				
			for (var j:Number=0; j<allTypesArr.length;j++) {			
				var type:String = (allTypesArr[j].substr(0, 1) == "*") ? allTypesArr[j].substr(1, allTypesArr[j].length) : allTypesArr[j];					
				if (uploadList.dataProvider[i].data.type == type) found = true;				
			}	
			
			if (!found) {
				uploadList.removeItemAt(i);	
				removed = true;
			}
			
		}		
	
		return removed;
	
	}
	
	
	private function onRemoveClick():Void {
		
		if (uploadList.selectedItems == null || uploadList.selectedItems.length == 0) {
			statusBox.create(config.infoTitle, config.noFilesSelectedMessage, ["ok"]);
			return;
		}
			
		for (var i:String in uploadList.selectedIndices) {
			uploadList.removeItemAt(uploadList.selectedIndices[i]);	
		}
		
					
	}
	
	
	private function onUploadClick():Void {
		
		if (uploadList.length == 0) {
			statusBox.create(config.infoTitle, config.noFilesAddedMessage, ["ok"]);
			return;
		}
		
		if (thumbCheck.selected && thumbDetails_mc.size_txt.text == "") {
			statusBox.create(config.infoTitle, config.noThumbSizeSetMessage, ["ok"]);
			return;			
		}	
		
		fileQueue.clear();		
		
		var thumbVars:String = "";
		if (thumbCheck.selected) thumbVars += "&"+thumbDetails_mc.thumbGroup.selection._name+"="+Number(thumbDetails_mc.size_txt.text);
		var getParams:String = "?dir="+config.uploadDir+uploadCombo.value+"/"+thumbVars;
		
		for (var i:Number=0; i<uploadList.dataProvider.length; i++) {		
			fileQueue.push({file:FileReference(uploadList.dataProvider[i].data), url:config.uploadScript+getParams});
		}
		
		fileQueue.execute(FileQueue.UPLOAD);
		
	}
	
	
	private function onDownloadClick():Void {
		
		if (selectedFiles == null || selectedFiles.length == 0) {
			statusBox.create(config.infoTitle, config.noFilesSelectedMessage, ["ok"]);
			return;
		}
		
		fileQueue.clear();
		
		for (var i:Number=0; i<selectedFiles.length; i++) {		
			fileQueue.push({url:config.downloadDir+selectedFolder+"/"+selectedFiles[i], name:selectedFiles[i]});
		}
		
		fileQueue.execute(FileQueue.DOWNLOAD);
	
	}
	
	
	private function cancelLoading():Void {
		fileQueue.clear();	
	}
	
		
	/***************************************************************************
	// FileQueue events
	***************************************************************************/
	private function onQueueStart(evObj:Object):Void {
		
		if (evObj.mode == FileQueue.UPLOAD) {
			statusBox.create(config.uploadTitle, config.waitForUpload, ["cancel"]);
		} else if (evObj.mode == FileQueue.DOWNLOAD) {
			statusBox.create(config.downloadTitle, config.waitForDownload, ["cancel"]);
		}
		
		statusBox.setCancelHandler(cancelLoading, this);
		statusBox.setCloseHandler(cancelLoading, this);
			
	}
	

	private function onItemProgress(evObj:Object):Void {
				
		var fileName:String = (evObj.file.name.length > 10) ? evObj.file.name.substr(0, 10)+"..." : evObj.file.name;
		statusBox.message = fileName+" ("+String(evObj.progress.percentLoaded)+" %)\n"+config.totalPercentLabel+evObj.progress.overallPercent+" %";
	    	    
	}
	
	
	private function onItemComplete(evObj:Object):Void {
		
		for (var i:Number=0; i<uploadList.dataProvider.length; i++) {	
			if (uploadList.dataProvider[i].data == evObj.file) uploadList.removeItemAt(i);
		}
		
		uploadList.vPosition = uploadList.maxVPosition;
		
	}
	
	
	private function onQueueComplete(evObj:Object):Void {
						
		statusBox.destroy();
		browseCombo.selectedIndex = uploadCombo.selectedIndex;	
		onRefreshClick();
					
	}
	
	
	/***************************************************************************
	// Public methods
	***************************************************************************/
	public function showButtons(mode:Boolean):Void {
		
		fb_mc.ok_mc._visible = mode;
		fb_mc.cancel_mc._visible = mode;	
		
	}
	
	
	public function destroy():Void {
		
		mcl.removeListener(this);
		container_mc.removeMivieClip();
		
	}
	
	
	public function move(newX:Number, newY:Number):Void {
		
		container_mc._x = newX;
		container_mc._y = newY;
		
	}
	
	
	/***************************************************************************
	// Getter/Setter
	***************************************************************************/
	public function get visible():Boolean {
		return container_mc._visible;	
	}	
	
	public function set visible(mode:Boolean):Void {
		container_mc._visible = mode;	
	}
	
	
	public function get selectedFolder():Object {
		return browseCombo.value;	
	}	

	
	public function get selectedFile():String {
		return browseList.selectedItem;	
	}
	
	
	public function get selectedFiles():Array {
		return browseList.selectedItems;	
	}
			
	
}