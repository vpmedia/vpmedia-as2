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
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;

/**
 * @often_name dv
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.data.DynamicValue extends MIBroadcastClass implements MIValueOwner {
	
	public var event_ValueChange:Object={name:'ValueChange'};
	
	public var name : String;
	public var value : MIValue;
	
	public function DynamicValue($iniValue, $name:String) {
		value=(new MIValue(null, false, $iniValue)).setOwner(this);
		if($name){
			name=$name;
			_global.pl.milib.dbg.DynamicValuesDBG.getInstance().regDynamicValue(this);
		}
	}//<>
	
//****************************************************************************
// EVENTS for DynamicValue
//****************************************************************************
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		bev(event_ValueChange);
	}//<<

}