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
import pl.milib.mc.service.MIMC;

/**
 * @author Marek Brun
 */
class pl.milib.mc.MCPlayTo extends MIRunningClass {
	
	public var mimc : MIMC;
	private var frameBase : Number;
	private var frameEnd : Number;
	
	public function MCPlayTo(mc:MovieClip) {
		if(mc!=null){ setupMC(mc); }
	}//<>
	
	public function setupMC(mc:MovieClip, $frameBase:Number, $frameEnd:Number) {
		frameBase=$frameBase==null ? 1 : $frameBase;		frameEnd=$frameEnd==null ? mc._totalframes : $frameEnd;
		mimc=MIMC.forInstance(mc);
		mimc.addListener(this);
		if(isRunning){ mimc.playTo(frameEnd); }
		else{ mimc.playTo(frameBase); }
		
	}//<<
	
	private function doStart(Void):Boolean {
		mimc.playTo(frameEnd);
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		if(mimc.mc._currentframe==frameBase){
			return true;
		}else{
			mimc.playTo(frameBase);
			return false;
		}
	}//<<
	
//****************************************************************************
// EVENTS for MCPlayTo
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mimc:
				switch(ev.event){
					case mimc.event_EnterNewFrame:
						if(mimc.mc._currentframe==frameBase){
							if(isRunningFlag){
								mimc.playTo(frameEnd);
							}else{
								finish();
							}
						}
					break;
				}
			break;
		}
	}//<<Events
	
}