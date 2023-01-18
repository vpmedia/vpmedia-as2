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
* 	Animation class. Animates a number of animatable elements, and if needed, sub queues.
* It holds an array of animatable objects
* Has a callback for each item that is completed, returning current item and number of items
* Has a callback for all items completed
* Different animation sequences are:
* Simultaneous, sequential, sequential with delay
* Each animated object handles its own step, returns when its completed
* 
* The animate parameter is passed a parameter which is effectively the state to pass on to each object
* controlled by it. This state is interpretated differently by each object
* 
*/
class wilberforce.animation.animationQueueSystem implements wilberforce.animation.animationQueueInterface {
	
	/** Array containing all objects controlled by the queue	**/
	private var controlledObjects:Array;
	/** Array containing all objects that are actively being animated	*/
	private var currentAnimatingObjects:Array;
	/** Items that have not been animated yet in the queue (when using sequential mode) */
	private var remainingAnimatingObjects:Array;
	
	/** The animation style (sequential or simultaneous) */
	private var animationStyle;	
	static var ANIM_SEQUENTIAL=1;
	static var ANIM_SIMULTANEOUS=2;
	
	// Will there be a delay?
	private var animationDelay:Number;
	private var animationCountdown:Number;
	
	var currentAnimationParameter;
	var controlledClips;
	var callBackFunction:Function;
	
	/**
	* Constructor. Create the queue
	* 
	**/
	function animationQueueSystem(tStyle:Number,tDelay) {
		//trace("Queue constructed");
		controlledObjects=[];
		currentAnimatingObjects=[];
		remainingAnimatingObjects=[];
		if (animationStyle>0) {
		}
		else {
			animationStyle=tStyle;
		}
		if (animationDelay>0) {
		}
		else {
			animationDelay=tDelay;
		}
			
		
		if (controlledClips!=undefined) {
			var tSplitClips=controlledClips.split(",");
			for (var i=0;i<tSplitClips.length;i++) {
				var tName=tSplitClips[i];
				//trace("** Adding "+tName);
				var tClip=_parent[tName];
				//trace("Clip is "+tClip)
				if (tClip!=null) {
					//trace("** Added "+tClip);
					addControlledObject(tClip);
				}
			}
		}
		
	}
	
	function isComplete() {
		if (currentAnimatingObjects.length==0) return true
		return false;
	}
	
	/** 
	* Sets the queue to operate in a sequential manner or simulatenous manner
	* @param isSequential Takes a boolean (true of false) to set the behaviour
	**/
	public function setSequential(isSequential:Boolean) {
		if (isSequential) animationStyle=ANIM_SEQUENTIAL;
		else animationStyle=ANIM_SIMULTANEOUS;
	}
	
	/** Get the animation queue to animate at the parameter passed, until all objects 
	* have signified that they have completed animating
	* @param tParameter The animation parameter (sent to all elements in the queue)
	* @param tCallBackFunction The function called when the queue is complete
	* If already animating, animation must be cleared using clearQueue before animate can be called again
	*/
	public function animate(tParameter:Object,tCallBackFunction:Function):Void {
		
		// If already animating, ignore this function call. Animation		
		if (currentAnimatingObjects.length!=0 || remainingAnimatingObjects.length!=0) {
			trace("ALREADY FULL")
			return;
		}
		callBackFunction=tCallBackFunction;
		currentAnimationParameter=tParameter;
	
		switch (animationStyle) {
			
			case ANIM_SIMULTANEOUS:
				//trace("animating simultaneous: Delay "+animationDelay+" "+controlledObjects);
				if (animationDelay==0) {

					for (i=0;i<controlledObjects.length;i++) {
						
						animateObject(controlledObjects[i]);
					}
				}
				else {
					// If going forwards
					if (tParameter==1) {
						// Kick off the first
						animateObject(controlledObjects[0]);
						// Add the rest to the remainingAnimatingObjects
						for (var i=1;i<controlledObjects.length;i++) remainingAnimatingObjects.push(controlledObjects[i]);						
					}
					else {
						// Kick off the last
						animateObject(controlledObjects[controlledObjects.length-1]);
						// Add the rest to the remainingAnimatingObjects
						for (var i=controlledObjects.length-2;i>=0;i--) remainingAnimatingObjects.push(controlledObjects[i]);						
					}
					// Start the countdown
					animationCountdown=animationDelay;
				}
				break;
			case ANIM_SEQUENTIAL:
				//trace("animating sequential");
				if (tParameter==1) {
					// Kick off the first
					animateObject(controlledObjects[0]);
					// Add the rest to the remainingAnimatingObjects
					for (var i=1;i<controlledObjects.length;i++) remainingAnimatingObjects.push(controlledObjects[i]);
				}
				else {
					// Kick off the last
					animateObject(controlledObjects[controlledObjects.length-1]);
					// Add the rest to the remainingAnimatingObjects
					for (var i=controlledObjects.length-2;i>=0;i--) remainingAnimatingObjects.push(controlledObjects[i]);						
				}
				break;
		}
		//for (var i in 
	}
	
