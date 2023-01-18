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
import pl.milib.mc.buttonViews.ButtonViewContrast;
import pl.milib.mc.MCListElement;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCDropDownListElement extends MCListElement {

	private var btn : MIButton;

	public function MCDropDownListElement() {
		
	}//<>
	
	private function doSetupMC(Void):Void {
		enable();
		btn=MIMC.forInstance(mc).getMIButton('bg');
		btn.addButtonView(new ButtonViewContrast(mc));
		btn.addListener(this);
	}//<<
	
	public function doData(Void):Void {
		mc.tfName.htmlText=data.title;
	}//<<
	
	//public function enable(Void):Void {}//<<
	
	public function setWidth(width:Number):Void {
		mc.bg._width=width;
	}//<<
	
//****************************************************************************
// EVENTS for EaseListElement
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				switch(ev.event){
					case btn.event_Press:
						bev(event_Select);
					break;
				}
			break;
		}
	}//<<Events
	
}