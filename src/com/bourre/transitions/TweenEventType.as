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
 * {@code TweenEventType} defines all available event's name in Tween API.
 * 
 * <p>Event "strong" type declaration is part of Pixlib Event API.
 * 
 * <p>Events broadcasted by {@link ITween} family classes.
 * <ul>
 *   <li>onStart</li>
 *   <li>onStop</li> *   <li>onMotionFinished</li> *   <li>onMotionChanged</li>
 * </ul>
 * 
 * <p>Example
 * <code>
 *   var e:TweenEvent = new TweenEvent( TweenEventType.onMotionFinished, this );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
import com.bourre.events.EventType;

class com.bourre.transitions.TweenEventType extends EventType
{
	//-------------------------------------------------------------------------
	// Events definition
	//-------------------------------------------------------------------------
	
	/**
	 * Broadcasted to listeners when tween starts.
	 */
	[Event("onStart")]
	public static var onStartEVENT:TweenEventType = new TweenEventType("onStart");
	
	/**
	 * Broadcasted to listeners when tween stops.
	 */
	[Event("onStop")]
	public static var onStopEVENT:TweenEventType = new TweenEventType("onStop");
	
	/**
	 * Broadcasted to listeners when tween is finished.
	 */
	[Event("onMotionFinished")]
	public static var onMotionFinishedEVENT:TweenEventType = new TweenEventType("onMotionFinished");
	
	/**
	 * Broadcasted to listeners when property value is updated.
	 */
	[Event("onMotionChanged")]
	public static var onMotionChangedEVENT:TweenEventType = new TweenEventType("onMotionChanged");
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code TweenEventType} instance
	 * 
	 * @param s Event name
	 */
	public function TweenEventType(s:String)
	{
		super(s);
	}
}