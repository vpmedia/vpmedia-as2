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

import pl.milib.core.supers.MIRunningClass;
import pl.milib.core.value.MIValue;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.data.CurrentAndTargetValue extends MIRunningClass {
	
	//START means deleting current value
	//FINISH means that target value is changed to current
		public var event_TargetValueIsChangedToCurrent:Object={name:'TargetValueIsChangedToCurrent'};	public var event_BeforeTargetValueIsChangedToCurrent:Object={name:'BeforeTargetValueIsChangedToCurrent'};
	
	public var currentValue : MIValue;
	public var targetValue : MIValue;
	
	public function CurrentAndTargetValue($initialCurrentValue, $initialTargetValue) {
		currentValue=new MIValue();		targetValue=new MIValue();
		if($initialCurrentValue!=null){ currentValue.v=$initialCurrentValue; }		if($initialTargetValue!=null){ targetValue.v=$initialTargetValue; }
	}//<>
	
	public function setTargetValue(value):Boolean {
		if(targetValue.v===value || currentValue.v===value || value==null){ return false; };		targetValue.v=value;
		start();		if(!currentValue.gotValue()){ setTargetAsCurrent(); }
		return true;
	}//<<
	
	public function gotTargetValue(Void):Boolean {
		return true;
	}//<<
	
	public function setTargetAsCurrent(Void):Void {
		finish();
	}//<<
	
	private function doFinish(Void):Boolean {
		bev(event_BeforeTargetValueIsChangedToCurrent);
		currentValue.v=targetValue.v;
		targetValue.setValueByDefault();
		bev(event_TargetValueIsChangedToCurrent);
		return true;
	}//<<
	
}