// *******************************************
//	 CLASS: SlideAbout
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.Slide;
import de.websector.games.parachute.slides.ISlide;
import de.websector.games.parachute.slides.ScrollPanel;

class de.websector.games.parachute.slides.SlideAbout extends Slide implements ISlide
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var myScroll: ScrollPanel;
	
	function SlideAbout() 
	{
		super();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (): Void 
	{
		super.init();
		myScroll.init("mc_about");
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
	};
	public function onStartTween (): Void 
	{
		if (show)
		{
			super.showBackButton("Menu");
			b_back.addEventListener("press", Proxy.create (this, changeSlide, "menu"));
			
			super.changeHeadline("About");
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
		if (!show) myScroll.startPos();
	};
	
}