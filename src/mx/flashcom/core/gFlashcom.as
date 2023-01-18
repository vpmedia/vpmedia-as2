import mx.events.EventDispatcher;
class mx.flashcom.core.gFlashcom{
	function gFlashcom(){
		if(_global.gFlashcom == null){
			_global.gFlashcom = new Object();
			EventDispatcher.initialize(_global.gFlashcom);
			_global.gFlashcom.localClient = new Object();
		}
	}
	public function dispatchEvent(){
		dispatchEvent.apply(_global.gFlashcom,arguments);
	}
	public function setProperty(prop,value){
		_global.gFlashcom[prop] = value;
	}
}