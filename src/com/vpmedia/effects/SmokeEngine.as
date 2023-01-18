// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.SmokeEngine {
	// START CLASS
	public var className:String = "Smoke";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var __viewPort:MovieClip;
	private var __width:Number;
	private var __height:Number;
	private var particles:Array;
	private var mBitmapData:BitmapData;
	private var mPerlinBitmapData:BitmapData;
	private var mDisplaceBitmapData:BitmapData;
	private var mSmokingBitmapData:BitmapData;
	private var mSmokingClip:MovieClip;
	private var mRectangle:Rectangle;
	private var mPoint_1:Point;
	private var mPoint_2:Point;
	private var mMatrix:Matrix;
	private var mBlur;
	private var mDisplacement;
	public var addListener:Function;
	public var removeListener:Function;
	public var broadcastMessage:Function;
	public function SmokeEngine (aViewPort:MovieClip, aWidth:Number, aHeight:Number) {
		viewPort = aViewPort;
		width = aWidth;
		height = aHeight;
		initialize ();
	}
	private function initialize ():Void {
		AsBroadcaster.initialize (this);
		particles = new Array ();
		mBitmapData = new BitmapData (width, height + 20, false, 0x00000000);
		mPerlinBitmapData = new BitmapData (width, 20, false, 0x00000000);
		mSmokingBitmapData = BitmapData.loadBitmap ("queen");
		mSmokingClip = viewPort.createEmptyMovieClip ("queen", 1);
		mSmokingClip.attachBitmap (mSmokingBitmapData, 1, "auto", false);
		mSmokingClip.blendMode = 13;
		viewPort.scrollRect = new Rectangle (0, 0, width, height);
		mRectangle = new Rectangle (0, 0, width, height);
		mPoint_1 = new Point (0, 0);
		mPoint_2 = new Point (0, 0);
		viewPort.attachBitmap (mBitmapData, 0, "auto", false);
		mMatrix = new Matrix ();
		mMatrix.translate (0, height - 20);
		mBlur = new BlurFilter (4, 4, 3);
	}
	public function onEnterFrame ():Void {
		mPoint_1.x += 1;
		mPoint_1.y += .5;
		mPoint_2.x += .5;
		mPoint_2.y += 2;
		mPerlinBitmapData.perlinNoise (width / 2, 10, 2, 12345, false, true, 1, true, [mPoint_1, mPoint_2]);
		mBitmapData.draw (mPerlinBitmapData, mMatrix);
		mBitmapData.applyFilter (mBitmapData, mRectangle, new Point (0, -5), mBlur);
		mDisplacement = new DisplacementMapFilter (mBitmapData, new Point (0, 0), 1, 1, 0, -40, "color", 0x000000, 100);
		mSmokingClip.filters = [mDisplacement];
	}
	public function set viewPort (aViewPort:MovieClip):Void {
		var p = this;
		aViewPort.onEnterFrame = function () {
			p.onEnterFrame ();
		};
		__viewPort = aViewPort;
	}
	public function get viewPort ():MovieClip {
		return __viewPort;
	}
	public function set width (aWidth:Number):Void {
		__width = aWidth;
	}
	public function get width ():Number {
		return __width;
	}
	public function set height (aHeight:Number):Void {
		__height = aHeight;
	}
	public function get height ():Number {
		return __height;
	}
}
