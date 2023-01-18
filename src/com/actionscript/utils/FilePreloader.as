//this file has been updated to support EventHandling since
//the original ActionScript.com article was written.

import mx.utils.Delegate;
import mx.events.EventDispatcher;
class com.actionscript.utils.FilePreloader {
	
	private var _loadArray:Array;
	private var _fileArray:Array;
	private var _currentLoad:String;
	private var _lv:LoadVars;
	
	public function dispatchEvent() {};
	public function addEventListener() {};
	public function removeEventListener() {};
	public function dispatchQueue() {};
	
	function FilePreloader() {
		mx.events.EventDispatcher.initialize(this);
		init();
	}
	
	public function init() {
		_fileArray = [];
		_loadArray = [];
		_lv = new LoadVars();
		_lv.onLoad = Delegate.create(this, onLoadHandler);
	}
	public function preload(a:Array):Void {
		_loadArray = a;
		loadNextItem();
	}
	
	public function get loadedItems():Array {
		return _fileArray.slice(0);
	}
	public function get currentLoadProgress():Number {
		return _lv.getBytesLoaded() / _lv.getBytesTotal();
	}
	public function get currentLoad():Number {
		return _fileArray.length;
	}
		
	private function loadNextItem():Void {
		_currentLoad = String(_loadArray.shift());
		_lv.load(_currentLoad);
	}
	private function onLoadHandler(success:String) {
		dispatchEvent({type:"load", target:this, success:success});
		if(success) {
			_fileArray.push(_currentLoad);
		}
		if(_loadArray.length) {
			loadNextItem();
		}
	}
}