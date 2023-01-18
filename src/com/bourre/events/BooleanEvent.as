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
 * {@code BooleanEvent} defines specific event structure to work with
 * {@code Boolean} value.
 * 
 * <p>Based on {@link BasicEvent} class, {@code BooleanEvent} add access 
 * to his specific {@code Boolean} property with {@link #getBoolean} and 
 * {@link #setBoolean} methods.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.BooleanEvent extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _b:Boolean;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BooleanEvent} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BooleanEvent = new BooleanEvent(MyClass.onSomething, true);
	 * </code>
	 * 
	 * @param e an {@link EventType} instance (event name).
	 * @param b a {@code Boolean} value
	 */
	public function BooleanEvent(e:EventType, b:Boolean)
	{
		super(e);
		_b = b;
	}
	
	/**
	 * Returns instance {@code Boolean} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BooleanEvent = new BooleanEvent(MyClass.onSomething, true);
	 *   trace( e.getBoolean() ); //return true
	 * </code>
	 * 
	 * @return a {@code Boolean} value
	 */
	public function getBoolean() : Boolean
	{
		return _b;
	}
	
	/**
	 * Defines instance {@code Boolean} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BooleanEvent = new BooleanEvent(MyClass.onSomething);
	 *   e.setBoolean(false);
	 * </code>
	 * 
	 * @param b {@code Boolean} value
	 */
	public function setBoolean(b:Boolean) : Void
	{
		_b = b;
	}
	
	/**
	 * Indicates if {@code Boolean} instance property is {@code true} 
	 * or {@code false}
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BooleanEvent = new BooleanEvent(MyClass.onSomething, true);
	 *   trace( e.isTrue() ); //return true;
	 * </code>
	 * 
	 * @return {@code true} if instance {@code Boolean} is true, either {@code false}
	 */
	public function get isTrue() : Boolean
	{
		return _b;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + ' : ' + getType() + ', ' + getBoolean();
	}
}