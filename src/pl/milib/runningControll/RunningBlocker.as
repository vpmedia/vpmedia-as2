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
import pl.milib.runningControll.AbstractRunningCondition;

/**
 * @author Marek Brun
 */
class pl.milib.runningControll.RunningBlocker extends MIClass {

	private var condition : AbstractRunningCondition;
	private var runnerToBlock : MIRunningClass;
	private var isBlockingStart : Boolean;
	
	public function RunningBlocker(condition:AbstractRunningCondition, runnerToBlock:MIRunningClass, isBlockingStart:Boolean) {
		this.condition=condition;
		this.condition.addListener(this);
		this.runnerToBlock=runnerToBlock;
		this.runnerToBlock.addListener(this);
		this.isBlockingStart=isBlockingStart;
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
						if(runnerToBlock.getIsRunningFlag()==isBlockingStart){
							runnerToBlock.setIsRunning(isBlockingStart);
						}
					break;
				}
			break;
			case runnerToBlock:
				switch(ev.event){
					case runnerToBlock.question_PermissionToStart:
						if(isBlockingStart){
							if(!condition.isCorrectCondition()){
								ev.data=runnerToBlock.answer_PermissionToStart_Deny;
								condition.exeToAchive();
							}
						}
					break;
					case runnerToBlock.question_PermissionToFinish:
						if(!isBlockingStart){
							if(!condition.isCorrectCondition()){
								ev.data=runnerToBlock.answer_PermissionToFinish_Deny;
								condition.exeToAchive();
							}
						}
					break;
				}
			break;
		}
	}//<<Events
	
}