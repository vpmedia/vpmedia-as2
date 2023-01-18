/**
 * com.sekati.log.LogEvent
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.events.Event;
import com.sekati.log.Logger;

/**
 * LogEvent object for use by {@link Logger} for {@link Console}.
 */
class com.sekati.log.LogEvent extends Event {

	public static var onLogEVENT:String = "onLogEvent";
	private static var target:Logger = Logger.getInstance( );

	/**
	 * Constructor creates a LogEvent by {@link Logger} to be dispatched to {@link Console}.
	 * @param data (Object) - contains ConsoleItem data: {@code {id:Number, type:String, origin:Sting, message:String, benchmark:Number}}
	 * @return Void
	 */
	public function LogEvent(data:Object) {
		super( onLogEVENT, target, data );
	}
}