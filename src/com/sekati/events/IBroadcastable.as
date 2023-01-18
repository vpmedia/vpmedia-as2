/**
 * com.sekati.events.IBroadcastable
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreInterface;

/**
 * Interface describing Event Broadcasters such as {@link com.sekati.events.Broadcaster}.
 */
interface com.sekati.events.IBroadcastable extends CoreInterface {

	function subscribe(o:Object):Void;

	function unsubscribe(o:Object):Void;

	function reset():Void;

	function broadcast():Void;

	function addListener(o:Object):Number;

	function removeListener(o:Object):Boolean;
}