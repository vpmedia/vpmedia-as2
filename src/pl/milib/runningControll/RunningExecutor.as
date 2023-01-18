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

import pl.milib.core.supers.MIClass;
import pl.milib.core.supers.MIRunningClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.runningControll.RunningCondition;

/**
 * @author Marek Brun
 */
class pl.milib.runningControll.RunningExecutor extends MIClass {

	private var condition : RunningCondition;
	private var runnerToExe : MIRunningClass;
	private var isStart : Boolean;
	
	public function RunningExecutor(condition:RunningCondition, runnerToExe:MIRunningClass, isStart:Boolean) {
		this.condition=condition;
		this.condition.addListener(this);
		this.runnerToExe=runnerToExe;
		this.isStart=isStart;
	}//<>
	
//****************************************************************************
// EVENTS for RunningConditionExecutor
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case condition:
				switch(ev.event){
					case condition.event_RunningConditionIsFulfilled:
						if(isStart){
							runnerToExe.start();
						}else{
							runnerToExe.finish();
						}
					break;
				}
			break;
		}
	}//<<Events
	
}