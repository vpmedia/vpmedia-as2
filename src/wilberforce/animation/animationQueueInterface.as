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

/**
* TODO - Remove as this is seriously out of date
*  Defines the required interface for all animatable objects that can be added to an animationQueueSystem
**/
interface wilberforce.animation.animationQueueInterface
{
	/** Animate to a set state or parameter **/
  function animate(parameter:Object,callbackFunction:Function):Void;
  /** Single step in the animation */
  function step():Boolean;
  /**  Set a particular state */
  function setState(tState:Number,tData):Void;
}
