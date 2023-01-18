/**
 * com.sekati.effects.AnimHandler
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.BaseClip;
import com.sekati.utils.ClassUtils;

/**
 * Create an animation handler object to preserve 
 * the objects natural onEnterFrame event.
 */
class com.sekati.effects.AnimHandler {

	/**
	 * Create a {@link com.sekati.display.BaseClip} onEnterFrame animation 
	 * handler object for text effects. Only one anim handler per TextField;
	 * old or running anim handlers are automatically removed and overwritten
	 * to prevent animation overlaps.
	 * @param tf (TextField) target text
	 * @return MovieClip
	 */
	public static function create(tf:TextField):MovieClip {
		var cName:String = "$__" + tf._name + "__anim__";
		
		var oldAnim:BaseClip = tf._parent[cName];
		if (oldAnim) {
			oldAnim.destroy( );
		}
		return ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, tf._parent, cName );
	}

	/**
	 * Destroy an animation.
	 * @param tf (TextField) target text
	 * @return Void
	 */
	public static function destroy(tf:TextField):Void {
		var cName:String = "$__" + tf._name + "__anim__";
		var oldAnim:BaseClip = tf._parent[cName];
		if (oldAnim) {
			oldAnim.onEnterFrame = null;
			oldAnim.destroy( );
		}		
	}	

	private function AnimHandler() {
	}
}