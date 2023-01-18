/**
 * com.sekati.draw.Tile
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import flash.display.BitmapData;

/**
 * Tiles a bitmap as wallpaper
 */
class com.sekati.draw.Tile {

	/**
	 * create a tiled bitmap wallpaper
	 * @param bitmap (String) export from library
	 * @param target (MovieClip) clip to tile inside
	 * @param w (Number) optional width to be tiled
	 * @param h (Number) optional height to be tiled
	 * @return Void
	 * {@code Usage:
	 * 	Tile.create(_level0, "bg_img", Stage.width, Stage.height);
	 * }
	 */
	public static function create(bitmap:String, target:MovieClip, w:Number, h:Number):Void {
		var pattern:BitmapData = BitmapData.loadBitmap( bitmap );
		w = (!w) ? target._width : w;
		h = (!h) ? target._height : h;
		with (target) {
			begineBitmapFill( pattern );
			moveTo( 0, 0 );
			lineTo( w, 0 );
			lineTo( w, h );
			lineTo( 0, h );
			lineTo( 0, 0 );
			endFill( );				
		}
	}

	private function Tile() {
	}
}