// *******************************************
//	 CLASS: Bomb 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

class de.websector.games.parachute.Bomb extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// var
	private var diff: Number = 70;
	private var timer: Number = 0;
	// mc
	private var s: MovieClip;
	private var xS: Number;
	private var yS: Number;
	private var t: MovieClip;
	public var xT: Number;
	private var yT: Number;
	// parable
	private var x: Number;
	private var y: Number;
	private var xA: Number;
	private var yA: Number;
	private var c: Number;
	private var n: Number = 0;
	private var xSpeed: Number;

	public function Bomb () {}
	//
	// init
	public function iniTrajectory (_s: MovieClip, _t: MovieClip): Void
	{
		s = _s;
		t = _t;		
 		// tank / soldiers position
 		xT = t._x;
 		yT = t._y;
 		xS = s._x;
 		yS = s._y;
 		// apex
 		xA = (xT >= xS) ? (xT - xS) / 2 + xS : (xS - xT) / 2 + xT;
 		yA = yT - diff;
  		// parable's constant
  		c = (xT - xA) * (xT - xA);
  		c /= -2 * (yT - yA);
 		// diff x for speedX
 		xSpeed = (xT >= xS) ? (xT - xS) : (xS - xT);
 		xSpeed /= 100; 
  		// set start position
  		x = xS;
  		y = yS;
  		this._x = x;
  		this._y = y;
	}
	
	public function move (): Void
	{
 		this._x = x;
 		this._y = y;
 		n ++;
		// y 
 		y = ((x - xA) * (x - xA)); 
 		y /= -2 * c;
 		y += yA;
 		// x
 		x = (xT >= xS) ? x + xSpeed : x - xSpeed;
	}
	
	public function drop (): Void
	{		
 		y = this._y += 1;
	}	

	public function hit (): Boolean
	{
 		var b: Boolean = (y <= yS) ? false : true;
 		return b;			
	}
}