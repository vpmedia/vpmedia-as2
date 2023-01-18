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

import wilberforce.animation.animationDynamicAttribute;
/**
* TODO - Remove as this is seriously out of date
* Class assigned to any movie clip (or extended by another class). Adds the ability for any
* attributes of the movieclip to be freely animated through code. Can easily be added to an animationqueue
*/
class wilberforce.animation.animationDynamicAttributesMC extends MovieClip implements wilberforce.animation.animationQueueInterface {
	
	
	var stateTable:Array;
	var originalStateTable:Array;
	
	var animatedAttributeList;
	//var animatedAttributeNameList;
	var thresholdPercentage:Number;

	var progressionType:Number;
	var progressionParam1:Number;
	var progressionParam2:Number;
	
	var currentAimStateIndex;
	var currentAimStateData;
	
	
	var forcedAttributesList=["_x","_y","_width","_height","_alpha","_rotation","_xscale","_yscale"];
	
	var progressionSetup;
	
	
	/**
	* No parameters (as created by the movieclip its assigned to)
	*/
	function animationDynamicAttributesMC() {
		//trace("animationDynamicAttributesMC "+_name)
		stateTable=[];
		originalStateTable=[];
		animatedAttributeList={};//[];
		//animatedAttributeNameList={};
		
	//	animatedAttributeNameList["tester"]=32
		//trace("BIG ONE "+animatedAttributeNameList.length)
		
		//thresholdPercentage=0.01;
		thresholdPercentage=0.003;
		
		var initialState={};
		
		// Record all the attributes of this MC and add them 
		for (var i=0;i<forcedAttributesList.length;i++) {
			var tAttributeName=forcedAttributesList[i]
			initialState[tAttributeName]=this[tAttributeName];
			//trace("INITIAL "+tAttributeName+" : "+initialState[tAttributeName])
		}
		// Set state 0 as the initial state of the clip
		setState(0,initialState);
		
		// Set the default state as being elastic with simple parameters
		if (progressionSetup==null) {
			setProgression(animationDynamicAttribute.ELASTIC_PROGRESSION,0.015,0.1);
		}
		else {
			setProgression(progressionSetup.type,progressionSetup.arg1,progressionSetup.arg2);
		}
		

	}
	/**
	* Set the progression type
	* @param tType The type of progression - Linear, Elastic or Easeout
	* @param tProgressionParam1 Parameters of progression (for Linear this is number of steps, for elastic this is spring, for easeout this is the division per frame
	* @param tProgressionParam2 Parameters of progression (for elastic and easeout this is the percentage threshold 
	*/
	function setProgression(tType,tProgressionParam1,tProgressionParam2) {		
		progressionType=tType;
		progressionParam1=tProgressionParam1;
		progressionParam2=tProgressionParam2;		
	}
	
	/** Animate to the state passed 
	* 
	* @param parameter The state to aim to
	* @param callbackFunction <Unused>
	*/	
	function animate(parameter:Object,callbackFunction:Function):Void {
		
		// If this state has not been set, use the default		
		if (stateTable[parameter]==null) parameter=0;
		
		// Retrieve the state
		currentAimStateIndex=parameter;
		currentAimStateData=stateTable[currentAimStateIndex];
		
		// Aim each dynamic attribute at this value
		for (var tAttribute in currentAimStateData) {
			var tAimValue=currentAimStateData[tAttribute];
			animatedAttributeList[tAttribute].aimAt(tAimValue);
		}
	}
	
	/** 
	* Animate all animating attributes a single step towards the aim state
	* @return true or false, depending on whether or not the animation has been completed
	*/	
	function step():Boolean {

		//var remainingAnimating=animatedAttributeList.length;
		var stillAnimating=0;
		//trace("attributes animating "+animatedAttributeList.length)
		
		//for (var i=0;i<animatedAttributeList.length;i++) {
		for (var tAttributeName in animatedAttributeList) {
			//var tAttributeName=animatedAttributeNameList[i];
			//trace("Animating "+tAttributeName)
			
			var tAttribute:animationDynamicAttribute=animatedAttributeList[tAttributeName];
			if (!tAttribute.step()) {
				stillAnimating++;	
				//trace("Still left "+tAttributeName)
			}
			this[tAttributeName]=tAttribute.value;
		}
		if (stillAnimating==0) {
			//trace("COMPLETE")
			animationComplete();
			return true;
		}
		else {
			//trace("REMAINING "+stillAnimating)
			animationStep();
			return false;
		}
		
	}
	
