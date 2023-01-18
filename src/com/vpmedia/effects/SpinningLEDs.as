// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
//
import com.vpmedia.effects.LED;
import com.vpmedia.events.Delegate;
// start class
class com.vpmedia.effects.SpinningLEDs {
	// START CLASS
	public var className:String = "SpinningLEDs";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var bmp:BitmapData;
	private var clip:MovieClip;
	private var colors:Array = [0x00ff00, 0xffff00, 0x0000ff, 0xff0000, 0x0000ff, 0xffff00, 0x00ff00];
	private var globeRadius:Number = 200;
	private var intervals:Array = [100, 50, 25, 10, 25, 50, 100];
	private var leds:Array;
	private var numRows:Number = 7;
	private var numSlices:Number = 30;
	private var rotation:Number = .06;
	private var target:MovieClip;
	public static function main (target:MovieClip):Void {
		var app:SpinningLEDs = new SpinningLEDs (target);
	}
	public function SpinningLEDs (target:MovieClip) {
		this.target = target;
		init ();
	}
	private function init ():Void {
		clip = target.createEmptyMovieClip ("clip", 0);
		leds = new Array ();
		for (var i:Number = 0; i < numRows; i++) {
			var zAngle:Number = Math.PI / (numRows + 1) * (i + 1) - Math.PI / 2;
			var cosZ:Number = Math.cos (zAngle);
			var sinZ:Number = Math.sin (zAngle);
			for (var j:Number = 0; j < numSlices; j++) {
				var led = new LED (clip, 8, colors[i], intervals[i]);
				led.x = cosZ * globeRadius;
				led.y = sinZ * globeRadius;
				led.z = 0;
				var yAngle:Number = Math.PI * 2 / numSlices * j;
				var cosy:Number = Math.cos (yAngle);
				var siny:Number = Math.sin (yAngle);
				var x:Number = led.x * cosy + led.z * siny;
				var z:Number = led.z * cosy - led.x * siny;
				led.x = x;
				led.z = z;
				leds.push (led);
			}
		}
		bmp = new BitmapData (Stage.width, Stage.height, false, 0xff000000);
		target.attachBitmap (bmp, target.getNextHighestDepth ());
		target.onEnterFrame = Delegate.create (this, onEnterFrame);
	}
	public function onEnterFrame ():Void {
		var xAngle:Number = .01;
		var cosx:Number = Math.cos (xAngle);
		var sinx:Number = Math.sin (xAngle);
		var cosz:Number = Math.cos (rotation);
		var sinz:Number = Math.sin (rotation);
		for (var i:Number = 0; i < leds.length; i++) {
			var led = leds[i];
			var x:Number = led.x * cosz + led.z * sinz;
			var z:Number = led.z * cosz - led.x * sinz;
			var y:Number = led.y * cosx + z * sinx;
			var z1:Number = z * cosx - led.y * sinx;
			led.x = x;
			led.y = y;
			led.z = z1;
			led.render ();
		}
		bmp.draw (clip, new Matrix ());
		bmp.applyFilter (bmp, bmp.rectangle, new Point (), new BlurFilter (4, 4, 4));
	}
}
