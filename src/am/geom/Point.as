import am.geom.*;

class am.geom.Point
{
	var x: Number;
	var y: Number;

	function Point ( x: Number, y: Number )
	{
		this.x = x;
		this.y = y;
	}

	function moveBy ( v: Vector ): Void
	{
		x += v.x;
		y += v.y;
	}
	function moveTo ( p: Point ): Void
	{
		x = p.x;
		y = p.y;
	}
	function getSum ( v: Vector ): Point
	{
		return new Point( x + v.x, y + v.y );
	}
	function lerp ( p , t ): Point
	{
		return new Point( x + ( p.x - x ) * t, y + ( p.y - y ) * t );
	}
	function getAngle ( p: Point ): Number
	{
		return Math.atan2( p.y - y , p.x - x );
	}
	function crossProduct( p0: Point, p1: Point ): Number
	{
		return ( p0.x - x ) * ( p1.y - y ) - ( p0.y - y ) * ( p1.x - x );
	}
	function getVector ( p: Point ): Vector
	{
		return new Vector ( p.x - x, p.y - y );
	}
	function summate ( p: Point ): Point
	{
		return new Point( x + p.x, y + p.y );
	}
	function multiply ( t: Number ): Point
	{
		return new Point( x * t, y * t );
	}
	function min (p): Point
	{
	    return new Point( Math.min( x , p.x ), Math.min( y, p.y ) );
	}
	function max (p): Point
	{
	    return new Point( Math.max( x , p.x ), Math.max( y, p.y ) );
	}
	function clone (): Point
	{
		return new Point( x, y );
	}

	function draw( mc: MovieClip, radius: Number, col: Number ): Void {
		mc.lineStyle( radius * 2 , col );
		mc.moveTo( x , y );
		mc.lineTo( x + .5 , y );
	}
	function toString(): String {
		return "[class 'Point' x: " + ( int( x * 100 ) / 100 ) + " y: " + ( int( y * 100 ) / 100 ) + "]";
	}
}