/**
 * com.sekati.events.IEventBroadcastable
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreInterface;

/**
 * Interface describing EventBroadcasters such as {@link com.sekati.events.EventBroadcaster}.
 */
interface com.sekati.events.IEventBroadcastable extends CoreInterface {

	function addEventListener(o:Object, event:String, handler:Function):Void;

	function removeEventListener(o:Object, event:String, handler:Function):Void;

	function reset():Void;

	function broadcastEvent(o:Object, event:String):Void;
}