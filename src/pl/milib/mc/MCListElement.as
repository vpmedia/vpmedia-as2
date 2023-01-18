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
import pl.milib.core.value.MIBooleanValue;
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;

/** @author Marek Brun 'minim' */
class pl.milib.mc.MCListElement extends MIBroadcastClass implements MIValueOwner {
	
	public var event_Select:Object={name:'Select'};
	
	private var mc : MovieClip;
	private var num : Number;
	public var areEnabled : MIBooleanValue;
	private var data : Object;
	private var dataType : MIValue;
	private var dataWatch : MIValue;
	
	private function MCListElement() {
		areEnabled=(new MIBooleanValue()).setOwner(this);
		dataType=(new MIValue()).setOwner(this);		dataWatch=(new MIValue()).setOwner(this);
	}//<>
	/*abstract*/ public function doData(Void):Void {}//<<	/*abstract optional*/ public function doDataType(dataType:Object):Void { }//<<
	/*abstract optional*/ public function setWidth(width:Number):Void {}//<<
	/*abstract optional*/ private function doSetupMC(Void):Void {}//<<
	/*abstract optional*/ private function unregData(oldData):Void {}//<<
	
	private function disable(Void):Void {
		mc.gotoAndStop(mc._totalframes);
	}//<<
	
	private function enable(Void):Void {
		mc.gotoAndStop(1);
	}//<<
	
	public function setup(mc:MovieClip, num:Number):MCListElement {
		this.mc=mc;
		this.num=num;
		disable();
		doSetupMC();
		return this;
	}//<<
	
	public function getListNum(Void):Number {
		return num;
	}//<<
	
	public function setData(data):Void {
		dataWatch.v=data;
		this.data=data;
		dataType.v=data.type;
		doData();
		areEnabled.v=true;
	}//<<
	
//****************************************************************************
// EVENTS for MCListElement
//****************************************************************************
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		switch(val){
			case dataWatch:
				unregData(oldValue);
			break;
			case dataType:
				doDataType(dataType.v);
			break;
			case areEnabled:
				if(areEnabled.v){
					enable();
				}else{
					dataType.v=null;
					disable();
				}
			break;
		}
	}//<<

}