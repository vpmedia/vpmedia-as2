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
import pl.milib.dbg.MethodWatcher;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.dbg.window.contents.DBGWindowMethodsContent;
import pl.milib.mc.buttonViews.ButtonViewFourFrames;
import pl.milib.mc.MCCheck;
import pl.milib.mc.MCCheckOwner;
import pl.milib.mc.MCListElement;
import pl.milib.mc.service.MIButton;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.MethodsListElement extends MCListElement implements MCCheckOwner {

	private var btnExe : MIButton;
	private var owner : DBGWindowMethodsContent;
	private var birdIsWatched : MCCheck;
	
	public function MethodsListElement(owner:DBGWindowMethodsContent) {
		this.owner=owner;
	}//<>
	
	private function doDataType(Void):Void {
		switch(data.type){
			case owner.eleDataType_method:
				mc.gotoAndStop(1);
				btnExe=MIButton.forInstance(mc.btnExe);
				btnExe.addListener(this);
				btnExe.addButtonView(new ButtonViewFourFrames(mc.btnExe));
				birdIsWatched=new MCCheck(this, mc.isWatched, MethodWatcher(data.mw).areShowEnabled);
				TextField(mc.tfName).autoSize=true;
			break;
			case owner.eleDataType_title:
				birdIsWatched.getDeleter().DELETE();				delete birdIsWatched;
				mc.gotoAndStop(2);
			break;
		}
	}//<<
	
	public function doData(Void):Void {
		switch(data.type){
			case owner.eleDataType_method:
				mc.tfName.text=data.name;				mc.btnExe._x=mc.tfName._x+mc.tfName._width+5;
				birdIsWatched.setupMIBool(MethodWatcher(data.mw).areShowEnabled);
			break;
			case owner.eleDataType_title:
				mc.tfName.htmlText=MIDBGUtil.formatClassNameText(data.name);
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
						MethodWatcher(data.mw).exe();
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MCCheck_Change(bird:MCCheck) {
		bird.setIsTaggedBySwitch();
	}//<<

}