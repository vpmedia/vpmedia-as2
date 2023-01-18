// *******************************************
//	CLASS: Application
//	by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

import de.websector.games.parachute.slides.Slide;
import de.websector.ui.buttons.IconButton;


class de.websector.games.parachute.Application extends MovieClip
{	
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// mc
	private var mc_target: MovieClip; 
	
	function Application() 
	{
		super();
	}
	
	///////////////////////////////////////////////////////////
	// #init
	///////////////////////////////////////////////////////////
	// 
	// function: init
	private function init (_t: MovieClip): Void
	{
		mc_target = _t;
		
		Stage.scaleMode = "SCALE";
		Stage.align = "TL";
		_focusrect = false;
		Stage.showMenu = false;
		
		var b_logo: IconButton = mc_target.b_logo;
		b_logo.addEventListener("release", Proxy.create (this, linkWS));
	};
	///////////////////////////////////////////////////////////
	// main
	///////////////////////////////////////////////////////////	
	// main entry point
	public static function main (): Void
	{
		// Note for MTASC User:
		// If you export library symbols in MX2004 that are linked to classes, 
		// Mtasc will issue a warning that these classes need to be explicitly compiled into your swf.
		// the solution is here: http://www.ubergeek.tv/article.php?pid=100
		registerClass("mySlidePreGame", de.websector.games.parachute.slides.SlidePreGame);
		registerClass("mySlideMenu", de.websector.games.parachute.slides.SlideMenu);
		registerClass("mySlideButton", de.websector.games.parachute.slides.SlideButton);
		registerClass("myIconButton", de.websector.ui.buttons.IconButton);
		registerClass("myTextButton", de.websector.ui.buttons.TextButton);		
		registerClass("mySlideLevel", de.websector.games.parachute.slides.SlideLevel);	
		registerClass("mySlideGame", de.websector.games.parachute.slides.SlideGame);	
		registerClass("mySlideHelp", de.websector.games.parachute.slides.SlideHelp);
		registerClass("myScrollMC", de.websector.games.parachute.slides.ScrollPanel);
		registerClass("mySlideAbout", de.websector.games.parachute.slides.SlideAbout);
		registerClass("mySlideDownload", de.websector.games.parachute.slides.SlideDownload);
		registerClass("mySlideGameOver", de.websector.games.parachute.slides.SlideGameOver);			
		registerClass("download", de.websector.games.parachute.slides.Download);	
		registerClass("about", de.websector.games.parachute.slides.About);
		
		var myApplication: Application = new Application ();
		myApplication.init (_root);

	}
	private function linkWS (): Void 
	{
		getURL("http://www.websector.de", "_blank");
	};	
}