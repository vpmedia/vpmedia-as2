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

import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIRunningClass;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.collection.RunnersCollection extends MIObjects {
	
	private function addObject(runner:MIRunningClass):Void {
		super.addObject(runner);
	}//<<
	
	private function removeObject(runner:MIRunningClass):Void {
		super.removeObject(runner);
	}//<<
	
	public function start(Void):Void {
		exe('start', arguments);
	}//<<
	
	public function finish(Void):Void {
		exe('finish', arguments);
	}//<<
	
}