
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
 
import wilberforce.event.frameEventBroadcaster;
 
/**
* TODO - Remove as this is seriously out of date
* Root animation queue class that binds to an instance of {@link com.scee.animation.animationQueueSystem} 
* and listens to the static {@link wilberforce.system.frameEventController}
* class. for each frame. 
*/
class wilberforce.animation.animationQueueRoot {
	
	var controlledQueue:wilberforce.animation.animationQueueSystem;
	/** 
	* Create a new animationQueueRoot
	* @param tQueue An instance of {@link wilberforce.animation.animationQueueSystem} 
	*/
	function animationQueueRoot(tQueue:wilberforce.animation.animationQueueSystem) {		
		controlledQueue=tQueue;		
		frameEventBroadcaster.addListener(this);
	}
	/** 
	* frameStep is called by frameEventController, causing the assigned queue to step through on frame events
	*/
	function frameStep() {
		//trace("Stepping");
		controlledQueue.step();		
	}
	
}