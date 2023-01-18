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

import pl.milib.core.MIObjSoul;
import pl.milib.core.supers.MIRunningClass;
import pl.milib.core.value.MIBooleanValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.runningControll.AbstractRunningCondition;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.runningControll.RunningCondition extends AbstractRunningCondition {
	
	private var condition : MIBooleanValue;
	private var runner : MIRunningClass;
	private var isRunnerRunning : Boolean;
	private var shouldRun : Boolean;
	
	private function RunningCondition(runner:MIRunningClass, shouldRun:Boolean) {
		super(false);
		this.runner=runner;
		runner.addListener(this);		this.shouldRun=shouldRun;
		isRunnerRunning=runner.getIsRunning();
	}//<>
	
	private function chceckRunningCondition(Void):Void {
		if(isRunnerRunning!=runner.getIsRunning()){
			isRunnerRunning=runner.getIsRunning();
			if(isCorrectCondition()){
				bev(event_RunningConditionIsFulfilled);
			}
		}
	}//<<
	
	public function isCorrectCondition(Void):Boolean {
		return (runner.getIsRunning()==shouldRun && !(runner['isSuccess']===false));
	}//<<
	
	public function exe(Void):Void {
		runner.setIsRunning(shouldRun);
	}//<<
	
	public function exeToAchive(Void):Void {
		runner.setIsRunning(shouldRun);
	}//<<
	
	static public function forInstance(runner:MIRunningClass, shouldRun:Boolean):RunningCondition {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(runner);
		var varName:String='forRunningCondition_'+String(shouldRun);
		if(!milibObjObj[varName].o){ milibObjObj[varName]=MIObjSoul.forInstance(new RunningCondition(runner, shouldRun)); }
		return milibObjObj[varName].o;
	}//<<
	
//****************************************************************************
// EVENTS for RunningCondition
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case runner:
				switch(ev.event){
					case runner.event_RunningFinish:
						chceckRunningCondition();
					break;
					case runner.event_RunningStart:
						chceckRunningCondition();
					break;
				}
			break;
		}
	}//<<Events

}