	/**
	* A single step in the animation. Animates the next step of all objects and checks all objects to see if they have
	* completed animating.
	*/
	function step():Boolean {	
		if (currentAnimatingObjects.length==0) return true;
		//trace("callBackFunction "+callBackFunction);
		//trace("Stepping Q animating "+currentAnimatingObjects.length);
		// Step through for each element
		for (var i=0;i<currentAnimatingObjects.length;i++) {
			//trace("Targetting "+currentAnimatingObjects[i])
			var tStopped=currentAnimatingObjects[i].step();
			if (tStopped) {
				//trace("STOPPED");
				removeFromArray(currentAnimatingObjects,currentAnimatingObjects[i]);
				if (animationStyle==ANIM_SEQUENTIAL && remainingAnimatingObjects.length>0) {					
					// Grab the next object to animate
					tNewObject=remainingAnimatingObjects[0];					
					animateObject(tNewObject);
				}				
			}
		}
		if (animationStyle==ANIM_SIMULTANEOUS && animationDelay>0 && remainingAnimatingObjects.length>0) {
			// We are doing a delay between animating objects
			animationCountdown--;
			if (animationCountdown==0) {
				// Animate the next object
				var tNewObject=remainingAnimatingObjects[0];
				animateObject(tNewObject);
				if (remainingAnimatingObjects.length>0) animationCountdown=animationDelay;
			}
		}
		
		// Has everything stopped?
		if (currentAnimatingObjects.length==0 && remainingAnimatingObjects.length==0) {
			// Call the callback function exactly once
			//trace("Calling callBackFunction "+callBackFunction);
			var tCallingFunction=callBackFunction
			callBackFunction=null;
			tCallingFunction(this);			
			return true;
		}
		else {
			return false;
		}
	}
	/**
	* Removes an element from an array
	*/
	function removeFromArray(tArray,tElement):Boolean {
		// Search for the element
		for (var i=0;i<tArray.length;i++) {
			if (tArray[i]==tElement) {
				//Splice the array
				tArray.splice(i,1);
				return true;
			}
		}
		// Didnt find it
		return false;
	}
	/**
	* Clears the animation queue completely
	*/
	public function clearQueue():Void {
		controlledObjects=[];
		currentAnimatingObjects=[];
		remainingAnimatingObjects=[];
	}
	/**
	* Start animating the next object from the queue
	*/
	function animateObject(tNewObject) {
		//trace("animating "+tNewObject);
		tNewObject.animate(currentAnimationParameter);
		// Remove from the remainingAnimatingObjects array
		removeFromArray(remainingAnimatingObjects,tNewObject);
		
		// Make sure theres no duplicates to avoid double steps
		var tFound=false
		for (var i in currentAnimatingObjects) {
			if (currentAnimatingObjects[i]==tNewObject) tFound=true;
		}
		//trace("tFound "+tFound)
		if (!tFound) currentAnimatingObjects.push(tNewObject);
	}
	
	/**
	* Adds an object to the queue
	*/
	
	function addControlledObject(tObject):Boolean {
		var tFound=false
		// Make sure that this is a valid queue object by casting to it
		var isValid:com.scee.animation.animationQueueInterface = com.scee.animation.animationQueueInterface(tObject);
		if (!isValid) {
			//trace("Invalid object request");
			return false
		}
		for (var i in controlledObjects) {
			if (currentAnimatingObjects==tObject) {
				//trace("Duplicate found");
				tFound=true;
				return false;
			}
		}
		if (!tFound) {
			//trace("Valid object added");
			controlledObjects.push(tObject);			
		}
		return true;
	}
	/**
	* Clears all controlled objects
	*/
	function removeAllControlledObjects() {
		controlledObjects=[];
	}
	
	function setState(tState:Number,tData):Void {
		
		// Sets the position of the 
	}
	
}





// every animatable object has the properties
// animationActive:boolean

// and the functions
// step(); (returns true if still animating, false if not animating)


// animate(id)
// this "id" needs to be interpreted by each independant clip
// for example animationqueue will kick off its animation sequence
// or forward playing movieclip will animate to the end of its sequence


// AQ - 



