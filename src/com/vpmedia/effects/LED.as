// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.LED {
	// START CLASS
	public var className:String = "LED";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var centerX:Number;
	private var centerY:Number;
	private var centerZ:Number;
	private var clip:MovieClip;
	private var color:Number;
	private var fl:Number = 250;
	private var interval:Number;
	private var size:Number;
	private var target:MovieClip;
	public var x:Number = 0;
	public var y:Number = 0;
	public var z:Number = 0;
	public function LED (target:MovieClip, size:Number, color:Number, interval:Number) {
		this.target = target;
		this.size = size;
		this.color = color;
		this.interval = interval;
		init ();
	}
	private function init ():Void {
		centerX = Stage.width / 2;
		centerY = Stage.height / 2;
		centerZ = 200;
		var depth:Number = target.getNextHighestDepth ();
		clip = target.createEmptyMovieClip ("led" + depth, depth);
		var radius:Number = size / 2;
		clip.beginFill (color, 100);
		clip.moveTo (radius, 0);
		for (var i:Number = 0; i < Math.PI * 2; i += .1) {
			clip.lineTo (Math.cos (i) * radius, Math.sin (i) * radius);
		}
		clip.lineTo (radius, 0);
		clip.endFill ();
		setInterval(this, "switchMode", interval);
	}
	public function setPos (x:Number, y:Number, z:Number):Void {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	public function show (b:Boolean):Void {
		clip._visible = b;
	}
	public function render ():Void {
		var scale:Number = fl / (fl + z + centerZ);
		clip._x = centerX + x * scale;
		clip._y = centerY + y * scale;
		clip._xscale = clip._yscale = scale * 100;
		clip.swapDepths (-z);
	}
	private function switchMode ():Void {
		clip._visible = !clip._visible;
	}
}
