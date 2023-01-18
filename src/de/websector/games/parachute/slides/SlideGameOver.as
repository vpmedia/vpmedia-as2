// *******************************************
//	 CLASS: SlideGameOver
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.Slide;
import de.websector.games.parachute.slides.ISlide;
import de.websector.ui.buttons.TextButton;
import de.websector.games.parachute.Counter;

class de.websector.games.parachute.slides.SlideGameOver extends Slide implements ISlide
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// var
	private var showMenu: Boolean;
	private var txt1: TextField;
	private var txt2: TextField;
	// instances	
	private var b_new : TextButton;	
	private var myC: Counter;	
			
	function SlideGameOver() 
	{
		super();
	}

	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (): Void 
	{
		super.init();
		// counter
 		myC = Counter.getInstance();
	};
	
	public function initButtons (): Void 
	{

	};
	private function initTxt (): Void 
	{
		txt1.autoSize = txt2.autoSize = "left";
		txt1.html = txt2.html = true;
	};
	///////////////////////////////////////////////////////////
	// tweens
	///////////////////////////////////////////////////////////	
	
	public function changeSlide (evtObj: Object, targetSlide: String, direction: String): Void 
	{		
		myC.setStartLevel();
		super.move (this, targetSlide, direction);
	};

	public function onStartTween (): Void 
	{
		if (show)
		{			
			super.showBackButton("Menu");
			b_back.addEventListener("press", Proxy.create (this, backToMenu, "menu", "right"));

			var initObj: Object = {_x: 170, _y: this._y - 20};
			mc_target.attachMovie("b_txt", "b_new", mc_target.getNextHighestDepth(), initObj);
			b_new = mc_target.b_new; // workaround => if b_pause a attached movie you cannot assign MovieClip to an instance of de.websector.ui.buttons.TextButton
			b_new.init("New Game", B_NORMAL, B_HOVER, false);			
			b_new.addEventListener("press", Proxy.create (this, changeSlide, "game", "left"));
			
			changeTxt();			
			
			super.changeHeadline("Game Over");
		}
		else
		{
			b_back.removeEventListener("press", this);
			super.hideBackButton();
			
			b_new.removeEventListener("press", this);
			b_new.removeMovieClip();			
		}
	};
	public function onEndTween (): Void 
	{
		super.onEndTween();
		if (!show && showMenu) setAllStartPos();
		if (show) showMenu = false;
	};
	
	private function backToMenu (evtObj: Object): Void 
	{
		showMenu = true;
		changeSlide(evtObj, "menu", "right");		
	};	
	
	private function changeTxt (): Void 
	{
		initTxt();
		txt1.htmlText = "Points: " + myC.gP;
		txt2.htmlText = "Level: " + myC.gL;		
		txt1._x = Math.round(this._width / 2 - txt1._width / 2);
		txt2._x = Math.round(this._width / 2 - txt2._width / 2);		
	};	
}