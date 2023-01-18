/**
 * @author tPS
 */
class com.tPS.tween.CubicSplineInterpolation {

	function CubicSplineInterpolation (xa: Array, ya: Array, yp1: Number, ypn: Number) {
		takeValues (xa, ya, yp1, ypn);
		
	}
	
	var xa: Array, ya: Array, y2a: Array;

	function takeValues (xa: Array, ya: Array, yp1: Number, ypn: Number): Void {
		y2a = spline (this.xa = xa, this.ya = ya, yp1, ypn);
		
	}
	
	function valueAt (x: Number): Number {
		return splint (xa, ya, y2a, x);
		
	}

	// Given arrays x[1..n] and y[1..n] containing a tabulated function, i. e., 
	// y[i] = f(xi), with x1 < x2 < ... < xN, and given values yp1 and ypn for the
	// first derivative of the interpolating function at points 1 and n, respectively,
	// this routine returns an array y2[1..n] that contains the second derivatives
	// of the interpolating functionat the tabulated points xi. If yp1 and/or
	// ypn are equal to 1 * 10^30 or larger, the routine is signaled to set the
	// corresponding boundary condition for a natural spline, with zero second
	// derivative on that boundary.

	static function spline (x: Array, y: Array, yp1: Number, ypn: Number): Array {
		var n: Number = x.length;
		var y2: Array = new Array (n);
		y2 [n - 1] = y2 [n - 2] = 0;
		
		var i: Number, k: Number;
		var p: Number, qn: Number, sig: Number, un: Number, u: Array;

		u = new Array (n - 1);
		if (yp1 > 0.99e30) // The lower boundary condition is set either to be "natural"
			y2[0] = u[0] = 0.0; 
			
		else {
			y2[0] = -0.5; // or else to have a specified first derivative.
			u[0] = (3.0 / (x[1] - x[0])) * ((y[1] - y[0]) / (x[1] - x[0]) - yp1);

		}

		for (i = 1; i < n - 1; i++) { // This is the decomposition loop of the tridiagonal algorithm. y2 and u are used for temporary storage of the decomposed factors.
			sig = (x[i] - x[i - 1]) / (x[i + 1] - x [i - 1]);
			p = sig * y2[i - 1] + 2.0;
			y2[i] = (sig - 1.0) / p;
			u[i] = (y[i + 1] - y[i]) / (x[i + 1] - x[i]) - (y[i] - y[i - 1]) / (x[i] - x[i - 1]);
			u[i] = (6.0 * u[i] / (x[i+1] - x[i-1]) - sig * u[i-1]) / p;
			
		}

		if (ypn > 0.99e30) // The lower boundary condition is set either to be "natural"
			qn = un = 0.0;
			
		else { // or else to have a specified first derivative.
			qn = 0.5;
			un = (3.0 / (x[n - 1] - x[n - 2])) * (ypn - (y[n - 1] - y[n - 2]) / (x[n - 1] - x[n - 2]));
		
		}

		y2[n - 1] = (un - qn * u[n - 2]) / (qn * y2[n - 2] + 1.0);
		for (k = n - 2; k >= 0; k--) // This is the backsubstitution loop of the tridiagonal algorithm.
			y2[k] = y2[k] * y2[k + 1] + u[k];

		return y2;

	}
	
	// Given the arrays xa[1..n] and ya[1..n], which tabulate a function (with the xa[i]s
	// in order), and given the array y2a[1..n], which is the output from spline above,
	// and given a value of x, this routine returns a cubic-spline interpolated valuey. 

	static function splint (xa: Array, ya: Array, y2a: Array, x: Number): Number {
		var n: Number = xa.length;
		
		var klo: Number, khi: Number, k: Number; 
		var h: Number, b: Number, a: Number;
		
		klo = 0; // We will find the right place in the table by means of bisection. This is optimal if sequential calls to this routine are at random values of x. If sequential calls  are in order, and closely spaced, one would do better to store previous values of klo and khi and test if they remain appropriate on the next call.
		khi = n - 1;
		while (khi - klo > 1) { 
			k = (khi + klo) >> 1; 
			if (xa[k] > x) khi = k; 
			else klo = k;
			
		} // klo and khi now bracket the input value of x.
		
		h = xa[khi] - xa[klo]; 
		if (h == 0.0) throw new Error ("Bad xa input to routine splint"); // The xas must be distinct. 
		a = (xa[khi] - x) / h; 
		b = (x - xa[klo]) / h; // Cubic spline polynomial is now evaluated.
		
		return a * ya[klo] + b * ya[khi] + ((a * a * a - a) * y2a[klo] + (b * b * b - b) * y2a[khi]) * (h * h) / 6.0;

	}
	

}