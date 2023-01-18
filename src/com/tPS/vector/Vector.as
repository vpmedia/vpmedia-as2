import com.tPS.draw.Point;
/**
 * Abstract Vector Class
 * 
 * @author tPS
 */
class com.tPS.vector.Vector {
	public var x:Number;
	public var y:Number;
	public var length:Number;
	
	public function Vector($startpoint:Point, $endpoint:Point) {
		x = ($startpoint && $endpoint) ? $endpoint.x - $startpoint.x : 1;	
		y = ($startpoint && $endpoint) ? $endpoint.y - $startpoint.y : 1;
		calcLength();
	}
	
	public function fromCoordinates($startpoint:Object, $endpoint:Object) : Void {
		x = ($startpoint && $endpoint) ? $endpoint.x - $startpoint.x : 1;	
		y = ($startpoint && $endpoint) ? $endpoint.y - $startpoint.y : 1;
		calcLength();	
	}
	
	public function fromValues($x:Number, $y:Number) : Void {
		x = $x;
		y = $y;
		calcLength();	
	}
	
	private function calcLength(): Void {
		length = Math.sqrt(Math.pow(x,2) + Math.pow(y,2));
	}
	
	public function get _length() : Number {
		return length;
	}
	
	
	
}