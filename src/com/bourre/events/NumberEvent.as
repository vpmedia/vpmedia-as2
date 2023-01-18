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
 * {@code NumberEvent} defines specific event structure to work with
 * {@code Number} value.
 * 
 * <p>Based on {@link BasicEvent} class, {@code NumberEvent} add access 
 * to his specific {@code Number} property with {@link #getNumber} and 
 * {@link #setNumber} methods.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.NumberEvent extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _n:Number;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code NumberEvent} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : NumberEvent = new NumberEvent(MyClass.onSomething, 10);
	 * </code>
	 * 
	 * @param e an {@link EventType} instance (event name).
	 * @param n a {@code Number} value
	 */
	public function NumberEvent(e:EventType, n:Number)
	{
		super(e);
		_n = n;
	}
	
	/**
	 * Returns instance {@code Number} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : NumberEvent = new NumberEvent(MyClass.onSomething, 10);
	 *   trace( e.getNumber() ); //return 10
	 * </code>
	 * 
	 * @return a {@code Number} value
	 */
	public function getNumber() : Number
	{
		return _n;
	}
	
	/**
	 * Defines instance {@code Number} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : NumberEvent = new NumberEvent(MyClass.onSomething);
	 *   e.setNumber(10);
	 * </code>
	 * 
	 * @param n {@code Number} value
	 */
	public function setNumber(n:Number) : Void
	{
		_n = n;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + ' : ' + getType() + ', ' + getNumber();
	}
}