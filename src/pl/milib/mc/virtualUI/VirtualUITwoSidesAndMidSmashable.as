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
class pl.milib.mc.virtualUI.VirtualUITwoSidesAndMidSmashable extends VirtualUI implements MIValueOwner {
	
	public var setupSide0Length : MINumberValue;
	public var setupSide1Length : MINumberValue;
	public var setupLength : MINumberValue;
	public var setupPos : MINumberValue;
	public var setupMidMinLength : MINumberValue;
	
	public function VirtualUITwoSidesAndMidSmashable(Void){
		setupSide0Length=(new MINumberValue(null, 0)).setOwner(this);		setupSide1Length=(new MINumberValue(null, 0)).setOwner(this);		setupLength=(new MINumberValue(null, 0)).setOwner(this);		setupPos=(new MINumberValue(null, 0)).setOwner(this);		setupMidMinLength=(new MINumberValue(null, 0)).setOwner(this);
	}//<>
	
	public function setupSidesLength(length:Number):Void {
		setupSide0Length.v=length/2;		setupSide1Length.v=length/2;
	}//<<
	
	public function getSidesLength(Void):Number {
		return getSide0Length()+getSide1Length();
	}//<<
	
	public function getSide1IniPos(Void):Number {
		return setupLength.v-getSide1Length();
	}//<<
	
	public function getScrollingAreaLength(Void):Number {
		return setupLength.v-getSidesLength();
	}//<<
	
	public function getMidLength(Void):Number {
		var sidesLength:Number=setupSide0Length.v+setupSide1Length.v;
		if(sidesLength>setupLength.v){
			return 0;
		}else{
			return setupLength.v-sidesLength;
		}
	}//<<
	
	public function getMidIniPos(Void):Number {
		return setupPos.v+getSide0Length();
	}//<<
	
	public function getSide0Length(Void):Number {
		var sidesLength:Number=setupSide0Length.v+setupSide1Length.v;
		var scrollingArea:Number=setupLength.v-sidesLength;
		if(scrollingArea<0){
			return Math.max(setupSide0Length.v+scrollingArea/2, 0);
		}else{
			return setupSide0Length.v;
		}
	}//<<
	
	public function getSide1Length(Void):Number {
		var sidesLength:Number=setupSide0Length.v+setupSide1Length.v;
		var scrollingArea:Number=setupLength.v-sidesLength;
		if(scrollingArea<0){
			return Math.max(setupSide1Length.v+scrollingArea/2, 0);
		}else{
			return setupSide1Length.v;
		}
	}//<<

}