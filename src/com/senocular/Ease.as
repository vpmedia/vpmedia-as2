
/**
 * The Ease class is used to create functions that add an easing to a number value or percentage.
 * Functions created take one numeric parameter t (0-1) and returns an eased version of that value.
 * There are two kinds of Ease methods that are used to define Ease instances.  The first are ease
 * method methods, those which affect the actual ease behavior (ease 'method').  These include methods
 * like sin and circular. The others define the ease type.  These are Ease methods that start with 'easing'
 * and determine whether or not an ease eases in or out or a combination of either. These methods
 * include easingIn and easingInToBackOut.
 */
class com.senocular.Ease {
	
	public static var version:String = "0.7.1";
	
	/**
	 * Compounds multiple ease functions to be called in sequential
	 * order as one function
	 * @param functions Any number of comma-separated functions
	 * or Ease instances to be combined into one function
	 * @return A new easing function which will call each function passed in,
	 * evenly distributed, in sequential order.
	 */
	public static function compound():Function {
		var e = arguments;
		var n = e.length;
		if (!n) return;
		var i = n;
		
		// if Ease instances were passed
		// get the ease functions from the instances
		while(i--){
			if (e[i] instanceof Ease){
				e[i] = e[i].create();
			}
		}
		var mf = Math.floor;
		var d = 1/n;
		return function(t:Number){
			if ((i = mf(t/d)) >= n) i = n-1;
			return e[i]( n*(t - d*i) );
		}
	}
	
	
	/** Easing method. */
	public var method:Function = function(t:Number){ return t; } // default: linear
	/** Ease type (in or out) */
	public var type:Function = function(t:Number, e:Function):Number { return e(t); }; // ease in or out or comb; default: None (eases in given ease methods)

	/**
	 * Constructor: Creates an Ease instance.
	 */
	public function Ease(Void){}

	/**
	 * Creates a function reflective of the easing applied to the Ease instance.
	 * The function accepts one parameter, t:Number, and returns the eased version
	 * of its value when called.  This function mimics the call() method of Ease.
	 * @param f An additional function the returned function can wrap
	 * @return A function which applies a tween to a number passed into it when called.
	 */
	public function create(f:Object):Function {
		if (!this.type) return this.method;
		var em = this.method;
		var ep = this.type;
		if (f){
			
			if (f instanceof Ease){
				f = f.create();
			}
			
			if (this.hasOwnProperty("type")){
				return function(t:Number){
					return ep(f(t), em);
				}
			}else{
				return function(t:Number){
					return em(f(t));
				}
			}
			
		}else{
			
			if (this.hasOwnProperty("type")){
				return function(t:Number){
					return ep(t, em);
				}
			}else{
				return function(t:Number){
					return em(t);
				}
			}
			
		}
	}
	
	/**
	 * Applies Easing as defined by the Ease instance to the value passed.
	 * @param t A value 0-1 which is to have easing applied to it
	 * @return The eased version of the number passed.
	 */
	public function call(t:Number):Number {
		return (this.hasOwnProperty("type")) ? this.type(t, this.method) : this.method(t);
	}	
	
	// Ease types
	/**
	 * Modifies the Ease to ease in by a specified amount
	 * @param a Amount of easing applied to the ease
	 * @return The current Ease instance
	 */
	public function easingIn(a:Number):Ease {
		if (a == undefined || a == 1){
			delete this.type; // easing in is prototyped/default
		}else{
			this.type = function(t:Number, e:Function):Number {
				var et =  e(t);
				return t + (et - t)*a;
			}
		}
		return this;
	}
	/**
	 * Modifies the Ease to ease out by a specified amount
	 * @param a Amount of easing applied to the ease
	 * @return The current Ease instance
	 */
	public function easingOut(a:Number):Ease {
		if (a == undefined || a == 1){
			this.type = function(t:Number, e:Function):Number {
				return 1 - e(1 - t);
			}
		}else{
			this.type = function(t:Number, e:Function):Number {
				return t + ((1 - e(1 - t)) - t)*a;
			}
		}
		return this;
	}
	
