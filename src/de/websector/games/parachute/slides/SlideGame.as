// *******************************************
//	 CLASS: SlideGame
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.Slide;
import de.websector.games.parachute.slides.ISlide;
import de.websector.games.parachute.Game;
import de.websector.ui.buttons.TextButton;

class de.websector.games.parachute.slides.SlideGame extends Slide implements ISlide
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var b_pause : TextButton;
	private var b_play : TextButton;	
	private var myGame: Game;
	
	function SlideGame() 
	{
		super();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (): Void 
	{
		super.init();
		myGame = Game.getInstance();
		myGame.init (mc_target);
		myGame.addEventListener("pause", Proxy.create (this, gamePause));
		myGame.addEventListener("endExplosion", Proxy.create (this, gameEndExplosion));
		myGame.addEventListener("gameOver", Proxy.create (this, gameOver));
	};
	
	public function initButtons (): Void 
	{
	
	};
	///////////////////////////////////////////////////////////
	// tweens
	///////////////////////////////////////////////////////////	
	
	public function changeSlide (evtObj: Object, targetSlide: String): Void 
	{				
		super.move (this, targetSlide, "right");
		myGame.skipGame();
	};	
	public function onStartTween (): Void 
	{
 		if (show)
		{
			super.showBackButton("Skip");
			b_back.addEventListener("press", Proxy.create (this, changeSlide, "preGame"));

			var initObj: Object = {	_x: 190, 
									_y: this._y - 20	};
			mc_target.attachMovie("b_txt", "b_pause", mc_target.getNextHighestDepth(), initObj);
			b_pause = mc_target.b_pause; // workaround => if b_pause a attached movie you cannot assign MovieClip to an instance of de.websector.ui.buttons.TextButton
			b_pause.init("Pause", B_NORMAL, B_HOVER, false);			
			b_pause.addEventListener("press", Proxy.create (myGame, myGame.pauseGame));
			
			super.changeHeadline("Play");
		}
		else
		{
			b_back.removeEventListener("press", this);
			super.hideBackButton();
			
			b_pause.removeEventListener("press", this);
			b_pause.removeMovieClip();
		}
	};
	public function onEndTween (): Void 
	{		
		super.onEndTween();
		if (show) myGame.newGame();
	};	
	
	private function gamePause (evtObj: Object): Void 
	{
		 if (evtObj.gamePause) 
		 {
			var initObj: Object = {	_x: 180, 
									_y: this._y - 20	};
			mc_target.attachMovie("b_txt", "b_play", mc_target.getNextHighestDepth(), initObj);
			b_play = mc_target.b_play; // workaround => if b_play a attached movie you cannot assign MovieClip to an instance of de.websector.ui.buttons.TextButton
			b_play.init("Continue", B_NORMAL, B_HOVER, false);			
			b_play.addEventListener("press", Proxy.create (myGame, myGame.pauseGame));
		 	
		 	super.changeHeadline("Pause");
		 	b_pause._visible = b_back._visible = false;
		 }
		 else 
		 {
			b_play.removeEventListener("press", this);
			b_play.removeMovieClip();
			
		 	super.changeHeadline("Play");
		 	b_pause._visible = b_back._visible = true;
		 }		
	};
	private function gameEndExplosion (): Void 
	{
		b_back.removeEventListener("press", this);
		super.hideBackButton();
		
		b_pause.removeEventListener("press", this);
		b_pause.removeMovieClip();		
	};
	private function gameOver (evtObj: Object): Void 
	{				
		changeSlide(evtObj, "gameOver");
	};	
}