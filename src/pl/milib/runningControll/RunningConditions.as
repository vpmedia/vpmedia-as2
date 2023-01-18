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
import pl.milib.core.supers.MIClass;
import pl.milib.core.supers.MIRunningClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.runningControll.RunningCondition;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.runningControll.RunningConditions extends MIClass {

	public var conditionsToAchieving : MIObjects; //of RunningCondition
	public var runnersToStart : Array; //of MIRunningClass
	
	public function RunningConditions() {
		conditionsToAchieving=new MIObjects();
		conditionsToAchieving.addListener(this);
		runnersToStart=[];
	}//<>
	
	private function isCorrectConditions(Void):Boolean {
		var conditionsToAchievingArr:Array=conditionsToAchieving.getArray();
		for(var i=0,condition:RunningCondition;i<conditionsToAchievingArr.length;i++){
			condition=conditionsToAchievingArr[i];
			if(!condition.isCorrectCondition()){ return false; }
		}
		return true;
	}//<<
	
//****************************************************************************
// EVENTS for RunningConditions
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case conditionsToAchieving:
				var hero:RunningCondition=RunningCondition(ev.data.hero);
				switch(ev.data.event){
					case hero.event_RunningConditionIsFulfilled:
						if(isCorrectConditions()){
							for(var i=0,runner:MIRunningClass;i<runnersToStart.length;i++){
								runner=runnersToStart[i];
								runner.start();
							}
						}
					break;
				}
			break;
		}
	}//<<Events
	
}