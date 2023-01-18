// *******************************************
//	 CLASS: Game 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.Keys;
import de.websector.games.parachute.Tank;
import de.websector.games.parachute.Shot;
import de.websector.games.parachute.Soldier;
import de.websector.games.parachute.Heli;
import de.websector.games.parachute.Bomb;
import de.websector.games.parachute.Counter;
import de.websector.games.parachute.Parachute;
import de.websector.games.parachute.slides.Slide;
import mx.events.EventDispatcher;


class de.websector.games.parachute.Game
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
 	private static var instance: Game = null;			
 	// shots
	private var arr_s: Array = new Array();			// all shots
 	private var no_s: Number = 0;
 	private var nextShot: Boolean = true;
	// tank
	public var mc_tank: Tank;							// mc tank
 	private var turnTurretOf: Boolean = true;
 	private var ex_tank: MovieClip;					// explosion
	// helis
	private var arr_h: Array = new Array();			// all helis
	private var arr_hRows: Array = new Array();		// _y positions = rows
	private var arr_hPos: Array = new Array();			// positions of helis
 	private var no_helis: Number = 0;					// number of helis
 	private var max_helis: Number = 10;				// max number of helis
 	private var all_helis: Number = 0;				// number of all helis
 	private var buffer_h: Number = 10;				// time buffer 
  	// parachutes
	private var arr_p: Array = new Array();			// all parachutes
 	private var no_p: Number = 0;
   	// soldiers
	private var arr_so: Array = new Array();			// all soldiers
 	private var no_so: Number = 0;					
 	private var att_so: Boolean;						// ready for attack
 	private var mc_so: Soldier;						// soldier, who plant a bomb
	// bomb
	private var mc_bomb: Bomb; 						// mc bomb
	private var mc_airBomb: Bomb; 					// mc aircraft bomb
	private var throw_bo: Boolean;					// let's bombing
	private var eject_bo : Boolean;	
	// points
	private var myC: Counter; 						// points
	// keys
	private var myKeys: Keys;							// Keys
	// game
	private var mc_t: MovieClip; 						// mc timeline
	private var mc_gH: MovieClip; 					// mc game holder
	private var mc_bg: MovieClip;						// bg
	private var mc_pause: MovieClip; 					// mc pause
	public var gP: Boolean;							// pause game
	private var startTime: Number;					// time
  	private var tb: Number = 0;						// time buffer 
    private var maxB: Number = 10;					// max buffer => ca. framerate / 3 
    // EVENTS 
    private var dispatchEvent: Function;
    public var addEventListener: Function;
    public var removeEventListener: Function;
    private var eventType: String;

	///////////////////////////////////////////////////////////
	// GAME
	///////////////////////////////////////////////////////////	
		
	//
	// constructor
	private function Game () 
	{
		EventDispatcher.initialize(this);
	};
	//	
    // Singleton: get instance
    public static function getInstance (): Game
    {		
	    	if (Game.instance == null)
	    	{
	    		Game.instance = new Game ();
	    	}
	    	return Game.instance;
    }
    // init
    public function init (_t: MovieClip): Void
    {		
		// init mc's
		mc_t = _t.sl_game;
		mc_gH = mc_t.mc_gH;
		mc_bg = mc_t.mc_bg;
		// points
		myC = Counter.getInstance ();
		myC.txtPoints = mc_t.txtPoints;
		myC.txtLevel = mc_t.txtLevel;
		myC.gameHolder = mc_gH;
    }   
	//
	// new game
	public function newGame (): Void
	{			
		// points = 0
		myC.change(myC.gP = 0);
		// game Pause
		gP = false;
		// tank
		newTank ();
		// helis
		arr_hRows =	[ 	[0, 0],
						[0, 0],
					 	[0, 0],
					 	[0, 0]	];
		// keys
		if (!myKeys) myKeys = new Keys ();		
		myKeys.kListener ();
		startGame ();
		// level
		myC.showLevel();
	};
	//
	// start game
	private function startGame (): Void
	{			
		mc_gH.onEnterFrame = ascb.util.Proxy.create (this, runGame);
	};
	//
	// run the game
	private function runGame (): Void
	{
		// time buffer: don't check helis/shots at every frame...
		tb = (tb <= 0) ? maxB : tb - 1;
		myKeys.checkIt();
		newHeli();
		if (arr_h.length) moveHelis();
		if (arr_p.length) moveParas();
		if (arr_s.length)
		{
			moveShots();
			checkCollision();
		}
		if (att_so) actionSo();
		if (throw_bo) moveBomb();
		if (eject_bo) moveAirBomb();
	};
	//
	// stop game
	public function stopGame (): Void
	{
		 mc_gH.onEnterFrame = undefined;
	}
	//
	// pause game
	public function pauseGame (): Void
	{
		 if (gP) 
		 {
		 	gP = false;
		 	mc_pause.removeMovieClip ();
		 	startGame ();
		 }
		 else 
		 {
		 	gP = true;
		 	mc_pause = mc_t.attachMovie('mc_pause', 'mc_pause', mc_gH.getNextHighestDepth());
		 	stopGame ();
		 }
		 this.dispatchEvent({target:this, type:'pause', gamePause: gP});
	}
	public function skipGame (): Void 
	{
		myC.setStartLevel();
		removeTank();
		finishGame();
	};
	
	private function endExplosion (): Void 
	{
		var o: Object = {_x: mc_tank._x ,_y: mc_tank._y, _xscale: 150, _yscale: 150, cLoop: 2};
		ex_tank = mc_gH.attachMovie('mc_ex', 'mc_ex', mc_gH.getNextHighestDepth(), o);
				 		
		finishGame();
		ex_tank.onEnterFrame = ascb.util.Proxy.create (this, endAnimation);
		
		this.dispatchEvent({target:this, type:'endExplosion'});		
	};
	// loop last explosion && gameOver
	private function endAnimation (): Void 
	{
		 var cF: Number = ex_tank._currentframe;
		 var tF: Number = ex_tank._totalframes;
		 var c: Number = ex_tank.cLoop;
		  
		 if (cF == tF - 1)
		 {
		 	if (c > 0)
		 	{
		 		ex_tank.gotoAndPlay(1);
		 		ex_tank._xscale = ex_tank._yscale += 20;
		 		ex_tank._rotation += 30;
		 		if (c == 1) removeTank();
		 		ex_tank.cLoop--;
		 	}
		 	else
		 	{
			 	ex_tank.onEnterFrame = undefined;
		 		ex_tank.removeMovieClip();
		 		
		 		this.dispatchEvent({target:this, type:'gameOver'});		 	
		 	}	
		 }		
	};
	//
	// finish the game
	private function finishGame (): Void
	{
		gP = true;
		stopGame ();
		myKeys.removeKListener();	
		// remove all sprites
		removeAllParas ();
		removeAllHelis ();
		removeAllShots ();
		removeBomb ();
		removeAllSo ();
	}
	///////////////////////////////////////////////////////////
	// SHOTs
	///////////////////////////////////////////////////////////		
	//
	// shot
	public function shoot (): Void
	{
		 if (nextShot && !gP)
		 {
			mc_gH.attachMovie("mc_shot", "mc_shot" + no_s, mc_gH.getNextHighestDepth());
			var mc_shot: Shot = mc_gH["mc_shot" + no_s];			
			mc_shot.init(mc_bg, mc_tank.getTurretXPos(), mc_tank.getTurretYPos(), mc_tank.getTurretXDir(), mc_tank.getTurretYDir());
			arr_s.push(mc_shot);
			no_s ++;
			myC.change(0 - myC.gL * 5);
			nextShot = false;
		}
	};
	//
	// ready to next shot
	public function cleanShot (): Void
	{
		nextShot = true;
	};
	//
	// remove to next shot
	private function removeShot (mc_shot: Shot): Void
	{
		var s: Number = arr_s.length;
		// move all shots
		while (--s > -1) 
		{
			if(arr_s[s] == mc_shot) 
			{
				// remove entry (it's only a string not a movieclip)
				arr_s.splice(s, 1);
				break;
			}		
		}
		mc_shot.removeMovieClip();
	};
	//
	// move shots
	private function moveShots (): Void
	{		
		var s: Number = arr_s.length;
		// move all shots
		while (--s > -1) 
		{
			arr_s[s].move();
			// time buffer for unimportantly checks
			if (tb <= 1)
			{
				if (arr_s[s].outside()) removeShot(arr_s[s]);
			}
		}
	};
	private function removeAllShots (): Void 
	{				
		var s: Number = arr_s.length;
		if (s)
		{
			while (--s > -1) 
			{
				arr_s[s].removeMovieClip();		
			}
			arr_s.length = 0;
		}
	}	
	///////////////////////////////////////////////////////////
	// TANK
	///////////////////////////////////////////////////////////		
	private function newTank (): Void
	{
		if (!mc_tank) 
		{
			mc_gH.attachMovie('mc_tank', 'mc_tank', mc_gH.getNextHighestDepth());
			mc_tank = mc_gH.mc_tank;	
			mc_tank.init (mc_gH, mc_bg);		
		}
	}
	private function removeTank (): Void
	{
		mc_tank.removeMovieClip ();
		mc_tank = undefined;
	}
	///////////////////////////////////////////////////////////
	// HELIS
	///////////////////////////////////////////////////////////		
	//
	// check number of helis
	private function newHeli (): Void
	{
		var rnd: Function = Math.random;
		var fl: Function = Math.floor;
		// random buffering
		buffer_h = (buffer_h <= 0) ? fl(rnd() * (100 / myC.gL + 40)) :  buffer_h - 1;
		
		if (buffer_h <= 1)
		{
			if(arr_h.length < max_helis)
			{
				// xPos (0 => left, 1 => right)
				var xStart: Number = fl(rnd() * 2);
				// yPos (0 => 1.row, 1 => 2.row, 2 => 3.row, 3 => 4.row)
				var rY: Number = (myC.gL < 3) ? 2 : myC.gL;
				var yStart: Number = fl(rnd() * rY);
				// looking for free positions
				var p0 = arr_hRows[yStart][0];  // Number OR MovieClip (Heli);
				var p1 = arr_hRows[yStart][1]; // Number OR MovieClip (Heli);
				//
				// first heli at this yPos
				if (p0 == 0)
				{
					// attach the heli
					var mc_heli: Heli = attachHeli (xStart, yStart);
					// store the heli
					arr_hRows[yStart][0] = mc_heli;
				}
				//
				// second heli at this yPos
				else if (p0 != 0 && p1 == 0)
				{
					if( checkHeliRow(p0) && getHeliDir(p0) == xStart)
					{
						// attach the heli
						var mc_heli: Heli = attachHeli (xStart, yStart);
						// store the heli
						arr_hRows[yStart][1] = mc_heli;
					}	
				}
			}												
		}
	};
	//
	// ready for a second heli at this row
	private function checkHeliRow (heli: Heli): Boolean
	{
		var b: Boolean = heli.readyForSecond();
		return b;
	}
	//
	// get helis dir
	private function getHeliDir (heli: Heli): Number
	{
		var b: Number = heli.getDir();
		return b;
	}
	//
	// attach a heli
	private function attachHeli (xStart, yStart): Heli
	{
		mc_gH.attachMovie("mc_heli", "mc_heli" + no_helis, mc_gH.getNextHighestDepth());		
		var mc_heli: Heli = mc_gH["mc_heli" + no_helis];

		mc_heli.init(mc_bg, xStart, yStart);
		// store all values of a heli
		arr_h.push(mc_heli);
		arr_hPos.push([mc_heli, xStart, 1]);
		// count helis
		no_helis ++;	
		
		return mc_heli;
	};
	//
	// remove a heli
	private function removeHeli (mc_heli: Heli): Void
	{				
		// remove heli in arr_hPos
		var h: Number = arr_h.length;
		while (--h > -1) 
		{
			if(arr_h[h] == mc_heli) 
			{
				arr_h.splice(h, 1);
				break;
			}		
		}
		// remove heli in arr_hPos 
		var hP: Number = arr_hPos.length;
		while (--hP > -1) 
		{
			if(arr_hPos[hP][0] == mc_heli) 
			{
				arr_hPos.splice(hP, 1);
				break;
			}		
		}
		// change the status of helisRows
		var hR: Number = arr_hRows.length;
		while (--hR > -1) 
		{			
			var p0 = arr_hRows[hR][0]; // Number OR MovieClip (Heli);
			var p1 = arr_hRows[hR][1]; // Number OR MovieClip (Heli);
			// first heli at row
			if(p0 == mc_heli) 
			{
				if (p1 != 0)
				{ 
					arr_hRows[hR][0] = p1;
					arr_hRows[hR][1] = 0;
					break;
				}
				else
				{
					arr_hRows[hR][0] = 0;
					break;
				}
			}
			// second heli at row
			else if (p1 == mc_heli)
			{
				arr_hRows[hR][1] = 0;
				break;
			}				
		}
		mc_heli.remove();
	}				
	//
	// move helis
	private function moveHelis (): Void
	{		
		var h: Number = arr_h.length;
		while (--h > -1) 
		{
			var mc_h: Heli = arr_h[h];
			mc_h.move();
			// buffer for unimportantly checks
			if (tb <= 1)
			{
				// check jump position
				if(mc_h.jumpPos()) startParas(mc_h._x - 10, mc_h._y + 10);	
				// check bombPos
				if (mc_h.bombPos() && !eject_bo) ejectBomb(mc_h._x, mc_h._y);
				// remove helis outsided
				if(mc_h.outside()) removeHeli(mc_h);			
			}	
		}	
	};
	//
	// remove all helis
	private function removeAllHelis (): Void
	{				
		var h: Number = arr_h.length;
		if (h)
		{
			while (--h > -1) 
			{
				arr_h[h].remove();
			}
			arr_h.length = 0;
		}
		arr_hRows.length = 0;
		arr_hPos.length = 0;
	}
	///////////////////////////////////////////////////////////
	// PARACHUTES
	///////////////////////////////////////////////////////////		
	//
	// start para
	private function startParas (xP: Number, yP: Number): Void
	{	
		mc_gH.attachMovie('mc_para', 'mc_para' + no_p, mc_gH.getNextHighestDepth());
		var mc_p: Parachute = mc_gH['mc_para' + no_p];
		mc_p.init(mc_bg, xP, yP);
		// store all values of paras
		arr_p.push(mc_p);
		// count para
		no_p ++;
	}
	//
	// move paras
	private function moveParas (): Void
	{	
		var pL: Number = arr_p.length;
		while (--pL > -1) 
		{
			var p: Parachute = arr_p[pL];
			p.move();
			// remove paras on ground
			if(p.onGround()) 
			{
				newSoldier(p._x, p._y);	
				removePara(p);	
			}
		}		
	}
	//
	// remove para
	private function removePara (mc: Parachute): Void
	{				
		var mc_p: Parachute = mc;
		var p: Number = arr_p.length;
		while (--p > -1) 
		{
			if(arr_p[p] == mc_p) 
			{
				arr_p.splice(p, 1);
				break;
			}		
		}
		mc_p.remove();
	}
	//
	// remove all paras
	private function removeAllParas (): Void
	{				
		var p: Number = arr_p.length;
		if (p)
		{
			while (--p > -1) 
			{
				arr_p[p].removeMovieClip();		
			}
			arr_p.length = 0;
		}
	}
	///////////////////////////////////////////////////////////
	// SOLDIERS
	///////////////////////////////////////////////////////////		
	//
	// new soldier on ground
	private function newSoldier (xP: Number, yP: Number): Void
	{				
		mc_gH.attachMovie("mc_soldier", "mc_soldier" + no_so, mc_gH.getNextHighestDepth(), {_x: xP ,_y: yP});
		var so: Soldier = mc_gH["mc_soldier" + no_so];
		
		// store soldier
		arr_so.push(so);
		// attack
		if (!att_so && !throw_bo) 
		{
			att_so = so.attack();
			if (att_so) mc_so = so;
		}		
		no_so++;
	}
	//
	// remove all soldiers
	private function removeAllSo (): Void
	{				
		var s: Number = arr_so.length;
		if (s)
		{
			while (--s > -1) 
			{
				arr_so[s].removeMovieClip();		
			}
			arr_so.length = 0;
		}
	}	
	///////////////////////////////////////////////////////////
	// BOMB
	///////////////////////////////////////////////////////////	
	//
	// letz bomb
	private function actionSo (): Void
	{				
		var s: Soldier = mc_so;
		if (s.no_b < s.maxB)
		{
			s.blink();
		}
		else
		{
			var bomb: MovieClip = mc_gH.attachMovie("mc_bomb", "mc_bomb", mc_gH.getNextHighestDepth());
			mc_bomb = mc_gH.mc_bomb;
			mc_bomb.iniTrajectory(s, mc_tank);
			att_so = false;
			throw_bo = true;
		}	 
	}
	//
	// throw the bomb
	private function moveBomb (): Void
	{				
 			mc_bomb.move();
 			// hit the tank?
 			if (mc_bomb.hit()) endExplosion ();
	}	
	//
	// remove bomb
	private function removeBomb (): Void
	{				
 		if (mc_bomb) mc_bomb.removeMovieClip();
 		if (mc_airBomb) mc_airBomb.removeMovieClip();
 		throw_bo = eject_bo = false;	
	}
	
	private function ejectBomb (xPos: Number, yPos: Number): Void 
	{
		var bomb: MovieClip = mc_gH.attachMovie("mc_bomb", "mc_airBomb", mc_gH.getNextHighestDepth(), {_x: xPos, _y: yPos, yS: mc_tank._y - 10});
		mc_airBomb = mc_gH.mc_airBomb;
		eject_bo = true;	
	};
	//
	// throw the bomb
	private function moveAirBomb (): Void
	{				
	 	mc_airBomb.drop();
	 	// hit the tank?
	 	if (mc_airBomb.hit()) endExplosion ();
	}		
					
	///////////////////////////////////////////////////////////
	// collision
	///////////////////////////////////////////////////////////		
	//
	// check collision
	private function checkCollision (): Void
	{
		var sL: Number = arr_s.length;
		var fz: Number = 100; // firezone for helis
		var pL: Number = arr_p.length;
		
		while (--sL > -1) 
		{
			var s: Shot = arr_s[sL];
			// shots -> heli
			if(s._y < fz)
			{
				for (var i: String in arr_h)
				{
					var h: Heli = arr_h[i];
					if (s.hitTest(h)) 
					{
						h.hit = true;
						explosion (h._x, h._y, 80, 100);
						removeHeli(h);	
						removeShot(s);
					}	
				}
			}			
			// shots -> parachutes
			if(pL)
			{
				for (var i: String in arr_p)
				{
					var p: Parachute = arr_p[i];					
					if (s.hitTest(p)) 
					{
						explosion (p._x, p._y, 50, 70); 
						p.hit = true;				
						removePara (p);	
						removeShot (s);
					}	
				}
			}
		}	
	};
	//
	// explosion
	private function explosion (xP: Number, yP: Number, sx: Number, sy: Number): Void
	{
		var o: Object = {_x: xP ,_y: yP, _xscale: sx, _yscale: sy};
		var ex: MovieClip = mc_gH.attachMovie("mc_ex", "mc_ex" + no_s, mc_gH.getNextHighestDepth(), o);
	}	
}




