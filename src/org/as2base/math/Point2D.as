import org.as2base.math.*;

class org.as2base.math.Point2D
{
	var x: Number;
	var y: Number;
	
	function Point2D( x: Number, y: Number )
	{
		this.x = x || 0;
		this.y = y || 0;
	}
	
	function moveBy( v: Vector2D ): Void
	{
		x += v.x;
		y += v.y;
	}
	
	function getMoveBy( v: Vector2D ): Point2D
	{
		return new Point2D( x + v.x , y + v.y );
	}
	
	function rotateBy( angle: Number ): Void
	{
		var ca: Number = Math.cos ( angle );
		var sa: Number = Math.sin ( angle );
		var rx: Number = x * ca - y * sa;
		y = x * sa + y * ca;
		x = rx;
	}
	
	function getRotateBy( angle: Number ): Vector2D
	{
		var ca: Number = Math.cos ( angle );
		var sa: Number = Math.sin ( angle );
		var rx: Number = x * ca - y * sa;
		
		return new Vector2D( rx , x * sa + y * ca );
	}
	
	function getDistance( p: Point2D ): Number
	{
		var dx: Number = p.x - x;
		var dy: Number = p.y - y;
		
		return Math.sqrt( dx * dx + dy * dy );
	}
	
	function getClone( Void ): Point2D
	{
		return new Point2D( x , y );
	}
	
	function toString( Void ): String
	{
		var rx: Number = Math.round ( x * 1000 ) / 1000;
		var ry: Number = Math.round ( y * 1000 ) / 1000;
		
		return '[Point2D x: ' + rx + ' y: ' + ry + ']';
	}
}