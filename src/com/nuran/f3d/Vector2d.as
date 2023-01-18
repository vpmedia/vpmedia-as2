// -- #########################################################
// -- (c) 2003 Grigory Ryabov.
// -- http://www.flash.plux.ru/
// -- #########################################################
class com.nuran.f3d.Vector2d {
	var x:Number;
	var y:Number;
	/* constructor */
	function Vector2d(__x:Number, __y:Number) {
		x = __x;
		y = __y;
	}
	/* 01. += */
	function addition(__ax:Number, __ay:Number):Void {
		x += __ax;
		y += __ay;
	}
	/* 02. angle */
	function angle(_v2d:Vector2d):Number {
		var cosine:Number = normal().dotProduct(_v2d.normal());
		return (cosine>=1.0) ? 0.0 : (cosine<=-1.0) ? Math.PI : Math.acos(cosine);
	}
	/* 03. = */
	function copy(__v2d:Vector2d):Void {
		x = __v2d.x;
		y = __v2d.y;
	}
	/* 04. distance */
	function distance():Number {
		return null;
	}
	/* 05. /= */
	function division(__dx:Number, __dy:Number):Void {
		x /= __dx;
		y /= __dy;
	}
	/* 06. getDominantAxis */
	function dominantAxis():Vector2d {
		if (Math.abs(x)>Math.abs(y)) {
			return new Vector2d(1.0, 0.0);
		} else {
			return new Vector2d(0.0, 1.0);
		}
	}
	/* 07. * */
	function dotProduct(__v2d:Vector2d):Number {
		return (x*__v2d.x+y*__v2d.y);
	}
	/* 08. == */
	function equality(__v2d:Vector2d):Boolean {
		return (x == __v2d.x && y == __v2d.y);
	}
	/* 09. = */
	function get(__v2d:Vector2d):Vector2d {
		return new Vector2d(x, y);
	}
	/* 10. + */
	function getAddition(__ax:Number, __ay:Number):Vector2d {
		return new Vector2d(x+__ax, y+__ay);
	}
	/* 11. / */
	function getDivision(__dx:Number, __dy:Number):Vector2d {
		return new Vector2d(x/__dx, y/__dy);
	}
	/* 12. * */
	function getMultiplication(__mx:Number, __my:Number):Vector2d {
		return new Vector2d(x*__mx, y*__my);
	}
	/* 13. *= */
	function getScale(__s:Number):Vector2d {
		return new Vector2d(x*__s, y*__s);
	}
	/* 14. - */
	function getSubtraction(__sx:Number, __sy:Number):Vector2d {
		return new Vector2d(x-__sx, y-__sy);
	}
	/* 15. + */
	function getVectorAddition(__v2d:Vector2d):Vector2d {
		return new Vector2d(x+__v2d.x, y+__v2d.y);
	}
	/* 16. / */
	function getVectorDivision(__v2d:Vector2d):Vector2d {
		return new Vector2d(x/__v2d.x, y/__v2d.y);
	}
	/* 17. * */
	function getVectorMultiplication(__v2d:Vector2d):Vector2d {
		return new Vector2d(x*__v2d.x, y*__v2d.y);
	}
	/* 18. - */
	function getVectorSubtraction(__v2d:Vector2d):Vector2d {
		return new Vector2d(x-__v2d.x, y-__v2d.y);
	}
	/* 19. > */
	function greater(__v2d:Vector2d):Boolean {
		return (x>__v2d.x && y>__v2d.y);
	}
	/* 20. >= */
	function greaterOrEqual(__v2d:Vector2d):Boolean {
		return (x>=__v2d.x && y>=__v2d.y);
	}
	/* 21. != */
	function inequality(__v2d:Vector2d):Boolean {
		return (x != __v2d.x && y != __v2d.y);
	}
	/* 22. isParallel */
	function isParallel(_v2d:Vector2d):Boolean {
		var v1:Vector2d = normal();
		var v2:Vector2d = _v2d.normal();
		return (Math.abs(v1.dotProduct(v2)) == 1.0) ? true : false;
	}
	/* 23. length */
	function length():Number {
		return Math.sqrt(x*x+y*y);
	}
	/* 24. < */
	function less(__v2d:Vector2d):Boolean {
		return (x<__v2d.x && y<__v2d.y);
	}
	/* 25. <= */
	function lessOrEqual(__v2d:Vector2d):Boolean {
		return (x<=__v2d.x && y<=__v2d.y);
	}
	/* 26. *= */
	function multiplication(__mx:Number, __my:Number):Void {
		x *= __mx;
		y *= __my;
	}
	/* 27. negate */
	function negate():Void {
		x = -x;
		y = -y;
	}
	/* 28. norm */
	function norm():Number {
		return (x*x+y*y);
	}
	/* 29. normal */
	function normal():Vector2d {
		var tmp:Number = 1.0/Math.sqrt(x*x+y*y);
		return new Vector2d(x*tmp, y*tmp);
	}
	/* 30. normalize */
	function normalize():Vector2d {
		var tmp:Number = 1.0/Math.sqrt(x*x+y*y);
		return new Vector2d(x *= tmp, y *= tmp);
	}
	/* 31. *= */
	function scale(__s:Number):Void {
		x *= __s;
		y *= __s;
	}
	/* 32. = */
	function set(__x:Number, __y:Number):Void {
		x = __x;
		y = __y;
	}
	/* 33. -= */
	function subtraction(__sx:Number, __sy:Number):Void {
		x -= __sx;
		y -= __sy;
	}
	/* 34. toString */
	function toString():String {
		return ("<"+x+", "+y+">");
	}
	/* 35. += */
	function vectorAddition(__v2d:Vector2d):Void {
		x += __v2d.x;
		y += __v2d.y;
	}
	/* 36. /= */
	function vectorDivision(__v2d:Vector2d):Void {
		x /= __v2d.x;
		y /= __v2d.y;
	}
	/* 37. *= */
	function vectorMultiplication(__v2d:Vector2d):Void {
		x *= __v2d.x;
		y *= __v2d.y;
	}
	/* 38. -= */
	function vectorSubtraction(__v2d:Vector2d):Void {
		x -= __v2d.x;
		y -= __v2d.y;
	}
	/* additional methods ------------------------------------------ */
	/* 39. normalFromTwoPoints */
	function normalFromTwoPoints(__v2d:Vector2d):Vector2d {
		return getVectorSubtraction(__v2d).normalize();
	}
	// 40.
	function rotate(__s:Number, __c:Number):Void {
		var xp:Number = x*__c-y*__s;
		var yp:Number = x*__s+y*__c;
		x = xp;
		y = yp;
	}
}