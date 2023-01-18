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
import pl.milib.util.MILibUtil;

/**
 * @often_name mcIO
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCInOut extends MIRunningClass {
	
	//state start has come
	public var event_StateStart:Object={name:'StateStart'};
	//state mid ini has come
	public var event_StateMidIni:Object={name:'StateMidIni'};
	//state mid has come
	public var event_StateMid:Object={name:'StateMid'};
	//state mid out has come
	public var event_StateMidOut:Object={name:'StateMidOut'};
	//state end has come
	public var event_StateEnd:Object={name:'StateEnd'};
	
	public var state:Object;	public var state_start:Object={name:'start'};	public var state_mid:Object={name:'mid'};	public var state_end:Object={name:'end'};	public var targetState:Object;
	public var mc : MovieClip;
	private var midFrame : Number;
	
	public function MCInOut(mc:MovieClip){
		this.mc=mc;
		if(!mc){ logError_UnexpectedArg(arguments, 0, ['mc:MovieClip'], 'mc>'+link(mc)); }
		mc.mid=MILibUtil.createDelegate(this, onMCMid);
		mc.end=MILibUtil.createDelegate(this, onMCEnd);
		mc.gotoAndStop(1);
		state=state_start;
	}//<>
	
	public function setState(newState:Object):Void{
		if(state==state_start){
			if(newState==state_mid){
				if(targetState!=state_mid){
					mc.gotoAndPlay(2);
				}
			}else if(newState==state_start){
				if(targetState==state_mid){
					mc.play();
				}else{
					mc.gotoAndStop(1);
					bev(event_StateStart);
				}
			}
		}else if(state==state_mid){
			if(newState==state_start){
				mc.gotoAndPlay(mc._currentframe+1);
				bev(event_StateMidOut);
			}else if(newState==state_mid){
				bev(event_StateMid);
			}
		}
		targetState=newState;
	}//<<
	
	private function setStateMid(){ setState(state_mid); }//<<	private function setStateStart(){ setState(state_start); }//<<
	
	private function doStart(Void):Boolean {
		setStateMid();
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		if(state==state_end){
			mc.gotoAndStop(1);
			state=state_start;
			bev(event_StateStart);
			return true;
		}else{
			setStateStart();
			return false;
		}
	}//<<
	
	public function isInStartOrEnd():Boolean{
		return ((mc._currentframe==1 && (!targetState || targetState==state_start)) || state==state_end);
	}//<<
	
	public function isInMid():Boolean{
		return mc._currentframe==midFrame;
	}//<<
	
//****************************************************************************
// EVENTS for MCInOut
//****************************************************************************
	public function onMCMid(){
		midFrame=mc._currentframe;		
		if(targetState==state_mid){
			state=state_mid;
			mc.stop();
			bev(event_StateMidIni);
			bev(event_StateMid);
		}
	}//<<
	
	public function onMCEnd(){
		state=state_end;
		bev(event_StateEnd);
		if(isRunningFlag){
			mc.gotoAndPlay(1);
		}else{
			mc.stop();
			finish();
		}
	}//<< Events
	
}