// -- ##################################################
// -- (c) 2003 Grigory Ryabov.
// -- http://www.flash.plux.ru/
// -- ##################################################
class com.nuran.f3d.Vector3d {
	var x:Number;
	var y:Number;
	var z:Number;
	/* constructor */
	function Vector3d(__x:Number, __y:Number, __z:Number) {
		x = __x;
		y = __y;
		z = __z;
	}
	/* 01. += */
	function addition(__ax:Number, __ay:Number, __az:Number):Void {
		x += __ax;
		y += __ay;
		z += __az;
	}
	/* 02. angle */
	function angle(_v3d:Vector3d):Number {
		var cosine:Number = normal().dotProduct(_v3d.normal());
		return (cosine>=1.0) ? 0.0 : (cosine<=-1.0) ? Math.PI : Math.acos(cosine);
	}
	/* 03. = */
	function copy(__v3d:Vector3d):Void {
		x = __v3d.x;
		y = __v3d.y;
		z = __v3d.z;
	}
	/* 04. ^ */
	function crossProduct(__v3d:Vector3d):Vector3d {
		return new Vector3d(y*__v3d.z-z*__v3d.y, z*__v3d.x-x*__v3d.z, x*__v3d.y-y*__v3d.x);
	}
	/* 05. distance */
	function distance():Number {
		return null;
	}
	/* 06. /= */
	function division(__dx:Number, __dy:Number, __dz:Number):Void {
		x /= __dx;
		y /= __dy;
		z /= __dz;
	}
	/* 07. getDominantAxis */
	function dominantAxis():Vector3d {
		var xx, yy:Number;
		if ((xx=Math.abs(x))>(yy=Math.abs(y))) {
			return (xx>Math.abs(z)) ? new Vector3d(1.0, 0.0, 0.0) : new Vector3d(0.0, 0.0, 1.0);
		} else {
			return (yy>Math.abs(z)) ? new Vector3d(0.0, 1.0, 0.0) : new Vector3d(0.0, 0.0, 1.0);
		}
	}
	/* 08. * */
	function dotProduct(__v3d:Vector3d):Number {
		return (x*__v3d.x+y*__v3d.y+z*__v3d.z);
	}
	/* 09. == */
	function equality(__v3d:Vector3d):Boolean {
		return (x == __v3d.x && y == __v3d.y && z == __v3d.z);
	}
	/* 10. = */
	function get(__v3d:Vector3d):Vector3d {
		return new Vector3d(x, y, z);
	}
	/* 11. + */
	function getAddition(__ax:Number, __ay:Number, __az:Number):Vector3d {
		return new Vector3d(x+__ax, y+__ay, z+__az);
	}
	/* 12. / */
	function getDivision(__dx:Number, __dy:Number, __dz:Number):Vector3d {
		return new Vector3d(x/__dx, y/__dy, z/__dz);
	}
	/* 13. * */
	function getMultiplication(__mx:Number, __my:Number, __mz:Number):Vector3d {
		return new Vector3d(x*__mx, y*__my, z*__mz);
	}
	/* 14. *= */
	function getScale(__s:Number):Vector3d {
		return new Vector3d(x*__s, y*__s, z*__s);
	}
	/* 15. - */
	function getSubtraction(__sx:Number, __sy:Number, __sz:Number):Vector3d {
		return new Vector3d(x-__sx, y-__sy, z-__sz);
	}
	/* 16. + */
	function getVectorAddition(__v3d:Vector3d):Vector3d {
		return new Vector3d(x+__v3d.x, y+__v3d.y, z+__v3d.z);
	}
	/* 17. / */
	function getVectorDivision(__v3d:Vector3d):Vector3d {
		return new Vector3d(x/__v3d.x, y/__v3d.y, z/__v3d.z);
	}
	/* 18. * */
	function getVectorMultiplication(__v3d:Vector3d):Vector3d {
		return new Vector3d(x*__v3d.x, y*__v3d.y, z*__v3d.z);
	}
	/* 19. - */
	function getVectorSubtraction(__v3d:Vector3d):Vector3d {
		return new Vector3d(x-__v3d.x, y-__v3d.y, z-__v3d.z);
	}
	/* 20. > */
	function greater(__v3d:Vector3d):Boolean {
		return (x>__v3d.x && y>__v3d.y && z>__v3d.z);
	}
	/* 21. >= */
	function greaterOrEqual(__v3d:Vector3d):Boolean {
		return (x>=__v3d.x && y>=__v3d.y && z>=__v3d.z);
	}
	/* 22. != */
	function inequality(__v3d:Vector3d):Boolean {
		return (x != __v3d.x && y != __v3d.y && z != __v3d.z);
	}
	/* 23. isParallel */
	function isParallel(_v3d:Vector3d):Boolean {
		var v1:Vector3d = normal();
		var v2:Vector3d = _v3d.normal();
		return (Math.abs(v1.dotProduct(v2)) == 1.0) ? true : false;
	}
	/* 24. length */
	function length():Number {
		return Math.sqrt(x*x+y*y+z*z);
	}
	/* 25. < */
	function less(__v3d:Vector3d):Boolean {
		return (x<__v3d.x && y<__v3d.y && z<__v3d.z);
	}
	/* 26. <= */
	function lessOrEqual(__v3d:Vector3d):Boolean {
		return (x<=__v3d.x && y<=__v3d.y && z<=__v3d.z);
	}
	/* 27. *= */
	function multiplication(__mx:Number, __my:Number, __mz:Number):Void {
		x *= __mx;
		y *= __my;
		z *= __mz;
	}
	/* 28. negate */
	function negate():Void {
		x = -x;
		y = -y;
		z = -z;
	}
	/* 29. norm */
	function norm():Number {
		return (x*x+y*y+z*z);
	}
	/* 30. normal */
	function normal():Vector3d {
		var tmp:Number = 1.0/Math.sqrt(x*x+y*y+z*z);
		return new Vector3d(x*tmp, y*tmp, z*tmp);
	}
	/* 31. normalize */
	function normalize():Vector3d {
		var tmp:Number = 1.0/Math.sqrt(x*x+y*y+z*z);
		return new Vector3d(x *= tmp, y *= tmp, z *= tmp);
	}
	/* 32. *= */
	function scale(__s:Number):Void {
		x *= __s;
		y *= __s;
		z *= __s;
	}
	/* 33. = */
	function set(__x:Number, __y:Number, __z:Number):Void {
		x = __x;
		y = __y;
		z = __z;
	}
	/* 34. -= */
	function subtraction(__sx:Number, __sy:Number, __sz:Number):Void {
		x -= __sx;
		y -= __sy;
		z -= __sz;
	}
	/* 35. toString */
	function toString():String {
		return ("<"+x+", "+y+", "+z+">");
	}
	/* 36. += */
	function vectorAddition(__v3d:Vector3d):Void {
		x += __v3d.x;
		y += __v3d.y;
		z += __v3d.z;
	}
	/* 37. /= */
	function vectorDivision(__v3d:Vector3d):Void {
		x /= __v3d.x;
		y /= __v3d.y;
		z /= __v3d.z;
	}
	/* 38. *= */
	function vectorMultiplication(__v3d:Vector3d):Void {
		x *= __v3d.x;
		y *= __v3d.y;
		z *= __v3d.z;
	}
	/* 39. -= */
	function vectorSubtraction(__v3d:Vector3d):Void {
		x -= __v3d.x;
		y -= __v3d.y;
		z -= __v3d.z;
	}
	/* additional methods ------------------------------------------ */
	/* 40. normalFromTwoPoints */
	function normalFromTwoPoints(__v3d:Vector3d):Vector3d {
		return getVectorSubtraction(__v3d).normalize();
	}
	// 41. -- rotate around of any axis _v3d
	function rotateAxis(__v3d:Vector3d, __s:Number, __c:Number):Void {
		var t:Number = 1.0-__c;
		var t1:Number = __v3d.x*t;
		var t2:Number = __v3d.y*t;
		var t3:Number = __v3d.z*t;
		var tsx:Number = __s*__v3d.x;
		var tsy:Number = __s*__v3d.y;
		var tsz:Number = __s*__v3d.z;
		var xp:Number = x*(t1*__v3d.x+__c)+y*(t2*__v3d.x-tsz)+z*(t3*__v3d.x+tsy);
		var yp:Number = x*(t1*__v3d.y+tsz)+y*(t2*__v3d.y+__c)+z*(t3*__v3d.y-tsx);
		var zp:Number = x*(t1*__v3d.z-tsy)+y*(t2*__v3d.z+tsx)+z*(t3*__v3d.z+__c);
		x = xp;
		y = yp;
		z = zp;
	}
	// 42. -- rotate around of axis x
	function rotateX(__s:Number, __c:Number):Void {
		var yp:Number = y*__c-z*__s;
		var zp:Number = y*__s+z*__c;
		y = yp;
		z = zp;
	}
	// 43. -- rotate around of axis y
	function rotateY(__s:Number, __c:Number):Void {
		var xp:Number = x*__c+z*__s;
		var zp:Number = -x*__s+z*__c;
		x = xp;
		z = zp;
	}
	// 44. -- rotate around of axis z
	function rotateZ(__s:Number, __c:Number):Void {
		var xp:Number = x*__c-y*__s;
		var yp:Number = x*__s+y*__c;
		x = xp;
		y = yp;
	}
}