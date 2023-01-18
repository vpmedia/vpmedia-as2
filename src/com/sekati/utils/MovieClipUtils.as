/**
 * com.sekati.utils.MovieClipUtils
 * @version 1.3.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Static class wrapping various MovieClip utilities.
 * @see {@link com.sekati.utils.ClassUtils}
 */
class com.sekati.utils.MovieClipUtils {

	/**
	 * absolute remove movieclip
	 * @param mc (MovieClip)
	 * @return Void
	 */
	public static function rmClip(mc:MovieClip):Void {
		mc.swapDepths( mc._parent.getNextHighestDepth( ) );
		mc.removeMovieClip( );
	}

	/**
	 * recursively set cacheAsBitmap property on top level clip and all children
	 * since var i is a string use mc[i] to refer to the mc - recurses max 256 levels
	 */
	public static function recursiveCache(mc:MovieClip):Void {
		mc.cacheAsBitmap = true;
		for (var i in mc) {
			if (typeof (mc[i]) == "movieclip") {
				MovieClipUtils.recursiveCache( mc[i] );
			}
		}
	}

	/**
	 * simple HitTest wrapper
	 * @param mc mc (MovieClip)
	 * @return Boolean
	 */
	public static function hitTest(mc:MovieClip):Boolean {
		return (mc.hitTest( _root._xmouse, _root._ymouse, true ));
	}

	private function MovieClipUtils() {
	}
}