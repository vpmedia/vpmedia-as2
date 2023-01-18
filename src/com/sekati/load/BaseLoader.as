/**
 * com.sekati.load.BaseLoader
 * @version 1.2.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.core.FWDepth;
import com.sekati.display.BaseClip;
import com.sekati.display.StageDisplay;
import com.sekati.events.FramePulse;
import com.sekati.utils.ClassUtils;
/**
 * Generic _root Preloader - stops movie, preloads, then advances to defined frame label.
 * {@code Usage: 
 * var preload:BaseLoader = new BaseLoader("finalFrameLabel");
 * }
 */
class com.sekati.load.BaseLoader extends CoreObject {
	private var _nextFrameLabel:String;
	private var _loader:MovieClip;
	private var _isLoaded:Boolean;
	private var _l:Number;
	private var _t:Number;
	private var _p:Number;
	/**
	 * BaseLoader Constructor.
	 * @param frameLabel (String) the root framelabel to advance to when preload is complete [default: "bootstrap"]
	 * @return Void
	 */
	public function BaseLoader(frameLabel:String) {
		super( );
		_nextFrameLabel = (!frameLabel) ? "bootstrap" : frameLabel;
		_isLoaded = false;
		_level0.stop( );
		_loader = ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, _root, "___BaseLoader", {_depth:FWDepth.BaseLoader} );
		FramePulse.$.addFrameListener( this );
	}
	private function _onEnterFrame():Void {
		_l = _level0.getBytesLoaded( );
		_t = _level0.getBytesTotal( );
		_p = Math.floor( _l / _t * 100 );
		if (_t > 5 && _l >= _t && StageDisplay.$.isReady) {
			_isLoaded = true;
			_level0.gotoAndStop( _nextFrameLabel );
			this.destroy( );
		}
	}
	/**
	 * Percent Loaded getter.
	 * @return Number
	 */
	public function get percent():Number {
		return _p;	
	}
	/**
	 * bytesLoaded getter.
	 * @return Number
	 */
	public function get bytesLoaded():Number {
		return _l;	
	}
	/**
	 * bytesTotal getter.
	 * @return Number
	 */
	public function get bytesTotal():Number {
		return _t;	
	}
	/**
	 * isLoaded getter.
	 * @return Boolean
	 */
	public function get isLoaded():Boolean {
		return _isLoaded;	
	}
	/**
	 * Destroy the BaseLoader.
	 * @return Void
	 */	
	public function destroy():Void {
		FramePulse.$.removeFrameListener( this );
		_loader.destroy( );
		super.destroy( );
	}
}