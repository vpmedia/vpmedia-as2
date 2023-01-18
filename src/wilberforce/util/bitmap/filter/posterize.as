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

/**
* Filter to convert a bitmap into a posterized bitmap
*/
class wilberforce.util.bitmap.filter.posterize
{
	
	public static function apply(bitmapData:BitmapData,levels:Number):BitmapData
	{
		var tAreas:Number = 256.0000 / levels;
		var tValues = 255.0000 / (levels - 1);
				
		var tWidth:Number=bitmapData.width;
		var tHeight:Number=bitmapData.height;
		
		var newBitmapData:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, bitmapData.transparent, 0x000000);
		var colorTrans:ColorTransform = new ColorTransform();
		
		for (var y:Number=0;y<tHeight;y++)
		{
			for (var x:Number=0;x<tWidth;x++)
			{
				colorTrans.rgb=bitmapData.getPixel(x,y);								
				colorTrans.redOffset=setToLevel(colorTrans.redOffset,tAreas, tValues);
				colorTrans.greenOffset=setToLevel(colorTrans.greenOffset,tAreas, tValues);
				colorTrans.blueOffset=setToLevel(colorTrans.blueOffset,tAreas, tValues);				
				newBitmapData.setPixel(x,y,colorTrans.rgb);
			}		
		}
		return newBitmapData;
	}
	
	private static function setToLevel(value:Number, tAreas:Number, tValues:Number)
	{		
		var area = Math.floor(value / tAreas);
		return Math.floor(tValues * area);
	}
}