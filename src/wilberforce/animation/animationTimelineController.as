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
* Animation class that allows a timeline animation created in the authoring environment to be queued and controlled by
* an {@link wilberforce.animation.animationQueueSystem}. Assigned to a movieClip in the library to be used.
* 
* todo: Needs to be tidied considerably. Currently not working within the framework correctly
*/
class wilberforce.animation.animationTimelineController extends MovieClip implements wilberforce.animation.animationQueueInterface {
	
	var currentDirection;
	var stateTable:Array;
	
	
	function animationTimelineController() {
		currentDirection=-1;
		stateTable=[];
		// -1 = stopped
		//0 =backwards
		//1 =forwards
		stop();
		// Set the default states. State 0 is the first frame. State 1 is the last fram
		
		setState(0,1);
		setState(1,_totalframes);
				
	}
	
	/** 
	* Plays the next frame in the currently specified direction. If it reaches the last frame of its current direction, it returns 1,
	* otherwise returns 0
	*/
	function step():Boolean {
		//trace(_name+" STEP frame is "+_currentframe);
		if (currentDirection==-1) return true;
		if (currentDirection==1) {
			if (_currentframe==_totalframes) {currentDirection=-1;return true;}
			var tNextFrame=_currentframe+1;
			gotoAndStop(tNextFrame);
			if (_currentframe==_totalframes) {currentDirection=-1;return true;}			
		}
		if (currentDirection==0) {
			if (_currentframe==1) {currentDirection=-1;return true;}
			var tNextFrame=_currentframe-1;
			gotoAndStop(tNextFrame);
			if (_currentframe==_totalframes) {currentDirection=-1;return true;}			
		}
		return false;
	}
	/** 
	* @param tParameter The direction to play in : 1 to play forwards, -1 to play backwards
	* @param tFunction Not used
	*/
	function animate(tParameter:Object,tFunction:Function):Void {
		currentDirection=tParameter;
	}
	/** 
	* Not used
	*/
	function setState(tState:Number,tData):Void {		
		// Sets the frame for this particular state
	}
}