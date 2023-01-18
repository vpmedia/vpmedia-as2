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

/**
 * @often_name animNumIner
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.dynamic_.AnimatedInertialNumber extends AnimatedNumber implements EnterFrameReciver {

	private var speed : Number;
	private var friction : Number;
	private var acceleration : Number;
	
	/**
	 * @param $acceleration biger - faster, delault:0.5	 * @param $friction smaller - longer animation, delault:0.1
	 */
	public function AnimatedInertialNumber(initialCurrentValue:Number, $acceleration:Number, $friction:Number) {
		super(initialCurrentValue);
		acceleration=$acceleration==null ? .5 : $acceleration;		friction=$friction==null ? .04 : $friction;
		speed=0;
	}//<>
	
	private function checkIsFinish(Void):Boolean {
		return Math.abs(targetValue.v-currentValue.v)<0.01 && Math.abs(speed)<0.001;
	}//<<
	
	private function doEnterFrame(Void):Void {
		var curr:Number=currentValue.v;
		speed+=(targetValue.v-curr)*acceleration;
		speed-=speed*friction;
		curr+=speed;
		currentValue.v=curr;
	}//<<
	
	public function setSpeed(speed:Number):Void {
		this.speed=speed;
	}//<<

}