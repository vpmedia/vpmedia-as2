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
import pl.milib.runningControll.MainSubsRunningController;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.runningControll.BlockFinishIfSubsRunning_AutoFinishSubs extends MainSubsRunningController {
	
	public function BlockFinishIfSubsRunning_AutoFinishSubs(mainRunner:MIRunningClass) {
		setMainRunner(mainRunner);
	}//<>
	
//****************************************************************************
// EVENTS for SubsFinishWatcher
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		switch(ev.hero){
			case mainRunner:
				switch(ev.event){
					case mainRunner.question_PermissionToFinish:
					var runningSubs:Array=getRuningSubs();
					if(runningSubs.length){
						ev.data=mainRunner.answer_PermissionToFinish_Deny;
						while(runningSubs.length){
							MIRunningClass(runningSubs.shift()).finish();
						}
					}
				}
			break;
			case subs:
				var subRunner:MIRunningClass=MIRunningClass(ev.data.hero);
				switch(ev.data.event){
					case subRunner.event_RunningFinish:
						if(!mainRunner.getIsRunningFlag()){ 
							mainRunner.finish();
						}
					break;
				}
			break;
		}
		//super.onEvent(ev);
	}//<<Events
	
}