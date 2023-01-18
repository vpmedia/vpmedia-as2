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
 * {@code PointEvent} defines specific event structure to work with
 * {@link com.bourre.structures.Point} instance.
 * 
 * <p>Based on {@link BasicEvent} class, {@code PointEvent} add access 
 * to his specific {@link com.bourre.structures.Point} property with 
 * {@link #getPoint} and {@link #setPoint} methods.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.structures.Point;

class com.bourre.events.PointEvent extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _p:Point;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code PointEvent} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : PointEvent = new PointEvent(MyClass.onSomething, new Point(10,2) );
	 * </code>
	 * 
	 * @param e an {@link EventType} instance (event name).
	 * @param p a {@link com.bourre.structures.Point} instance
	 */
	public function PointEvent(e:EventType, p:Point)
	{
		super(e);
		_p = p;
	}
	
	/**
	 * Returns instance {@link com.bourre.structures.Point} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : PointEvent = new PointEvent(MyClass.onSomething, new Point(10,2) );
	 *   trace( e.getPoint() );
	 * </code>
	 * 
	 * @return a {@link com.bourre.structures.Point} instance
	 */
	public function getPoint() : Point
	{
		return _p;
	}
	
	/**
	 * Defines instance {@link com.bourre.structures.Point} value.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : PointEvent = new PointEvent(MyClass.onSomething);
	 *   e.setPoint( new Point(10,2) );
	 * </code>
	 * 
	 * @param p {@link com.bourre.structures.Point} value
	 */
	public function setPoint(p:Point) : Void
	{
		_p = p;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + ' : ' + getType() + ', ' + getPoint();
	}
}