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
 * {@code IBasicTween} defines basic rules for tween implementation.
 * 
 * <p>Take a look at {@link com.bourre.transitions.BasicTweenMS} and 
 * {@link com.bourre.transitions.BasicTweenFPS} for concrete implementation.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.Command;

interface com.bourre.transitions.IBasicTween extends Command
{
	/**
	 * Defines easing function for tween effect.
	 * 
	 * @param f Easing {@code Function}
	 */
	public function setEasing(f:Function) : Void;
	
	/**
	 * Starts tweening.
	 */
	public function start() :Void;
	
	/**
	 * Stops tweening.
	 */
	public function stop() :Void;
}