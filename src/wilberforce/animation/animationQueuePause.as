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
* Animatable Pause object that can be added to a queue to add a gap in sequentially animated queues.
* Like a water bubble in a tube.
*/
class wilberforce.animation.animationQueuePause implements wilberforce.animation.animationQueueInterface
{
	
	
	var stateTable:Array;
	var pauseFrames:Number;
	
	var currentFramesCountdown:Number;
	var completeFunction;
	
	/** 
	* @param tPauseFrames the number of frames to pause 
	* @param tCompleteFunction Function to call when the pause has completed
	*/
	function animationQueuePause(tPauseFrames,tCompleteFunction) {
		completeFunction=tCompleteFunction
		pauseFrames=tPauseFrames;
		
		currentFramesCountdown=pauseFrames;
				
		stateTable=[];		
	}
	
	/** 
	* Animate all animating attributes a single step towards the aim state
	* @return true or false, depending on whether or not the animation has been completed
	*/	
	function step():Boolean {
		
		if (currentFramesCountdown==0) return true;
		
		currentFramesCountdown--;
		//trace("PAUSE OBJECT FRAMECOUNT "+currentFramesCountdown);
		if (currentFramesCountdown==0) {
			completeFunction();
			return true;
		}
		
		return false;
	}
	/** 
	* Resets the counter when animating this object
	*/
	function animate(tParameter:Object,tFunction:Function):Void {
		currentFramesCountdown=pauseFrames;
	}
	function setState(tState:Number,tData):Void {		
		// Sets the frame for this particular state
	}
}