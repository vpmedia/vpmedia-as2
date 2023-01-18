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

import pl.milib.core.supers.MIClass;

/** @author Marek Brun 'minim' */
class pl.milib.tools.KeyboardShortcut extends MIClass {

	public var key : Number;
	public var keys : Array;
	public var desc : String;
	public var keysLength : Number;
	private var isEnabled : Boolean=true;
	
	public function KeyboardShortcut(keys:Array, key:Number, desc:String) {
		this.keys=keys;
		this.key=key;
		this.desc=desc;
		keysLength=keys.length;
	}//<>
	
	public function setIsEnabled(bool:Boolean):Void{ isEnabled=bool; }//<<
	
	public function getIsEnabled():Boolean{ return isEnabled; }//<<
}