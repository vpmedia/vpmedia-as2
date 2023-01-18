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

import pl.milib.data.DynamicValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.MCListElement;
import pl.milib.mc.service.MITextField;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.DynamicValueListElement extends MCListElement {

	private var data : DynamicValue;
	private var mitfValue : MITextField;

	public function DynamicValueListElement() {
		
	}//<>
	
	private function doSetupMC(Void):Void {
		enable();
		mitfValue=MITextField.forInstance(mc.tfValue);
		mitfValue.addListener(this);
	}//<<
	
	public function doData(Void):Void {
		mc.tfName.autoSize=true;
		mc.tfName.text=data.name;		mc.tfValue.text=data.value.v;
		mc.tfValue._width=mc.bg._width-mc.tfValue._x;		mc.tfValue._x=mc.tfName._width;
	}//<<
//	private function unregData(oldData:DynamicValue):Void {}//<<
	
	public function disable(Void):Void {
		mitfValue.getDeleter().DELETE(); delete mitfValue;
		super.disable();
	}//<<
	
	public function setWidth(width:Number):Void {
		mc.bg._width=width;		mc.tfValue._width=width-mc.tfValue._x;
	}//<<
	
//****************************************************************************
// EVENTS for EaseListElement
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mitfValue:
				switch(ev.event){
					case mitfValue.event_SetFocus:
						mitfValue.tf.background=true;
					break;
					case mitfValue.event_KillFocus:
						mitfValue.tf.background=false;
					break;
					case mitfValue.event_UserChanged:
						if(!isNaN(Number(mitfValue.text))){
							data.value.v=Number(mitfValue.text);
						}else{
							data.value.v=mitfValue.text;
						}
					break;
				}
			break;
		}
	}//<<Events
	
}