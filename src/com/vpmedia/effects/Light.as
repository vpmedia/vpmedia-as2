// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.Light {
	// START CLASS
	public var className:String = "Light";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var mc:MovieClip;
	private var tl:MovieClip;
	//private var blur: BlurFilter = new BlurFilter( 0, 4, 3 );
	//private var obj: Object = new Object( );
	//private var copo2: Copo2 = new Copo2( );
	private var glow:GlowFilter;
	function Light (timeline:MovieClip) {
		this.tl = timeline;
		//this.blur = new BlurFilter( 0, 4, 3 );
		var color:Number = 0xFF0000;
		var alpha:Number = .8;
		var blurX:Number = 35;
		var blurY:Number = 35;
		var strength:Number = 6;
		var quality:Number = 3;
		var inner:Boolean = false;
		var knockout:Boolean = false;
		this.glow = new GlowFilter (color, alpha, blurX, blurY, strength, quality, inner, knockout);
	}
	public function init (linkage:String, width:Number, height:Number) {
		this.mc = this.tl.createEmptyMovieClip (linkage, this.tl.getNextHighestDepth ());
		var bm:BitmapData = BitmapData.loadBitmap (linkage);
		this.mc.beginBitmapFill (bm);
		this.mc.moveTo (0, 0);
		this.mc.lineTo (width, 0);
		this.mc.lineTo (width, height);
		this.mc.lineTo (0, height);
		this.mc.lineTo (0, 0);
		this.mc.endFill ();
	}
	public function setPos (newPos:Point) {
		this.mc._x = newPos.x;
		this.mc._y = newPos.y;
	}
	public function fallStep () {
		var myFilters:Array = Array (this.mc.filters);
		//myFilters.push( this.blur );
		myFilters[0] = this.glow;
		this.mc.filters = myFilters;
		this.mc._y++;
	}
	public function getY () {
		return this.mc._y;
	}
	public function dispose () {
		this.mc.swapDepths (1000);
		this.mc.removeMovieClip ();
	}
}
