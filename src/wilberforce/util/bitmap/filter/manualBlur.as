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
import wilberforce.event.frameEventBroadcaster;

/**
* Bitmap filter to perform a simple linear blur, calculated on a per-pixel basis with the surrounding pixels.
* Can be used as a static class or a new instance can be created for multi-frame events
* TODO - Remove dependency on frameEventBroadcaster
*/
class wilberforce.util.bitmap.filter.manualBlur extends wilberforce.event.simpleEventDispatcher
{
	// Define the array to hold steps to allow it to be spread over multiple frames
	private var _stepsArray:Array;
	private var _sourceBitmapData:BitmapData;
	private var _newBitmapData:BitmapData;
	private var _distance:Number;
	
	private var _stepsPerFrame:Number;
	private static var _defaultStepsPerFrame:Number=1000;
	private static var _totalSteps:Number;
	private static var _stepsComplete:Number;
	
	public function manualBlur(stepsPerFrame:Number)
	{
		
	}
	
	public function applyInterval(sourceBitmapData:BitmapData,distance:Number):Void
	{
		// Create the new output bitmap
		_newBitmapData = new BitmapData(sourceBitmapData.width, sourceBitmapData.height, sourceBitmapData.transparent, 0x000000);

		// Populate the array with each step required
		_stepsArray=new Array();
		
		for (var y:Number=0;y<sourceBitmapData.height;y++)
		{
			for (var x:Number=0;x<sourceBitmapData.width;x++) _stepsArray.push({x:x,y:y})
		}
		_totalSteps=sourceBitmapData.height*sourceBitmapData.width;
		_stepsComplete=0;
		_sourceBitmapData=sourceBitmapData;
		_distance=distance;
		frameEventBroadcaster.addEventListener("frameStep",this,blurStep);
	}
	
	public function blurStep()
	{
		var tStepsToExecute:Number=Math.min(_defaultStepsPerFrame,_stepsArray.length)
		for (var i:Number=0;i<tStepsToExecute;i++)
		{
			processStep(_sourceBitmapData,_newBitmapData,_stepsArray[i].x,_stepsArray[i].y,_distance);
			_stepsComplete++;
		}
		_stepsArray.splice(0,tStepsToExecute);
		if (_stepsArray.length==0)
		{
			frameEventBroadcaster.removeEventListener("frameStep",this);
			dispatchEvent("blurComplete",_newBitmapData,this);
		}
		else {
			var tPerc=_stepsComplete/_totalSteps;
			dispatchEvent("blurProgress",tPerc,_stepsComplete,_totalSteps,this);
		}
	}
	
	/**
	* Filter a bitmap in a single processing loop. WARNING: This is very CPU heavy so not recommended for anything but a small image
	* @param	sourceBitmapData	The Bitmap data to blur
	* @param	distance			The distance to blur
	* @return
	*/
	public static function apply(sourceBitmapData:BitmapData,distance:Number):BitmapData
	{		
		var newBitmapData:BitmapData = new BitmapData(sourceBitmapData.width, sourceBitmapData.height, sourceBitmapData.transparent, 0x000000);
		var colorTrans:ColorTransform = new ColorTransform();
		
		for (var y:Number=0;y<sourceBitmapData.height;y++)
		{
			for (var x:Number=0;x<sourceBitmapData.width;x++) processStep(sourceBitmapData,newBitmapData,x,y,distance);
		}
		return newBitmapData;
	}
	
	private static function processStep(sourceBitmapData:BitmapData,newBitmapData:BitmapData,x:Number,y:Number,distance:Number)
	{
		var tNewValue=getAveragePixelValues(sourceBitmapData,x,y,distance);
		newBitmapData.setPixel(x,y,tNewValue);
	}
	
	private static function getAveragePixelValues(sourceBitmapData:BitmapData,x:Number,y:Number,distance:Number)
	{
		var left=Math.max(0,x-distance);
		var top=Math.max(0,y-distance);
		var right=Math.min(sourceBitmapData.width-1,x+distance);
		var bottom=Math.min(sourceBitmapData.height-1,y+distance);
		
		var totalPixels:Number=(right-left)*(bottom-top);
		var totalRed:Number=0;
		var totalGreen:Number=0;
		var totalBlue:Number=0;		
		
		var colorTrans:ColorTransform = new ColorTransform();
		
		for (var tx:Number=left;tx<right;tx++)
		{
			for (var ty:Number=top;ty<bottom;ty++)
			{
				colorTrans.rgb=sourceBitmapData.getPixel(tx,ty);
				totalRed+=colorTrans.redOffset/totalPixels;
				totalGreen+=colorTrans.greenOffset/totalPixels;
				totalBlue+=colorTrans.blueOffset/totalPixels;
			}		
		}
		colorTrans.redOffset=totalRed;
		colorTrans.greenOffset=totalGreen;
		colorTrans.blueOffset=totalBlue;
		return colorTrans.rgb;
	}
}