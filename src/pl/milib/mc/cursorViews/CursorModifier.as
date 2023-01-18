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
import pl.milib.data.info.MIEventInfo;
import pl.milib.managers.CursorManager;
import pl.milib.managers.MouseManager;
import pl.milib.mc.abstract.AbstractButton;

/**
 * @often_name cursorMode*
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.cursorViews.CursorModifier extends MIRunningClass {
	
	//broadcasted when cursor is change to over
	public var event_Over:Object={name:'Over'};
	
	//broadcasted when cursor is change to down
	public var event_Down:Object={name:'Down'};

	public var overID : String;
	public var downID : String;
	private var mm : MouseManager;
	private var button : AbstractButton;
	
	public function CursorModifier($overID:String, $downID:String) {
		overID=$overID;		downID=$downID;
		mm=MouseManager.getInstance();
	}//<>
	
	private function doStart(Void):Boolean {
		if(button){
			button.addListener(this);
		}
		if(mm.isDown){ setDown(); }else{ setOver(); }
		mm.addListener(this);
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		if(button){
			button.removeListener(this);
		}
		mm.removeListener(this);
		return true;
	}//<<
	
	public function setupButton(button:AbstractButton):Void {
		this.button.removeListener(this);
		this.button=button;
		this.button.addListener(this);
	}//<<
	
	private function setOver(Void):Void {
		bev(event_Over);
		if(overID){
			CursorManager.getInstance().setCursor(overID);
		}else{
			CursorManager.getInstance().setStandardCursor();
		}
	}//<<
	
	private function setDown(Void):Void {
		bev(event_Down);
		if(downID){
			CursorManager.getInstance().setCursor(downID);
		}else{
			CursorManager.getInstance().setStandardCursor();
		}
	}//<<
	
//****************************************************************************
// EVENTS for CursorModifier
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mm:
				switch(ev.event){
					case mm.event_Down:
						setDown();
					break;
					case mm.event_Up:
						setOver();	
					break;
				}
			break;
		}
	}//<<Events
	
}