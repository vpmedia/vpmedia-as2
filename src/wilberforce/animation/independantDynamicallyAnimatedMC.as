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
* Independant animation class that can be assigned to a movieclip. Listens to the singleton {@link wilberforce.system.frameEventController}
* class, and allows it to be controlled as if it was a {@link wilberforce.animation.animationDynamicAttributesMC} object without the need
* for a queue to control it.
* 
* todo: this needs fixing up - at the moment its relying on its own enterframe rather than listening to the frameevent controller
*/
class wilberforce.animation.independantDynamicallyAnimatedMC extends wilberforce.animation.animationDynamicAttributesMC {
	
	var aimState:Number;
	var completionFunction;
	var timerOffset:Number=0;
	var lastFrameTimer:Number;
	function independantDynamicallyAnimatedMC() {
		//super();
	}
	/** Animate to the state passed 
	* 
	* @param tState The state to aim to
	* @param tCompletionFunction Function to call when completed
	*/
	function animateToState(tState,tCompletionFunction) {
		//trace("Animating to "+tState)
		aimState=tState;
		completionFunction=tCompletionFunction;
		this.animate(aimState,completionFunction);
		
		
		if (_global.lockFrameInterval>0) {
			lastFrameTimer=getTimer();
			this.onEnterFrame=intervalAnimationLoop;
		}
		else this.onEnterFrame=animationLoop;
	}
	
	/** 
	* Function called to animate the next step
	*/
	function animationLoop() {
		var tResult=this.step();
		if (tResult) {
			// Animation complete
			//trace("ANIM Complete");
			completionFunction(this);
			delete this.onEnterFrame;			
		}
		else {
			//trace("looping")
		}
	}
	
	/**
	* Call the required number of frames to make the animation sync up with time rather
	* than maximum renderable frame rate
	*/
	function intervalAnimationLoop() {
		//trace("looping here")
		var dTime=getTimer()-lastFrameTimer;
		timerOffset+=dTime;
		while (timerOffset>_global.lockFrameInterval) {
			timerOffset-=_global.lockFrameInterval;
			var tResult=this.step();
			if (tResult) {
				completionFunction(this);
				delete this.onEnterFrame;
			}
		}
		lastFrameTimer=getTimer();
	}
}