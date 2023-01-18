// -- #################################################################
// -- (c) 2003 Grigory Ryabov
// -- http://www.flash.plux.ru
// -- #################################################################
import com.nuran.f3d.Vector3d;

class com.nuran.f3d.Matrix3x3 {
	var e:Array;
	/* 00. constructor */
	function Matrix3x3() {
		e = new Array(2);
		e[0] = new Array(1.0, 0.0, 0.0);
		e[1] = new Array(0.0, 1.0, 0.0);
		e[2] = new Array(0.0, 0.0, 1.0);
	}
	private function det2x2(__e00:Number, __e01:Number, __e10:Number, __e11:Number):Number {
		return __e00*__e11-__e01*__e10;
	}
	/* 01. */
	function addition(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Void {
		e[0][0] += __e00;		e[0][1] += __e01;		e[0][2] += __e02;
		e[1][0] += __e10;		e[1][1] += __e11;		e[1][2] += __e12;
		e[2][0] += __e20;		e[2][1] += __e21;		e[2][2] += __e22;
	}
	/* 02. */
	function copy(__m:Matrix3x3):Void {
		e[0][0] = __m.e[0][0];		e[0][1] = __m.e[0][1];		e[0][2] = __m.e[0][2];
		e[1][0] = __m.e[1][0];		e[1][1] = __m.e[1][1];		e[1][2] = __m.e[1][2];
		e[2][0] = __m.e[2][0];		e[2][1] = __m.e[2][1];		e[2][2] = __m.e[2][2];
	}	
	/* 03. */
	function copyFromArray(__Array3x3:Array):Void {
		e[0][0] = __Array3x3[0][0];		e[0][1] = __Array3x3[0][1];		e[0][2] = __Array3x3[0][2];
		e[1][0] = __Array3x3[1][0];		e[1][1] = __Array3x3[1][1];		e[1][2] = __Array3x3[1][2];
		e[2][0] = __Array3x3[2][0];		e[2][1] = __Array3x3[2][1];		e[2][2] = __Array3x3[2][2];
	}
	/* 04. */
	function copyFromList(__List:Array):Void {
		e[0][0] = __List[0];		e[0][1] = __List[1];		e[0][2] = __List[2];
		e[1][0] = __List[3];		e[1][1] = __List[4];		e[1][2] = __List[5];
		e[2][0] = __List[6];		e[2][1] = __List[7];		e[2][2] = __List[8];
	}
	/* 05. */
	function determinant():Number {
		return e[0][0]*det2x2(e[1][1], e[1][2], e[2][1], e[2][2])-e[1][0]*det2x2(e[0][1], e[0][2], e[2][1], e[2][2])+e[2][0]*det2x2(e[0][1], e[0][2], e[1][1], e[1][2]);
	}
	/* 06. */
	function equality(__m:Matrix3x3):Boolean {
		return e[0][0] == __m.e[0][0] && e[0][1] == __m.e[0][1] && e[0][2] == __m.e[0][2] && e[1][0] == __m.e[1][0] && e[1][1] == __m.e[1][1] && e[1][2] == __m.e[1][2] && e[2][0] == __m.e[2][0] && e[2][1] == __m.e[2][1] && e[2][2] == __m.e[2][2];
	}
	/* 07. */
	function get():Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3;
		t.e[0][0] = e[0][0];		t.e[0][1] = e[0][1];		t.e[0][2] = e[0][2];
		t.e[1][0] = e[1][0];		t.e[1][1] = e[1][1];		t.e[1][2] = e[1][2];
		t.e[2][0] = e[2][0];		t.e[2][1] = e[2][1];		t.e[2][2] = e[2][2];
		return t;
	}
	/* 08. */
	function getAddition(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0]+__e00;		t.e[0][1] = e[0][1]+__e01;		t.e[0][2] = e[0][2]+__e02;
		t.e[1][0] = e[1][0]+__e10;		t.e[1][1] = e[1][1]+__e11;		t.e[1][2] = e[1][2]+__e12;
		t.e[2][0] = e[2][0]+__e20;		t.e[2][1] = e[2][1]+__e21;		t.e[2][2] = e[2][2]+__e22;
		return t;
	}
	/* 09. */
	function getElement(__rowNum:Number, __colNum:Number):Number {
		return e[__rowNum][__colNum];
	}
	/* 10. */
	function getMatrixAddition(__m:Matrix3x3):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0]+__m.e[0][0];		t.e[0][1] = e[0][1]+__m.e[0][1];		t.e[0][2] = e[0][2]+__m.e[0][2];
		t.e[1][0] = e[1][0]+__m.e[1][0];		t.e[1][1] = e[1][1]+__m.e[1][1];		t.e[1][2] = e[1][2]+__m.e[1][2];
		t.e[2][0] = e[2][0]+__m.e[2][0];		t.e[2][1] = e[2][1]+__m.e[2][1];		t.e[2][2] = e[2][2]+__m.e[2][2];
		return t;
	}
	/* 11. */
	function getMatrixMultiplication(__m:Matrix3x3):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = __m.e[0][0]*e[0][0]+__m.e[1][0]*e[0][1]+__m.e[2][0]*e[0][2];
		t.e[0][1] = __m.e[0][1]*e[0][0]+__m.e[1][1]*e[0][1]+__m.e[2][1]*e[0][2];
		t.e[0][2] = __m.e[0][2]*e[0][0]+__m.e[1][2]*e[0][1]+__m.e[2][2]*e[0][2];
		t.e[1][0] = __m.e[0][0]*e[1][0]+__m.e[1][0]*e[1][1]+__m.e[2][0]*e[1][2];
		t.e[1][1] = __m.e[0][1]*e[1][0]+__m.e[1][1]*e[1][1]+__m.e[2][1]*e[1][2];
		t.e[1][2] = __m.e[0][2]*e[1][0]+__m.e[1][2]*e[1][1]+__m.e[2][2]*e[1][2];
		t.e[2][0] = __m.e[0][0]*e[2][0]+__m.e[1][0]*e[2][1]+__m.e[2][0]*e[2][2];
		t.e[2][1] = __m.e[0][1]*e[2][0]+__m.e[1][1]*e[2][1]+__m.e[2][1]*e[2][2];
		t.e[2][2] = __m.e[0][2]*e[2][0]+__m.e[1][2]*e[2][1]+__m.e[2][2]*e[2][2];
		return t;
	}
	/* 12. */
	function getMatrixSubtraction(__m:Matrix3x3):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0]-__m.e[0][0];		t.e[0][1] = e[0][1]-__m.e[0][1];		t.e[0][2] = e[0][2]-__m.e[0][2];
		t.e[1][0] = e[1][0]-__m.e[1][0];		t.e[1][1] = e[1][1]-__m.e[1][1];		t.e[1][2] = e[1][2]-__m.e[1][2];
		t.e[2][0] = e[2][0]-__m.e[2][0];		t.e[2][1] = e[2][1]-__m.e[2][1];		t.e[2][2] = e[2][2]-__m.e[2][2];
		return t;
	}
	/* 13. */
	function getMultiplication(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0]*__e00;		t.e[0][1] = e[0][1]*__e01;		t.e[0][2] = e[0][2]*__e02;
		t.e[1][0] = e[1][0]*__e10;		t.e[1][1] = e[1][1]*__e11;		t.e[1][2] = e[1][2]*__e12;
		t.e[2][0] = e[2][0]*__e20;		t.e[2][1] = e[2][1]*__e21;		t.e[2][2] = e[2][2]*__e22;
		return t;
	}
	/* 14. */
	function getScalarMultiplication(__s:Number):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0]*__s;		t.e[0][1] = e[0][1]*__s;		t.e[0][2] = e[0][2]*__s;
		t.e[1][0] = e[1][0]*__s;		t.e[1][1] = e[1][1]*__s;		t.e[1][2] = e[1][2]*__s;
		t.e[2][0] = e[2][0]*__s;		t.e[2][1] = e[2][1]*__s;		t.e[2][2] = e[2][2]*__s;
		return t;
	}
	/* 15. */
	function getSubtraction(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0]-__e00;		t.e[0][1] = e[0][1]-__e01;		t.e[0][2] = e[0][2]-__e02;
		t.e[1][0] = e[1][0]-__e10;		t.e[1][1] = e[1][1]-__e11;		t.e[1][2] = e[1][2]-__e12;
		t.e[2][0] = e[2][0]-__e20;		t.e[2][1] = e[2][1]-__e21;		t.e[2][2] = e[2][2]-__e22;
		return t;
	}
	/* 16. */
	function getVectorMultiplication(__v:Vector3d):Vector3d {
		var t = new Vector3d(0.0, 0.0, 0.0);
		t.x = e[0][0]*__v.x+e[0][1]*__v.y+e[0][2]*__v.z;
		t.y = e[1][0]*__v.x+e[1][1]*__v.y+e[1][2]*__v.z;
		t.z = e[2][0]*__v.x+e[2][1]*__v.y+e[2][2]*__v.z;
		return t;
	}
	/* 17. */
	function greater(__m:Matrix3x3):Boolean {
		return e[0][0]>__m.e[0][0] && e[0][1]>__m.e[0][1] && e[0][2]>__m.e[0][2] && e[1][0]>__m.e[1][0] && e[1][1]>__m.e[1][1] && e[1][2]>__m.e[1][2] && e[2][0]>__m.e[2][0] && e[2][1]>__m.e[2][1] && e[2][2]>__m.e[2][2];
	}
	/* 18. */
	function greaterOrEqual(__m:Matrix3x3):Boolean {
		return e[0][0]>=__m.e[0][0] && e[0][1]>=__m.e[0][1] && e[0][2]>=__m.e[0][2] && e[1][0]>=__m.e[1][0] && e[1][1]>=__m.e[1][1] && e[1][2]>=__m.e[1][2] && e[2][0]>=__m.e[2][0] && e[2][1]>=__m.e[2][1] && e[2][2]>=__m.e[2][2];
	}
	/* 19. */
	function identity():Void {
		e[0][1] = e[0][2]=e[1][0]=e[1][2]=e[2][0]=e[2][1]=0.0;
		e[0][0] = e[1][1]=e[2][2]=1.0;
	}
	/* 20. */
	function inequality(__m:Matrix3x3):Boolean {
		return e[0][0] != __m.e[0][0] && e[0][1] != __m.e[0][1] && e[0][2] != __m.e[0][2] && e[1][0] != __m.e[1][0] && e[1][1] != __m.e[1][1] && e[1][2] != __m.e[1][2] && e[2][0] != __m.e[2][0] && e[2][1] != __m.e[2][1] && e[2][2] != __m.e[2][2];
	}
	/* 21. */
	function invert():Matrix3x3 {
		return null;
	}
	/* 22. */
	function less(__m:Matrix3x3):Boolean {
		return e[0][0]<__m.e[0][0] && e[0][1]<__m.e[0][1] && e[0][2]<__m.e[0][2] && e[1][0]<__m.e[1][0] && e[1][1]<__m.e[1][1] && e[1][2]<__m.e[1][2] && e[2][0]<__m.e[2][0] && e[2][1]<__m.e[2][1] && e[2][2]<__m.e[2][2];
	}
	/* 23. */
	function lessOrEqual(__m:Matrix3x3):Boolean {
		return e[0][0]<=__m.e[0][0] && e[0][1]<=__m.e[0][1] && e[0][2]<=__m.e[0][2] && e[1][0]<=__m.e[1][0] && e[1][1]<=__m.e[1][1] && e[1][2]<=__m.e[1][2] && e[2][0]<=__m.e[2][0] && e[2][1]<=__m.e[2][1] && e[2][2]<=__m.e[2][2];
	}
	/* 24. */
	function matrixAddition(__m:Matrix3x3):Void {
		e[0][0] += __m.e[0][0];		e[0][1] += __m.e[0][1];		e[0][2] += __m.e[0][2];
		e[1][0] += __m.e[1][0];		e[1][1] += __m.e[1][1];		e[1][2] += __m.e[1][2];
		e[2][0] += __m.e[2][0];		e[2][1] += __m.e[2][1];		e[2][2] += __m.e[2][2];
	}
	/* 25. */
	function matrixMultiplication(__m:Matrix3x3):Void {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = __m.e[0][0]*e[0][0]+__m.e[1][0]*e[0][1]+__m.e[2][0]*e[0][2];
		t.e[0][1] = __m.e[0][1]*e[0][0]+__m.e[1][1]*e[0][1]+__m.e[2][1]*e[0][2];
		t.e[0][2] = __m.e[0][2]*e[0][0]+__m.e[1][2]*e[0][1]+__m.e[2][2]*e[0][2];
		t.e[1][0] = __m.e[0][0]*e[1][0]+__m.e[1][0]*e[1][1]+__m.e[2][0]*e[1][2];
		t.e[1][1] = __m.e[0][1]*e[1][0]+__m.e[1][1]*e[1][1]+__m.e[2][1]*e[1][2];
		t.e[1][2] = __m.e[0][2]*e[1][0]+__m.e[1][2]*e[1][1]+__m.e[2][2]*e[1][2];
		t.e[2][0] = __m.e[0][0]*e[2][0]+__m.e[1][0]*e[2][1]+__m.e[2][0]*e[2][2];
		t.e[2][1] = __m.e[0][1]*e[2][0]+__m.e[1][1]*e[2][1]+__m.e[2][1]*e[2][2];
		t.e[2][2] = __m.e[0][2]*e[2][0]+__m.e[1][2]*e[2][1]+__m.e[2][2]*e[2][2];
		copy(t);
	}
	/* 26. */
	function matrixSubtraction(__m:Matrix3x3):Void {
		e[0][0] -= __m.e[0][0];		e[0][1] -= __m.e[0][1];		e[0][2] -= __m.e[0][2];
		e[1][0] -= __m.e[1][0];		e[1][1] -= __m.e[1][1];		e[1][2] -= __m.e[1][2];
		e[2][0] -= __m.e[2][0];		e[2][1] -= __m.e[2][1];		e[2][2] -= __m.e[2][2];
	}
	/* 27. */
	function multiplication(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Void {
		e[0][0] *= __e00;		e[0][1] *= __e01;		e[0][2] *= __e02;
		e[1][0] *= __e10;		e[1][1] *= __e11;		e[1][2] *= __e12;
		e[2][0] *= __e20;		e[2][1] *= __e21;		e[2][2] *= __e22;
	}
	/* 28. */
	function rotationMatrix(__a:Vector3d, __s:Number, __c:Number):Void {
		var t:Number = 1.0-__c;
		var tx:Number = t*__a.x;
		var ty:Number = t*__a.y;
		var tz:Number = t*__a.z;
		e[0][0] = tx*__a.x+__c;
		e[0][1] = ty*__a.x-__s*__a.z;
		e[0][2] = tz*__a.x+__s*__a.y;
		e[1][0] = tx*__a.y+__s*__a.z;
		e[1][1] = ty*__a.y+__c;
		e[1][2] = tz*__a.y-__s*__a.x;
		e[2][0] = tx*__a.z-__s*__a.y;
		e[2][1] = ty*__a.z+__s*__a.x;
		e[2][2] = tz*__a.z+__c;
	}
	/* 29. */
	function rotationXMatrix(__s:Number, __c:Number):Void {
		e[0][1] = e[0][2]=e[1][0]=e[2][0]=0.0;
		e[0][0] = 1.0;
		e[1][1] = __c;
		e[1][2] = __s;
		e[2][1] = -__s;
		e[2][2] = __c;
	}
	/* 30. */
	function rotationYMatrix(__s:Number, __c:Number):Void {
		e[0][1] = e[1][0]=e[1][2]=e[2][1]=0.0;
		e[1][1] = 1.0;
		e[0][0] = __c;
		e[0][2] = -__s;
		e[2][0] = __s;
		e[2][2] = __c;
	}
	/* 31. */
	function rotationZMatrix(__s:Number, __c:Number):Void {
		e[0][2] = e[1][2]=e[2][0]=e[2][1]=0.0;
		e[2][2] = 1.0;
		e[0][0] = __c;
		e[0][1] = __s;
		e[1][0] = -__s;
		e[1][1] = __c;
	}
	/* 32. */
	function scalarMultiplication(__s:Number):Void {
		e[0][0] *= __s;		e[0][1] *= __s;		e[0][2] *= __s;
		e[1][0] *= __s;		e[1][1] *= __s;		e[1][2] *= __s;
		e[2][0] *= __s;		e[2][1] *= __s;		e[2][2] *= __s;
	}
	/* 33. */
	function scaleMatrix(__sx:Number, __sy:Number, __sz:Number):Void {
		e[0][1] = e[0][2]=e[1][0]=e[1][2]=e[2][0]=e[2][1]=0.0;
		e[0][0] = __sx;
		e[1][1] = __sy;
		e[2][2] = __sz;
	}
	/* 34. */
	function set(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Void {
		e[0][0] = __e00;		e[0][1] = __e01;		e[0][2] = __e02;
		e[1][0] = __e10;		e[1][1] = __e11;		e[1][2] = __e12;
		e[2][0] = __e20;		e[2][1] = __e21;		e[2][2] = __e22;
	}
	/* 35. */
	function setElement(__rowNum:Number, __colNum:Number, __val:Number):Void {
		e[__rowNum][__colNum] = __val;
	}
	/* 36. */
	function subtraction(__e00:Number, __e01:Number, __e02:Number, __e10:Number, __e11:Number, __e12:Number, __e20:Number, __e21:Number, __e22:Number):Void {
		e[0][0] -= __e00;		e[0][1] -= __e01;		e[0][2] -= __e02;
		e[1][0] -= __e10;		e[1][1] -= __e11;		e[1][2] -= __e12;
		e[2][0] -= __e20;		e[2][1] -= __e21;		e[2][2] -= __e22;
	}
	/* 37. */
	function toString():String {
		return ("< "+"<"+e[0][0]+", "+e[0][1]+", "+e[0][2]+">"+", "+"<"+e[1][0]+", "+e[1][1]+", "+e[1][2]+">"+", "+"<"+e[2][0]+", "+e[2][1]+", "+e[2][2]+">"+" >");
	}
	/* 38. */
	function transpose():Matrix3x3 {
		var t:Matrix3x3 = new Matrix3x3();
		t.e[0][0] = e[0][0];		t.e[0][1] = e[1][0];		t.e[0][2] = e[2][0];
		t.e[1][0] = e[0][1];		t.e[1][1] = e[1][1];		t.e[1][2] = e[2][1];
		t.e[2][0] = e[0][2];		t.e[2][1] = e[1][2];		t.e[2][2] = e[2][2];
		return t;
	}
	/* 39. */
	function vectorMultiplication(__v:Vector3d):Vector3d {
		var t = new Vector3d(0.0, 0.0, 0.0);
		t.x = e[0][0]*__v.x+e[0][1]*__v.y+e[0][2]*__v.z;
		t.y = e[1][0]*__v.x+e[1][1]*__v.y+e[1][2]*__v.z;
		t.z = e[2][0]*__v.x+e[2][1]*__v.y+e[2][2]*__v.z;
		return t;
	}
	/* 40. */
	function zero():Void {
		e[0][0] = e[0][1]=e[0][2]=e[1][0]=e[1][1]=e[1][2]=e[2][0]=e[2][1]=e[2][2]=0.0;
	}
}