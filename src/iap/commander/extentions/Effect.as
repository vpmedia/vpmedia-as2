/*
 *This file is part of MovieClipCommander Framework.
 *
 *   MovieClipCommander Framework  is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    MovieClipCommander Framework is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with MovieClipCommander Framework; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
 import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.filters.BitmapFilter;
import flash.filters.*

/**
* Extention to easly handle an effect on the MovieClip
* @author Gabi Paciornic
*/
class iap.commander.extentions.Effect extends iap.services.MovieClipService{
	static var FILTER_DROP_SHADOW:String="dropShadow";
	static var FILTER_GLOW:String="glow";
	static var FILTER_BLUR:String="blur";
	
	private var __filterNum:Number;
	private var __parametersArray:Array;
	private var __savedFilter:BitmapFilter;
	
	private function init(filter:String, color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number,  distance:Number, angleInDegrees:Number,inner:Boolean, knockout:Boolean, hideObject:Boolean){
		if (filter.length > 0) {
			createFilter(filter,color,alpha,blurX,blurY,strength,quality,distance,angleInDegrees,inner,knockout,hideObject);
		}
		__commander.addEventListener("paramChange", this);
	}
	
	public function createFilter(filter:String, color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number,  distance:Number, angleInDegrees:Number,inner:Boolean, knockout:Boolean, hideObject:Boolean){
		if (__filterNum!=undefined){
			clearFilter();
		}
		switch(filter){
			case FILTER_DROP_SHADOW:
				dropShadow( color, alpha, blurX, blurY, strength, quality,  distance, angleInDegrees,inner, knockout, hideObject);
				break;
			case FILTER_GLOW:
				glow(color, alpha, blurX, blurY, strength, quality, inner, knockout);
				break;
			case FILTER_BLUR:
				blur(blurX,blurY,quality);
				break;
		}
		
	}
	
	private function glow(color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number, inner:Boolean, knockout:Boolean){
		var filter:GlowFilter = new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
		addFilter(filter);
	}
		
	private function dropShadow(color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number,  distance:Number, angleInDegrees:Number,inner:Boolean, knockout:Boolean, hideObject:Boolean){
		var filter:DropShadowFilter = new DropShadowFilter(distance, angleInDegrees, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		addFilter(filter);
	}
	
	private function blur(blurX:Number,blurY:Number, quality:Number){
		var filter:BlurFilter = new BlurFilter(blurX,blurY,quality);
		addFilter(filter);
	}
	
	public function clearFilter(){
		var filterArray:Array=__clip.filters;
		filterArray.splice(__filterNum-1,1);
		__clip.filters=filterArray;
		__filterNum=undefined;
	}
	
	private function addFilter(filter:BitmapFilter){
		var filterArray:Array = __clip.filters;
		__filterNum = filterArray.push(filter);
		__clip.filters = filterArray;		
		__savedFilter=filter;
	}
	
	public function set _visible(val:Boolean){
		if (val) {
			if (__filterNum==undefined){
				addFilter(__savedFilter);
			}
		} else {
			clearFilter();
		}
	}
	
	public function get _visible():Boolean{
		return (__filterNum!=undefined);
	}
	
	private function paramChange(evt:Object) {
		var filtersProp:Array = ["color", "alpha", "blurX", "blurY", "distance"];
		for (var i in filtersProp) {
			if (evt.name == filtersProp[i]) {
				trace("changing filter settings: "+[evt.name, __savedFilter[evt.name],evt.value]);
				__savedFilter[evt.name] = evt.value;
				return
			}
		}
	}
}
