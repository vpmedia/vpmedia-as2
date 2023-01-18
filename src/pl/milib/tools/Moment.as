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

import pl.milib.core.supers.MIWorkingClass;

/**
 * @author Marek Brun
 */
class pl.milib.tools.Moment extends MIWorkingClass {
	
	public var event_Progress:Object={name:'Progress'};
	private var times : Array;
	
	public function Moment() {
		
	}//<>
	
	private function doStart(Void):Boolean {
		if(super.doStart()){
			times=[];
			bev(event_Progress);
			return true;
		}
	}//<<
	
	private function doWork(Void):Void {
		times.push(efb.getLastFrameTime());
		bev(event_Progress);
	}//<<
	
	public function getAverageTime(Void):Number {
		var sum:Number=0;
		for(var i=0;i<times.length;i++){
			sum+=times[i];
		}
		return sum/times.length;
	}//<<
	
}