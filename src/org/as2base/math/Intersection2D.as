import org.as2base.math.*;

/* based on copyright 2002-2003, Kevin Lindsey */

class org.as2base.math.Intersection2D
{
	private var points: Array;
	private var status: String;
	
	function Intersection2D( status: String )
	{
		this.status = status;

		points = new Array;
	}
	
	function getIntersectionPoints( Void ): Array
	{
		return points;
	}
	
	function getIntersectionStatus( Void ): String
	{
		return status;
	}
	
	function getBoolean( Void ): Boolean
	{
		return points.length > 0;
	}
	
	static function intersectLineLine( l0: Line2D, l1: Line2D ): Intersection2D
	{
		var x0: Number = l0.x0;
		var y0: Number = l0.y0;

		var x1: Number = l0.x1;
		var y1: Number = l0.y1;
		
		var x2: Number = l1.x0;
		var y2: Number = l1.y0;
	
		var dx10: Number = x1 - x0;
		var dy10: Number = y1 - y0;
		
		var dx02: Number = x0 - x2;
		var dy02: Number = y0 - y2;
		
		var dx32: Number = l1.x1 - x2;
		var dy32: Number = l1.y1 - y2;
		
		var ud: Number = ( dy32 * dx10 - dx32 * dy10 );
		
		var ua: Number = ( dx32 * dy02 - dy32 * dx02 );
		var ub: Number = ( dx10 * dy02 - dy10 * dx02 );
		
		if( ud == 0 )
		{
			if( ua == 0 && ub == 0 )
			{
				return new Intersection2D( 'Coincident' );
			}
			else
			{
				return new Intersection2D( 'Parallel' );
			}
		}
		else if( ( ua /= ud ) >= 0 && ua <= 1 && ( ub /= ud ) >= 0 && ub <= 1 )
		{
			var result: Intersection2D = new Intersection2D( 'Intersection' );
			
			result.points.push( new Point2D( x0 + ua * dx10 ,  y0 + ua * dy10 ) );
			
			return result;
		}
		else
		{
			return new Intersection2D( 'No Intersection' );
		}
	}
	
	static function intersectStraightStraight( l0: Line2D, l1: Line2D ): Intersection2D
	{
		var x0: Number = l0.x0;
		var y0: Number = l0.y0;

		var x1: Number = l0.x1;
		var y1: Number = l0.y1;
		
		var x2: Number = l1.x0;
		var y2: Number = l1.y0;
	
		var dx10: Number = x1 - x0;
		var dy10: Number = y1 - y0;
		
		var dx02: Number = x0 - x2;
		var dy02: Number = y0 - y2;
		
		var dx32: Number = l1.x1 - x2;
		var dy32: Number = l1.y1 - y2;
		
		var ud: Number = ( dy32 * dx10 - dx32 * dy10 );
		
		var ua: Number = ( dx32 * dy02 - dy32 * dx02 );
		var ub: Number = ( dx10 * dy02 - dy10 * dx02 );
		
		if( ud == 0 )
		{
			if( ua == 0 && ub == 0 )
			{
				return new Intersection2D( 'Coincident' );
			}
			else
			{
				return new Intersection2D( 'Parallel' );
			}
		}
		else
		{
			ua /= ud;
			ub /= ud;
			
			var result: Intersection2D = new Intersection2D( 'Intersection' );
			
			result.points.push( new Point2D( x0 + ua * dx10 ,  y0 + ua * dy10 ) );
			
			return result;
		}
	}
}









