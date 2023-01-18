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

import pl.milib.anim.static_.AnimationElement;
import pl.milib.core.supers.MIClass;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.static_.AnimationDistance extends MIClass {

	private var oneUnit : AnimationElement;
	private var dist : Number;
	
	public function AnimationDistance(oneUnit:AnimationElement) {
		this.oneUnit=oneUnit;
		dist=Math.abs(oneUnit.target-oneUnit.obj[oneUnit.param]);
	}//<>
	
	public function getTime(time:Number):Number {
		var distNow:Number=Math.abs(oneUnit.target-oneUnit.obj[oneUnit.param]);
		return int((distNow/dist)*time);
	}//<<
	
}