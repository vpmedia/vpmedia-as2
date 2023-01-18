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
import pl.milib.data.info.MIEventInfo;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.managers.KeyManager;
import pl.milib.managers.MouseManager;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.DBGMCSelector extends MIBroadcastClass implements MIValueOwner {
	
	public var event_KeyUpWhenEnabled:Object={name:'KeyUpWhenEnabled'};	public var event_MouseDownWhenEnabled:Object={name:'MouseDownWhenEnabled'};
	
	private static var instance : DBGMCSelector;
	public var areEnabled : MIBooleanValue;
	private var mm : MouseManager;
	private var km : KeyManager;
	private var selectedMC : MovieClip;
	
	private function DBGMCSelector() {
		areEnabled=(new MIBooleanValue()).setOwner(this);
		mm=MouseManager.getInstance();		km=KeyManager.getInstance();
		
	}//<>
	
	public function getCurrentMC(Void):MovieClip {
		var cmc:MovieClip=_root;		var isHit:Boolean;
		while(true){
			isHit=false;
			for(var i in cmc){
				if(cmc[i]._parent==cmc){
					if(cmc[i].hitTest(MIMCUtil.getXRoot(cmc[i], cmc[i]._xmouse), MIMCUtil.getYRoot(cmc[i], cmc[i]._ymouse), true) && i!='milibMC' && i!='MCForCursorManager'){
						cmc=cmc[i];
						isHit=true;
						break;
					}
				}
				if(isHit){ break; }
			}
			if(!isHit){ break; }
		}
		return cmc;
	}//<<
	
	private function selectCurrentMC(Void):Void {
		km.addListener(this);		mm.addListener(this);
		var selMC:MovieClip=getCurrentMC();
		if(selectedMC!=selMC){
			MIDBGUtil.deselectMC(selectedMC);
			selectedMC=selMC;
			MIDBGUtil.selectMC(selectedMC);
		}
	}//<<
	
	private function deselectCurrentMC(Void):Void {
		MIDBGUtil.deselectMC(selectedMC);
	}//<<
	
	/** @return singleton instance of DBGMCSelector */
	public static function getInstance(Void):DBGMCSelector {
		if(instance==null){ instance=new DBGMCSelector(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for DBGMCSelector
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mm:
				switch(ev.event){
					case mm.event_Move:
						selectCurrentMC();
					break;
					case mm.event_Down:
						bev(event_MouseDownWhenEnabled);
					break;
				}
			break;
			case km:
				switch(ev.event){
					case km.event_Up:
						bev(event_KeyUpWhenEnabled);
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		if(areEnabled.v){
			km.addListener(this);
			mm.addListener(this);
			selectCurrentMC();
		}else{
			km.removeListener(this);
			mm.removeListener(this);
			deselectCurrentMC();
		}
	}//<<
	
}