	/**
	 * Modifies the Ease to apply two easing in eases in succession
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingInToIn(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingIn, this.easingIn, false);
	}
	/**
	 * Modifies the Ease to apply two eases in succession, the first easing in, the second easing out
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingInToOut(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingIn, this.easingOut, false);
	}
	/**
	 * Modifies the Ease to apply two easing out eases in succession
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingOutToOut(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingOut, this.easingOut, false);
	}
	/**
	 * Modifies the Ease to apply two eases in succession, the first easing out, the second easing in
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingOutToIn(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingOut, this.easingIn, false);
	}
	/**
	 * Modifies the Ease to apply two eases in succession, the first easing all the way in,
	 * the second easing in back to the the ease start
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingInToBackIn(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingIn, this.easingOut, true);
	}
	/**
	 * Modifies the Ease to apply two eases in succession, the first easing all the way in,
	 * the second easing out back to the the ease start
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingInToBackOut(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingIn, this.easingIn, true);
	}
	/**
	 * Modifies the Ease to apply two eases in succession, the first easing all the way out,
	 * the second easing out back to the the ease start
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingOutToBackOut(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingOut, this.easingIn, true);
	}
	/**
	 * Modifies the Ease to apply two eases in succession, the first easing all the way out,
	 * the second easing out in to the the ease start
	 * @param a Amount of easing applied to the ease
	 * @param c The point at which the first ease changes to the next in percent)
	 * @return The current Ease instance
	 */
	public function easingOutToBackIn(a:Number, c:Number):Ease {
		return this.easeComb(a, c, this.easingOut, this.easingOut, true);
	}
	
