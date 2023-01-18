// *******************************************
//	 CLASS: Counter 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import mx.transitions.Tween;

class de.websector.games.parachute.Counter extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	 private static var instance: Counter = null;	
	// mc	
	private var txtP: TextField;
	private var txtL: TextField;
	private var gH: MovieClip;	
	// values
	private var points: Number = 0;
	private var level: Number = 1;
	private var startLevel: Number = 1;
	private var maxLevel: Number;
	private var changeLevel: Array = [1000, 5000, 15000];
//	private var changeLevel: Array = [100, 300, 500]; // Debugging
	
	//
	// constructor
	public function Counter ()
	{
		maxLevel = changeLevel.length + 1;	
	};
	//	
    // Singleton: get instance
    public static function getInstance (): Counter
    {		
	    	if (Counter.instance == null)
	    	{
	    		Counter.instance = new Counter ();
	    	}
	    	return Counter.instance;
    }
	//
	// change
	public function change (_p: Number): Void
	{
		points += _p;
		if (points < 0) points = 0;
		txtP.autoSize = "left";
		txtP.htmlText = points.toString();
		txtP._x = Math.round(226 - txtP._width);

		checkLevel();
	}
	// check level	
	private function checkLevel (): Void 
	{
		if (level < maxLevel) 
		{
			if (points >= changeLevel[level - 1]) 
			{
				level ++;
				showLevel();
			}
		}
		txtL.htmlText = level.toString();
	};
	public function setStartLevel (): Void 
	{
		level = startLevel;
	};
	
	///////////////////////////////////////////////////////////
	// headlines
	///////////////////////////////////////////////////////////	
	
	public function showSpecialPoints (points: Number, xPos: Number, yPos: Number): Void 
	{
		var h: MovieClip = gH.attachMovie("h1", "hPoints", gH.getNextHighestDepth(), {_x: xPos, _y: yPos + 10});
		h.txtField.autoSize = "left";
		h.txtField.htmlText = 	(points > 0) ? "+" + points.toString() : points.toString();	
		h.txtField.textColor = (points > 0) ? 0xFFFFFF : 0xFF2790;
		
		h._x = xPos - h._width / 2;
		
		var duration: Number = 1;
		var easing: Function = mx.transitions.easing.Regular.easeIn;
		
		var tw1: Tween = new Tween (h, "_y", easing, h._y, h._y - 50, duration, true);
		tw1.onMotionFinished = Proxy.create (this, removeHeadline, h);
		var tw2: Tween = new Tween (h, "_alpha", easing, 100, 0, duration, true);
		
	};
	
	public function showLevel (): Void 
	{
		var xPos: Number = 117;
		var yPos: Number = 63;
		
		var h: MovieClip = gH.attachMovie("h1", "hLevel", gH.getNextHighestDepth(), {_x: xPos, _y: yPos});
		h.txtField.autoSize = "left";
		h.txtField.htmlText = "Level " + level;	
		h.txtField.textColor = 0x34579B;
		
		h._x = Math.round(xPos - h._width / 2);
		
		var easing: Function = mx.transitions.easing.Regular.easeIn;
		
		var tw1: Tween = new Tween (h, "_alpha", easing, 100, 0, 2, true);
		tw1.onMotionFinished = Proxy.create (this, removeHeadline, txtL);	
	};
	private function removeHeadline (h: MovieClip): Void 
	{
		h.txtField.removeMovieClip();
		h.removeMovieClip();
	};	
	///////////////////////////////////////////////////////////
	// getter / setter
	///////////////////////////////////////////////////////////	
	// game level	
	public function get gL (): Number 
	{
		return level;
	};		
	public function set gL (_l: Number ): Void 
	{
		level = _l;
	};
	public function get sL (): Number 
	{
		return startLevel;
	};		
	public function set sL (_startLevel: Number ): Void 
	{
		startLevel = _startLevel;
	};	
	public function get gP (): Number 
	{
		return points;
	};		
	public function set gP (_points: Number ): Void 
	{
		points = _points;
	};
	
	public function get txtPoints (): TextField 
	{
		return txtP;
	};		
	public function set txtPoints (_txtP: TextField ): Void 
	{
		txtP = _txtP;
	};
	public function get txtLevel (): TextField 
	{
		return txtL;
	};		
	public function set txtLevel (_txtL: TextField ): Void 
	{
		txtL = _txtL;
	};
	public function get gameHolder (): MovieClip 
	{
		return gH;
	};		
	public function set gameHolder (_gH: MovieClip ): Void 
	{
		gH = _gH;
	};		
}