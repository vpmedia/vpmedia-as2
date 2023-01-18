/**
 * com.sekati.events.IPulsable
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreInterface;

/**
 * Interface describing {@link com.sekati.events.FramePulse}.
 */
interface com.sekati.events.IPulsable extends CoreInterface {

	function start():Void;

	function stop():Void;

	function isRunning():Boolean;

	function addFrameListener(o:Object):Void;

	function addFrameListeners(a:Array):Void;

	function removeFrameListener(o:Object):Void;

	function removeFrameListeners(a:Array):Void;

	function isListenerRegistered(o:Object):Boolean;
}