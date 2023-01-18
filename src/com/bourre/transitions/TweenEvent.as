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
 * {@code TweenEvent} defines event model for Tween API.
 * 
 * <p>Based on {@link com.bourre.events.BasicEvent} class.
 * 
 * <p>{@code TweenEvent} events are broadcasted by {@link ITween} instances. 
 * 
 * @author Francis Bourre
 * @version 1.0
 */
import com.bourre.events.BasicEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.transitions.ITween;
import com.bourre.transitions.TweenEventType;

class com.bourre.transitions.TweenEvent extends BasicEvent
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oTween:ITween;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code TweenEvent} instance broadcasted by {@link ITween} 
	 * family classes.
	 * 
	 * <p>Example
	 * <code>
	 *   var e:TweenEvent = new TweenEvent(TweenFPS.onMotionFinished, this);
	 * </code>
	 * 
	 * @param e event type (event name).
	 * @param oTween event source ({@link ITween} instance).
	 */
	public function TweenEvent(e:TweenEventType, oTween:ITween)
	{
		super(e);
		_oTween = oTween;
	}
	
	/**
	 * Returns {@link ITween} event source.
	 * 
	 * <p>Example
	 * <code>
	 *   var t:TweenMS = TweenMS( e.getType() );
	 * </code>
	 * 
	 * @return {@link ITween} instance
	 */
	public function getTween() : ITween
	{
		return _oTween;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * <p>{@link com.bourre.events.BasciEvent#toString} overridding
	 * 
	 * @return {@code String} representation of this instance
	 */
	public function toString() : String
	{
		return PixlibStringifier.stringify( this ) + getType() + ', ' + getTween();
	}
}