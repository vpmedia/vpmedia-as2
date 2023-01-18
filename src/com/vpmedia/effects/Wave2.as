// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.Wave2 {
	// START CLASS
	public var className:String = "Wave";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	public static function doWave (__target) {
		displace_mc.createEmptyMovieClip ("perlin", 1);
		var ramp:MovieClip = displace_mc.ramp;
		ramp.swapDepths (2);
		var speed = 2;
		var channel = 1;
		var flapX = 50;
		var flapY = 50;
		var mode = "clamp";
		var offset = new flash.geom.Point (0, 0);
		var displaceBitmap:flash.display.BitmapData = new flash.display.BitmapData (ramp._width, ramp._height);
		var displaceFilter:flash.filters.DisplacementMapFilter = new flash.filters.DisplacementMapFilter (displaceBitmap, offset, channel, channel, flapX, flapY, mode);
		var baseX = 100;
		var baseY = 100;
		var octs = 1;
		var seed = Math.floor (Math.random () * 50);
		var stitch = true;
		var fractal = true;
		var gray = false;
		var noiseBitmap:flash.display.BitmapData = new flash.display.BitmapData (500, 1);
		noiseBitmap.perlinNoise (baseX, baseY, octs, seed, stitch, fractal, channel, gray);
		var shift:flash.geom.Matrix = new flash.geom.Matrix ();
		onEnterFrame = function () {
			shift.translate (speed, 0);
			with (displace_mc.perlin) {
				clear ();
				beginBitmapFill (noiseBitmap, shift);
				moveTo (0, 0);
				lineTo (ramp._width, 0);
				lineTo (ramp._width, ramp._height);
				lineTo (0, ramp._height);
				lineTo (0, 0);
				endFill ();
			}
			displaceBitmap.draw (displace_mc);
			__target.filters = [displaceFilter];
		};
		displace_mc._visible = false;
		__target._visible = true;
	}
}
