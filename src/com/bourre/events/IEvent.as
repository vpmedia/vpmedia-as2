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
 * {@code IEvent} defines basic rules for all event structure.
 * 
 * <p>All custom event classes must extends {@link BasicEvent} class or 
 * implements {@code IEvent} interface.
 * 
 * <ul>
 *   <li>{@link #setType} to define event name</li>
 *   <li>{@link #getType} to retreive event name</li>
 *   <li>{@link #setTarget} to define event source</li>
 *   <li>{@link #getTarget} to retreive event source</li>
 * </ul>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.events.EventType;

interface com.bourre.events.IEvent
{
	/**
	 * Returns event type (name).
	 * 
	 * <p>Example
	 * <code>
	 *   var e : IEvent = new BasicEvent( MyClass.onSomething, this);
	 *   var t : EventType = e.getType();
	 * </code>
	 * 
	 * @return an {@link EventType} instance
	 */
	public function getType() : EventType;
	
	/**
	 * Returns event target (usually event source).
	 * 
	 * <p>Example
	 * <code>
	 *   var e : IEvent = new BasicEvent( myClass.onSomething, this);
	 *   var t = e.getTarget();
	 * </code>
	 * 
	 * @return event target
	 */
	public function getTarget();
	
	/**
	 * Defines event type (name).
	 * <p>Example
	 * <code>
	 *   var e : IEvent = new BasicEvent( null, this);
	 *   e.setType( MyClass.onSomething );
	 * </code>
	 * 
	 * @param e an {@link EventType} instance.
	 */
	public function setType(e:EventType) : Void;
	
	/**
	 * Defines event target.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : IEvent = new BasicEvent( myClass.onSomething, null);
	 *   e.setTarget(this);
	 * </code>
	 * 
	 * @param oT event target
	 */
	public function setTarget(oTarget) : Void;
}