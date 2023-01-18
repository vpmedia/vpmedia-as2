/**
 * com.sekati.display.StageDisplay
 * @version 1.1.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.events.Dispatcher;
import com.sekati.events.Event;
import com.sekati.events.FramePulse;
import com.sekati.geom.Point;
import com.sekati.utils.Delegate;

/**
 * StageDisplay eases Stage interfacing with added/simplified methods and properties. 
 * Note {@link _fullscreen()} requires Flash Player >=9.0.28
 */
class com.sekati.display.StageDisplay extends CoreObject {

	private static var _instance:StageDisplay;
	public static var onStageResizeEVENT:String = "onStageResize";
	public static var onStageResizeCompleteEVENT:String = "onStageResizeComplete";
	public static var onStageFullScreenEVENT:String = "onStageFullScreen";
	public static var onStageReadyEVENT:String = "onStageReady";
	private static var _resizeDelayMs:Number = 500;
	private static var _resizeIntervalId:Number;		

	/**
	 * Singleton Private Constructor
	 */
	private function StageDisplay() {
		super( );
		Stage.addListener( this );
		FramePulse.$.addFrameListener( this );
	}

	/**
	 * Singleton Accessor
	 * @return StageDisplay
	 */
	public static function getInstance():StageDisplay {
		if (!_instance) _instance = new StageDisplay( );
		return _instance;
	}

	/**
	 * Shorthand singleton accessor getter
	 * @return StageDisplay
	 */
	public static function get $():StageDisplay {
		return StageDisplay.getInstance( );	
	}

	/**
	 * Stage.onResize dispatches onStageResize event.
	 * @return Void 
	 */
	 
	public function onResize():Void {
		if (_resizeIntervalId != null) clearResizeInt( );
		_resizeIntervalId = setInterval( Delegate.create( this, onResizeComplete ), _resizeDelayMs );
		Dispatcher.$.dispatchEvent( new Event( onStageResizeEVENT, _instance, {_width:_width, _height:_height} ) );	
	}

	/**
	 * Fires when an onResize event has not been fired in the time defined by {@link _resizeDelayMs}.
	 * @return Void
	 */
	public function onResizeComplete():Void {
		trace( "@@@ onResizeComplete Fired! (" + _resizeDelayMs + "ms expired since last resize)" );
		Dispatcher.$.dispatchEvent( new Event( onStageResizeCompleteEVENT, _instance, {_width:_width, _height:_height} ) );
		clearResizeInt( );
	}	

	/**
	 * Stage.onFullScreen dispatches onStageFullscreen event.
	 * @return Void
	 */
	public function onFullScreen(bFull:Boolean):Void {
		trace( "@@@ onFullScreen Fired! (" + bFull + ")" );
		Dispatcher.$.dispatchEvent( new Event( onStageFullScreenEVENT, _instance, {isFullscreen:bFull} ) );
	}

	/**
	 * Handle resizeInterval resets
	 * @return Void
	 */
	private function clearResizeInt():Void {
		clearInterval( _resizeIntervalId );
		_resizeIntervalId = null;		
	}

	/**
	 * Listen to {@link com.sekati.events.FramePulse} and dispatch an onStageReadyEVENT once the Stage has initialized.
	 * @return Void
	 */
	private function _onEnterFrame():Void {
		if (isReady) {
			FramePulse.$.removeFrameListener( this );
			Dispatcher.$.dispatchEvent( new Event( onStageReadyEVENT, _instance, {isReady:isReady} ) );	
		}
	}	

	/**
	 * StageDisplay.isReady getter to indicate if Stage has been fully initialized.
	 * @return Boolean 
	 */
	public function get isReady():Boolean {
		return (_width > 0 && _height > 0);	
	}

	/**
	 * Stage.width getter.
	 * @return Number
	 */
	public function get _width():Number {
		return Stage.width;	
	}

	/**
	 * Stage.height getter.
	 * @return Number
	 */
	public function get _height():Number {
		return Stage.height;
	}

	/**
	 * Stage size getter.
	 * @return Point - containing right, bottom.
	 */
	public function get _size():Point {
		return new Point( _width, _height );	
	}

	/**
	 * Stage center _x getter.
	 * @return Number
	 */
	public function get _centerx():Number {
		return Math.round( _width / 2 );
	}

	/**
	 * Stage center _y getter.
	 * @return Number
	 */
	public function get _centery():Number {
		return Math.round( _height / 2 );
	}

	/**
	 * Stage center getter.
	 * @return Point
	 */
	public function get _center():Point {
		return new Point( _centerx, _centery );	
	}

	/**
	 * Stage.displayState fullscreen getter
	 * @return Boolean - true if fullscreen, false if normal.
	 */	 
	public function get _fullscreen():Boolean {
		return (Stage["displayState"] == "fullScreen") ? true : false;
	}

	/**
	 * Stage.displayState fullscreen setter - dispatches "onStageFullscreen" event.
	 * @param b (Boolean) true sets fullscreen, false sets normal.
	 */
	public function set _fullscreen(b:Boolean):Void {
		var state:String = (!b) ? "normal" : "fullScreen";
		Stage["displayState"] = state;
	}

	/**
	 * toggle Stage.displayState between "normal" and "fullScreen".
	 * @return Void
	 */
	public function toggleFullScreen():Void {	
		_fullscreen = !_fullscreen;
	}

	/**
	 * Destroy Singleton instance.
	 * @return Void
	 */
	public function destroy():Void {
		FramePulse.$.removeFrameListener( this );
		super.destroy( );
	}
}