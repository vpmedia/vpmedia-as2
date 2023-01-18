import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
class com.vpmedia.effects.Pixelate {
	// START CLASS
	public var className:String = "Pixelate";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	function Pixelate () {
	}
	public static function main (__target, __direction) {
		if (!__direction) {
			__direction = 0;
		}
		__target._visible = false;
		var pixelated_mc = __target._parent.createEmptyMovieClip ("pixelated_mc", 1);
		pixelated_mc._x = __target._x;
		pixelated_mc._y = __target._y;
		if (__direction == 0) {
			var pixelSize = 80;
		} else {
			var pixelSize = 1;
		}
		__target._parent.onEnterFrame = function () {
			var bitmapData = new BitmapData (__target._width / pixelSize, __target._height / pixelSize, false);
			pixelated_mc.attachBitmap (bitmapData, 1);
			var scaleMatrix = new Matrix ();
			scaleMatrix.scale (1 / pixelSize, 1 / pixelSize);
			bitmapData.draw (__target, scaleMatrix);
			pixelated_mc._width = __target._width;
			pixelated_mc._height = __target._height;
			if (__direction == 0) {
				pixelSize /= 1.3;
				if (pixelSize < 1) {
					__target._visible = true;
					bitmapData.dispose ();
					removeMovieClip (pixelated_mc);
					delete this.onEnterFrame;
				}
			} else {
				pixelSize *= 1.3;
				if (pixelSize > 80) {
					delete this.onEnterFrame;
				}
			}
		};
	}
}
