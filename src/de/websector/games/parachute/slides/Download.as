// *******************************************
//	 CLASS: Download
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.SlideButton;

class de.websector.games.parachute.slides.Download extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// instances	
	private var b_url1 : SlideButton;
	private var b_url2: SlideButton;	
	
	function Download() 
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
		var _blank: Boolean;
		var level: Number;
		
		b_url1.init("<u>http://creativecommons.org/licenses/</u>", hideArrow = true);
		b_url1.addEventListener("release", Proxy.create (this, referURL, "http://creativecommons.org/licenses/by-nc-sa/2.0/"));

		b_url2.init("<u>Coming soon...</u>", hideArrow = true);				
//		b_url2.init("<u>Download game engine (*fla file)</u>", hideArrow = true);
		b_url2.addEventListener("release", Proxy.create (this, referURL, "mailto:sectore@gmail.com"));	
	};
	///////////////////////////////////////////////////////////
	// events
	///////////////////////////////////////////////////////////	
	private function referURL (evtObj: Object, targetUrl): Void 
	{
		getURL(targetUrl, "_blank");
	};
	
}