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
 * {@code BubbleEvent} defines specific event structure to work with
 * {@link BubbleEventBroadcaster}
 * 
 * <p>Based on {@link BasicEvent} class, {@code BubbleEvent} add access 
 * to his specific {@link #bubbles} and {@link #propagation} properties.
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.BubbleEvent extends BasicEvent 
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** Indicates if the event will be passed to the parent object. **/
	public var bubbles:Boolean;
	
	/** Indicates if the event is still be propagated **/
	public var propagation:Boolean;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BubbleEvent} instance.
	 * 
	 * <p>{@link #bubbles} and {@link #propagation} properties are set
	 * to {@code true}.
	 * 
	 * <p>Example
	 * <code>
	 *   var e : BubbleEvent = new BubbleEvent(MyClass.onSomething, this);
	 * </code>
	 * 
	 * @param e an {@link EventType} instance (event name).
	 * @param oT event target.
	 */
	public function BubbleEvent( e : EventType, oT ) 
	{
		super(e, oT);
		bubbles = true;
		propagation = true;
	}

	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return 		PixlibStringifier.stringify( this ) + ' : ' 
					+ 'type:' + getType() + ', '					+ 'target:' + getTarget() +', '
					+ 'bubbles:' + bubbles  +', '					+ 'propagation:' + propagation;
	}
}