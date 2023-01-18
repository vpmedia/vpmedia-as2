import am.geom.*;

class am.geom.Connection {

	static function getCircleBy3Points ( p1: Point, p2: Point, p3: Point ): Circle
	{
		var ma = ( p2.y - p1.y ) / ( p2.x - p1.x );
		var mb = ( p3.y - p2.y ) / ( p3.x - p2.x );

		var x = ( ma * mb * ( p1.y - p3.y ) + mb * ( p1.x + p2.x ) - ma * ( p2.x + p3.x ) ) / ( 2 * ( mb - ma ) );
		var y = ( -1 / ma ) * ( x - ( p1.x + p2.x ) / 2 ) + ( p1.y + p2.y ) / 2;

		var dx = p1.x - x;
		var dy = p1.y - y;

		return new Circle ( x , y , Math.sqrt( dx * dx + dy * dy ) );

	}

 	static function get2CirclesTangentPointByBit( c0: Circle , c1: Circle , si: Number ): Point
	{
		var x1 = c0.x;
		var y1 = c0.y;
		var r1 = c0.radius;
		var x2 = c1.x;
		var y2 = c1.y;
		var r2 = c1.radius;
		var xx1, xx2, yy1, yy2, rr1, rr2, dx, dy, dd, s1, s2, dr, t, d, a, b, e, tt1, a1, b1;

		if ( si < 4 )
		{
			xx1 = x1; yy1 = y1; rr1 = r1;
			xx2 = x2; yy2 = y2; rr2 = r2;
		}
		else
		{
			xx1 = x2; yy1 = y2; rr1 = r2;
			xx2 = x1; yy2 = y1; rr2 = r1;
		}

		dx = xx2 - xx1;
		dy = yy2 - yy1;

		dd = Math.sqrt ( dx * dx + dy * dy );

		a1 =  dy / dd;
		b1 = -dx / dd;

		s1 = ( ( si & 2 ) >> 1 ) * 2 - 1;
		s2 = ( si & 1 ) * 2 - 1;

		dr = s2 * rr2 - s1 * rr1;
		t = dr / dd;
		d = ( 1 - t ) * ( 1 + t );

		if ( d < 0 ) d = 0;

		d =  Math.sqrt ( d );

		a = a1 * d + b1 * t;
		b = b1 * d - a1 * t;
		e = xx2 * a + yy2 * b + rr2 * s2;
		tt1 = e - xx1 * a - yy1 * b;

		return new Point( xx1 + a * tt1 , yy1 + b * tt1 );
	}

 }

