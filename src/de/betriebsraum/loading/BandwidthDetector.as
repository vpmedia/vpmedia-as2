/**
 * BandwidthDetector
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */ 
 
 
import mx.events.EventDispatcher;


class de.betriebsraum.loading.BandwidthDetector {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	private var target_mc:MovieClip;
	private var container_mc:MovieClip;
	private var dummy_mc:MovieClip;	
	
	private var mcl:MovieClipLoader;	
	private var startTime:Number;
	private var loadedBytes:Number;
	private var elapsedTime:Number;
	private var bwSO:SharedObject;	
	
	private var expireTime:Number;
	private var duration:Number;	
	
	// IP Packet is usually 576 bytes in size, including 40 bytes of header data: 40/576 = 0.69444 or ~7% --> 0.93	
	private static var IPPacketHeaderOverhead:Number = 0.93;


	public function BandwidthDetector(target:MovieClip) {
		
		EventDispatcher.initialize(this);
		target_mc = target;
		
	}
	
	
	/***************************************************************************
	// Private Methods
	***************************************************************************/
	private function setup():Void {
		
		container_mc = target_mc.createEmptyMovieClip("container_mc" + target_mc.getNextHighestDepth(), target_mc.getNextHighestDepth());
		dummy_mc = container_mc.createEmptyMovieClip("dummy_mc", 0);
		
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		
	}
	
	
	private function onLoadStart(target_mc:MovieClip):Void {
		
		startTime = getTimer();		
		target_mc._visible = false;
		
	}
	
	
	private function onLoadProgress(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void {
		
		this.loadedBytes = loadedBytes;
		this.elapsedTime = getTimer()-startTime;

		if (elapsedTime >= duration) onLoadComplete();
		
	}
	
	
	private function onLoadComplete(target_mc:MovieClip):Void {
		
		destroy();
		getBandwidth(loadedBytes, elapsedTime);		
		
	}
	
	
	private function onLoadError():Void {		
		onLoadComplete();		
	}
	
	
	private function getBandwidth(loadedBytes:Number, elapsedTime):Void {
		
		var elapsedSeconds:Number = elapsedTime/1000;
		var loadedKBytes:Number = loadedBytes/1024;
		var loadedKBits:Number = (loadedBytes*8)/1024;
		
		var dataObj:Object = new Object();
		dataObj.kBytesSec = Math.floor((loadedKBytes/elapsedSeconds) * IPPacketHeaderOverhead);
		dataObj.kBitsSec = Math.floor((loadedKBits/elapsedSeconds) * IPPacketHeaderOverhead);
		dataObj.fromSO = false;
		
		if (expireTime != undefined) {
			saveSO(dataObj.kBytesSec, dataObj.kBitsSec);
			dataObj.expiresIn = expireTime;
		}
		
		dispatchEvent({type:"onDetect", target:this, data:dataObj});		
		
	}
	
	
	private function useSO():Boolean {
		
		if (expireTime != undefined) {
			
			bwSO = SharedObject.getLocal("bwDetect");
			
			if (bwSO.data.kBytesSec != undefined && bwSO.data.kBitsSec != undefined) {			
				if ((Math.round(new Date().getTime()/1000) - bwSO.data.time) <= bwSO.data.expireTime) {
					return true;
				}			
			}	
			
		}
		
		return false;
		
	}
	
	
	private function saveSO(kBytesSec:Number, kBitsSec:Number):Void {
		
		bwSO.data.kBytesSec = kBytesSec;
		bwSO.data.kBitsSec = kBitsSec;
		bwSO.data.time = Math.round(new Date().getTime()/1000);
		bwSO.data.expireTime = expireTime;
		bwSO.flush();
		
	}
	
	
	/***************************************************************************
	// Public Methods
	***************************************************************************/
	public function detect(file:String, duration:Number):Void {
		
		if (useSO()) {	
		
			var dataObj:Object = new Object();
			dataObj.kBytesSec = bwSO.data.kBytesSec;
			dataObj.kBitsSec = bwSO.data.kBitsSec;
			dataObj.fromSO = true;			
			dataObj.expiresIn = (bwSO.data.time + bwSO.data.expireTime)-Math.round(new Date().getTime()/1000);

			dispatchEvent({type:"onDetect", target:this, data:dataObj});
		
		} else {		
		
			this.duration = Math.abs(Math.max(1, duration));
			setup();			
			var fileStr:String = (_url.indexOf("file") == 0) ? file : file+"?"+String(new Date().getTime());
			mcl.loadClip(fileStr, dummy_mc);
			
		}
		
	}
	
	
	public function getExpireTime():Number {
		return expireTime;
	}
	
	
	public function setExpireTime(newExpireTime:Number):Void {
		expireTime = newExpireTime;
	}
	
	
	public function destroy():Void {
		
		mcl.unloadClip(dummy_mc);
		mcl.removeListener(this);		
		container_mc.removeMovieClip();		
		
	}
	

}