import com.lo9ic.Quaternion;
import com.tPS.vector.Vector;
import com.tPS.draw.Point;

/**
 * 3D vector
 * @author tPS
 */
class com.tPS.vector.Vector3D extends Vector {
	public var z:Number;
	
	public function Vector3D($startpoint : Quaternion, $endpoint : Quaternion) {
		super(new Point($startpoint.x,$startpoint.y),new Point($endpoint.x, $endpoint.y));
		z = ($startpoint && $endpoint) ? $endpoint.z - $startpoint.z : 1;
	}
	
	public function fromCoordinates($startpoint:Quaternion, $endpoint:Quaternion) : Void {
		super.fromCoordinates($startpoint, $endpoint);
		z = ($startpoint && $endpoint) ? $endpoint.z - $startpoint.z : 1;
		calcLength();	
	}
	
	public function fromValues($x:Number, $y:Number) : Void {
		x = $x;
		y = $y;
		calcLength();	
	}
	
	private function calcLength(): Void {
		length = Math.sqrt(Math.pow(x,2) + Math.pow(y,2) + Math.pow(z,2));
	}

}