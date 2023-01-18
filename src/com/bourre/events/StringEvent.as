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
 * {@code StringEvent} defines specific event structure to work with
 * {@code String} value.
 * 
 * <p>Based on {@link BasicEvent} class, {@code StringEvent} add access 
 * to his specific {@code String} property with  {@link #getString} and 
 * {@link #setString} methods.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.StringEvent extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _s:String;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code NumberEvent} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : StringEvent = new StringEvent(MyClass.onSomething, "pixlib");
	 * </code>
	 * 
	 * @param e an {@link EventType} instance (event name).
	 * @param s a {@code String} value
	 */
	public function StringEvent(e:EventType, s:String)
	{
		super(e);
		_s = s;
	}
	
	/**
	 * Returns instance {@code String} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : StringEvent = new StringEvent(MyClass.onSomething, "pixlib");
	 *   trace( e.getString() );
	 * </code>
	 * 
	 * @return a {@code String} value
	 */
	public function getString() : String
	{
		return _s;
	}
	
	/**
	 * Defines instance {@code String} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : StringEvent = new StringEvent(MyClass.onSomething);
	 *   e.setString("pixlib");
	 * </code>
	 * 
	 * @param n {@code Number} value
	 */
	public function setString(s:String) : Void
	{
		_s = s;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + ' : ' + getType() + ', ' + getString();
	}
}