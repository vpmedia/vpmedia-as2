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
import pl.milib.managers.KeyManager;
import pl.milib.tools.KeyboardShortcut;

/** @author Marek Brun 'minim' */
class pl.milib.tools.KeyboardShortcuts extends MIBroadcastClass {
	
	//nastąpiło wciśnięcie podanego skrutu klawiaturowego
	//DATA:	KeyboardShortcut
	public var event_ShortcutPress:Object={name:'ShortcutPress'};
	
	private var isEnabled : Boolean;
	private var shortcuts : Array;
	private var km : KeyManager;
	
	public function KeyboardShortcuts() {
		shortcuts=[];
		km=KeyManager.getInstance();
	}//<>
	
	public function addShortcut(shortcut:KeyboardShortcut){
		if(!shortcuts[shortcut.key]){ shortcuts[shortcut.key]=[]; }
		shortcuts[shortcut.key].push(shortcut);
		shortcuts[shortcut.key].sortOn('keysLength', Array.NUMERIC);
		shortcuts[shortcut.key].reverse();
	}//<<
	
	/** @param shortcuts Array of KeyboardShortcut */
	public function addShortcuts(shortcuts:Array){
		for(var i=0,shortcut:KeyboardShortcut;shortcut=shortcuts[i];i++){
			addShortcut(shortcut);
		}
	}//<<
	
	public function setIsEnabled(bool:Boolean):Void{
		if(isEnabled==bool){ return; }
		isEnabled=bool;
		if(isEnabled){
			KeyManager.getInstance().addListener(this);
		}else{
			KeyManager.getInstance().removeListener(this);
		}
	}//<<
	
//****************************************************************************
// EVENTS for KeyboardShortcuts
//****************************************************************************
	private function onEvent(ev:MIEventInfo):Void{
		switch(ev.hero){
			case km:
				switch(ev.event){
					case km.event_Down:
						var code:Number=ev.data.code;
						if(shortcuts[code]){
							for(var i=0,i2,shortcut:KeyboardShortcut,isPassed;shortcut=shortcuts[code][i];i++){
								if(!shortcut.getIsEnabled()){ continue; }
								isPassed=true;
								for(i2=0;i2<shortcut.keysLength;i2++){
									if(!Key.isDown(shortcut.keys[i2])){
										isPassed=false;
										break;
									}
								}
								if(isPassed){
									if(log.isInfoEnabled()){ logHistory('ShortcutPress shortcut.desc>'+shortcut.desc); }
									bev(event_ShortcutPress, shortcut);
									break;
								}
							}
						}
					break;
				}
			break;
		}
	}//<<Events KeyManager
	
}