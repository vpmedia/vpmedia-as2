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

import wilberforce.geom.rect;
import wilberforce.geom.circle;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import wilberforce.util.drawing.drawingShape;
import wilberforce.util.drawing.styles.*;

/**
* Filter to convert a bitmap into a series of shapes (either rectangles or circles)
*/
class wilberforce.util.bitmap.filter.mosaicRects
{
	function mosaicRects()
	{
		
	}
	
	static public function apply(bitmapData:BitmapData,tileWidth:Number,tileHeight:Number,asCircles:Boolean,fast:Boolean,spacing:Number):Array
	{
		var rectArray:Array=new Array();
		trace("Width is "+bitmapData.width);
		
		if (!spacing) spacing=0;
				
		var columns:Number=Math.round(bitmapData.width/tileWidth);
		var rows=Math.round(bitmapData.height/tileHeight);
		
		var _actualTileWidth:Number=bitmapData.width/columns;
		var _actualTileHeight:Number=bitmapData.height/rows;
		
		trace("Rendering bitmap to rects "+rows+"/"+columns);
		
		for (var row:Number=0;row<rows;row++)
		{
			for (var column:Number=0;column<columns;column++)
			{
				var tRect=new rect(Math.round(column*_actualTileWidth),Math.round(row*_actualTileHeight),Math.round((column+1)*_actualTileWidth),Math.round((row+1)*_actualTileHeight));
				var tShape=getSingleRect(bitmapData,tRect,asCircles,fast,spacing);
				rectArray.push(tShape);
			}
		}		
		return rectArray;
	}
	
	static function getSingleRect(bitmapData:BitmapData,region:rect,asCircle:Boolean,fast:Boolean,spacing:Number):drawingShape
	{
		
		
		var tPixels=region.width*region.height;
		//trace("Pixels "+tPixels);
		var totalRed:Number=0;
		var totalGreen:Number=0;
		var totalBlue:Number=0;
		
		var tColor:Number;
		
		if (!fast)
		{
			for (var y:Number=region.top;y<region.bottom;y++)
			{
				for (var x:Number=region.left;x<region.right;x++)
				{
						//trace("testing "+x+","+y);
						var colorTrans:ColorTransform = new ColorTransform();
						colorTrans.rgb=bitmapData.getPixel(x,y);
						totalRed+=colorTrans.redOffset/tPixels;
						totalGreen+=colorTrans.greenOffset/tPixels;
						totalBlue+=colorTrans.blueOffset/tPixels;
						//var tTestColor:Number=bitmapData.getPixel(x,y);
						//var r=tTestColor>>16;
						//var g=tTestColor>>8;
						
				}
			}
			
			var colorTransAverage:ColorTransform = new ColorTransform();
			colorTransAverage.redOffset=totalRed;//Math.round(totalRed);
			colorTransAverage.greenOffset=totalGreen;//Math.round(totalGreen);
			colorTransAverage.blueOffset=totalBlue;//Math.round(totalBlue);
			tColor=colorTransAverage.rgb;
		}
		else {
					
			tColor=bitmapData.getPixel(region.left+region.width/2,region.top+region.height/2);						
		}
		
		var tLineStyle:lineStyleFormat=null;		
		var tFillStyle:fillStyleFormat=new fillStyleFormat(tColor,100,0);
		
		if (asCircle) 
		{
			var tx:Number=region.left+region.width/2;
			var ty:Number=region.top+region.height/2;
			
			var tCircle:circle=new circle(tx,ty,region.width/2-spacing);
			return new drawingShape(tCircle,tLineStyle,tFillStyle)
		}
		else {
			region.width-=spacing;
			region.height-=spacing;
			return new drawingShape(region,tLineStyle,tFillStyle)		
		}
	}
}