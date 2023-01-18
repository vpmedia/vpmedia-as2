import flash.geom.Point;
import com.senocular.drawing.PathLineSegment;

class com.senocular.drawing.PathMoveSegment extends PathLineSegment {
	
	// Constructor
	public function PathMoveSegment(startPt:Point, endPt:Point) {
		super(startPt, endPt);
		_command = "moveTo";
	}
}