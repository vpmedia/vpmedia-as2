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
class pl.milib.data.LimitedLengthArray extends Array {
	
	public var lengthLimit:Number;
	
	public function LimitedLengthArray($lengthLimit:Number) {
		setupLengthLimit($lengthLimit);
	}//<>
	
	public function setupLengthLimit($lengthLimit:Number):Void {
		lengthLimit=$lengthLimit==null ? Infinity : $lengthLimit;
		if(length>lengthLimit){
			splice(0, length-lengthLimit);
		}
	}//<<
	
	public function push(value):Void {
		super.push(value);
		if(length>lengthLimit){
			splice(0, length-lengthLimit);
		}
	}//<>
	
	public function unshift(value):Void {
		super.unshift(value);
		if(length>lengthLimit){
			splice(lengthLimit);
		}
	}//<<
	
}