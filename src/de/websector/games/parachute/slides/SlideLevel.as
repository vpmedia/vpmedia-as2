// *******************************************
//	 CLASS: SlideLevel
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.SlideButton;
import de.websector.games.parachute.slides.Slide;
import de.websector.games.parachute.Counter;
import de.websector.games.parachute.slides.ISlide;

class de.websector.games.parachute.slides.SlideLevel extends Slide implements ISlide
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var b_level1 : SlideButton;
	private var b_level2: SlideButton;
	private var b_level3: SlideButton;
	private var b_level4: SlideButton;		
	private var activeButton: SlideButton;	
	private var gameCounter: Counter;
	
	function SlideLevel() 
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
		gameCounter = Counter.getInstance(undefined);
	};
	
	public function initButtons (): Void 
	{
		var hideArrow: Boolean;
		var level: Number;
		
		b_level1.init("Level 1", hideArrow = true);
		b_level1.addEventListener("press", Proxy.create (this, changeSlide, "preGame", level = 1));		
		b_level1.rollOverEvent();
		b_level1.isActive (false);
		activeButton = b_level1;
		
		b_level2.init("Level 2", hideArrow = true);
		b_level2.addEventListener("press", Proxy.create (this, changeSlide, "preGame", level = 2));
		
		b_level3.init("Level 3", hideArrow = true);
		b_level3.addEventListener("press", Proxy.create (this, changeSlide, "preGame", level = 3));
		
		b_level4.init("Level 4", hideArrow = true);
		b_level4.addEventListener("press", Proxy.create (this, changeSlide, "preGame", level = 4));				
	};
	///////////////////////////////////////////////////////////
	// tweens
	///////////////////////////////////////////////////////////	
	
	public function changeSlide (evtObj: Object, targetSlide: String, level: Number): Void 
	{
		if (level != undefined)
		{
			activeButton.isActive(true);
			activeButton.rollOutEvent();
			
			activeButton = evtObj.target;
			activeButton.isActive(false);
	
			gameCounter.gL = gameCounter.sL = level;		
		}				
		super.move (this, targetSlide, "right");
	};
	public function onStartTween (): Void 
	{
		if (show)
		{
			super.showBackButton("WS-Parachute");
			b_back.addEventListener("press", Proxy.create (this, changeSlide, "preGame", undefined));
			
			super.changeHeadline("Level");
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