	/** 
	* Set the attributes for a particular state for animations to aim to
	* @param tState The State index
	* @param tData Object (effectively property list) containing all attributes for that state
	*/
	function setState(tState:Number,tData):Void {
		// The fun bit. we only need to create dynamic attributes when we create a new state, as thats what we are
		// animating to
		if (tState!=0) {
			for (var tAttribute in tData) {
				// Add the standard attributes
				
				var tAttributeValue=tData[tAttribute];
				addDynamicAttribute(tAttribute,tAttributeValue);
				//if (tAttribute=="_y" && tState==3) trace(this["id"]+" - "+_name+" - "+tAttribute+" set to "+tData[tAttribute])
			}
		}
		stateTable[tState]=tData;		
		var tDuplicateData={};
		//
		for (var tAttribute in tData) {
			var tAttributeValue=tData[tAttribute];
			
			tDuplicateData[tAttribute]=tAttributeValue;
			
			//trace("Setting "+tAttribute+" to "+tDuplicateData[tAttribute]+" from "+tAttributeValue)
		}
		originalStateTable[tState]=tDuplicateData;
	}
	
	/** 
	* Resets all states the original values of creation, if they have been modified
	*/
	function restoreOriginalStates() {
		for (var i=0;i<stateTable.length;i++) {
			var tState=stateTable[i];
			var tOriginalState=originalStateTable[i];
						
			for (var tAttribute in tState) {
				var tOriginalValue=tOriginalState[tAttribute];
				if (tOriginalValue!=undefined) {
//					trace("Restoring "+tAttribute+" to "+tOriginalValue)
					tState[tAttribute]=tOriginalValue;
				}
			}
		}
	}
	/** 
	* Modify all states by the value of each attribute within the propertylist, for example if {_y:-30} was sent as the value of
	* tPropertyList, it would cause the aim y position of each state to be decreased by 30
	* @param tPropertyList The property list of all changes
	*/
	function modifyStatesRelative(tPropertyList) {
		
		for (var i=0;i<stateTable.length;i++) {
			for (var tAttributeName in tPropertyList) {
				var tState=stateTable[i];				
			}
		}
		
		for (var i=0;i<stateTable.length;i++) {
			var tState=stateTable[i];
			// State 1 is a duplicate. ignore
			if (i!=1) {
				for (var tAttributeName in tPropertyList) {
					tState[tAttributeName]+=tPropertyList[tAttributeName];
					//animatedAttributeList[tAttributeName].value=tPropertyList[tAttributeName]
					// Modify the attribute relatively
					//trace("Adding "+tPropertyList[tAttributeName]+" to property "+tAttributeName+" state "+i+" now is "+tState[tAttributeName])
					//tState[tAttributeName]+=tPropertyList[tAttributeName];
				}
			}
		}
	}
	
	/** 
	* Cause the movieclip to jump immediately to a given state
	* @param tState The State index	
	*/
	function jumpToState(tState) {

		currentAimStateData=stateTable[tState];
		
		// Aim each dynamic attribute at this value
		for (var tAttribute in currentAimStateData) {
			var tAimValue=currentAimStateData[tAttribute];
			animatedAttributeList[tAttribute].value=animatedAttributeList[tAttribute].aimValue=tAimValue;
			this[tAttribute]=tAimValue;
			//trace("Setting "+tAttribute+" to "+tAimValue)
		}
	}
	
	/** 
	* Directly set the attributes of the movieclip
	* @param tPropertyList The property list of all changes
	*/
	function setProperties(tPropertyList) {
		for (var tAttributeName in tPropertyList) {
			animatedAttributeList[tAttributeName].value=tPropertyList[tAttributeName]
			this[tAttributeName]=tPropertyList[tAttributeName];
		}
	}
	/** 
	* Add a new animationAttribute to represent a property of the movieclip
	* @param tAttributeName The name of the property/variable that will be animated
	* @param tAttributeValue The initial value of the property/variable that will be animated
	*/
	function addDynamicAttribute(tAttributeName,tAttributeValue) {
		tAttributeName=""+tAttributeName;
		
		if (animatedAttributeList[tAttributeName]==null) {
			// Use the default value as the dynamic attribute
			var defaultState=stateTable[0];
			var tValue=defaultState[tAttributeName];
			if (tValue==null) {
				tValue=defaultState[tAttributeName]=this[tAttributeName];
				//trace(_name+" VALUE '"+tAttributeName+"' WAS NULL : NOW "+tValue)
			}
			//trace("adding attribute "+tAttributeName+" value "+tValue)
			var tDifference=Math.abs(tAttributeValue-tValue);
			var tThreshold=tDifference*thresholdPercentage;
			if (tThreshold<0.1) tThreshold=0.1;
			
			var tDynamicAttribute:animationDynamicAttribute=new animationDynamicAttribute(tValue,progressionType,progressionParam1,progressionParam2,tThreshold);
			
			animatedAttributeList[tAttributeName]=tDynamicAttribute;
			//animatedAttributeList.push(tDynamicAttribute);
			//animatedAttributeNameList.push(tAttributeName);
			//animatedAttributeNameList[
			//animatedAttributeNameList[tAttributeName]=animatedAttributeList.length-1;
			
			//trace("Total attributes now: "+animatedAttributeNameList.length)
		}
	}
	/** 
	* Function to be implemented by individual movieclips or subclasses
	*/
	function animationComplete():Void {
		// Overwritten
	}
	/** 
	* Function to be implemented by individual movieclips or subclasses
	*/
	function animationStep():Void {
		// Overwritten
	}
	

}