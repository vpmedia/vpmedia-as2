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
import flash.geom.Matrix;
import flash.geom.Rectangle;

import wilberforce.geom.rect;

class wilberforce.util.bitmap.bitmapUtility
{
	public static function createScaledBitmap(sourceBitmap:BitmapData,maxWidth:Number,maxHeight:Number,clipRect:rect):BitmapData
	{
		// Calculate the different scales
		var bitmapRatio:Number=sourceBitmap.width/sourceBitmap.height;
		var idealRatio:Number=maxWidth/maxHeight;
		
		// Depeding on which dimension maxes out the max size, resize
		var tScale=maxHeight/sourceBitmap.height;
		if (bitmapRatio>idealRatio) tScale=maxWidth/sourceBitmap.width;
		
		var tIconBitmap:BitmapData=new BitmapData(sourceBitmap.width*tScale,sourceBitmap.height*tScale,true,0x00CCCCCC);
		var tCopyMatrix:Matrix=new Matrix();
		tCopyMatrix.scale(tScale,tScale);
		
		var tClipRectangle:Rectangle=null;
		if (clipRect)
		{
			tClipRectangle=new Rectangle(clipRect.x,clipRect.x,clipRect.width,clipRect.height);
		}
		
		tIconBitmap.draw(sourceBitmap,tCopyMatrix,null,null,tClipRectangle,true);
		
		return tIconBitmap
	}
}