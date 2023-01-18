import am.geom.*;

class am.geom.Line
{
	var p0: Point;
	var p1: Point;

	function Line ( p0: Point, p1: Point )
	{
		this.p0 = p0;
		this.p1 = p1;
	}

	function moveBy ( v ): Void
	{
		p0.moveBy ( v );
		p1.moveBy ( v );
	}
	function getVector(): Vector
	{
		return new Vector( p1.x - p0.x, p1.y - p0.y );
	}
	function getAngle(): Number
	{
		return Math.atan2( p1.y - p0.y , p1.x - p0.x );
	}
	function getNormal(): Vector
	{
		return new Vector( p1.y - p0.y , - ( p1.x - p0.x ) ).normalize();
	}
	function crossProduct( p: Point ): Number
	{
		return ( p0.x - p.x ) * ( p1.y - p.y ) - ( p0.y - p.y ) * ( p1.x - p.x );
	}
	function getLength(): Number
	{
		var dx = p1.x - p0.x;
		var dy = p1.y - p0.y;
		return Math.sqrt( dx * dx + dy * dy );
	}
	function segments ( seg: Number ): Array
	{
		var x1 = p0.x;
		var y1 = p0.y;
		var x2 = p1.x;
		var y2 = p1.y;
		x1 -= x2;
		y1 -= y2;
		x1 /= seg;
		y1 /= (seg++);
		var result = [];
		while ( seg-- ) {
			result.push( new Point( x2 + seg * x1, y2 + seg * y1 ) );
		}
		return result;
	}

	function draw( mc: MovieClip ):Void
	{
		mc.moveTo ( p0.x , p0.y );
		mc.lineTo ( p1.x , p1.y );
	}
	function toString(): String
	{
		return "[class 'Line' x0: " + p0.x + " y0: " + p0.y + " x1: " + p1.x + " y1: " + p1.y + " ]";
	}
}