	// Used by double in and out methods
	// a:Amount, c:Change over % (position to switch from e1 to e2, e1:Ease type 1, e2:Ease type 2, k:Goes back
	private function easeComb(a:Number, c:Number, p1:Function, p2:Function, k:Boolean):Ease {
		// default changeover - halfway
		if (c == undefined) c = .5;
			
		// get type functions for each side of the ease
		if (p1 == p2){
			p2 = p1 = p1.call(this, a).type;
		}else{
			p1 = p1.call(this, a).type;
			p2 = p2.call(this, a).type;
		}
		
		// set types based on whether or not they come back (k)
		if (k){
			this.type = function(t:Number, e:Function):Number {
				if (t < c) return p1(t/c, e);
				var d = 1 - c;
				return p2((1 - t)/d, e);
			}
		}else{
			this.type = function(t:Number, e:Function):Number {
				if (t < c) return p1(t/c, e)*c;
				var d = 1 - c;
				return c + p2((t - c)/d, e)*d;
			}
		}
		return this;
	}

	
	// Ease methods
	/**
	 * Modifies the Ease to apply linear easing (no easing)
	 * @return The current Ease instance
	 */
	public function linear(Void):Ease {
		delete this.method; // linear is prototyped/default
		return this;
	}
	/**
	 * Modifies the Ease to apply exponential easing
	 * @param p The exponential power of the easing; the higher the greater the ease
	 * @return The current Ease instance
	 */
	public function exponential(p:Number):Ease { // p for exponential power
		var mp = Math.pow;
		if (!p) p = 2; // default power of 2 if not provided
		this.method = function(t:Number){
			return mp(t, p);
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply exponential easing with anticipation (backing up before going forward)
	 * @param p The exponential power of the easing; the higher the greater the ease
	 * @param a (Optional) The anticipation percent factor. The greater, the more the anticipation. Default: .5.
	 * @return The current Ease instance
	 */
	public function exponentialAnticipate(p:Number, a:Number):Ease { // p for exponential power, a for anticipation factor (between 0-1)
		var mp = Math.pow;
		if (!p) p = 2; // default power of 2 if not provided
		if (!a) a = .5; // default anticipation factor of .5 if not provided
		var r = a/(1 + a); // ratio for anticipation (negative t progression)
		var o = mp(a, p); // offset
		this.method = function(t:Number){
			return (t < r) ? -o + mp(a*(r - t)/r, p) : -o + mp((t - r)/(1 - r), p)*(1 + o);
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply easing based on the sine curve
	 * @param p The exponential power of the easing; the higher the greater the ease
	 * @return The current Ease instance
	 */
	public function sin(Void):Ease { // t
		var ms = Math.sin;
		this.method = function(t:Number){
			return 1 - ms((Math.PI + Math.PI*t)/2);
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply easing based on the sine curve with anticipation
	 * (backing up before going forward)
	 * @param a (Optional) The anticipation percent factor. The greater, the more the anticipation. Default: .5.
	 * @return The current Ease instance
	 */
	public function sinAnticipate(a:Number):Ease { // a for anticipation factor (between 0-1)
		var ms = Math.sin;
		if (!a) a = .5; // default anticipation factor of .5 if not provided
		var o = (1 + a)*(.5*Math.PI); // offset
		this.method = function(t:Number){
			return 1 + ms(o*t - o)/ms(o);
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply circular easing 
	 * @param p The exponential power of the easing; the higher the greater the ease
	 * @return The current Ease instance
	 */
	public function circular(Void):Ease { // t
		var mq = Math.sqrt;
		this.method = function(t:Number){
			return 1 - mq(1 - t*t);
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply easing based on a quadratic bezier curve
	 * @param c (Optional) Control point placement along 0-1. Default .5.
	 * @return The current Ease instance
	 */
	public function quadraticBezier(c:Number):Ease { // c for control point
		if (c == undefined) c = .5;
		this.method = function(t:Number){
			return 2*t*(1-t)*c + t*t;
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply easing based on a quadratic bezier curve
	 * @param c1 (Optional) First ontrol point placement along 0-1. Default .25.
	 * @param c2 (Optional) Second ontrol point placement along 0-1. Default .75.
	 * @return The current Ease instance
	 */
	public function cubicBezier(c1:Number, c2:Number):Ease { // c for control points
		if (c1 == undefined) c1 = .25;
		if (c2 == undefined) c2 = .75;
		this.method = function(t:Number){
			var s = t*t;
			var i = 1 - t;
			return 3*t*i*i*i*c1 + 3*s*i*c2 + s*t;
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply a bouncing effect
	 * @param b (Optional) The number of bounces. Default 1.
	 * @param r (Optional) The reduction applied to sequential bounces 0-1. Default 1.
	 * @param e (Optional) An Ease instance or ease function to be used for the bounces Default (exponential).
	 * @return The current Ease instance
	 */
	public function bounce(b:Number, r:Number, e:Object):Ease { // b for number of bounces, r for reduction of bounce (between 0-1), e for ease function
		var mf = Math.floor;
		var mp = Math.pow;
		if (!b) b = 1;
		if (!r) r = 1;
		if (!e) e = new Ease().exponential().create();
		else if (e instanceof Ease) e = e.create();
		var es = b*2 + 1; // number of eases
		this.method = function(t:Number){
			t = 1-t;
			b = mf(t*es); // which bounce
			var b1 = b + 1;
			var et = t*es - b; // ease t
			var d = mp(r, mf(b1/2)); // degredation for r
			return (b1%2) ? 1 - (1 - d + d*e(et)) : 1 - (1 - d + d*e(1 - et));
		}
		return this;
	}
	/**
	 * Modifies the Ease to apply an elastic effect
	 * @param b (Optional) The number of bounces. Default 1.
	 * @param r (Optional) The reduction applied to sequential bounces 0-1. Default 1.
	 * @param e (Optional) An Ease instance or ease function to be used for the bounces Default (exponential).
	 * @return The current Ease instance
	 */
	public function elastic(b:Number, r:Number, e:Object):Ease { // b for number of bounces, r for reduction of bounce (between 0-1), e for ease function
		var mf = Math.floor;
		var mp = Math.pow;
		if (!b) b = 1;
		if (!r) r = 1;
		if (!e) e = new Ease().exponential().create();
		else if (e instanceof Ease) e = e.create();
		var es = b*2 + 1; // number of eases
		this.method = function(t:Number){
			t = 1-t;
			b = mf(t*es);			// which bounce
			var b1 = b + 1;
			var et = (t*es - b);	// ease t
			if (b1%2 == 0) et = 1 - et;	// if reverse t direction
			var d = mp(r*r, t);			// degredation for r
			return (mf(b1/2)%2) ? 1 - (1 + d - d*e(et)) : 1 - (1 - d + d*e(et)); // side of destination
		}
		return this;
	}
}