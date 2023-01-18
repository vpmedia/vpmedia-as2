// *******************************************
//	 CLASS: SlidePreGame
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.SlideButton;
import de.websector.games.parachute.slides.Slide;
import de.websector.games.parachute.slides.ISlide;

class de.websector.games.parachute.slides.SlidePreGame extends Slide implements ISlide
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var b_start : SlideButton;
	private var b_level: SlideButton;
		
	function SlidePreGame() 
	{
		super();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (): Void 
	{
		super.init();
		initButtons();
	};
	
	public function initButtons (): Void 
	{
		b_start.init("Start game");
		b_start.addEventListener("press", Proxy.create (this, changeSlide, "game", "left"));
		
		b_level.init("Change level");
		b_level.addEventListener("press", Proxy.create (this, changeSlide, "level", "left"));
	};
	///////////////////////////////////////////////////////////
	// tweens
	///////////////////////////////////////////////////////////	
	
	public function changeSlide (evtObj: Object, targetSlide: String, direction: String): Void 
	{		
		super.move (this, targetSlide, direction);
	};

	public function onStartTween (): Void 
	{
		if (show)
		{
			super.showBackButton("Menu");
			b_back.addEventListener("press", Proxy.create (this, changeSlide, "menu", "right"));
			
			super.changeHeadline("WS-Parachute");
		}
		else
		{
			b_back.removeEventListener("press", this);
			super.hideBackButton();
		}
	};
	public function onEndTween (): Void 
	{		
		super.onEndTween();
	};		
}