class org.as2base.math.Vector2D
{
	var x: Number;
	var y: Number;
	
	//-- CONSTRUCTOR
	//
	function Vector2D( x: Number, y: Number )
	{
		this.x = x || 0;
		this.y = y || 0;
	}
	
	function length( Void ): Number
	{
		return Math.sqrt( x * x + y * y );
	}
	
	function angle( Void ): Number
	{
		return Math.atan2( y , x );
	}
	
	function dot( v: Vector2D ): Number
	{
		return x * v.x + y * v.y;
	}
		
	function angleBetween( v: Vector2D ): Number
	{
		return Math.acos ( dot( v ) / ( this.length() * v.length() ) );
	}
	
	function reflect( normal: Vector2D ): Void
	{
		var dp: Number = 2 * dot( normal );
		
		x -= normal.x * dp;
		y -= normal.y * dp;
	}
	
	function getReflect( normal: Vector2D ): Vector2D
	{
		var dp: Number = 2 * dot( normal );
		
		return new Vector2D( x - normal.x * dp, y - normal.y * dp );
	}
	
	function negate( Void ): Void
	{
		x = -x;
		y = -y;
	}
	
	function getNegate( Void ): Vector2D
	{
		return new Vector2D( -x , -y );
	}
	
	function orth( Void ): Void
	{
		var tx: Number = -y;
		
		y = x;
		x = tx;
	}
	
	function getOrth( Void ): Vector2D
	{
		return new Vector2D ( -y , x );
	}
	
	function normalize( Void ): Void
	{
		var ln: Number = this.length();
		
		x /= ln;
		y /= ln;
	}
	
	function getNormalize( Void ): Vector2D
	{
		var ln: Number = this.length();
		
		return new Vector2D( x / ln, y / ln );
	}
	
	function normal( Void ): Void
	{
		var ln: Number = this.length();
		var tx: Number = -y / ln;

		y = x / ln;
		x = tx;
	}
	
	function getNormal( Void ): Vector2D
	{
		var ln: Number = this.length();
		
		return new Vector2D ( -y / ln , x / ln );
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
	
	function rotateTo( angle: Number ): Void
	{
		var ln: Number = this.length();
		x = Math.cos( angle ) * ln;
		y = Math.sin( angle ) * ln;
	}
	
	function getRotateTo( angle: Number ): Vector2D
	{
		var ln: Number = this.length();
		
		return new Vector2D( Math.cos( angle ) * ln, Math.sin( angle ) * ln );
	}
	
	function newLength( len: Number ): Void
	{
		var ln: Number = this.length();
		
		x /= ln / len;
		y /= ln / len;
	}
	
	function getNewLength( len: Number ): Vector2D
	{
		var ln: Number = this.length();
		
		return new Vector2D( x / ln * len, y / ln * len );
	}
	
	function plus( v: Vector2D ): Void
	{
		x += v.x;
		y += v.y;
	}
	
	function getPlus( v: Vector2D ): Vector2D
	{
		return new Vector2D( x + v.x, y + v.y );
	}
	
	function minus( v: Vector2D ): Void
	{
		x -= v.x;
		y -= v.y;
	}
	
	function getMinus( v: Vector2D ): Vector2D
	{
		return new Vector2D( x - v.x, y - v.y );
	}
	
	function multiply( f: Number ): Void
	{
		x *= f;
		y *= f;
	}
	
	function getMultiply( f: Number ): Vector2D
	{
		return new Vector2D( x * f, y * f );
	}
	
	function divide( d: Number ): Void
	{
		x /= d;
		y /= d;
	}
	
	function getDivide( d: Number ): Vector2D
	{
		return new Vector2D( x / d, y / d );
	}
	
	function getClone( Void ): Vector2D
	{
		return new Vector2D( x , y );
	}
	
	function toString( Void ): String
	{
		var rx: Number = Math.round ( x * 1000 ) / 1000;
		var ry: Number = Math.round ( y * 1000 ) / 1000;
		
		return '[Vector2D x: ' + rx + ' y: ' + ry + ']';
	}
}