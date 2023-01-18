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
 * {@code EventType} defines strong-typing to set name of an event.
 * 
 * <p>Use in Pixlib Event API.
 * 
 * <p>Example
 * <code>
 *   var onSomeThingEVENT : EventType = new EventType( 'onSomething' );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

class com.bourre.events.EventType extends String
{
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code EventType} instance.
	 * 
	 * @param s event name.
	 * 
	 * @see com.bourre.events.EventBroadcaster
	 */
	public function EventType(s:String)
	{
		super(s);
	}
}
