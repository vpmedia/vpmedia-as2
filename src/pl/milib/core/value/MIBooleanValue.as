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

import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.core.value.MIBooleanValue extends MIValue {
	
	public function MIBooleanValue($iniValue:Boolean) {
		super(null, false, $iniValue);
	}//<>
	
	public function set v(newValue:Boolean){
		if(valueProp==newValue){ return; }
		valueProp=newValue;
		bev(event_ValueChanged);
		owner.onSlave_MIValue_ValueChange(this);
	}//<<
	
	public function get v(Void):Boolean {
		return valueProp;
	}//<<
	
	public function valueOf(Void):Boolean {
		return v;
	}//<<
	
	public function setOwner(owner:MIValueOwner):MIBooleanValue {
		this.owner=owner;
		return this;
	}//<<
	
	public function sWitch(Void):Void {
		v=!v;
	}//<<
}