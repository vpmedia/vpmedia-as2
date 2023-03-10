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
 * {@code ITween} defines basic rules for all tween impelmentations.
 * 
 * <p>Take a look at {@link BasicTweenFPS}, {@link BasicTweenMS}, {@link TweenFPS} 
 * and {@link TweenMS} for implementation.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.transitions.IBasicTween;
import com.bourre.transitions.ITweenListener;
import com.bourre.transitions.TweenEventType;

interface com.bourre.transitions.ITween extends IBasicTween
{
	/**
	 * Adds listener for receiving all events.
	 * 
	 * @param oL Listener object which implements {@link ITweenListener} interface.
	 */
	public function addListener(oL:ITweenListener) : Void;
	
	/**
	 * Removes listener for receiving all events.
	 * 
	 * @param oL Listener object which implements {@link ITweenListener} interface.
	 */
	public function removeListener(oL:ITweenListener) : Void;
	
	/**
	 * Adds listener for specifical event.
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function addEventListener(e:TweenEventType, oL) : Void;
	
	/**
	 * Removes listener for specifical event.
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function removeEventListener(e:TweenEventType, oL) : Void;
}