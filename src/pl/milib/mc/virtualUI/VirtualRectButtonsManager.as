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

import pl.milib.collection.MIObjects;
import pl.milib.core.MIObjSoul;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.managers.MouseManager;
import pl.milib.mc.virtualUI.VirtualRectButton;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.virtualUI.VirtualRectButtonsManager extends MIBroadcastClass {
	
	private static var instance : VirtualRectButtonsManager;
	private var btns : MIObjects; //of VirtualRectButton
	private var mm : MouseManager;
	private var currentBtn : MIObjSoul ;//VirtualRectButton; 
	
	private function VirtualRectButtonsManager() {
		btns=new MIObjects();
		btns.addListener(this);
	}//<>
	
	public function regButton(btn:VirtualRectButton):Void {
		btns.addObject(btn);
	}//<<
	
	public function unregButton(btn:VirtualRectButton):Void {
		btns.removeObject(btn);
	}//<<
	
	public function isSetNewOver(btn:VirtualRectButton):Boolean {
		if(currentBtn.o){
			var btnsArr:Array=btns.getArray();
			var mcs:Array=[];
			for(var i=0;i<btnsArr.length;i++){
				mcs.push(btnsArr[i].mimc.mc);
			}
			var hiMC:MovieClip=MIMCUtil.getHighestMCFromMCS(mcs);
			if(hiMC==currentBtn.o.mimc.mc){
				return false;
			}else if(hiMC==btn.mimc.mc){
				return true;
			}
		}else{
			return true;
		}
	}//<<
	
	/** @return singleton instance of VirtualRectButtonsManager */
	public static function getInstance(Void):VirtualRectButtonsManager {
		if (instance == null){ instance = new VirtualRectButtonsManager(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for VirtualRectButtonsManager
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btns:
				var hero:VirtualRectButton=VirtualRectButton(ev.data.hero);
				switch(ev.data.event){
					case hero.event_Over:
						if(currentBtn.o){
							currentBtn.o.doArtificialOut();
						}
						currentBtn=MIObjSoul.forInstance(hero);
					break;
					case hero.event_OutAndRelease:
						if(hero==currentBtn.o){
							delete currentBtn;
						}
					break;
				}
			break;
		}
	}//<<Events
	
}