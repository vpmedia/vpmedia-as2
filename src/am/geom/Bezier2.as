import am.geom.*;

class am.geom.Bezier2
{

	public var p0: Point;
	public var p1: Point;
	public var p2: Point;

	function Bezier2 ( p0: Point, p1: Point, p2: Point )
	{
		this.p0 = p0;
		this.p1 = p1;
		this.p2 = p2;
	}
	function getPointByT ( t: Number ): Point
	{
		return new Point( ( 1 - t ) * ( 1 - t ) * p0.x + 2 * t * ( 1 - t ) * p1.x + t * t * p2.x , ( 1 - t ) * ( 1 - t ) * p0.y + 2 * t * ( 1 - t ) * p1.y + t * t * p2.y );
	}
	function draw ( mc ): Void
	{
		mc.moveTo ( p0.x , p0.y );
		mc.curveTo ( p1.x , p1.y , p2.x , p2.y );
	}
	function getNormalThroughPoint ( p: Point ): Vector
	{
		var d0x = p0.x - p.x;
		var d0y = p0.y - p.y;
		var d1x = p1.x - p.x;
		var d1y = p1.y - p.y;
		var d2x = p2.x - p.x;
		var d2y = p2.y - p.y;

		var d00 = d0x * d0x + d0y * d0y;
		var d11 = d1x * d1x + d1y * d1y;
		var d22 = d2x * d2x + d2y * d2y;
		var d01 = d0x * d1x + d0y * d1y;
		var d02 = d0x * d2x + d0y * d2y;
		var d12 = d1x * d2x + d1y * d2y;

		var c0 = d01 - d00;
		var c1 = (3*d00-6*d01+2*d11+d02);
		var c2 = (-3*d00+9*d01-6*d11-3*d02+3*d12);
		var c3 = (d00-4*d01+4*d11+2*d02-4*d12+d22);

		var roots = Polynomial.getCubicRoots( c3 , c2 , c1 , c0 );

		for( var i in roots )
		{
			var t=roots[ i ];
			if( 0 <= t && t <= 1 ) break;
		}

		var x = ( 1 - t ) * ( 1 - t ) * p0.x + 2 * t * ( 1 - t ) * p1.x + t * t * p2.x;
		var y = ( 1 - t ) * ( 1 - t ) * p0.y + 2 * t * ( 1 - t ) * p1.y + t * t * p2.y;

		return new Vector( p.x - x, p.y - y );
	}
}
