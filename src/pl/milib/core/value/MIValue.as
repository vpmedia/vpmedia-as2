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

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.core.value.MIValueOwner;
import pl.milib.data.info.MIEventInfo;

/**
 * @often_name val
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.core.value.MIValue extends MIBroadcastClass {
	
	//invoked when value is change
	//DATA: Object
	public var event_ValueChanged:Object={name:'ValueChanged'};
	
	//invoked on value event
	//DATA: MIEventInfo //reflected event
	public var event_ValueEvent:Object={name:'ValueEvent'};
		public var defaultValue=null;
	private var valueProp;
	public var isValueEventsReflect : Boolean;
	private var owner : MIValueOwner;
	
	public function MIValue($defaultValue, $isValueEventsReflect:Boolean, $iniValue) {
		if($defaultValue){ defaultValue=$defaultValue; }
		isValueEventsReflect=Boolean($isValueEventsReflect);
		valueProp=$iniValue==null ? defaultValue : $iniValue;
	}//<>
	
	public function setOwner(owner:MIValueOwner):MIValue {
		this.owner=owner;
		return this;
	}//<<
	
	public function set v(newValue){
		if(valueProp==newValue){ return; }
		var oldValue=valueProp;
		oldValue.removeListener(this);
		valueProp=newValue;
		if(isValueEventsReflect){
			newValue.addListener(this);
		}
		bev(event_ValueChanged, oldValue);
		owner.onSlave_MIValue_ValueChange(this, oldValue);
	}//<<
	public function setValueByDefault(Void):Void {
		v=defaultValue;
	}//<<
	
	public function get v(Void){
		return valueProp;
	}//<<
	
	public function gotValue(Void):Boolean {
		return !(valueProp===defaultValue);
	}//<<
	
	public function valueOf(Void):Number {
		return v;
	}//<<
	
	public function apply(Void):Void {
		bev(event_ValueChanged);
		owner.onSlave_MIValue_ValueChange(this, null);
	}//<<
	
//****************************************************************************
// EVENTS for MIValue
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case valueProp:
				bev(event_ValueEvent, ev);
			break;
		}
	}//<<Events
	
}