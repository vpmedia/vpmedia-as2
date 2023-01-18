/**
 * com.sekati.ui.ScreenProtector
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.core.FWDepth;
import com.sekati.display.BaseClip;
import com.sekati.draw.Rectangle;
import com.sekati.geom.Point;
import com.sekati.utils.ClassUtils;

/**
 * Lock the Screen from UI interaction.
 * {@code Usage:
 * 	var protect:ScreenProjector = new ScreenProtector();
 * 	protect.destroy(); // enable;
 * }
 */
class com.sekati.ui.ScreenProtector extends CoreObject {

	private var _cover:MovieClip;
	private var _isLocked:Boolean;

	/**
	 * Constructor - create an invisible clip which locks the entire screen.
	 */
	public function ScreenProtector() {
		super( );
		_cover = ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, _root, "__ScreenProtector__", {_x:0, _y:0, _alpha:0, _depth:FWDepth.ScreenProtector} );
		Rectangle.draw( _cover, new Point( 0, 0 ), new Point( Stage.width, Stage.height ), 0xFF00FF, 0 );
		_cover.onPress = new Function( );
		_cover.useHandCursor = false;
		_isLocked = true;
	}

	/**
	 * Update ScreenProtector to highest depth.
	 * @return Void
	 */
	public function update():Void {
		_cover.swapDepths( _level0 );
	}

	/**
	 * isLocked getter.
	 * @return Boolean.
	 */
	public function get enabled():Boolean {
		return _isLocked;	
	}

	/**
	 * isLocked setter.
	 * @return Boolean
	 */
	public function set enabled(b:Boolean):Void {
		_isLocked = b;
		if (b) {
			update( );	
		}
	}

	/**
	 * Destroy the cover and instance.
	 * @return Void
	 */	
	public function destroy():Void {
		_cover.destroy( );
		super.destroy( );
	}
}