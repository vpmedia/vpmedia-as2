
import flash.display.BitmapData
import flash.geom.Point
import flash.geom.Rectangle

import wilberforce.geom.rect;
import com.bourre.transitions.IFrameListener;
import com.bourre.transitions.FPSBeacon;

import wilberforce.util.drawing.drawingUtility;
import wilberforce.events.simpleEventHelper;

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

class wilberforce.animation.transitions.gradientWipe extends simpleEventHelper implements IFrameListener
{

	var _transitionRect:rect;
	var _transitionRectangle:Rectangle;
	var _transitionInClip:MovieClip;
	var _transitionOutClip:MovieClip;
	var _transitionContainer:MovieClip;
	
	var _transitionFrames:Number;
	
	var _transitionInBitmapData:BitmapData;
	var _originalTransitionInBitmapData:BitmapData;
	var _transitionOutBitmapData:BitmapData;
	
	var _gradientBitmapData:BitmapData;
	
	var _fadeBarWidth:Number;
	
	var _transitionXposition:Number;
	var _transitionXstep:Number;
	
	var _gradientRectangle:Rectangle
	
	static public var TRANSITION_COMPLETE_EVENT=new EventType("onTransitionComplete");
	
	function gradientWipe(transitionContainer:MovieClip,transitionFrames:Number,fadeBarWidth:Number,transitionRect:rect)
	{
		super();
		
		_transitionContainer=transitionContainer;
		_transitionRect=transitionRect;
		
		_fadeBarWidth=fadeBarWidth;
		
		_transitionFrames=transitionFrames;
		
		// Create the gradient
		var tGradientClip:MovieClip=_transitionContainer.createEmptyMovieClip("gradient",_transitionContainer.getNextHighestDepth());
		var tGradientRect:rect=new rect(0,0,fadeBarWidth,_transitionRect.height);
		_gradientRectangle=new Rectangle(0,0,fadeBarWidth,_transitionRect.height);
		
		// Draw
		var colors = [0x000000, 0xFFFFFF];
		var alphas = [100, 100];
		var ratios = [0, 0xFF];
		var matrix = {matrixType:"box", x:0, y:0, w:tGradientRect.width, h:tGradientRect.height, r:0};//(90/180)*Math.PI};
		tGradientClip.beginGradientFill("linear", colors, alphas, ratios, matrix);
		drawingUtility.drawRectWithoutStyle(tGradientClip,tGradientRect);
		tGradientClip.endFill();
		
		_gradientBitmapData=new BitmapData(fadeBarWidth, _transitionRect.height, true);
		_gradientBitmapData.draw(tGradientClip);
		tGradientClip.removeMovieClip();
		
		_transitionXstep=_transitionRect.width/_transitionFrames;
		
		// Block interactions
		transitionContainer.onPress=function(){};
		transitionContainer.useHandCursor=false;
		//trace("Added bitmap "+_transitionInBitmapData.width+"x"+_transitionInBitmapData.height);
	}
	
	public function setTransitionOutClip(transitionOutClip)
	{
		_transitionOutClip=transitionOutClip;
		_transitionOutBitmapData=new BitmapData(_transitionRect.width, _transitionRect.height, true);
		_transitionOutBitmapData.draw(_transitionOutClip);
		_transitionContainer.attachBitmap(_transitionOutBitmapData,1);
	}
	
	public function setTransitionInClip(transitionInClip)
	{
		_transitionInClip=transitionInClip;
		_transitionInBitmapData=new BitmapData(_transitionRect.width, _transitionRect.height, true);
		_originalTransitionInBitmapData=new BitmapData(_transitionRect.width, _transitionRect.height, true);
		
		_transitionInBitmapData.draw(transitionInClip);
		_originalTransitionInBitmapData.draw(transitionInClip);
		
		var tDummyAlphaChannelBitmap:BitmapData = new BitmapData(_transitionRect.width, _transitionRect.height, true, 0x00550000);
		_transitionRectangle= new Rectangle(0, 0, _transitionRect.width, _transitionRect.height);
		_transitionInBitmapData.copyChannel(tDummyAlphaChannelBitmap,_transitionRectangle,new Point(0,0),8,8);
		tDummyAlphaChannelBitmap.dispose();
		
		_transitionContainer.attachBitmap(_transitionInBitmapData,2);
	}

	public function execute():Void
	{
		_transitionXposition=_transitionRect.width;
		
		_transitionInClip._visible=false;
		_transitionOutClip._visible=false;
		
		// Add a frame listener
		FPSBeacon.getInstance().addFrameListener(this);
	}
	
