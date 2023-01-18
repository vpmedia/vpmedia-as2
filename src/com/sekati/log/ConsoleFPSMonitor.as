/**
 * com.sekati.log.ConsoleFPSMonitor
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip;
import com.sekati.log.ConsoleStyle;
import com.sekati.time.FPS;
import com.sekati.utils.Delegate;

/**
 * Console FPSMonitor UI
 * {@code Usage:
 * var fpsMonitor:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.log.ConsoleFPSMonitor, this, "consoleFPSMonitor", {_x:750, _y:0});
 * }
 * @see {@link com.sekati.log.Console}
 */
class com.sekati.log.ConsoleFPSMonitor extends BaseClip {

	private var _fps:FPS;
	private var _cs:ConsoleStyle;
	private var _style:Object;	
	private var _bg:MovieClip;
	private var _currentLabel:TextField;
	private var _averageLabel:TextField;
	private var _currentFps:TextField;
	private var _averageFps:TextField;

	/**
	 * ConsoleFPSMonitor Constructor.
	 */
	public function ConsoleFPSMonitor() {	
		//trace("ConsoleFPSMonitor: "+_this._name+".__RUID = "+_this.__RUID+";");
		_cs = ConsoleStyle.getInstance( );
		_style = _cs.CSS.console.head.fps;
		
		// draw the bg for toClipboard presses
		_bg = _cs.createStyledRectangle( _this, _style.bg );
		
		// text - createStyledTextField (target:MovieClip, layout:Object, color:Object, str:String)
		_currentLabel = _cs.createStyledTextField( _this, _style.textfields.current_label );
		_averageLabel = _cs.createStyledTextField( _this, _style.textfields.average_label );
		_currentFps = _cs.createStyledTextField( _this, _style.textfields.current_fps );
		_averageFps = _cs.createStyledTextField( _this, _style.textfields.average_fps );
	
		// start monitoring	
		_fps = new FPS( Delegate.create( _this, updateFPS ), _style.updateRate );

		/*
		// events
		_bg.onPress = Delegate.create(_this, toClipboard);
		_bg.useHandCursor = false;
		 */
	}

	/**
	 * Update the FPS textfields.
	 * @param current (Number) the current swf's FPS
	 * @param average (Number) the average swf's FPS since inception
	 * @param currentTrend (String) direction is the current fps trending: "+"|"-" 
	 * @param averageTrend (String) direction is the average fps trending: "+"|"-" 
	 */
	private function updateFPS(current:Number, average:Number, currentTrend:String, averageTrend:String):Void {
		var cc:Number = (currentTrend == "+") ? _style.textfields.trend_colors.up : _style.textfields.trend_colors.down;
		var ac:Number = (averageTrend == "+") ? _style.textfields.trend_colors.up : _style.textfields.trend_colors.down;
		_currentFps.htmlText = "<font color='" + cc + "'>" + currentTrend + current + "</font>";
		_averageFps.htmlText = "<font color='" + ac + "'>" + averageTrend + average + "</font>";
	}	

	/**
	 * Copy FPS string data to clipboard.
	 * @return Void
	 */
	public function toClipboard():Void {
		System.setClipboard( toString( ) );
	}

	/**
	 * Return FPS string data
	 * @return String
	 */
	public function toString():String {
		var tab:String = "\t";
		var str:String = "FPS:" + tab + _currentLabel.text + ": " + _currentFps.text + tab + _averageLabel.text + ": " + _averageFps.text;	
		return str;
	}

	/**
	 * calls superclasses BaseClip.destroy and executes its own destroy behaviors.
	 * @return Void
	 */
	public function destroy():Void {
		_fps.destroy( );
		super.destroy( );
	}	
}