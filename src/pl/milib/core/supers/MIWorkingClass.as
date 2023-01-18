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
import pl.milib.data.DynamicValue;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;

/**
 * @often_name worker 
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.core.supers.MIWorkingClass extends MIRunningClass implements EnterFrameReciver {

	private var startTime : Number;
	private var efb : EnterFrameBroadcaster;
	private var workingTime : Number;	private var workingTimeDV : DynamicValue;
	public var isSuccess:Boolean;

	private var startWorkingTime : Number;
	
	public function MIWorkingClass() {
		efb=EnterFrameBroadcaster.getInstance();
	}//<>
	/*abstract*/ private function doWork(Void):Void {}//<<
	
	public function setupWorkingTime(workingTime:Number):Void {
		this.workingTime=workingTime;
		delete workingTimeDV;
	}//<<
	
	public function setupWorkingTimeAsDynamicValue(dv:DynamicValue):Void {
		workingTimeDV=dv;
	}//<<
	
	public function getWorkingTime(Void):Number {
		if(workingTimeDV){
			return workingTimeDV.value.v;
		}else{
			return workingTime;
		}
	}//<<
	
	private function doStart(Void):Boolean {
		isSuccess=false;
		startTime=efb.getTime();
		startWorkingTime=getWorkingTime();
		if(isNaN(getWorkingTime())){ logError_UnexpectedSituation(arguments, 'isNaN(getWorkingTime()); getWorkingTime()>'+link(getWorkingTime())); return false; }
		EnterFrameBroadcaster.start(this);
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		EnterFrameBroadcaster.stop(this);
		return true;
	}//<<
	
	public function getProgress(Void):Number {
		var progress:Number=(efb.getTime()-startTime)/startWorkingTime;
		if(progress>1){ progress=1; }
		return progress;
	}//<<
	
//****************************************************************************
// EVENTS for MIWorkingClass
//****************************************************************************
	public function onEnterFrame(id):Void {
		doWork();
		if(efb.getTime()-startTime>startWorkingTime){
			isSuccess=true;
			finish();
		}
	}//<<
	
}