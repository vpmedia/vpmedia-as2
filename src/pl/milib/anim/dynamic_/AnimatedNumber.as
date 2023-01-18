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

import pl.milib.data.CurrentAndTargetValue;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;

/**
 * @often_name animNumIner
 * 
 * @author Marek Brun 'minim'
 */
/*abstract*/ class pl.milib.anim.dynamic_.AnimatedNumber extends CurrentAndTargetValue implements EnterFrameReciver {

	private var efb : EnterFrameBroadcaster;
	
	private function AnimatedNumber(initialCurrentValue:Number) {
		super(initialCurrentValue, null);
		efb=EnterFrameBroadcaster.getInstance();
	}//<>
	/*abstract*/ private function checkIsFinish(Void):Boolean { return true; }//<<	/*abstract*/ private function doEnterFrame(Void):Void { }//<<
	
	public function setTargetValue(num:Number):Void {
		super.setTargetValue(num);
	}//<<
	
	private function doStart(Void):Boolean {
		EnterFrameBroadcaster.start(this);
		return true;
	}//<<
	
	private function doFinish(Void):Boolean {
		if(checkIsFinish()){
			EnterFrameBroadcaster.stop(this);
			return true;
		}else{
			return false;
		}
	}//<<
	
//****************************************************************************
// EVENTS for AnimedVectorNumber
//****************************************************************************
	public function onEnterFrame(id) : Void {
		doEnterFrame();
		finish();
	}//<<
	
}