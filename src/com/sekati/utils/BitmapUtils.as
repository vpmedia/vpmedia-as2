/**
 * com.sekati.utils.BitmapUtils
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import flash.display.BitmapData;
import flash.geom.Matrix;

/**
 * Static class wrapping variousBitmap utilities.
 */
class com.sekati.utils.BitmapUtils {

	/**
	 * copy object to bitmapData object
	 * @param src (MovieClip)
	 * @param target (MovieClip)
	 * @param deleteSource (Boolean)	
	 * @param cacheAsBitmap (Boolean)	
	 * @return Void
	 * {@code Usage: 
	 * BitmapUtils.copy(img, imgCopy, false, true); //copy to a new movieclip
	 * BitmapUtils.copy(img, img, false, true);  //overwrites itself
	 * }
	 */
	public static function copy(src:MovieClip, target:MovieClip, deleteSource:Boolean, cacheAsBitmap:Boolean):Void {
		var bdo:BitmapData = new BitmapData( src._width, src._height, true, 0 );
		target.attachBitmap( bdo, target.getNextHighestDepth( ), "auto", true );
		bdo.draw( src );
		if (deleteSource) {
			src.removeMovieClip( );
		}
		if (cacheAsBitmap) {
			target.cacheAsBitmap = true;
		}
	}

	/**
	 * returns an array of pixel data from bitmap data object to post/store for later use
	 * @param src (Object)
	 * @param scale (Number)
	 * @return Array
	 */	
	public static function getPixelData(src:Object, scale:Number):Array {
		var pixels:Array = new Array( );
		var bitmap:BitmapData = new BitmapData( src._width, src._height );
		var matrix:Matrix = new Matrix( );
		matrix.scale( scale, scale );
		bitmap.draw( src, matrix );
		var w:Number = bitmap.width;
		var h:Number = bitmap.height;
		var tmp:String;
		for (var a:Number = 0; a <= w ; a++) {
			for (var b:Number = 0; b <= h ; b++) {
				tmp = bitmap.getPixel32( a, b ).toString( 16 );
				pixels.push( tmp.substr( 1 ) );
			}
		}
		bitmap.dispose( );
		return pixels;
	}

	private function BitmapUtils() {
	}
}