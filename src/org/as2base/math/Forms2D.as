import org.as2base.math.*;

class org.as2base.math.Forms2D
{
	static function getMinEnclosingPolygon( points: Array ): Polygon2D
	{
		points = points.slice();
		
		var p: Number = points.length;
		
		var next;
		var i: Number;
		var min: Number = Number.POSITIVE_INFINITY;
		
		while( --p > -1 )
		{
			if( points[p].y < min )
			{
				next = points[p];
				min  = points[p].y;
				i = p;
			}
		}
		
		var hull: Polygon2D = new Polygon2D( next );
		var edges: Array = hull.getPoints();
		
		//-- DOWNSTREAM
	
		function()
		{
			var m: Number = 0;
			var a: Number;
			var i: Number;
			var p0: Point2d;
			var p1: Point2d;
			var p: Number = points.length;
			var atan2: Function = Math.atan2;
			
			while( --p > -1 )
			{
				if( ( a = atan2( p0.y - next.y, ( p0 = points[p] ).x - next.x ) ) > m )
				{
					m = a;
					i = p;
					p1 = p0;
				}
			}
	
			points.splice( i , 1 );
			
			if( m > 0 )
			{
				edges.push( next = p1 );
				
				arguments.callee();
			}
		}.call();
		
		//-- UPSTREAM
		
		function()
		{
			var m: Number = 0;
			var a: Number;
			var i: Number;
			var p0: Point2d;
			var p1: Point2d;
			var p: Number = points.length;
			var atan2: Function = Math.atan2;
			
			while( --p > -1 )
			{
				if( ( a = atan2( next.y - p0.y, next.x - ( p0 = points[p] ).x ) ) > m )
				{
					m = a;
					i = p;
					p1 = p0;
				}
			}
	
			points.splice( i , 1 );
			
			if( m > 0 )
			{
				edges.push( next = p1 );
				arguments.callee();
			}
		}.call();
		
		return hull;
	}
	
	static function getMinEnclosingCircle( n: Number, p: Array, m: Number, b: Array ): Circle2D
	{
		var c: Point2D = new Point2D( -1, -1 );
		var r: Number = 0;
		
		//... Compute the smallest circle defined by B.
		if( m == 1 )
		{
			c = b[0].getClone();
			r = 0;
		}
		else if( m == 2 )
		{
			c = new Point2d( ( b[0].x + b[1].x ) / 2, ( b[0].y + b[1].y ) / 2 );
			r = b[0].getDistance( c );
		}
		else if( m == 3 )
			return getCircle3Points( b[0], b[1], b[2] );
		
		
		var minC: Circle2D = new Circle2D( c.x, c.y , r );
		
		//... Now see if all the points in P are enclosed.
		for( var i = 0 ;  i < n ;  i++ )
		{
			if( p[i].getDistance( minC ) > minC.r )
			{
				//... Compute B <--- B union P[i].
				b[m] = p[i].getClone();
		
				//... Recurse
				minC = getMinEnclosingCircle( i, p, m + 1 , b );
			}
		}
		
		return minC;
	}
	
	static function getCircle3Points( p1: Point2D, p2: Point2D, p3: Point2D )
    {
		var ma = ( p2.y - p1.y ) / ( p2.x - p1.x );
		var mb = ( p3.y - p2.y ) / ( p3.x - p2.x );

		var x = ( ma * mb * ( p1.y - p3.y ) + mb * ( p1.x + p2.x ) - ma * ( p2.x + p3.x ) ) / ( 2 * ( mb - ma ) );
		var y = ( -1 / ma ) * ( x - ( p1.x + p2.x ) / 2 ) + ( p1.y + p2.y ) / 2;

		var dx = p1.x - x;
		var dy = p1.y - y;

		return new Circle2D ( x , y , Math.sqrt( dx * dx + dy * dy ) );
    }
}






