	public function onEnterFrame():Void
	{
		//trace("Frame "+_transitionXposition)
		_transitionXposition-=_transitionXstep;
		_transitionXposition=Math.round(_transitionXposition);
		var tCopyRect=new Rectangle(_transitionXposition,0,_fadeBarWidth,_transitionRect.height);
		
		_transitionInBitmapData.copyChannel(_gradientBitmapData, _gradientRectangle, new Point(_transitionXposition, 0), 1, 8);
		_transitionInBitmapData.copyChannel(_originalTransitionInBitmapData, tCopyRect,new Point(_transitionXposition, 0), 1, 1);
		_transitionInBitmapData.copyChannel(_originalTransitionInBitmapData, tCopyRect,new Point(_transitionXposition, 0), 2, 2);
		_transitionInBitmapData.copyChannel(_originalTransitionInBitmapData, tCopyRect,new Point(_transitionXposition, 0), 4, 4);
	
		// Copy the "filled" in aspect to the right
		_transitionInBitmapData.copyChannel(_originalTransitionInBitmapData, _gradientRectangle, new Point(_transitionXposition+_gradientRectangle.width, 0), 8, 8);
		
		if (_transitionXposition<=-_fadeBarWidth) {
			
			// Dipose of everything
			_transitionInBitmapData.dispose();
			_transitionOutBitmapData.dispose();
			_originalTransitionInBitmapData.dispose();
			
			// Dont free gradient bitmap data to allow for re-use
			//_gradientBitmapData.dispose();
			
			//trace("Here");
			_transitionInClip._visible=true;
			FPSBeacon.getInstance().removeFrameListener(this);
			_oEB.broadcastEvent(new BasicEvent(TRANSITION_COMPLETE_EVENT,this));
		}
	}
/*	

	var newImageBitmapData:BitmapData=new BitmapData(img2.width, img2.height, true,0x00FF0000)
	newImageBitmapData.draw(img2);
	// Fill with transparent in alpha
	var tDummyAlphaChannelBitmap:BitmapData = new BitmapData(img2.width, img2.height, true, 0x11550000);


	var tRectangle= new Rectangle(0, 0, previousImageBitmapData.width, previousImageBitmapData.height);
	newImageBitmapData.copyChannel(tDummyAlphaChannelBitmap,tRectangle,new Point(0,0),8,8);
	dispose(tDummyAlphaChannelBitmap);
	mc.attachBitmap(previousImageBitmapData, 1)
	mc.attachBitmap(newImageBitmapData, 2)

	var perc=0.50;
//img2.threshold(img1, tRectangle, new Point(0, 0), ">=", perc*0xFFFFFF, 0xFFFF00, 0xffffff, true);

gradClip=this.attachMovie("grad1","grad1",this.getNextHighestDepth());
//var img2:BitmapData = new BitmapData(img1.width, img1.height, false)
var gradientBitmap:BitmapData = new BitmapData(gradClip._width, gradClip._height, true)
var tRect2=new Rectangle(0,0,gradientBitmap.width,gradientBitmap.height);

//var tRect2=new Rectangle(0,0,gradientBitmap.width,gradientBitmap.height);
//trace("Size is "+img2.width+"x"+img2.height);

//mc.attachBitmap(gradientBitmap, 2)
gradientBitmap.draw(gradClip);
gradClip.removeMovieClip();
// Copy channel
var tx=newImageBitmapData.width;//-gradientBitmap.width;
newImageBitmapData.copyChannel(gradientBitmap, tRect2, new Point(tx, 0), 1, 8)


mc.onEnterFrame=function()
{
	tx-=40;
	
	var tCopyRect=new Rectangle(tx,0,50,gradientBitmap.height);
	newImageBitmapData.copyChannel(gradientBitmap, tRect2, new Point(tx, 0), 1, 8);
	//newImageBitmapData.copyChannel(img2, new rect(tx,0,30,200),new Point(tx, 0), 1, 1);
	newImageBitmapData.copyChannel(img2, tCopyRect,new Point(tx, 0), 1, 1);
	newImageBitmapData.copyChannel(img2, tCopyRect,new Point(tx, 0), 2, 2);
	newImageBitmapData.copyChannel(img2, tCopyRect,new Point(tx, 0), 4, 4);
	
	// Copy the "filled" in aspect to the right
	newImageBitmapData.copyChannel(img2, tRect2, new Point(tx+tRect2.width, 0), 8, 8);
}

*/


}