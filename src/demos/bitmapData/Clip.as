/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Matrix;

class demos.bitmapData.Clip extends MovieClip {
	
	private var imageSequence:MovieClip;
	public var index:Number;
	public var test:Number;
	private var bitmapDataClip:MovieClip;
	private var imageHeight:Number;
	private var imageWidth:Number;
	
	public function Clip(){
		imageSequence._visible = false;
		this.createEmptyMovieClip("bitmapDataClip",1);
	}
	
	public function gotoAndStop(frame:Number):Void{
		imageSequence.gotoAndStop(frame);
	}
	
	public function set scale(newScale:Number):Void{
		var sourceBitmapData:BitmapData = new BitmapData(imageSequence._width, imageSequence._height, true, 0x00CCCCCC);
		sourceBitmapData.draw(imageSequence, new Matrix(), null, "normal", null, true);
		
		imageWidth = imageSequence._width * 5;
		imageHeight = imageSequence._height * 5;

		var finalMatrix:Matrix = new Matrix();
		finalMatrix.scale(newScale/100*5,newScale/100*5);
		var finalBitmapData:BitmapData = new BitmapData(newScale*imageWidth/100, newScale*imageHeight/100, true, 0x00CCCCCC);
		finalBitmapData.draw(sourceBitmapData, finalMatrix, null, "normal", null, true);
		
		bitmapDataClip.attachBitmap(finalBitmapData,0,"auto",true);
		bitmapDataClip._x = bitmapDataClip._width/-2;
		bitmapDataClip._y = bitmapDataClip._height/-2;
	}
	
}