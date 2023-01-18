/**
 * com.sekati.events.IEventDispatch
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreInterface;
import com.sekati.events.Event;

/**
 * Interface describing Event Dispatchers such as {@link com.sekati.events.Dispatcher}.
 */
interface com.sekati.events.IDispatchable extends CoreInterface {

	function addEventListener(event:String, listener:Object):Void;

	function removeEventListener(event:String, listener:Object):Void;

	function dispatchEvent(e:Event):Void;

	function bubbleEvent(e:Event):Void;

	function broadcastEvent(_type:String, _target:Object, _data:Object):Void;
}