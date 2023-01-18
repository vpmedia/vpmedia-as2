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
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.tools.ImpulsOwner;

/**
 * @often_name imp
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.Impuls extends MIRunningClass implements EnterFrameReciver {

	private var efb : EnterFrameBroadcaster;
	private var oneImpulsTime : Number;
	private var owner : ImpulsOwner;
	private var lastImpulsTime : Number;
	private var isImpulsDirectly : Boolean=false;
	
	public function Impuls(owner:ImpulsOwner, $oneImpulsMSTime:Number) {
		this.owner=owner;
		oneImpulsTime=$oneImpulsMSTime==null ? 1000/31 : $oneImpulsMSTime;
		efb=EnterFrameBroadcaster.getInstance();
	}//<>
	
	public function start(Void):Boolean {
		if(getIsRunning()){
			setLastImpulsTimeAsTimeNow();
			return true;
		}else{
			return super.start();
		}
	}//<<
	
	public function setLastImpulsTimeAsTimeNow(Void):Void {
		lastImpulsTime=getTimer();
	}//<<
	
	public function setupIsImpulsDirectly(bool:Boolean):Void {
		isImpulsDirectly=bool;
	}//<<
	
	private function doStart(Void):Boolean {
		lastImpulsTime=getTimer();
		efb.start_(this);
		if(isImpulsDirectly){
			owner.onSlave_Impuls_NewImpuls(this);
		}
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		efb.stop_(this);
		return true;
	}//<<
	
	public function setTime(oneImpulsMSTime:Number):Void {
		oneImpulsTime=oneImpulsMSTime;
	}//<<
	
	public function getTime(Void):Number {
		return oneImpulsTime;
	}//<<
	
	public function getTimeToNextImpls(Void):Number {
		return oneImpulsTime-int(oneImpulsTime*((getTimer()-lastImpulsTime)/oneImpulsTime));
	}//<<
	
//****************************************************************************
// EVENTS for Impuls
//****************************************************************************
	public function onEnterFrame(id) : Void {
		var currentTime:Number=getTimer();
		if(currentTime-lastImpulsTime>oneImpulsTime){
			lastImpulsTime=currentTime;
			owner.onSlave_Impuls_NewImpuls(this);
		}
	}//<<

}