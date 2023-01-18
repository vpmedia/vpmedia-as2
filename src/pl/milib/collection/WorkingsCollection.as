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

import pl.milib.collection.RunnersCollection;
import pl.milib.core.supers.MIWorkingClass;
import pl.milib.data.DynamicValue;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.collection.WorkingsCollection extends RunnersCollection {
	
	private function addObject(worker:MIWorkingClass):Void {
		super.addObject(worker);
	}//<<
	
	private function removeObject(worker:MIWorkingClass):Void {
		super.removeObject(worker);
	}//<<
	
	public function setupWorkingTime(workingTime:Number):Void {
		exe('setupWorkingTime', arguments);
	}//<<
	
	public function setupWorkingTimeAsDynamicValue(dv:DynamicValue):Void {
		exe('setupWorkingTimeAsDynamicValue', arguments);
	}//<<
	
}