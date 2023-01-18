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
class pl.milib.core.value.MINumberValue extends MIValue {

	private var minNum : Number;
	private var maxNum : Number;
	
	public function MINumberValue($defaultValue:Number, $iniValue:Number) {
		super($defaultValue, false, $iniValue);
	}//<>
	
	public function setupMinNumber(num:Number):Void {
		minNum=num;
	}//<<
	
	public function setupMaxNumber(num:Number):Void {
		maxNum=num;
	}//<<
	
	public function setupMaxMinNumber(min:Number, max:Number):Void {
		setupMaxNumber(max);		setupMinNumber(min);
	}//<<
	
	public function setOwner(owner:MIValueOwner):MINumberValue {
		this.owner=owner;
		return this;
	}//<<
	
	public function set v(newValue:Number){
		if(valueProp==newValue){ return; }
		if(isNaN(newValue)){ newValue=0; }
		if(minNum!=null && newValue<minNum){ newValue=minNum;  if(valueProp==newValue){ return; } }		else if(maxNum!=null && newValue>maxNum){ newValue=maxNum;  if(valueProp==newValue){ return; } }
		var oldValue=valueProp;
		valueProp=newValue;
		bev(event_ValueChanged, oldValue);
		owner.onSlave_MIValue_ValueChange(this);
	}//<<
	
	public function get v(Void):Number{
		return valueProp;
	}//<<
	
	public function valueOf(Void):Number {
		return v;
	}//<<
	
	
}