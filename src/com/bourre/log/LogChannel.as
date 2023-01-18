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
 * {@code LogChannel} gives another filtering solution for logging message.
 * 
 * <p>Adds a {@link LogListener} for a specific channel,
 * using {@link Logger.addLoglistener} method with {@code channel} parameter.
 * 
 * <p>Example
 * <code>
 *   var myXMLChannel : LogChannel = new LogChannel("XML");
 *   var mySOChannel : LogChannel = new LogChannel("SO");
 *   
 *   Logger.getInstance().addLogListener( SosTracer.getInstance(), myXMLChannel );
 *   Logger.getInstance().addLogListener( SosTracer.getInstance(), mySOChannel );
 *   
 *   Logger.LOG("Message in Xml Channel", LogLevel.INFO, myXMLChannel);
 *   Logger.LOG("Message in SO Channel", LogLevel.DEBUG, mySOChannel);
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.events.EventType;

class com.bourre.log.LogChannel 
	extends EventType
{
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code LogChannel} instance.
	 * 
	 * @param s Channel's name
	 */
	public function LogChannel( s : String ) 
	{
		super( s );
	}
}