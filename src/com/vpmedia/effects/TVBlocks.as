// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.TVBlocks {
	// START CLASS
	public var className:String = "TVBlocks";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var scope:MovieClip;
	private var numRows:Number;
	private var numBlocks:Number;
	private var blockSize:Number;
	private var target:MovieClip;
	private var blurAmt:Number = 0;
	function TVBlocks (s:MovieClip) {
		scope = s;
		scope.createEmptyMovieClip ("TVBlocksContainer_mc", 1);
	}
	public function setTarget (m:MovieClip):Void {
		target = m;
	}
	public function getTarget ():MovieClip {
		return target;
	}
	public function setBlockSize (n:Number):Void {
		blockSize = n;
	}
	public function setNumRows (n:Number):Void {
		numRows = n;
	}
	public function setNumBlocks (n:Number):Void {
		numBlocks = n;
	}
	public function setBlurAmount (n:Number):Void {
		blurAmt = n;
	}
	public function createBlocks ():Void {
		var row:Number = 0;
		for (var i:Number = 0; i < numBlocks; i++) {
			scope.TVBlocksContainer_mc.createEmptyMovieClip ("block" + i, i + 1);
			var bmp:BitmapData = new BitmapData (blockSize, blockSize, false, 0xFFFF00);
			var nClip:MovieClip = scope.TVBlocksContainer_mc["block" + i];
			nClip.attachBitmap (bmp, 1);
			var lClip:MovieClip;
			if (i > 0) {
				lClip = scope.TVBlocksContainer_mc["block" + (i - 1)];
				nClip._x = lClip._x + blockSize;
				if (i % (numBlocks / numRows) == 0) {
					nClip._y = lClip._y + blockSize;
					nClip._x = 0;
				} else {
					nClip._y = lClip._y;
					nClip._x = lClip._x + blockSize;
				}
			}
			var randomNum:Number = Math.floor (Math.random () * 5);
			bmp.perlinNoise (blockSize, blockSize, 6, randomNum, false, true, 1, true, null);
		}
		var blocksBMP:BitmapData = new BitmapData (scope.TVBlocksContainer_mc._width, scope.TVBlocksContainer_mc._height);
		blocksBMP.draw (scope.TVBlocksContainer_mc);
		scope.TVBlocksContainer_mc._visible = false;
		var mapPoint:Point = new Point (_xmouse, _ymouse);
		var componentX:Number = 1;
		var componentY:Number = 1;
		var scaleX:Number = 100;
		var scaleY:Number = 100;
		var mode:String = "clamp";
		var color:Number = 0xFF0000;
		var alpha:Number = 0x00FF00;
		var filter:DisplacementMapFilter = new DisplacementMapFilter (blocksBMP, mapPoint, componentX, componentY, scaleX, scaleY, mode, color, alpha);
		var blur:BlurFilter = new BlurFilter (blurAmt, blurAmt, 1);
		blocksBMP.applyFilter (blocksBMP, blocksBMP.rectangle, new Point (0, 0), blur);
		getTarget ().filters = [filter];
	}
	public function update ():Void {
		createBlocks ();
	}
	public function getBlocks ():MovieClip {
		return scope.TVBlocksContainer_mc;
	}
}
