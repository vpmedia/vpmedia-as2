// *******************************************
//	 CLASS: Keys 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.Game;

class de.websector.games.parachute.Keys
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	private var myGame: Game;
	private var shotListener: Object;	
	private var mc_tank: MovieClip;	

	public function Keys ()
	{
		// get instance of Game
		myGame = Game.getInstance();
		mc_tank = myGame.mc_tank;
	}	
	//
	// listener
	public function kListener (): Void
	{
		shotListener = new Object ();		shotListener.onKeyDown = ascb.util.Proxy.create (this, kDown);
		shotListener.onKeyUp = ascb.util.Proxy.create (this, kUp);	
		Key.addListener (shotListener);	
	}
	//
	// remove listener
	public function removeKListener (): Void
	{	
		Key.removeListener (shotListener);
		delete shotListener;
	}
	//
	// keys down
	public function kDown (): Void
	{
		var k: Number = Key.getCode ();
		// SPACE
		if (k == 32) myGame.shoot ();
	};
	//
	// keys up
	public function kUp (): Void
	{
		var k: Number = Key.getCode ();
		// SPACE
		if (k == 32) myGame.cleanShot ();
		// P
		if (k == 80) myGame.pauseGame ();
	};
	//
	// check keys
	public function checkIt (): Void
	{
		var k: Function = Key.isDown;
		
		if (k(Key.RIGHT))
		{
	        	// turn turret to right
	        	mc_tank.turnTurret(1);
        }
        else if(k(Key.LEFT))
        {
	        	// turn turret to left
	        	mc_tank.turnTurret(0);
        }
	};	
}