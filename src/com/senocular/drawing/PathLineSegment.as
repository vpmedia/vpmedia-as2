import flash.geom.Point;
import com.senocular.drawing.PathSegment;

class com.senocular.drawing.PathLineSegment extends PathSegment {
	
	// Constructor
	public function PathLineSegment(startPt:Point, endPt:Point){
		super(startPt, endPt);
		_end = endPt;
		_command = "lineTo";
	}
	
	// Public Properties
	public function get length():Number {
		if (isNaN(_length)){
			_length = lineLength();
		}
		return _length;
	}
	
	// Public Methods
	public function segment(t1:Number, t2:Number):PathSegment {
		if (t2 == 1){
			if (t1 == 0) return this;
			return trim(t1, true);
		}
		var seg:PathSegment = trim(t2);
		if (t1 != 0){
			seg = seg.trim(t1/t2, true);
		}
		return seg;
	}
	public function trim(t:Number, fromStart:Boolean):PathSegment {
		var startPt:Point;
		var endPt:Point;
		if (fromStart){
			endPt = _start;
			startPt = _end;
			t = 1 - t;
		}else{
			startPt = _start;
			endPt = _end;
		}
		var newstart:Point = startPt;
		var newend:Point = startPt;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		if (fromStart){
			newstart = new Point(startPt.x + dx*t, startPt.y + dy*t);
		}else{
			newend = new Point(startPt.x + dx*t, startPt.y + dy*t);
		}
		return new __constructor__(newstart, newend);
	}
	public function pointAt(t:Number, startPt:Point, endPt:Point):Point {
		if (!startPt) startPt = _start;
		if (!endPt) endPt = _end;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		return new Point(startPt.x + dx*t, startPt.y + dy*t);
	}
	public function angleAt(t:Number, startPt:Point, endPt:Point):Number {
		if (!startPt) startPt = _start;
		if (!endPt) endPt = _end;
		return Math.atan2(endPt.y - startPt.y, endPt.x - startPt.x);
	}
	public function lineLength(startPt:Point, endPt:Point):Number {
		if (!startPt) startPt = _start;
		if (!endPt) endPt = _end;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		return Math.sqrt(dx*dx + dy*dy);
	}
}