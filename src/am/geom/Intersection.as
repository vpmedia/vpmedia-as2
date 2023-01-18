import am.geom.*;

class am.geom.Intersection
{
	static function getEllipseLine( ellipse: Ellipse, line: Line ): Array
	{
		var result = new Array();
		var a1 = line.p0;
		var a2 = line.p1;
		var xradius = ellipse.xradius;
		var yradius = ellipse.yradius;
		var origin = new Vector( a1.x, a1.y );
		var dir    = a1.getVector( a2 );
		var center = new Vector( ellipse.x, ellipse.y );
		var diff   = origin.getSubtract( center );
		var mDir   = new Vector( dir.x  / ( xradius * xradius ), dir.y  / ( yradius * yradius ) );
		var mDiff  = new Vector( diff.x / ( xradius * xradius ), diff.y / ( yradius * yradius ) );

		var a = dir.dot(  mDir );
		var b = dir.dot( mDiff );
		var c = diff.dot( mDiff ) - 1.0;
		var d = b * b - a * c;

		if ( d < 0 )
		{
			//-- OUTSIDE
			return result;
		}
		else if ( d > 0 )
		{
			var root = Math.sqrt(d);
			var t_a  = (-b - root) / a;
			var t_b  = (-b + root) / a;

			if ( (t_a < 0 || 1 < t_a) && (t_b < 0 || 1 < t_b) )
			{
				if ( (t_a < 0 && t_b < 0) || (t_a > 1 && t_b > 1) )
					//-- OUTSIDE
					return result;
				else
					//-- INSIDE
					return result;
			}
			else
			{
				//-- INTERSECTION
				if ( 0 <= t_a && t_a <= 1 )
				{
					result.push( a1.lerp(a2, t_a) );
				}
				if ( 0 <= t_b && t_b <= 1 )
				{
					result.push( a1.lerp(a2, t_b) );
				}
			}
		}
		else
		{
			var t = -b / a;
			if ( 0 <= t && t <= 1 )
			{
				//-- INTERSECTION
				result.push( a1.lerp( a2 , t ) );
			}
			else
			{
				//-- OUTSIDE
			}
		}
		return result;
	}

	static function getCircleLine ( circle: Circle, line: Line ): Array
	{
		//-- GET LOCAL
		var p0 = line.p0;
		var p1 = line.p1;
		var cr = circle.radius;
		var cx = circle.x;
		var cy = circle.y;
		//-- PRECALC LOCAL
		var dx = p1.x - p0.x;
		var dy = p1.y - p0.y;
		var a2  = ( dx * dx + dy * dy ) * 2;
		var b  = 2 * ( dx * ( p0.x - cx ) + dy * ( p0.y - cy ) );
		var cc = cx * cx + cy * cy + p0.x * p0.x + p0.y * p0.y - 2 * ( cx * p0.x + cy * p0.y ) - cr * cr;
		var deter = b*b - 2*a2*cc;
		if ( deter < 0 )
		{
			return [];
		}
		else
		{
			var e  = Math.sqrt( deter );
			var u1 = (  e - b ) / a2;
			var u2 = ( -b - e ) / a2;

			if ( ( u1 > 0 && u1 < 1 ) || ( u2 > 0 && u2 < 1 ) )
			{
				//-- INTERSECTION
				if ( u1 == u2 )
				{
					//-- TANGENT
					return [ p0.lerp( p1 , u1 ) ];
				}
				var points = new Array();
				if ( 0 <= u1 && u1 <= 1 )
				{
					points.push( p0.lerp( p1 , u1 ) );
				}
				if ( 0 <= u2 && u2 <= 1 )
				{
					points.push( p0.lerp( p1 , u2 ) );
				}
			}
		}
		return points;
	};

	static function getBezier2Line( bezier2: Bezier2, line: Line ): Array
	{
		var p1 = bezier2.p0;
		var p2 = bezier2.p1;
		var p3 = bezier2.p2;

		var a1 = line.p0;
		var a2 = line.p1;

		var points = new Array();

		var a, b;
		var c2, c1, c0;
		var cl;
		var n;
		var min = a1.min( a2 );
		var max = a1.max( a2 );

		a = p2.multiply( -2 );
		c2 = p1.summate( a.summate( p3 ) );
		a = p1.multiply(-2);
		b = p2.multiply(2);
		c1 = a.summate(b);

		n = new Vector( a1.y - a2.y, a2.x - a1.x );
		cl = a1.x * a2.y - a2.x * a1.y;

		var roots = Polynomial.getQuadraticRoots( n.dot(c2), n.dot(c1), n.dot(p1) + cl );

		for ( var i in roots )
		{
			var t = roots[i];

			if ( 0 <= t && t <= 1 )
			{
				var p4 = p1.lerp(p2, t);
				var p5 = p2.lerp(p3, t);
				var p6 = p4.lerp(p5, t);
				// P6 IS NOW INTERSECTION POINT FOR ENDLESS LINES
				if ( a1.x == a2.x )
				{
					if ( min.y <= p6.y && p6.y <= max.y )
					{
						points.push( p6 );
					}
				}
				else if ( a1.y == a2.y )
				{
					if ( min.x <= p6.x && p6.x <= max.x )
					{
						points.push( p6 );
					}
				}
				else if ( p6.x >= min.x && p6.y >= min.y && p6.x <= max.x && p6.y <= max.y )
				{
					points.push( p6 );
				}
			}
		}
		return points;
	}


	static function getLineLine ( l0: Line , l1: Line )
	{
		var l0p0 = l0.p0;
		var l0p1 = l0.p1;
		var l1p0 = l1.p0;
		var l1p1 = l1.p1;
		var ua_t = l1p0.crossProduct( l1p1 , l0p0 );
		var ub_t = l0p0.crossProduct( l1p0 , l0p1 );
		var u_b  = l0p0.getVector( l0p1 ).crossProduct( l1p0.getVector( l1p1 ) );
		var ua = ua_t / u_b;
		var ub = ub_t / u_b;
		if ( 0 <= ua && ua <= 1 && 0 <= ub && ub <= 1 )
		{
			return new Point( l1p0.x + ub * ( l1p1.x - l1p0.x ), l1p0.y + ub * ( l1p1.y - l1p0.y ) );
		}
		return false;
	}

	static function getStraightStraight ( l0: Line , l1: Line ): Point
	{
		var l0p0 = l0.p0;
		var l0p1 = l0.p1;
		var l1p0 = l1.p0;
		var l1p1 = l1.p1;
		var ua_t = l1p0.crossProduct( l1p1 , l0p0 );
		var ub_t = l0p0.crossProduct( l1p0 , l0p1 );
		var u_b  = l0p0.getVector( l0p1 ).crossProduct( l1p0.getVector( l1p1 ) );
		var ua = ua_t / u_b;
		var ub = ub_t / u_b;
		//-- IGNORE PARALLEL
		return new Point( l1p0.x + ub * ( l1p1.x - l1p0.x ), l1p0.y + ub * ( l1p1.y - l1p0.y ) );
	}
}