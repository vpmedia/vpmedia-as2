// *******************************************
//	 CLASS: Shot 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.Border;

class de.websector.games.parachute.Shot extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// speed
	private var speed:Number = 5;
	// border
	public var minX:Number;
	public var maxX:Number;
	public var minY:Number;
	public var maxY:Number;
	// directions
	public var xDir:Number;
	public var yDir:Number;
	// mc		
	public var mc_border:MovieClip; 		// bg
	//
	// constructor
	public function Shot () {};
	//
	// init
	public function init (_b, _xPos, _yPos, _xDir, _yDir):Void
	{
 		this.mc_border = _b;
		this._x = _xPos;
		this._y = _yPos;
		this.xDir = _xDir;
		this.yDir = _yDir;
		// check border
		this.checkBorder();
	}	
	//
	// check borders
	public function checkBorder ():Void
	{
		var diffX:Number = this._width/2;
		var diffY:Number = this._height/2;
		var checkBorder:Border = new Border (this.mc_border, diffX, diffY);
		this.minX = checkBorder.getMinX ();
		this.maxX = checkBorder.getMaxX ();
		this.minY = checkBorder.getMinY ();
		this.maxY = checkBorder.getMaxY ();
	}
	//
	// check borders
	public function outside ():Boolean
	{
		var x: Number = this._x;
		var y: Number = this._y;
		var b:Boolean = (x < this.minX || x > this.maxX || y < minY) ? true : false;
		return b;
	}	
	//
	// move
	public function move ():Void
	{	
		this._x += this.xDir * this.speed;
		this._y -= this.yDir * this.speed;
	}	
}