// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.Wave {
	// START CLASS
	public var className:String = "Wave";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	var warpBaseX:Number = 200;
	var warpBaseY:Number = 200;
	var warpNumOctaves:Number = 2;
	var warpRandomSeed:Number = Math.random () * 10;
	var warpStitch:Boolean = true;
	var warpFractalNoise:Boolean = true;
	var warpChannelOptions:Number = 1;
	var warpGrayScale:Boolean = false;
	// Offset array for perlin function
	var p1 = new Point (45, 34);
	var p2 = new Point (50, 60);
	function Wave () {
		perlinOffset = new Array (p1, p2);
		warpBMP = new flash.display.BitmapData (400, 300, true, 0x00000000);
	}
	public static function main (__target, __direction) {
		holderClip.blendMode = "overlay";
		__target._parent.onEnterFrame = function () {
			perlinOffset[0].y -= 2;
			perlinOffset[0].x -= 2;
			perlinOffset[1].x += 1;
			perlinOffset[1].y += 1;
			warpBMP.perlinNoise (warpBaseX, warpBaseY, warpNumOctaves, warpRandomSeed, warpStitch, warpFractalNoise, warpChannelOptions, warpGrayScale, perlinOffset);
			dmf = new DisplacementMapFilter (warpBMP, new Point (0, 0), 1, 1, 20, 20, "color");
			holderClip.filters = [dmf];
		};
	}
}
