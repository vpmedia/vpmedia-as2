import flash.geom.Point;
import com.senocular.drawing.PathSegment;
import com.senocular.drawing.PathLineSegment;

class com.senocular.drawing.PathCurveSegment extends PathLineSegment {
	
	private var _control:Point;
	
	// Constructor
	public function PathCurveSegment(startPt:Point, controlPt:Point, endPt:Point) {
		super(startPt, endPt);
		_control = controlPt.clone();
		_command = "curveTo";
	}
		
	// Public Properties
	public function get length():Number {
		if (isNaN(_length)){
			_length = curveLength();
		}
		return _length;
	}
	public function get control():Point {
		return _control.clone();
	}
	
	// Public Methods
	public function draw(target:Object):Void {
		target[command](_control.x, _control.y, _end.x, _end.y);
	}
	public function pointAt(t:Number):Point {
		var p1:Point = Point.interpolate(_control, _start, t);
		var p2:Point = Point.interpolate(_end, _control, t);
		return Point.interpolate(p2, p1, t);
	}
	public function angleAt(t:Number):Number {
		var startPt:Point = super.pointAt(t, _start, _control);
		var endPt:Point = super.pointAt(t, _control, _end);
		return super.angleAt(t, startPt, endPt);
	}
	
	// Private Methods
	private function trim(t:Number, fromStart:Boolean):PathSegment {
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
		var newcontrol:Point;
		var newend:Point = startPt;
		var dscx:Number = _control.x - startPt.x;
		var dscy:Number = _control.y - startPt.y;
		var dcex:Number = endPt.x - _control.x;
		var dcey:Number = endPt.y - _control.y;
		var dx:Number;
		var dy:Number;
		newcontrol = new Point(startPt.x + dscx*t, startPt.y + dscy*t);
		dx = _control.x + dcex*t - newcontrol.x;
		dy = _control.y + dcey*t - newcontrol.y;
		if (fromStart){
			newstart = new Point(newcontrol.x + dx*t, newcontrol.y + dy*t);
		}else{
			newend = new Point(newcontrol.x + dx*t, newcontrol.y + dy*t);
		}
		return new __constructor__(newstart, newcontrol, newend);
	}
	private function curveLength(startPt:Point, controlPt:Point, endPt:Point):Number {
		if (!startPt) startPt = _start;
		if (!controlPt) controlPt = _control;
		if (!endPt) endPt = _end;
		var dx:Number = endPt.x - startPt.x;
		var dy:Number = endPt.y - startPt.y;
		var cx:Number = (controlPt.x - startPt.x)/dx;
		var cy:Number = (controlPt.y - startPt.y)/dy;
		var f1:Number;
		var f2:Number;
		var t:Number;
		var d:Number = 0;
		var p:Point = startPt;
		var np:Point;
		var i:Number;
		for (i=1; i<curveAccuracy; i++){
			t = i/curveAccuracy;
			f1 = 2*t*(1 - t);
			f2 = t*t;
			np = new Point(startPt.x + dx*(f1*cx + f2), startPt.y + dy*(f1*cy + f2));
			d += lineLength(p, np);
			p = np;
		}
		return d + lineLength(p, endPt);
	}
}