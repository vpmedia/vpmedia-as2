// -- #############################################################
// -- (c) 2003 Grigory Ryabov
// -- http://www.flash.plux.ru
// -- #############################################################
class com.nuran.f3d.Vector4d
{
	public var x:Number;
	public var y:Number;
	public var z:Number;
	public var w:Number;
	function Vector4d (__x:Number, __y:Number, __z:Number, __w:Number)
	{
		x = __x;
		y = __y;
		z = __z;
		w = __w;
	}
	//00-----------------------------------------------------------------------------------
	public function addition (__ax:Number, __ay:Number, __az:Number, __aw:Number):Void
	{
		var h:Number = w / __aw;
		x += __ax * h;
		y += __ay * h;
		z += __az * h;
	}
	//00-----------------------------------------------------------------------------------
	public function angle (__v4d:Vector4d):Number
	{
		var cosine:Number = normal ().dotProduct (__v4d.normal ());
		return (cosine >= 1.0) ? 0.0 : (cosine <= -1.0) ? Math.PI : Math.acos (cosine);
	}
	//00-----------------------------------------------------------------------------------
	public function copy (__v4d:Vector4d):Void
	{
		x = __v4d.x;
		y = __v4d.y;
		z = __v4d.z;
		w = __v4d.w;
	}
	//00-----------------------------------------------------------------------------------
	public function crossProduct (__v4d:Vector4d):Vector4d
	{
		var a:Vector4d = new Vector4d (x, y, z, w);
		var b:Vector4d = new Vector4d (__v4d.x, __v4d.y, __v4d.z, __v4d.w);
		a.homogenize ();
		b.homogenize ();
		return new Vector4d (a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
	}
	//00-----------------------------------------------------------------------------------
	public function distance ():Number
	{
		return null;
	}
	//00-----------------------------------------------------------------------------------
	public function division (__dx:Number, __dy:Number, __dz:Number, __dw:Number):Void
	{
		x /= __dx;
		y /= __dy;
		z /= __dz;
		w *= __dw;
	}
	//00-----------------------------------------------------------------------------------
	public function dominantAxis ():Vector4d
	{
		var xx, yy:Number;
		if ((xx = Math.abs (x)) > (yy = Math.abs (y))) {
			return (xx > Math.abs (z)) ? new Vector4d (1.0, 0.0, 0.0, 1.0) : new Vector4d (0.0, 0.0, 1.0, 1.0);
		} else {
			return (yy > Math.abs (z)) ? new Vector4d (0.0, 1.0, 0.0, 1.0) : new Vector4d (0.0, 0.0, 1.0, 1.0);
		}
	}
	//00-----------------------------------------------------------------------------------
	public function dotProduct (__v4d:Vector4d):Number
	{
		var a:Vector4d = new Vector4d (x, y, z, w);
		var b:Vector4d = new Vector4d (__v4d.x, __v4d.y, __v4d.z, __v4d.w);
		a.homogenize ();
		b.homogenize ();
		return (a.x * b.x + a.y * b.y + a.z * b.z);
	}
	//00-----------------------------------------------------------------------------------
	public function equality (__v4d:Vector4d):Boolean
	{
		var h:Number = w / __v4d.w;
		return (x == (__v4d.x * h) && y == (__v4d.y * h) && z == (__v4d.z * h));
	}
	//00-----------------------------------------------------------------------------------
	public function get (__v4d:Vector4d):Vector4d
	{
		return new Vector4d (x, y, z, w);
	}
	//00-----------------------------------------------------------------------------------
	public function getAddition (__ax:Number, __ay:Number, __az:Number, __aw:Number):Vector4d
	{
		var h:Number = w / __aw;
		return new Vector4d (x + __ax * h, y + __ay * h, z + __az * h, w);
	}
	//00-----------------------------------------------------------------------------------
	public function getDivision (__dx:Number, __dy:Number, __dz:Number, __dw:Number):Vector4d
	{
		return new Vector4d (x / __dx, y / __dy, z / __dz, w * __dw);
	}
	//00-----------------------------------------------------------------------------------
	public function getMultiplication (__mx:Number, __my:Number, __mz:Number, __mw:Number):Vector4d
	{
		return new Vector4d (x * __mx, y * __my, z * __mz, w / __mw);
	}
	//00-----------------------------------------------------------------------------------
	public function getScale (__s:Number):Vector4d
	{
		var h:Number = w / __s;
		return new Vector4d (x, y, z, h);
	}
	//00-----------------------------------------------------------------------------------
	public function getSubtraction (__sx:Number, __sy:Number, __sz:Number, __sw:Number):Vector4d
	{
		var h:Number = w / __sw;
		return new Vector4d (x - __sx * h, y - __sy * h, z - __sz * h, w);
	}
	//00-----------------------------------------------------------------------------------
	public function getVectorAddition (__v4d:Vector4d):Vector4d
	{
		var h:Number = w / __v4d.w;
		return new Vector4d (x + __v4d.x * h, y + __v4d.y * h, z + __v4d.z * h, w);
	}
	//00-----------------------------------------------------------------------------------
	public function getVectorDivision (__v4d:Vector4d):Vector4d
	{
		return new Vector4d (x / __v4d.x, y / __v4d.y, z / __v4d.z, w * __v4d.w);
	}
	//00-----------------------------------------------------------------------------------
	public function getVectorMultiplication (__v4d:Vector4d):Vector4d
	{
		return new Vector4d (x * __v4d.x, y * __v4d.y, z * __v4d.z, w / __v4d.w);
	}
	//00-----------------------------------------------------------------------------------
	public function getVectorSubtraction (__v4d:Vector4d):Vector4d
	{
		var h:Number = w / __v4d.w;
		return new Vector4d (x - __v4d.x * h, y - __v4d.y * h, z - __v4d.z * h, w);
	}
	//00-----------------------------------------------------------------------------------
	public function greater (__v4d:Vector4d):Boolean
	{
		var h:Number = w / __v4d.w;
		return (x > (__v4d.x * h) && y > (__v4d.y * h) && z > (__v4d.z * h));
	}
	//00-----------------------------------------------------------------------------------
	public function greaterOrEqual (__v4d:Vector4d):Boolean
	{
		var h:Number = w / __v4d.w;
		return (x >= (__v4d.x * h) && y >= (__v4d.y * h) && z >= (__v4d.z * h));
	}
	//00-----------------------------------------------------------------------------------
	public function homogenize (__v4d:Vector4d):Void
	{
		if (w != 1.0) {
			x /= w;
			y /= w;
			z /= w;
		}
	}
	//00-----------------------------------------------------------------------------------
	public function inequality (__v4d:Vector4d):Boolean
	{
		var h:Number = w / __v4d.w;
		return (x != (__v4d.x * h) && y != (__v4d.y * h) && z != (__v4d.z * h));
	}
	//00-----------------------------------------------------------------------------------
	public function isParallel (__v4d:Vector4d):Boolean
	{
		var v1:Vector4d = normal ();
		var v2:Vector4d = __v4d.normal ();
		return (Math.abs (v1.dotProduct (v2)) == 1.0) ? true : false;
	}
	//00-----------------------------------------------------------------------------------
	public function length ():Number
	{
		return Math.sqrt (norm ());
	}
	//00-----------------------------------------------------------------------------------
	public function less (__v4d:Vector4d):Boolean
	{
		var h:Number = w / __v4d.w;
		return (x < (__v4d.x * h) && y < (__v4d.y * h) && z < (__v4d.z * h));
	}
	//00-----------------------------------------------------------------------------------
	public function lessOrEqual (__v4d:Vector4d):Boolean
	{
		var h:Number = w / __v4d.w;
		return (x <= (__v4d.x * h) && y <= (__v4d.y * h) && z <= (__v4d.z * h));
	}
	//00-----------------------------------------------------------------------------------
	public function multiplication (__mx:Number, __my:Number, __mz:Number, __mw:Number):Void
	{
		x *= __mx;
		y *= __my;
		z *= __mz;
		w /= __mw;
	}
	//00-----------------------------------------------------------------------------------
	public function negate ():Void
	{
		x = -x;
		y = -y;
		z = -z;
	}
	//00-----------------------------------------------------------------------------------
	public function norm ():Number
	{
		return (w == 1) ? (x * x + y * y + z * z) : (x * x + y * y + z * z) / (w * w);
	}
	//00-----------------------------------------------------------------------------------
	public function normal ():Vector4d
	{
		var t:Number = 1.0 / this.length ();
		return new Vector4d (x * t, y * t, z * t, 1.0);
	}
	//00-----------------------------------------------------------------------------------
	public function normalize ():Vector4d
	{
		var t:Number = 1.0 / this.length ();
		w = 1.0;
		return new Vector4d (x *= t, y *= t, z *= t, w);
	}
	//00-----------------------------------------------------------------------------------
	public function scale (__s:Number):Void
	{
		w /= __s;
	}
	//00-----------------------------------------------------------------------------------
	public function projection (__v4d:Vector4d):Vector4d
	{
		return null;
	}
	//00-----------------------------------------------------------------------------------
	public function set (__x:Number, __y:Number, __z:Number, __w:Number):Void
	{
		x = __x;
		y = __y;
		z = __z;
		w = __w;
	}
	//00-----------------------------------------------------------------------------------
	public function subtraction (__sx:Number, __sy:Number, __sz:Number, __sw:Number):Void
	{
		var h:Number = w / __sw;
		x -= __sx * h;
		y -= __sy * h;
		z -= __sz * h;
	}
	//00-----------------------------------------------------------------------------------
	public function toString ():String
	{
		return ("<" + x + ", " + y + ", " + z + ", " + w + ">");
	}
	//00-----------------------------------------------------------------------------------
	public function vectorAddition (__v4d:Vector4d):Void
	{
		var h:Number = w / __v4d.w;
		x += __v4d.x * h;
		y += __v4d.y * h;
		z += __v4d.z * h;
	}
	//00-----------------------------------------------------------------------------------
	public function vectorDivision (__v4d:Vector4d):Void
	{
		x /= __v4d.x;
		y /= __v4d.y;
		z /= __v4d.z;
		w *= __v4d.w;
	}
	//00-----------------------------------------------------------------------------------
	public function vectorMultiplication (__v4d:Vector4d):Void
	{
		x *= __v4d.x;
		y *= __v4d.y;
		z *= __v4d.z;
		w /= __v4d.w;
	}
	//00-----------------------------------------------------------------------------------
	public function vectorSubtraction (__v4d:Vector4d):Void
	{
		var h:Number = w / __v4d.w;
		x -= __v4d.x * h;
		y -= __v4d.y * h;
		z -= __v4d.z * h;
	}
}