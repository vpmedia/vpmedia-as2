// *******************************************
//	 CLASS: Tank 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.Border;

class de.websector.games.parachute.Tank extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// attributes
	private var speedRot: Number = 4;
	// border
	public var minX: Number;
	public var maxX: Number;
	public var minY: Number;
	public var maxY: Number;
	// rotation
	public var minRot: Number;
	public var maxRot: Number;

	// mc
	public var t: MovieClip; 					// timeline
	public var mc_b: MovieClip; 				// bg
	public var mc_turret: MovieClip;			// mc turret
	public var mc_tBody: MovieClip;			// mc tanks body
	public var turretLength: Number = 23;		// turrets length
	//
	// constructor
	public function Tank () {};
	//
	// init
	public function init (_t:MovieClip, _b:MovieClip): Void
	{
		t = _t;
		mc_b = _b;
		
		minRot = -90 + speedRot;
		maxRot = 90 - speedRot;		
		startPosition ();
		checkBorder ();
	}
	//
	// remove
	public function remove (): Void 
	{
		this.removeMovieClip();
	};
	
	//
	// set startposition
	private function startPosition (): Void
	{
		// set position
		this._x = mc_b._width/2;
		this._y = mc_b._height - this.mc_tBody._height/2;
		// init turret
		mc_turret = this.mc_turret;
		mc_turret._rotation = 0;
	}
	//
	// check borders
	private function checkBorder (): Void
	{
		var diffX: Number = this._width/2;
		var diffY: Number = this._height/2;
		var checkBorder: Border = new Border (mc_b, diffX, diffY);
		minX = checkBorder.getMinX ();
		maxX = checkBorder.getMaxX ();
		minY = checkBorder.getMinY ();
		maxY = checkBorder.getMinY ();
	}
	//
	// get _x property
	public function getTurretXPos (): Number
	{		var angle: Number = mc_turret._rotation / 180 * Math.PI; 		var x: Number = turretLength * Math.sin(angle) + this._x; 			
		return Math.round(x);
	}
	//
	// get _y property
	public function getTurretYPos (): Number
	{
		var angle: Number = mc_turret._rotation / 180 * Math.PI;		var y: Number = -turretLength * Math.cos(angle) + this._y; 		
		return Math.round(y);		
	}
	//
	// get x direction
	public function getTurretXDir (): Number
	{			
		return Math.sin(mc_turret._rotation / 180 * Math.PI);
	}
	//
	// get y direction
	public function getTurretYDir ():Number
	{
		return Math.cos(mc_turret._rotation / 180 * Math.PI);
	}		
	//
	// turn turret
	private function turnTurret (_d: Number):Void
	{	
		var d: Number = _d;
		if (d == 0)
		{
  				if (mc_turret._rotation >= minRot) 
  				{
  					mc_turret._rotation -= speedRot;
  				}
  		}
		else
		{
  				if (mc_turret._rotation <= maxRot) 
  				{
  					mc_turret._rotation += speedRot;
  				}
		}    
	}
	
}