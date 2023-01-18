// *******************************************
//	 CLASS: About
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.SlideButton;

class de.websector.games.parachute.slides.About extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var b_url : SlideButton;
	private var b_email: SlideButton;	
	private var b_para: SlideButton;	
	
	function About() 
	{
		super();
		init();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (): Void 
	{
		this.onEnterFrame = Proxy.create (this, initButtons);
	};
	
	public function initButtons (): Void 
	{
		this.onEnterFrame = undefined;
		
		var hideArrow: Boolean;
		var underline: Boolean;
		var _blank: Boolean;
		var level: Number;
		
		b_url.init("<u>www.websector.de</u>", hideArrow = true);
		b_url.addEventListener("release", Proxy.create (this, referURL, "http://www.websector.de/", _blank = true));
				
		b_email.init("<u>sectore@gmail.com</u>", hideArrow = true);
		b_email.addEventListener("release", Proxy.create (this, referURL, "mailto:sectore@gmail.com", _blank = false));

		b_para.init("<u>www.websector.de/games/parachute/</u>", hideArrow = true);
		b_para.addEventListener("release", Proxy.create (this, referURL, "http://www.websector.de/games/parachute/", _blank = true));
			
	};
	///////////////////////////////////////////////////////////
	// events
	///////////////////////////////////////////////////////////	
	private function referURL (evtObj: Object, targetUrl, _blank: Boolean): Void 
	{
		var urlWindow: String = (_blank) ? "_blank" : "_self";
		getURL(targetUrl, urlWindow);
	};
	
}