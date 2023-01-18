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

import pl.milib.core.value.MINumberValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.mc.virtualUI.VirtualUI;

/**
 * @ofte_name vi2S* 
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.virtualUI.VirtualUITwoSidesAndMid extends VirtualUI implements MIValueOwner {
	
	public var setupSide0Length : MINumberValue;
	public var setupSide1Length : MINumberValue;
	public var setupLength : MINumberValue;
	public var setupPos : MINumberValue;
	public var setupMidMinLength : MINumberValue;
	
	public function VirtualUITwoSidesAndMid(Void){
		setupSide0Length=(new MINumberValue(null, 0)).setOwner(this);		setupSide1Length=(new MINumberValue(null, 0)).setOwner(this);		setupLength=(new MINumberValue(null, 0)).setOwner(this);		setupPos=(new MINumberValue(null, 0)).setOwner(this);		setupMidMinLength=(new MINumberValue(null, 0)).setOwner(this);
	}//<>
	
	public function setupSidesLength(length:Number):Void {
		setupSide0Length.v=length/2;		setupSide1Length.v=length/2;
	}//<<
	
	public function getSidesLength(Void):Number {
		return setupSide0Length.v+setupSide1Length.v;
	}//<<
	
	public function getMidLength(Void):Number {
		var ret:Number=getLength()-getSidesLength();
		if(ret<0){ ret=0; }
		return ret;
	}//<<
	
	public function getMidIniPos(Void):Number {
		return setupPos.v+setupSide0Length.v;
	}//<<
	
	public function getSide1IniPos(Void):Number {
		return setupPos.v+getLength()-setupSide1Length.v;
	}//<
	
	public function getMinLength(Void):Number {
		return setupMidMinLength.v+getSidesLength();
	}//<
	
	public function getLength(Void):Number {
		if(getIsSmashed()){
			return getSidesLength();
		}else{
			return setupLength.v;
		}
	}//<
	
	public function getIsSmashed(Void):Boolean {
		//TODO no smashing
		return setupLength.v<getMinLength();
	}//<

}