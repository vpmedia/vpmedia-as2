// *******************************************
//	 CLASS: Soldier 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

class de.websector.games.parachute.Soldier extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	public var no_l: Number = 0; 
	public var maxL: Number = 5;
	// count up to throwing
	public var no_b: Number = 0;
	public var MAX_B: Number = 60;
	public function Soldier () {}
	
	public function attack (): Boolean
	{
		var r: Number = Math.floor(Math.random() * 2);
		var b: Boolean = (r == 1) ? true : false;
		return b;
	}
	//
	// blink
	public function blink (): Void
	{
		if (no_l >= 2 * maxL) 
		{
			this.gotoAndStop ("standing");
			this.no_l = 0;
		}
		else if (no_l == maxL) 
		{
			this.gotoAndStop ("attack");
		}
		no_l++;
		no_b++;
	}
	///////////////////////////////////////////////////////////
	// getter / setter
	///////////////////////////////////////////////////////////	
	public function get maxB (): Number 
	{
		return MAX_B;
	};		
	public function set maxB (_MAX_B: Number ): Void 
	{
		MAX_B = _MAX_B;
	};
	
}