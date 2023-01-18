/**
 * com.sekati.utils.FilterUtils
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import flash.filters.DropShadowFilter;

/**
 * Static class wrapping various filter utilities.
 */
class com.sekati.utils.FilterUtils {

	/**
	 * add a drop shadow to a movieclip
	 */
	public static function addDropShadow(mc:MovieClip, distance:Number, angleInDegrees:Number, color:Number, alpha:Number, blurX:Number, blurY:Number):Void {
		//var filter:DropShadowFilter = new DropShadowFilter (distance:Number, angleInDegrees:Number, color:Number, alpha:Number, blurX:Number, blurY:Number, strength:Number, quality:Number, inner:Boolean, knockout:Boolean, hideObject:Boolean);
		var filter:DropShadowFilter = new DropShadowFilter( distance, angleInDegrees, color, alpha, blurX, blurY, 1, 3, false, false, false );
		var filterArray:Array = new Array( );
		filterArray.push( filter );
		mc.filters = filterArray;
	}

	/**
	 * clear all filters on a movieclip
	 */
	public static function clearFilters(mc:MovieClip):Void {
		mc.filters = [];
	}

	private function FilterUtils() {
	}
}