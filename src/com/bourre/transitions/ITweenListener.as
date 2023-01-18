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
 * {@code ITweenListener} defines rules for tween listener.
 * 
 * <p>All instances which want to listen to {@link ITween} progression, 
 * must implement {@code ITweenListener} interface
 * 
 * <p>a {@link TweenEvent} is broadcasted throw event.
 * 
 * @author Francis Bourre
 * @version 1.0
 * 
 * @see com.bourre.transitions.TweenEvent
 */
import com.bourre.transitions.TweenEvent;

interface com.bourre.transitions.ITweenListener
{
	/**
	 * Triggers when tween starts.
	 * 
	 * @param e {@link TweenEvent} instance
	 */
	public function onStart(e:TweenEvent) : Void;
	
	/**
	 * Triggers when tween stops.
	 * 
	 * @param e {@link TweenEvent} instance
	 */
	public function onStop(e:TweenEvent) : Void;
	
	/**
	 * Triggers when tween ends.
	 * 
	 * @param e {@link TweenEvent} instance
	 */
	public function onMotionFinished(e:TweenEvent) : Void;
	
	/**
	 * Triggers when object property value is updated.
	 * 
	 * @param e {@link TweenEvent} instance
	 */
	public function onMotionChanged(e:TweenEvent) : Void;
}