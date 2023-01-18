/**
 * com.sekati.external.MouseWheel
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.events.Broadcaster;
import com.sekati.net.NetBase;
import com.sekati.validate.OSValidation;
import flash.external.*;

/**
 * MouseWheel support for Mac & PC. Requires: sasapi.js
 */
class com.sekati.external.MouseWheel {

	private static var _isMac:Boolean = OSValidation.isMac( );
	private static var _cb:Boolean;

	/**
	 * initialize MouseWheel support for mac/pc and add object as Mouse listener
	 * @param o (Object) to subscribe to onMouseWheel event
	 * @return Void
	 * {@code Usage:
	 * 	MouseWheel.init(this);
	 * }
	 */
	public static function init(o:Object):Void {
		if(!_cb && _isMac) {
			_cb = ExternalInterface.addCallback( "externalMouseEvent", MouseWheel, MouseWheel.externalMouseEvent );	
		}
		if(_isMac) {
			Broadcaster.$.addListener( o );
			if(!NetBase.isOnline( )) {
				//throw new Error ("@@@ com.sekati.external.MouseWheel Error: init was called but swf is not online and does not have access to the sasapi.js library to make Mac MouseWheel function.");	
			}
		} else {
			Mouse.addListener( o );
		}
	}

	/**
	 * Catch callback from javascript and broadcast MouseWheel event for Mac's
	 * @param delta (Number)
	 * @return Void
	 */
	private static function externalMouseEvent(delta:Number):Void {
		Broadcaster.$.broadcast( "onMouseWheel", delta );	
	}

	private function MouseWheel() {	
	}
}