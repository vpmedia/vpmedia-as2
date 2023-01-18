/**
 * FileQueue
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */


import mx.events.EventDispatcher;
import flash.net.FileReference;

import mx.utils.Delegate;


class de.betriebsraum.cms.filebrowser.FileQueue extends Array {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	
	
	private var loaded:Array;
	private var totalItems:Number;
	private var item:Object;
	private var mode:String;
	private var intervalID:Number;	
	
	private static var _UPLOAD:String = "upload";
	private static var _DOWNLOAD:String = "download";	
	private var _isLoading:Boolean;
	private var _isPaused:Boolean;
	
	
	public function FileQueue() {
		
		init();
				
	}	

	

	private function init():Void {	
	
		EventDispatcher.initialize(this);
		clear();
		
	}
	
	
	private function onOpen(file:FileReference):Void {
		dispatchEvent({type:"onItemStart", target:this, file:file, mode:mode});
	}
	
	
	private function onProgress(file:FileReference, loadedBytes:Number, totalBytes:Number):Void {
				
		var pInfo:Object = new Object();
		
		pInfo.percentLoaded = isNaN(Math.round(loadedBytes/totalBytes * 100)) ? 0 : Math.round(loadedBytes/totalBytes * 100);
		pInfo.bytesLoaded = loadedBytes;
		pInfo.bytesTotal = isNaN(totalBytes) ? 0 : totalBytes;
		pInfo.kBytesLoaded = loadedBytes/1024;
		pInfo.kBytesTotal = isNaN(totalBytes/1024) ? 0 : totalBytes/1024;
		pInfo.kBytesRemaining = pInfo.kBytesTotal-pInfo.kBytesLoaded;
		pInfo.kBytesSec = pInfo.kBytesLoaded/(getTimer()/1000);
		pInfo.secondsRemaining = isNaN(Math.round(pInfo.kBytesRemaining/pInfo.kBytesSec)) ? 0 : Math.round(pInfo.kBytesRemaining/pInfo.kBytesSec);
		
		pInfo.overallPercent = Math.round((loaded.length/totalItems)*100 + (pInfo.percentLoaded/100) * (100/totalItems));
		pInfo.loadedItems = (pInfo.overallPercent >= 100) ? totalItems : loaded.length;
		pInfo.totalItems = totalItems;
		
		dispatchEvent({type:"onItemProgress", target:this, progress:pInfo, file:file, mode:mode});
		dispatchEvent({type:"onQueueProgress", target:this, progress:{overallPercent:pInfo.overallPercent, loadedItems:pInfo.loadedItems, totalItems:totalItems}, file:file, mode:mode});
		
	}
	
	
	private function onComplete(file:FileReference):Void {
		
		dispatchEvent({type:"onItemComplete", target:this, file:file, mode:mode});
		loaded.push(file);
		file.removeListener(this);
		loadNext();
		
	}
	
	
	private function onCancel(file:FileReference):Void {
		
		totalItems--;
		dispatchEvent({type:"onItemCancel", target:this, file:file, mode:mode});
		file.removeListener(this);
		intervalID = setInterval(Delegate.create(this, resumeAfterCancel), 100);		
			
	}
	
	
	private function resumeAfterCancel():Void {
		
		clearInterval(intervalID);
		loadNext();
		
	}
	
	
	private function onHTTPError(file:FileReference):Void {

		totalItems--;
		dispatchEvent({type:"onItemError", target:this, file:file, mode:mode});
		file.removeListener(this);
		loadNext();
		
	}
	
	
	private function onIOError(file:FileReference):Void {
		onHTTPError(file);		
	}
	
	
	private function onSecurityError(file:FileReference):Void {
		onHTTPError(file);
	}
	
	
	private function loadNext():Void {
		
		if (isPaused) return;
		
		item = this.shift();
		
		if (item) {			
					
			if (mode == UPLOAD) {
				item.file.addListener(this);
				item.file.upload(item.url);
			} else if (mode == DOWNLOAD) {
				var file:FileReference = new FileReference();
				item.file = file;
				item.file.addListener(this);
				item.file.download(item.url, item.name);
			}
			
		} else {
			
			_isLoading = false;
			dispatchEvent({type:"onQueueComplete", target:this, loadedItems:loaded});
						
		}
		 
	}
	
	
	private function setPaused(mode:Boolean):Void {
		
		_isPaused = mode;
		_isLoading = !mode;
		
	}
	
	
	/***************************************************************************
	// Public Methods
	***************************************************************************/	
	public function execute(mode:String):Void {
		
		this.mode = mode;
		totalItems = this.length;		
		dispatchEvent({type:"onQueueStart", target:this, mode:mode});
		loadNext();	
		setPaused(false);
		
	}
	
	
	public function pause():Void {
				
		item.file.cancel();
		setPaused(true);
		
	}
	
	
	public function resume():Void {		
		
		this.unshift(item.file);
		loadNext();
		setPaused(false);
		
	}
	
	
	public function clear():Void {
		
		if (item) item.file.cancel();
		_isPaused = false;
		_isLoading = false;
		
		var l:Number = this.length;
		for (var i:Number=0; i<l; i++) {
			this.shift();
		}
		
		loaded = new Array();
		
	}
	
	
	/***************************************************************************
	// Getter/Setter
	***************************************************************************/
	public static function get UPLOAD():String {
		return _UPLOAD;
	}	
	
	public static function get DOWNLOAD():String {
		return _DOWNLOAD;
	}
	
	
	public function get isLoading():Boolean {
		return _isLoading;
	}	
	
	public function get isPaused():Boolean {
		return _isPaused;
	}
		
	
}