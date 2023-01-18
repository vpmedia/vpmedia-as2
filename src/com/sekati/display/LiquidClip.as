	/**
 * com.sekati.display.LiquidClip
 * @version 1.0.9
 * @author jason m horwitz | sekati.com | tendercreative.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
 import com.sekati.display.ILiquidClip;
 import com.sekati.display.UIClip;
 import com.sekati.display.StageDisplay;
 import com.sekati.events.Dispatcher;
 import com.sekati.utils.Delegate;

/**
 * LiquidClip - mixin for any subclass which needs to respond to {@link com.sekati.display.StageDisplay} 
 * events such as onResize, onResizeComplete or onFullScreen. 
 * Note: Extends {@link com.sekati.display.UIClip} to allow for easy/automatic TextField CSS styling.
 */
class com.sekati.display.LiquidClip extends UIClip implements ILiquidClip {

	/**
	 * Constructor
	 */
	public function LiquidClip() {
		super();
		Dispatcher.$.addEventListener(StageDisplay.onStageResizeEVENT, Delegate.create (_this, _onResize));
		Dispatcher.$.addEventListener(StageDisplay.onStageResizeCompleteEVENT, Delegate.create (_this, _onResizeComplete));
		Dispatcher.$.addEventListener(StageDisplay.onStageFullScreenEVENT, Delegate.create (_this, _onFullScreen));
		_onResize();
		_onResizeComplete();
	}

	/**
	 * Clip has been loaded and registered on Stage.
	 * @return Void
	 */
	public function configUI():Void {
		super.configUI();
		_onResize();
		_onResizeComplete();
	}
	
	/**
	 * Application has been Configured (Config & Data loaded).
	 * NOTE: Automatically applies the application stylesheet to all TextField Objects!
	 * @return Void
	 */
	public function onAppConfigured():Void {
		super.onAppConfigured();
		_onResize();
		_onResizeComplete();		
	}
	
	/**
	 * _onFullscreen stub: fires when Stage resize has occurs.
	 * @return Void
	 */
	public function _onResize():Void {
		//App.log.info(_this, StageDisplay.onStageFullScreenEVENT+" Fired!");
	}
	
	/**
	 * _onResizeComplete stub: fires {@link com.sekati.display.StageDisplay._resizeDelayMs} milliseconds after a Stage resize has occured.
	 * @return Void
	 */	
	public function _onResizeComplete():Void {
		//App.log.info(_this, StageDisplay.onStageResizeCompleteEVENT+" Fired!");
	}
	
	public function _onFullScreen():Void {
		_onResize();
		//App.log.info(_this, StageDisplay.onStageResizeCompleteEVENT+" Fired!");
	}
	
	/**
	 * Remove Dispatcher listeners onUnload.
	 * @return Void
	 */
	public function onUnload():Void {
		Dispatcher.$.removeEventListener(StageDisplay.onStageResizeEVENT, _this);	
		Dispatcher.$.removeEventListener(StageDisplay.onStageResizeCompleteEVENT, _this);
		Dispatcher.$.removeEventListener(StageDisplay.onStageFullScreenEVENT, _this);
		super.onUnload();
	}	
	
}