import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
class com.vpmedia.effects.PixelDissolve {
	// START CLASS
	public var className:String = "PixelDissolve";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	function PixelDissolve () {
	}
	
	public static function main (__target,a_mc,b_mc) {
		w = 200;
		h = 200;
		mat = new Matrix (1, 0, 0, 1, 0, 0);
		rect = new Rectangle (0, 0, w, h);
		pt = new Point (0, 0);
		var min = 0;
		var max = 100;
		a = new BitmapData (w, h, true);
		b = new BitmapData (w, h, true);
		a.draw (a_mc, mat);
		b.draw (b_mc, mat);
		c = a.clone ();
		d = b.clone ();
		__target.createEmptyMovieClip ("one_mc", 1);
		one_mc.attachBitmap (a, 1);
		__target.createEmptyMovieClip ("two_mc", 2);
		two_mc.attachBitmap (b, 1);
		one_mc._x = a_mc._x;
		one_mc._y = a_mc._y;
		two_mc._x = b_mc._x;
		two_mc._y = b_mc._y;
		a_mc._visible = false;
		b_mc._visible = false;
		seed = new Date ();
		i = 0;
		s = 3;
		
		__target._parent.onEnterFrame = function () {
			i += s;
			if (i > max) {
				i = max;
				s *= -1;
			} else if (i < min) {
				i = min;
				s *= -1;
			}
			var numPixels = ((w * h) / 100) * percent;
			a.floodFill (0, 0, 0xFFFFFFFF);
			a.draw (a_mc, mat);
			b.floodFill (0, 0, 0xFFFFFFFF);
			b.draw (b_mc, mat);
			a.pixelDissolve (d, rect, pt, seed, numPixels);
			b.pixelDissolve (c, rect, pt, seed, numPixels);
			};
		
	}
}
