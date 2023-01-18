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

import pl.milib.anim.static_.Animation;
import pl.milib.anim.static_.AnimationDistance;
import pl.milib.anim.static_.AnimationElement;
import pl.milib.collection.WorkingsCollection;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.collection.AnimationsCollection extends WorkingsCollection {
	
	private function addObject(anim:Animation):Void {
		super.addObject(anim);
	}//<<
	
	private function removeObject(anim:Animation):Void {
		super.removeObject(anim);
	}//<<
	
	public function setupDistanceUnit(animTimeUnit:AnimationDistance):Void {
		exe('setupDistanceUnit', arguments);
	}//<<
	
	public function setupDistanceUnitByElement(aei:AnimationElement):Void {
		exe('setupDistanceUnitByElement', arguments);
	}//<<
	
}