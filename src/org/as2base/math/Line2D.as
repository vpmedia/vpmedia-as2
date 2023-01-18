import org.as2base.math.*;

class org.as2base.math.Line2D
{
	var x0: Number;
	var y0: Number;
	
	var x1: Number;
	var y1: Number;
	
	function Line2D()
	{
		var argsLen: Number = arguments.length;
		
		if( argsLen == 4 )
		{
			x0 = arguments[0];
			y0 = arguments[1];
			x1 = arguments[2];
			y1 = arguments[3];
		}
		else if( argsLen == 2 )
		{
			var p0: Point2D = arguments[0];
			var p1: Point2D = arguments[1];
			
			x0 = p0.x;
			y0 = p0.y;
			x1 = p1.x;
			y1 = p1.y;
		}
		else
		{
			x0 = 0;
			y0 = 0;
			x1 = 0;
			y1 = 0;
		}
	}
	
	function moveBy( v: Vector2D ): Void
	{
		x0 += v.x;
		y0 += v.y;
		
		x1 += v.x;
		y1 += v.y;
	}
	
	function length( Void ): Number
	{
		var dx: Number = x1 - x0;
		var dy: Number = y1 - y0;
		
		return Math.sqrt( dx * dx + dy * dy );
	}
	
	function angle( Void ): Number
	{
		return Math.atan2( x1 - x0 , y1 - y0 );
	}
	
	function getVector( Void ): Vector2D
	{
		return new Vector2D( x1 - x0 , y1 - y0 );
	}
	
	function getNormal( Void ): Vector2D
	{
		var dx: Number = x1 - x0;
		var dy: Number = y1 - y0;
		
		var ln: Number = Math.sqrt( dx * dx + dy * dy );
		
		return new Vector2D ( -dy / ln , dx / ln );
	}
	
	function getIntersect( line: Line2D ): Point2D
	{
		var x2: Number = line.x0;
		var y2: Number = line.y0;
		
		var dx10: Number = x1 - x0;
		var dy10: Number = y1 - y0;
		
		var dx02: Number = x0 - x2;
		var dy02: Number = y0 - y2;
		
		var dx32: Number = line.x1 - x2;
		var dy32: Number = line.y1 - y2;
		
		var ua: Number = ( dx32 * dy02 - dy32 * dx02 ) / ( dy32 * dx10 - dx32 * dy10 );
		
		return new Point2D( x0 + ua * ( x1 - x0 ) ,  y0 + ua * ( y1 - y0 ) );
	}
	
	function clone( Void ): Line2D
	{
		return new Line2D( x0, y0, x1, y1 );
	}
	
	function draw( timeline: MovieClip ): Void
	{
		timeline.moveTo( x0, y0 );
		timeline.lineTo( x1, y1 );
	}
	
	function toString( Void ): String
	{
		return '[Line2D x0: ' + x0 + ' y0: ' + y0 + ' x1: ' + x1 + ' y1: ' + y1 + ']'
	}
}