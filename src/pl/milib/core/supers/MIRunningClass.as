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
import pl.milib.core.supers.MIRunningClasser;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.core.supers.MIRunningClass extends MIBroadcastClass implements MIRunningClasser {
	
	public var event_RunningStart:Object={name:'RunningStart'};	public var event_RunningFinish:Object={name:'RunningFinish'};	public var event_RunningFlagChanged:Object={name:'RunningFlaChanged'};	public var question_PermissionToStart:Object={name:'PermissionToStart'};	public var answer_PermissionToStart_Deny:Object={name:'PermissionToStart_Deny'};
	public var question_PermissionToFinish:Object={name:'PermissionToFinish'};
	public var answer_PermissionToFinish_Deny:Object={name:'PermissionToFinish_Deny'};	private var isRunning:Boolean;	private var isRunningFlag:Boolean;
	
	public function MIRunningClass() {
		isRunning=false;
		isRunningFlag=isRunning;
	}//<>
	/*abstract default*/private function doFinish(Void):Boolean { return true; }//<<
	/*abstract default*/private function doStart(Void):Boolean { return true; }//<<
	
	/*final*/public function setIsRunningFlag(bool:Boolean):Boolean {
		if(isRunningFlag!=bool){
			isRunningFlag=bool;
			bev(event_RunningFlagChanged);
			if(isRunningFlag){
				start();
			}else{
				finish();
			}
		}
		return isRunning;
	}//<<
	
	public function getIsRunningFlag(Void):Boolean {
		return isRunningFlag;
	}//<<
	
	public function getIsRunning(Void):Boolean {
		return isRunning;
	}//<<
	
	public function setIsRunning(isRunningStart:Boolean):Void {
		if(isRunningStart){ start(); }else{ finish(); }
	}//<<
	
	public function start(Void):Boolean {
		if(!isRunningFlag){ setIsRunningFlag(true); return isRunning; }
		if(isRunning){ return false; }
		switch(ask(question_PermissionToStart)){
			case answer_PermissionToStart_Deny: return false; break;
			//TODO: case answer_AskingForPermissionToStart_Deny_ButKeepAsking: ????????; return; break;
		}
		if(!doStart()){ return false; }
		isRunning=true;
		bev(event_RunningStart);
		return true;
	}//<<
	
	public function finish(Void):Boolean {
		if(isRunningFlag){ setIsRunningFlag(false); return !isRunning; }
		if(!isRunning){ return false; }
		switch(ask(question_PermissionToFinish)){
			case answer_PermissionToFinish_Deny: return false; break;
		}
		if(!doFinish()){ return false; }
		isRunning=false;
		bev(event_RunningFinish);
		return true;
	}//<<
	
	private function getDBGInfo(Void):Array {
		var info:String='isRunning>'+isRunning+' (flag:'+isRunningFlag+')';
		return [info].concat(super.getDBGInfo());
	}//<<
	
}
