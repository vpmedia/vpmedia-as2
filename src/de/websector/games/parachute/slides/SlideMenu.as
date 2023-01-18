// *******************************************
//	 CLASS: SlideMenu
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.SlideButton;
import de.websector.games.parachute.slides.Slide;
import de.websector.games.parachute.slides.ISlide;

class de.websector.games.parachute.slides.SlideMenu extends Slide implements ISlide
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var b_parachute : SlideButton;
	private var b_instructions: SlideButton;
	private var b_about : SlideButton;	
		
	function SlideMenu() 
	{
		super();
		this.onEnterFrame = Proxy.create (this, init); // hack the effect of attachMovie
	}

	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (): Void 
	{
		super.init();
		initButtons();
		super.changeHeadline("Menu");
	};
	
	public function initButtons (): Void 
	{
		b_parachute.init("WS-Parachute");
		b_parachute.addEventListener("press", Proxy.create (this, changeSlide, "preGame"));
		
		b_instructions.init("Instructions");
		b_instructions.addEventListener("press", Proxy.create (this, changeSlide, "help"));	
		
		b_about.init("About");
		b_about.addEventListener("press", Proxy.create (this, changeSlide, "about"));	
	};
	///////////////////////////////////////////////////////////
	// tweens
	///////////////////////////////////////////////////////////	
	
	public function changeSlide (evtObj: Object, targetSlide: String): Void 
	{	
		super.move (this, targetSlide, "left");
	};
	public function changeSlide2 (evtObj: Object, targetSlide: String): Void 
	{	
		super.move (this, targetSlide, "right");		
	};
	public function onStartTween (): Void 
	{
		if (show) 
		{
			super.changeHeadline("Menu");	
		}
	};
	public function onEndTween (): Void 
	{
		super.onEndTween();
	};	
}