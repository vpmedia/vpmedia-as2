/**
 * com.sekati.display.AbstractClip
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.display.CoreClip;

/**
 * Generic subclass implementation of {@link com.sekati.display.CoreClip} mixin.
 * To be used as template for all framework based extend movieclip UI classes.
 */
class com.sekati.display.AbstractClip extends CoreClip {

	/**
	 * private constructor; class is initialized via the MovieClip.onLoad event.
	 */
	private function AbstractClip() {
	}

	/**
	 * overrides CoreClip.configUI with its own intialization behavior once clip is loaded, registered on stage.
	 * @return Void
	 */
	private function configUI():Void {
		trace( toString( ) + " | " + _this._name + " [cacheAsBitmap:" + _this.cacheAsBitmap + ", __RUID:" + _this.__RUID + "]" );
	}

	/**
	 * calls superclasses destroy and executes its own destroy behaviors.
	 * @return Void
	 */
	private function destroy():Void {
		trace( toString( ) + " | " + _this._name + "  called destroy()" );
		super.destroy( );
	}
}