import am.geom.*;

class am.geom.Vector
{
	var x: Number;
	var y: Number;

	function Vector ( x: Number, y: Number )
	{
		this.x = x;
		this.y = y;
	}
	function multiply( factor: Number ): Vector
	{
		x *= factor;
		y *= factor;
		return this;
	}
	function getMultiplied ( scalar: Number): Vector
	{
		return new Vector( x * scalar, y * scalar );
	}
	function getDivived ( scalar: Number): Vector
	{
		return new Vector( x / scalar, y / scalar );
	}
	function divide( divisor: Number ): Vector
	{
		x /= divisor;
		y /= divisor;
		return this;
	}
	function normalize(): Vector
	{
		divide( magnitude() );
		return this;
	}
	function rotateByAngle ( angle: Number ): Void
	{
		var tx: Number;
		var sn: Number = Math.sin ( angle );
		var cs: Number = Math.cos ( angle );
		tx = y * sn + x * cs;
		y = y * cs - x * sn;
		x = tx;
	}
	function rotateByMatrix ( sn: Number, cs: Number ): Void
	{
		var tx: Number;
		tx = y * sn + x * cs;
		y = y * cs - x * sn;
		x = tx;
	}
	function getNormalized(): Vector
	{
		var len: Number = magnitude();
		return new Vector( x / len, y / len );
	}
	function scalarProduct( v: Vector ): Number
	{
		return v.x * x + v.y * y;
	}
	function crossProduct( v: Vector ): Number
	{
		return v.y * x - v.x * y;
	}
	function magnitude(): Number
	{
		return Math.sqrt ( x * x + y * y );
	}
	function getAngle(): Number
	{
		return Math.atan2( y , x ) + Math.PI * 2;
	}
	function getAngleBetween ( v ): Number
	{
		return Math.acos( getNormalized().scalarProduct( v.getNormalized() ) );
	}
	function dot( p: Point ): Number
	{
		return x * p.x + y * p.y;
	}
	function summate ( v: Vector ): Vector
	{
		x += v.x;
		y += v.y;
		return this;
	}
	function subtract ( v: Vector ): Vector
	{
		x -= v.x;
		y -= v.y;
		return this;
	}
	function getSummate ( v: Vector ): Vector
	{
		return new Vector( x + v.x, y + v.y );
	}
	function getSubtract ( v: Vector ): Vector
	{
		return new Vector( x - v.x, y - v.y );
	}
	function clone (): Vector
	{
		return new Vector( x , y );
	}

	function toString(): String
	{
		return "[class 'Vector' x: " + ( int( x * 100 ) / 100 ) + " y: " + ( int( y * 100 ) / 100 ) + "]";
	}
}