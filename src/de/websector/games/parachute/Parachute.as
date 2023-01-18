// *******************************************
//	 CLASS: Parachute 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.Border;
import de.websector.games.parachute.Counter;

class de.websector.games.parachute.Parachute extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// speed
	private var s1:Number = 2;
	private var s2:Number = .5;
	private var freeFall: Boolean = true;	// free fall
	// border
	private var startY: Number;
	private var maxY:Number;
	// boolean
	public var hit: Boolean = false;
	// values
	private var level: Number;
	// mc		
	public var mc_b:MovieClip; 				// bg
	// instances
	private var myC: Counter;	
	//
	// constructor
	public function Parachute () {};
	//
	// init
	public function init (_b, _xP, _yP, _l):Void
	{
 		this.mc_b = _b;
		this._x = _xP;
		this._y = this.startY = _yP;
		this.level = _l;
		// check border
		this.checkBorder();
		this.gotoAndStop(2);
 		// counter
 		myC = Counter.getInstance();				
	}	
	//
	// check borders
	public function checkBorder ():Void
	{
		var diffY:Number = this._height / 2 + s2;
		var checkBorder:Border = new Border (mc_b, 0, diffY);
		maxY = checkBorder.getMaxY ();
	}
	//
	// move
	public function move (): Void
	{	
		if (freeFall) 
		{
			this._y += this.s1;
			stopFreeFall ();
		}
		else this._y += this.s2;
	}
	//
	// stop free fall
	public function stopFreeFall (): Void
	{	
		if (this._y < startY + 20) 
		{
			freeFall = true;
		}
		else
		{
			freeFall = false;
			this.gotoAndStop(1);
		}
	}
	//
	// check on ground
	public function onGround (): Boolean
	{
		var b: Boolean = (this._y > this.maxY) ? true :  false;
		return b;
	}	
	public function remove (): Void 
	{
		if (hit) myC.change(20 * myC.gL);
		this.removeMovieClip();
	};
	
}