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
import pl.milib.managers.MouseManager;
import pl.milib.mc.virtualUI.VirtualUI;

/**
 * @often_name viDrag
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.virtualUI.VirtuaUIlDrag extends VirtualUI {
	
	//nastąpiło rozpoczęcie przesuwania
	public var event_Start:Object={name:'Start'};
	
	//nastąpiło przesunięcie
	public var event_NewDragXY:Object={name:'NewDragXY'};
	
	//nastąpiło zatrzymanie przesuwania
	public var event_Finish:Object={name:'Finish'};
	
	private var isDraged:Boolean;
	private var iniMouseX : Number;
	private var iniMouseY : Number;
	private var mm : MouseManager;
	
	public function VirtualDrag(Void){
		isDraged=false;
		mm=MouseManager.getInstance();
	}//<>
	
	public function setupStart(Void):Void {
		mm.addListener(this);
		isDraged=true;
		bev(event_Start);
	}//<<
	
	public function getVX(Void):Number {
		if(isDraged){ return iniMouseX-_root._xmouse; }		else{  return 0; }
	}//<<
	
	public function getVY(Void):Number {
		if(isDraged){ return iniMouseY-_root._ymouse; }
		else{  return 0; }
	}//<<
	
//****************************************************************************
// EVENTS for VirtualDrag
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		switch(ev.hero){
			case mm:
				switch(ev.event){
					case mm.event_Move:
						bev(event_NewDragXY);
					break;
					case mm.event_Up:						
						mm.removeListener(this);
						isDraged=false;
						bev(event_Finish);
					break;
				}
			break;
		}
		//super.onEvent(ev);
	}//<<Events
	
}
