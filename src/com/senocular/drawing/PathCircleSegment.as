import flash.geom.Point;
import com.senocular.drawing.PathSegment;
import com.senocular.drawing.PathLineSegment;

class com.senocular.drawing.PathCircleSegment extends PathLineSegment {
	
	private var _control:Point;
	private var _center:Point;
	private var radius:Number = 0;
	private var angleStart:Number = 0;
	private var angleEnd:Number = 0;
	private var arc:Number = 0;
	
	// Constructor
	public function PathCircleSegment(startPt:Point, controlPt:Point, endPt:Point) {
		super(startPt, endPt);
		_control = controlPt.clone();
		_command = "circleTo";
		_center = getCircleCenter(_start, _control, _end);
		if (_center) {
			radius = lineLength(_start, _center);
			angleStart = Math.atan2(_start.y - _center.y, _start.x - _center.x);
			angleEnd = Math.atan2(_end.y - _center.y, _end.x - _center.x);
			if (angleEnd < angleStart) {
				angleEnd += Math.PI*2;
			}
			arc = angleEnd - angleStart;
		}
	}
		
	// Public Properties
	public function get length():Number {
		if (isNaN(_length)){
			_length = circleLength();
		}
		return _length;
	}
	public function get control():Point {
		return _control.clone();
	}
	
	// Public Methods
	public function draw(target:Object):Void {
		if (!_center) {
			return;
		}
		var a1:Number = angleStart;
		var a2:Number;
		var n:Number = Math.floor(arc/(Math.PI/4)) + 1;
		var span:Number = arc/(2*n);
		var spanCos:Number = Math.cos(span);
		var rc:Number = (spanCos) ? radius/spanCos : 0;
		var i:Number;
		for (i=0; i<n; i++) {
			a2 = a1 + span;
			a1 = a2 + span;
			target.curveTo(
				_center.x + Math.cos(a2)*rc,
				_center.y + Math.sin(a2)*rc,
				_center.x + Math.cos(a1)*radius,
				_center.y + Math.sin(a1)*radius
			);
		}
	}
	public function pointAt(t:Number):Point {
		if (!_center) {
			return _start.clone();
		}
		var angle:Number = angleStart + t*arc;
		return new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
	}
	public function angleAt(t:Number):Number {
		var angle:Number = (angleStart + t*arc + (Math.PI/2)) % (Math.PI*2);
		if (angle > Math.PI) {
			angle -= Math.PI*2;
		}else if (angle < -Math.PI) {
			angle += Math.PI*2;
		}
		return angle;
	}
	
	// Private Methods
	private function trim(t:Number, fromStart:Boolean):PathSegment {
		var startPt:Point;
		var endPt:Point;
		if (fromStart){
			endPt = _start;
			startPt = _end;
		}else{
			startPt = _start;
			endPt = _end;
		}
		var newstart:Point = startPt;
		var newcontrol:Point;
		var newend:Point = startPt;
		var angle:Number = angleStart + t*arc;
		if (fromStart){
			newstart = new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
			angle = (angleEnd + angle)/2;
		}else{
			newend = new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
			angle = (angleStart + angle)/2;
		}
		newcontrol = new Point(_center.x + Math.cos(angle)*radius, _center.y + Math.sin(angle)*radius);
		return new __constructor__(newstart, newcontrol, newend);
	}
	
	private function circleLength():Number {
		return radius*arc;
	}
	
	private function getCircleCenter(p1:Point, p2:Point, p3:Point):Point {
		var tmp:Point;
		if (p1.x == p2.x || p1.y == p2.y) {
			tmp = p1;
			p1 = p3;
			p3 = tmp;
		}
		if (p2.x == p3.x) {
			tmp = p1;
			p1 = p2;
			p2 = tmp;
		}
		if (p1.x == p2.x || p2.x == p3.x) return null;
		var ma:Number = (p2.y - p1.y)/(p2.x - p1.x);
		var mb:Number = (p3.y - p2.y)/(p3.x - p2.x);
		if (ma == mb) return null;
		var x12:Number = p1.x + p2.x;
		var x23:Number = p2.x + p3.x;
		var x:Number = (ma*mb*(p1.y - p3.y) + mb*x12 - ma*x23)/(2*(mb - ma));
		var y:Number = (ma) ? (p1.y + p2.y)/2 - (x - x12/2)/ma : (p2.y + p3.y)/2 - (x - x23/2)/mb;
		return new Point(x,y);
	}
}