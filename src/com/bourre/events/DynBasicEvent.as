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
 * {@code DynBasicEvent} defines basic event structure for working with event as a classical 
 * {@code Object} structure.
 * 
 * <p>{@code DynBasicEvent} defines 2 main properties : 
 * <ul>
 *   <li>{@link #type} to get event name</li>
 *   <li>{@link #target} to get event target</li>
 * </ul>
 * 
 * <p>Using {@code DynBasicEvent} gives compatibility to send event throw Macromedia event API using
 * {@code EventDispatcher} broadcaster.
 * 
 * <p>{@link EventBroadcaster#dispatchEvent} use this structure to send Macromedia compatible event.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

dynamic class com.bourre.events.DynBasicEvent extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code DynBasicEvent} instance.
	 * 
	 * @param s Event name
	 * @param oT Event target
	 */
	public function DynBasicEvent(s:String, oT)
	{
		super( new EventType(s), oT);
	}
	
	/**
	 * Returns event type (event name).
	 * 
	 * <p>Example
	 * <code>
	 *   var o : EventType = e.type;
	 * </code>
	 * 
	 * @return {@code String} event name
	 */
	public function get type() : String 
	{ 
		return _e.toString(); 
	}
	
	/**
	 * Defines event type (event name).
	 * 
	 * <p>Example
	 * <code>
	 *   e.type = MyClass.onSomething;
	 * </code>
	 * 
	 * @param e  {@code String} event name.
	 */
	public function set type(s:String) : Void
	{ 
		_e = new EventType(s); 
	}
	
	/**
	 * Returns event target.
	 * 
	 * <p>Example
	 * <code>
	 *   var o = e.target;
	 * </code>
	 * 
	 * @return event target
	 */
	public function get target() : Object 
	{ 
		return _oT; 
	}
	
	/**
	 * Defines event target.
	 * 
	 * <p>Example
	 * <code>
	 *   e.target = this;
	 * </code>
	 * 
	 * @param event target
	 */
	public function set target(oT) : Void 
	{ 
		_oT = oT; 
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + ' : ' + this.type;
	}
}