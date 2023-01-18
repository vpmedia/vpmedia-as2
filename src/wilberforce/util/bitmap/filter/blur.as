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
 * @author Simon Oliver
 * @version 1.0
 */

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.filters.BlurFilter;

/**
* Blur function. Uses flash 8s built in native blur renderer to blur a bitmap to allow
* blur to be performed quickly.
*/
class wilberforce.util.bitmap.filter.blur
{
	static var defaultQuality:Number=3;
	
	public static function apply(bitmapData:BitmapData,blurX:Number,blurY:Number,temporaryMovieClip:MovieClip):BitmapData
	{
		
		
		if (!temporaryMovieClip) temporaryMovieClip=_root;
		
		var filter:BlurFilter = new BlurFilter(blurX, blurY, defaultQuality);
		var filterArray:Array = new Array();
		filterArray.push(filter);
		
		trace("Size is "+bitmapData.width+","+bitmapData.height);
		
		var newBitmapData:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, bitmapData.transparent, 0x00CCCCCC);	
		var tDepth=temporaryMovieClip.getNextHighestDepth();
		var temporaryHolderClip:MovieClip=temporaryMovieClip.createEmptyMovieClip("temp"+tDepth,tDepth);
		
		trace("new clip is "+temporaryHolderClip);
		temporaryHolderClip.attachBitmap(bitmapData,2);
				
		temporaryHolderClip.filters = filterArray;
				
		newBitmapData.draw(temporaryHolderClip);
		temporaryHolderClip.removeMovieClip();
		return newBitmapData;
		
	}

}