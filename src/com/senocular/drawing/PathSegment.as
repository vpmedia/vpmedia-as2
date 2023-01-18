import flash.geom.Point;
import com.senocular.drawing.*;

class com.senocular.drawing.PathSegment {
	public var _command:String = "moveTo";
	public var _length:Number;
	private var _start:Point;
	private var _end:Point;
	private var __constructor__:Function;
	
	public static var curveAccuracy:Number = 5;
	
	// Constructor
	public function PathSegment(startPt:Point, endPt:Point){
		_start = startPt.clone();
		_end = _start;
	}
	// Public Properties
	public function get command():String {
		return _command;
	}
	public function get start():Point {
		return _start.clone();
	}
	public function get end():Point {
		return _end.clone();
	}
	public function get length():Number {
		return 0;
	}
	
	// Public Methods
	public function toString(Void):String {
		return "["+command+"]";
	}
	public function draw(target:Object):Void {
		target[command](_end.x, _end.y);
	}
	public function trim(t:Number, fromStart:Boolean):PathSegment {
		return this;
	}
	public function pointAt(t:Number, startPt:Point, endPt:Point):Point {
		return _start.clone();
	}
	public function angleAt(t:Number, startPt:Point, endPt:Point):Number {
		return 0;
	}
}