/**
 * VideoControAsset View Element controlled by 
 * StreamingVideoModel
 * 
 * Provides an UI-Element with playercontrols
 * 
 * @author tPS
 * @version 1
 */
 
import com.tPS.ui.GenericLibraryElement;
import com.tPS.event.Delegate;
import com.tPS.tween.Thread;
 
class com.tPS.ui.video.VideoControlAsset extends GenericLibraryElement {
	
	private var _stream:NetStream;
	
	private var duration:Number;
	
	
	
	function VideoControlAsset($rt : MovieClip) {
		super($rt);
		setup();
	}
	
	private function setup() : Void {
		Thread.initialize();
	}
	
	
	private function init() : Void {
	};
	
	
	/**
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 */
	private function reset() : Void {
		trace(this + " ---> reset UI");
		duration = undefined;
		Thread.endThread(this);
	}
	
	private function update() : Void {
		var t:Number = _stream.time;
		var pos:Number;
		
		if(duration)
			pos = t/duration;
			
		var lp:Number = _stream.bytesLoaded/_stream.bytesTotal;
	}
	
	/**
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 */
	
	/*
	 * Invoked by stream initialization from StreamingVideoModel
	 */
	public function onStreamInit( $stream:NetStream ) : Void {
		reset();
		_stream = $stream;
		
		Thread.beginThread(this);
	}
	
	private function onTogglePlay( toPlay:Boolean ) : Void {
		
	}
	
	public function onMetaData( md:Object ) : Void {
		duration = Number(md.duration);
	}
	
	
	public function toString() : String {
		return "[VideoControlAsset]";
	}

}