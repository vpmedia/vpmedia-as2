import com.tPS.draw.Shape;
import flash.geom.Point;
/**
 * Draws a Bounding Box 
 * around a given MovieClip
 * 
 * @author tPS
 */
 
class com.tPS.movieClipUtils.BoundingBox {
	private var _rt:MovieClip;
	private var bbox:Shape;
	
	public function BoundingBox($rt:MovieClip, $fs:Object, $ls:Object) {
		_rt = $rt;
		render($fs, $ls);
	}
	
	/**
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 * BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	BEHAVIOUR	
	 */
	private function render($fs:Object, $ls:Object) : Void {
		bbox = new Shape(	_rt,
							[new Point(0,0), new Point(_rt._width, 0), new Point(_rt._width, _rt._height), new Point(0, _rt._height)],
							$fs, 
							$ls);
	}
	
	
	/**
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 * INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	INTERFACE	
	 */
	public function update($fs:Object, $ls:Object) : Void {
		render($fs, $ls);
	}
}