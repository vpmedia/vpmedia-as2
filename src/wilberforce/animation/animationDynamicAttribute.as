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
* Class to hold an animatable attribute, and perform steps
* to animate to different values
*/
class wilberforce.animation.animationDynamicAttribute {
	var value:Number;
	var initialValue:Number;
	var aimValue:Number;
	
	var progressionType:Number;
	
	static var LINEAR_PROGRESSION:Number=1;
	static var ELASTIC_PROGRESSION:Number=2;
	static var EASEOUT_PROGRESSION:Number=3;
	
	var progressionData,progressionFunction;
	
	/** 
	* Create a new animationDynamicAttribute
	* @param tValue The initial value of the attribute
	* @param tProgressionType The type of progression - Linear, Elastic or Easeout
	* @param tArg1 Parameters of progression (for Linear this is number of steps, for elastic this is spring, for easeout this is the division per frame
	* @param tArg2 Parameters of progression (for elastic and easeout this is the percentage threshold 
	*/
	function animationDynamicAttribute(tValue,tProgressionType,tArg1,tArg2,tThreshold1) {
		aimValue=initialValue=value=tValue;		
		progressionType=tProgressionType
//		trace("Attribute constructed "+tValue+","+tProgressionType+","+tArg1+","+tArg2);
		switch (tProgressionType) {
			case LINEAR_PROGRESSION:
				progressionFunction=linearProgressionFunction;			
				progressionData={steps:tArg1,stepsLeft:0};
//				trace("STEPS "+progressionData.steps);
				break;
			case ELASTIC_PROGRESSION:
				progressionFunction=elasticProgressionFunction;
				progressionData={spring:tArg1,damping:tArg2,velocity:0,threshold:tThreshold1};
				break;
			case EASEOUT_PROGRESSION:
				progressionFunction=easeOutProgressionFunction;
				progressionData={factor:tArg1,threshold:tThreshold1};
				break;
		}
	}
	/**
	* Sets the value for the animation attribute to aim at
	*/
	function aimAt(tValue) {
		aimValue=tValue;
		switch (progressionType) {
			case LINEAR_PROGRESSION:
				
				var dValue=(tValue-value)/progressionData.steps;
				progressionData.stepsLeft=progressionData.steps;
				progressionData.stepValue=dValue;
				//trace("STEPS "+progressionData.steps+" SVAL - "+dValue+" aim "+tValue);
				break;				
		}		
	}
	
	/** Individual step according to current progression
	*/
	public function step() {
		//trace("STEP "+value+" threshold "+progressionData.threshold+" aim: "+aimValue);
		// Are we within the threshold. returns true if so
		 return progressionFunction();
		
	}
	function setThreshold() {
	
	}
	/**
	* Progression function for linear animation. Called by step
	*/
	private function linearProgressionFunction() {
		
		if (progressionData.stepsLeft<=0) return true;
		//trace("LINEAR PROGRESSION "+progressionData.stepsLeft)
		value+=progressionData.stepValue;
		progressionData.stepsLeft--;
		//trace("LINEAR PROGRESSION "+progressionData.stepsLeft+" : "+value)
		if (progressionData.stepsLeft<=0) return true
		else return false;
	}
	/**
	* Progression function for elastic animation. Called by step
	*/
	private function elasticProgressionFunction() {
		var dValue=aimValue-value;
		//trace("dvalue is "+dValue)
		var acceleration=dValue*progressionData.spring-progressionData.velocity*progressionData.damping;
		progressionData.velocity+=acceleration;
		value+=progressionData.velocity;
		
		if (Math.abs(dValue)<=progressionData.threshold) {value=aimValue;return true;}
		else return false;
		// Test to see if its within a threshold
		
	}
	/**
	* Progression function for easing-out animation. Called by step
	*/
	private function easeOutProgressionFunction() {
		var dValue=aimValue-value;
		//trace("dvalue "+dValue+" aiming at "+aimValue)
		value+=dValue/progressionData.factor;
		if (Math.abs(dValue)<=progressionData.threshold) {value=aimValue;return true;}
		else return false;
	}
	
}