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
import pl.milib.core.supers.MIRunningClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.runningControll.AbstractRunningCondition;
import pl.milib.runningControll.RunningCondition;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.runningControll.RunningConditionMulti extends AbstractRunningCondition {

	private var conditionsToAchieving : MIObjects; //of RunningCondition
	private var conditionsToExe : Array; //of RunningCondition
	
	public function RunningConditionMulti(conditionsToAchieving:Array, conditionsToExe:Array) {
		this.conditionsToAchieving=new MIObjects();
		this.conditionsToAchieving.setObjects(conditionsToAchieving);
		this.conditionsToAchieving.addListener(this);
		this.conditionsToExe=conditionsToExe;
		tryExe();
	}//<>
	
	private function isCorrectCondition(Void):Boolean {
		var conditionsToAchievingArr:Array=conditionsToAchieving.getArray();
		for(var i=0,condition:RunningCondition;i<conditionsToAchievingArr.length;i++){
			condition=conditionsToAchievingArr[i];
			if(!condition.isCorrectCondition()){ return false; }
		}
		return true;
	}//<<
	
	public function tryExe(Void):Void {
		if(isCorrectCondition()){
			exe();
		}
	}//<<
	
	public function exe(Void):Void {
		for(var i=0,condition:RunningCondition;i<conditionsToExe.length;i++){
			condition=conditionsToExe[i];
			condition.exe();
		}
	}//<<
	
	public function exeToAchive(Void):Void {
		var conditionsToAchievingArr:Array=conditionsToAchieving.getArray();
		for(var i=0,condition:AbstractRunningCondition;i<conditionsToAchievingArr.length;i++){
			condition=conditionsToAchievingArr[i];
			condition.exe();
		}
	}//<<
	
	static public function createConditionsArrayByRunners(runners:Array, shouldRun:Boolean):Array {
		var arr:Array=[];
		for(var i=0,runner:MIRunningClass;i<runners.length;i++){
			runner=runners[i];
			arr.push(RunningCondition.forInstance(runner, shouldRun));
		}
		return arr;
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
						tryExe();
					break;
				}
			break;
		}
	}//<<Events
	
}