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

import pl.milib.anim.dynamic_.AnimatedNumber;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.util.MIMathUtil;

/**
 * @often_name animNumIner
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.dynamic_.AnimatedStoppingNumber extends AnimatedNumber implements EnterFrameReciver {

	private var speed : Number;
	private var minDistToTarget : Number;
	
	/**
	 * @param $speed bigger - faster, default: 0.5
	 */
	public function AnimatedStoppingNumber(initialCurrentValue:Number, $minDistToTarget, $speed:Number) {
		super(initialCurrentValue);
		this.speed=$speed==null ? .5 : $speed;
		minDistToTarget=$minDistToTarget==null ? .5 : $minDistToTarget;
	}//<>
	
	private function checkIsFinish(Void):Boolean {
		return Math.abs(targetValue.v-currentValue.v)<minDistToTarget;
	}//<<
	
	private function doEnterFrame(Void):Void {
		var num:Number=currentValue.v;		var targetNum:Number=targetValue.v;
		num+=((targetNum-num)*speed)*MIMathUtil.between(efb.getAverageFrameTimeInS01()*8, 0, .95);
		currentValue.v=num;
	}//<<
	
	public function setSpeed(speed:Number):Void {
		this.speed=speed;
	}//<<

}