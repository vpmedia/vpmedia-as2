/**
 * com.sekati.time.FPS
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.events.FramePulse;

/**
 * Monitor the current applications framerate (fps).
 * {@code Usage:
 * 	var f:FPS = new FPS(Delegate.create(this,fpsUpdate), 1);
 * 	function fpsUpdate(current:Number, average:Number, currentTrend:String, averageTrend:String):Void {
 * 		tf.text = "current fps: "+currentTrend+current+" average fps: "+averageTrend+average;
 * 	}
 * }
 */
class com.sekati.time.FPS extends CoreObject {

	private var _this:FPS;
	private var _frame:Number;
	private var _currentFps:Number;
	private var _currentTrend:String;
	private var _averageFps:Number;
	private var _averageTrend:String;
	private var _now:Number;
	private var _updateEachFrame:Number;
	private var _cb:Function;

	/**
	 * FPS Constructor
	 * @param cb (Function) callback to pass (currentFps:Number, averageFps:Number, currentTrend:String, averageTrend:String)
	 * @param updateEachFrame (Number) frame ticks between cb updates
	 */
	public function FPS(cb:Function, updateEachFrame:Number) {
		super( );
		_this = this;
		_frame = 1;
		_cb = cb;
		_updateEachFrame = (updateEachFrame != null) ? updateEachFrame : 1;
		_now = getTimer( );
		FramePulse.getInstance( ).addFrameListener( _this );		
	}

	/**
	 * handle onEnterFrame Pulse
	 */
	 
	private function _onEnterFrame():Void {
		var cur:Number = Math.round( 1000 / (getTimer( ) - _now) );
		_currentTrend = (cur >= _currentFps) ? "+" : "-";
		_currentFps = cur;
		_now = getTimer( );
		var avg:Number = Math.round( (_frame / (_now / 1000)) );
		_averageTrend = (avg >= _averageFps) ? "+" : "-";	
		_averageFps = avg;
		// cb on each X frame
		if(_frame % _updateEachFrame == 0) {
			_cb( _currentFps, _averageFps, _currentTrend, _averageTrend );
		}
		_frame++;
	}

	/**
	 * Destroy the FPS Singleton instance.
	 * @return Void
	 */
	public function destroy():Void {
		FramePulse.$.removeFrameListener( _this );
		delete _this;
		super.destroy( );
	}	
}