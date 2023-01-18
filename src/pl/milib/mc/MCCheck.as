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
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.MCCheckOwner;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;

/**
 * @often_name check
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCCheck extends MIBroadcastClass {
	
	private var btn : MIButton;
	private var owner : MCCheckOwner;
	private var mibool : MIBooleanValue;
	private var mc : MovieClip;
	private var mimc : MIMC;
	private var mimcAnim : MIMC;
	
	public function MCCheck(owner:MCCheckOwner, mc:MovieClip, $mibool:MIBooleanValue) {
		this.owner=owner;
		mimc=MIMC.forInstance(mc);		mimcAnim=mimc.getMIMC('anBird');
		mimcAnim.gotoAndStop(1);
		btn=MIButton.forInstance(mc.btn);
		btn.addListener(this);
		
		setupMIBool($mibool==null ? (new MIBooleanValue(false)) : $mibool);
		
		addDeleteTogether(mimc);
	}//<>
	
	public function setupMIBool(mibool:MIBooleanValue):Void {
		this.mibool.removeListener(this);
		this.mibool=mibool;
		mibool.addListener(this);
		
		if(mibool.v){
			mimcAnim.gotoLastFrame();
		}else{
			mimcAnim.gotoAndStop(1);
		}
	}//<<
	
	public function setIsTagged(isTagged:Boolean):Void{
		mibool.v=isTagged;
	}//<<
	public function setIsTaggedBySwitch(Void):Void{
		mibool.sWitch();
	}//<<
	
//****************************************************************************
// EVENTS for Bird
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				switch(ev.event){
					case btn.event_Press:
						owner.onSlave_MCCheck_Change(this);
					break;
				}
			break;
			case mibool:
				switch(ev.event){
					case mibool.event_ValueChanged:						
						if(mibool.v){
							mimcAnim.playTo();
						}else{
							mimcAnim.gotoAndStop(1);
						}
					break;
				}
			break;
		}
	}//<<Events
	
}