/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code LogEvent} defines event model for logging API event.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.LogChannel;
import com.bourre.log.LogLevel;
import com.bourre.log.PixlibStringifier;

class com.bourre.log.LogEvent 
	extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** log message. **/
	public var content;
	
	/** message level. **/
	public var level:LogLevel;
	
	/** message timestamp. **/
	public var timestamp : Number;
	
	/** Triggers when {@link Logger} sends messages to tracer. **/
	public static var onLogEVENT:EventType = new EventType("onLog");
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code LogEvent} instance.
	 * 
	 * @param oLevel Log level defined by a {@link LogLevel} instance
	 * @param oContent Log message
	 * @param channel (optional) A {@link LogChannel} instance for 
	 * channel filter 
	 */
	public function LogEvent( oLevel:LogLevel, oContent, channel:LogChannel )
	{
		super( channel?channel:LogEvent.onLogEVENT );
		level = oLevel;
		content = oContent;
		timestamp = (new Date()).getTime();
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}