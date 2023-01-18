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
 * @author Simon Oliver
 * @version 1.0
 */
 
// Classes from Wilberforce
import wilberforce.geom.IShape2D;

// Classes from Pixlib
import com.bourre.core.HashCodeFactory;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;

class wilberforce.ui.canvas.transformableObjectModifiedEvent
	implements IEvent
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _e:EventType;
	private var _oT;
	public var shape:IShape2D;
	public var isFinal:Boolean;
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BasicEvent} instance.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BasicEvent = new BasicEvent( MyClass.onSomething, this);
	 * </code>
	 * 
	 * @param e an {@link EventType} instance (event name).
	 * @param oT event target.
	 */
	public function transformableObjectModifiedEvent(e:EventType, oT,tShape:IShape2D,tIsFinal:Boolean) 
	{
		_e = e;
		_oT = oT;
		shape=tShape;
		isFinal=tIsFinal;
	}
	
	/**
	 * Returns event type (name).
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BasicEvent = new BasicEvent( MyClass.onSomething, this);
	 *   var t : EventType = e.getType();
	 * </code>
	 * 
	 * @return an {@link EventType} instance
	 */
	public function getType() : EventType
	{ 
		return _e; 
	}
	
	
	
	
	/**
	 * Defines event type (name).
	 * <p>Example
	 * <code>
	 *   var e : BasicEvent = new BasicEvent( null, this);
	 *   e.setType( MyClass.onSomething );
	 * </code>
	 * 
	 * @param e an {@link EventType} instance.
	 */
	public function setType(e:EventType) : Void 
	{ 
		_e = e; 
	}
	
	/**
	 * Returns event target (usually event source).
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BasicEvent = new BasicEvent( myClass.onSomething, this);
	 *   var t = e.getTarget();
	 * </code>
	 * 
	 * @return event target
	 */
	public function getTarget()
	{ 
		return _oT; 
	}
	
	/**
	 * Defines event target.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BasicEvent = new BasicEvent( myClass.onSomething, null);
	 *   e.setTarget(this);
	 * </code>
	 * 
	 * @param oT event target
	 */
	public function setTarget(oT) : Void 
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
		return '[BasicEvent' + HashCodeFactory.getKey( this ) + ' : ' + getType() + ']';
	}
}