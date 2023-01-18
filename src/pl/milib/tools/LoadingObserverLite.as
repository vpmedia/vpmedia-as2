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

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.LoadingObserverLite {
	
	private var phaseNow : Object;
	private var phase_0_ObserveBytesTotal : Object = {name:'ObserveBytesTotal'};
	private var phase_1_ObserveBytesLoaded : Object = {name:'ObserveBytesLoaded'};	private var phase_2_Finishing: Object = {name:'Finishing'};
	private var loadedObj : Object;
	public var progressN01 : Number;
	private var startTime : Number;
	private var mc : MovieClip;
	private var intervalID : Number;
	
	public function LoadingObserverLite() {
		progressN01=0;
		setInterval();
	}//<>
	public function onBytesTotalRecived(Void):Void {}//<<
	public function onAllBytesLoaded(Void):Void {}//<<	public function onFinish(Void):Void {}//<<
	
	public function startObserve(obj):Void {
		loadedObj=obj;
		startTime=getTimer();
		phaseNow=phase_0_ObserveBytesTotal;
		progressN01=0;
		observeBytesTotal();
		intervalID=setInterval(this, 'onEnterFrame', int(1000/60));
	}//<<
	
	private function observeBytesTotal(Void):Void {		
		if(loadedObj.getBytesTotal()>0){
			onBytesTotalRecived();
			phaseNow=phase_1_ObserveBytesLoaded;
			observeBytesLoaded();
		}else if(getTimer()-startTime>5000){
			finish();
		}
	}//<<
	
	private function observeBytesLoaded(Void):Void {
		progressN01=loadedObj.getBytesLoaded()/loadedObj.getBytesTotal();
		if(progressN01==1){
			onAllBytesLoaded();
			phaseNow=phase_2_Finishing;
		}
	}//<<
	
	private function finish(Void):Void {
		progressN01=1;
		onFinish();
		clearInterval(intervalID);
	}//<<
	
//****************************************************************************
// EVENTS for LoadingObserver
//****************************************************************************
	public function onEnterFrame(id):Void {
		switch(phaseNow){
			case phase_0_ObserveBytesTotal:
				observeBytesTotal();
			break;
			case phase_1_ObserveBytesLoaded:
				observeBytesLoaded();
			break;
			case phase_2_Finishing:
				finish();
			break;
		}
	}//<<

}