// *******************************************
//	 CLASS: Heli 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.Border;
import de.websector.games.parachute.Tank;
import de.websector.games.parachute.Counter;

class de.websector.games.parachute.Heli extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// values
	private var speed: Number;
	public var score: Number;
	// boolean
	public var bomb: Boolean = false;
	public var ambulance: Boolean = false;	
	public var hit: Boolean = false;
	// border
	private var minX: Number;
	private var maxX: Number;
	private var minY: Number;
	// directions
	private var dir: Number;
	// mc		
	private var mc_border: MovieClip; 		// bg
	private var mc_ani: MovieClip;			// ani
	private var logo_a: MovieClip;			// logo ambulance
	private var logo_b: MovieClip;			// logo bomb
	// paras
	private var arr_p: Array;					// parachutes postions
	private var buffer_t: Number = 0; 		// time buffering
	// instances
	private var myC: Counter;
	//
    // constructor
   	function Heli () {};
	//
	// init
	public function init (_b: MovieClip, _xPos: Number, _yPos: Number): Void	
	{
 		// logos
 		logo_b = this.mc_ani.logo_b;
 		logo_a = this.mc_ani.logo_a;
 		logo_b._visible = logo_a._visible = false;
 		// counter
 		myC = Counter.getInstance();
 				
 		// check border
 		this.mc_border = _b;
 		checkBorder();
 		// x positions (0=>left, 1=>right)
		this._x = (_xPos == 0) ? (this.minX + this._width) :  (this.maxX - this._width);
		// y positions
 		setYPos(_yPos);
 		// direction (0=>left, 1=>right)
		setDir(_xPos);
				
 		// type
 		var scope: Number = 60 - myC.gL * 10;
 		var _type: Number = Math.floor(Math.random() * scope);			
		setType(_type);	
	}
	//
	// check borders
	public function checkBorder (): Void
	{
		var diffX: Number = (-.5) * this._width;
		var diffY: Number = this._height;
		var checkBorder: Border = new Border (mc_border, diffX, diffY);
		this.minX = checkBorder.getMinX ();
		this.maxX = checkBorder.getMaxX ();
		this.minY = checkBorder.getMinY ();
	}
	private function setType (_t: Number): Void 
	{		
		// bomb
		if (_t == 0)
		{
			logo_b._visible = true;
			bomb = true;
			speed = 1;
			score = 150;
		}
		// ambulance 
		else if  (_t > 0 && _t < 3)
		{
			logo_a._visible = true;
			ambulance = true;
			speed = .5;
			score = -50; // reverse at remove ();
		}
		// with parachute
		else
		{
			// no of paras
			var _paras: Number = Math.floor(Math.random() * myC.gL + 3);
			// parachutes		
			initParas(_paras);
			speed = 1;
			score = 30;
		}				
	};
	//
	// set helis yPos
	public function setDir (_xPos: Number): Void
	{
		this.dir = _xPos;
		if (this.dir == 0) this.gotoAndStop(2);
	}
	//
	// set helis yPos
	public function setYPos (_yPos: Number): Void
	{
		var diffY: Number = 10;
		switch (_yPos)
		{
	  		// row 1
	  		case 0: 
	    			this._y = this.minY;
	    		break;
	    		// row 2
	  		case 1: 
	   	 		this._y = this.minY + this._height;
	     		break;
	     	// row 3	
	  		case 2: 
	    			this._y = this.minY + this._height * 2 + diffY;
	    		break;
	    		// row 4
	  		case 3: 
	    			this._y = this.minY + this._height * 3 + 2 * diffY;
	    		break;	    		
	  		default: 
	    			this._y = this.minY;
	    };
	}
	//
	// get helis dir
	public function getDir (): Number
	{
		return this.dir;
	}
	//
	// init parachutes
	public function initParas (_pa:Number): Void
	{
		var p: Number = _pa;
		if (p > 0)
		{
			var _min: Number = this.minX + this._width;
			var _max: Number = this.maxX - this._width;
			var _diff: Number = _max - _min;
			this.arr_p = new Array();	
					
			while (--p > -1) 
			{
			 	var rnd: Number = Math.floor(Math.random() * _diff) + _min;
			 	this.arr_p.push(rnd);
			};
			arr_p.sortOn(0, Array.NUMERIC);
		}
	}
	//
	// ready for a second heli at this row
	public function readyForSecond (): Boolean
	{
		var x: Number = this._x;
		var w: Number = this._width;
		var b: Boolean = ((this.dir == 0 && x > this.minX + 3 * w) || (this.dir == 1 && x < this.maxX - 3 * w)) ? true :  false;
		return b;	
	}
	//
	// move
	public function move (): Void
	{	
		buffer_t = (buffer_t <= 0) ? 15 :  buffer_t - 1;
		
		if (this.dir == 0) this._x += this.speed;
		else this._x -= this.speed;
	}
	//
	// check jump Pos
	public function jumpPos (): Boolean
	{
		var p: Number = arr_p.length;
		var b: Boolean = false;

		if (p) 	// nested if-statements are faster
		{		
			var x: Number = this._x;
			
			if (this.dir == 0)
			{
				if (this._x > arr_p[0])
				{
					arr_p.splice(0, 1);
					b = true;
				}
			}
			else
			{
				if (this._x < arr_p[p - 1])
				{
					arr_p.splice((p - 1), 1);
					b = true;
				}		
			}
		}
		return b;
	}
	//
	// check bomb Pos
	public function bombPos (): Boolean
	{
		var b: Boolean = false;

		if (bomb) 	// nested if-statements are faster
		{		
			var x: Number = this._x;
			var mc_tank: Tank = _parent.mc_tank;
			var xT: Number = mc_tank._x;
			
			if (this.dir == 0)
			{
				if (this._x > xT)
				{
					b = true;
				}
			}
			else
			{
				if (this._x < xT)
				{
					b = true;
				}		
			}
		}
		return b;
	}			
	//
	// check for outside
	public function outside (): Boolean
	{
		var b: Boolean = (this._x < this.minX || this._x > this.maxX || this._y < minY) ? true : false;
		// count outside
		if (b && !ambulance) myC.change(0 - Math.floor (score / myC.gL / 2));	
		
		return b;
	}
	public function remove (): Void 
	{
		if (hit)
		{
			var sign: String = (ambulance) ? "-" : "+";
			var points: Number = this.score * myC.gL;
			myC.change(points);
			if (bomb || ambulance) myC.showSpecialPoints(points, this._x, this._y);
		}
		this.removeMovieClip();
	};
		
}