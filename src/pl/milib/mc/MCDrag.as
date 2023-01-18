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
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.abstract.AbstractButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualDrag;

/**
 * @author Marek Brun
 */
class pl.milib.mc.MCDrag extends MIBroadcastClass {
	
	public var mimc : MIMC;
	public var vd : VirtualDrag;
	private var btn : AbstractButton;
	
	public function MCDrag(btn:AbstractButton, mc:MovieClip) {
		mimc=MIMC.forInstance(mc);
		vd=new VirtualDrag(mc);
		vd.addListener(this);
		this.btn=btn;
		btn.addListener(this);
	}//<>
	
//****************************************************************************
// EVENTS for MCDrag
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				switch(ev.event){
					case btn.event_Press:
						vd.start();
					break;
					case btn.event_ReleaseAll:
						vd.stop();
					break;
				}
			break;
			case vd:
				switch(ev.event){
					case vd.event_NewDragXY:
						mimc.mc._x=vd.getX();
						mimc.mc._y=vd.getY();
					break;
				}
			break;
		}
	}//<<Events
	
}