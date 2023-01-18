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

import flash.geom.Point;

class pl.milib.util.MIMathUtil{
	
	static public function getHEXByRGB(r:Number, g:Number, b:Number):Number {
		return r<<16 | g<<8 | b;
	}//<<
	
	static public function getRGBByHEX(hex:Number){
  		return {r:hex>>16, g:Math.floor(hex/256)%256, b:hex%256};
	}//<<
	
	static public function getHEXString(color:Number){
		var rgb=getRGBByHEX(color);
		return rgb.r.toString(16)+rgb.g.toString(16)+rgb.b.toString(16);
	}//<<
	
	static public function b01(num:Number):Number{
		if(num<0){ return 0; }		if(num>1){ return 1; }
		return num;
	}//<<
	
	static public function between(num:Number, min:Number, max:Number):Number{
		if(num<min){return min;}
		if(num>max){return max;}
		return num;
	}//<<
	
	static public function dist(x1, y1, x2, y2):Number{
		var oxp=x2-x1;
		var oyp=y2-y1;
		return Math.sqrt(oxp*oxp+oyp*oyp);
	}//<<
	
	static public function distPoints(point0:Point, point1:Point):Number{
		var oxp=point1.x-point0.x;
		var oyp=point1.y-point0.y;
		return Math.sqrt(oxp*oxp+oyp*oyp);
	}//<<
	
	static public function radPoints(pointFrom:Point, pointTo:Point):Number{
		return Math.atan2(pointTo.y-pointFrom.y, pointTo.x-pointFrom.x);
	}//<<
	
	static public function getScopeIntBy01(scopeIni:Number, scopeEnd:Number, n01:Number){
		return scopeIni+Math.round(n01*(scopeEnd-scopeIni));
	}//<<
	
	static public function getNextPrev(min:Number, max:Number, currentNumber:Number, isNext:Boolean):Number {
		if(isNext){
			currentNumber++;
			if(currentNumber>max){ return min; }			return currentNumber;
		}else{
			currentNumber--;
			if(currentNumber<min){ return max; }
			return currentNumber;
		}
	}//<<

}
