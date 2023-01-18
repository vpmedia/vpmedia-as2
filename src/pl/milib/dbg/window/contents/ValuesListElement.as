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

import pl.milib.data.info.MIEventInfo;
import pl.milib.dbg.window.contents.DBGWindowValuesContent;
import pl.milib.mc.MCListElement;
import pl.milib.mc.service.MIButton;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.ValuesListElement extends MCListElement {

	private var btnExe : MIButton;
	private var owner : DBGWindowValuesContent;
	
	public function ValuesListElement(owner:DBGWindowValuesContent) {
		this.owner=owner;
	}//<>
	
	private function doSetupMC(Void):Void {
		mc.gotoAndStop(mc._totalframes);
	}//<<
	
	public function doDataType(Void):Void {
		switch(data.type){
			case owner.eleDataType_value:
				mc.gotoAndStop(1);
				TextField(mc.tfName).autoSize=true;				TextField(mc.tfValue).autoSize=true;
			break;
			case owner.eleDataType_title:
				mc.gotoAndStop(2);
				TextField(mc.tfName).autoSize=true;
			break;
		}
	}//<<
	
	private function doData(Void):Void {
		switch(data.type){
			case owner.eleDataType_value:
				mc.tfName.text=data.name;
				//num:Number, name:String, value, senderSoulObj
				mc.tfValue.htmlText=data.value;
				mc.tfValue._x=mc.tfName._x+mc.tfName._width+5;
			break;
			case owner.eleDataType_title:
				mc.tfName.text=data.name;
			break;
		}
	}//<<
	
	public function enable(Void):Void {}//<<
	
	public function setWidth(width:Number):Void {
		mc.bg._width=width;
	}//<<
	
//****************************************************************************
// EVENTS for MethodsListElement
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btnExe:
				switch(ev.event){
					case btnExe.event_Press:
						
					break;
				}
			break;
		}
	}//<<Events
	
}