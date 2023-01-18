// *******************************************
//	 CLASS: SlideButton 
//	 by Jens Krause [www.websector.de]
// *******************************************

import de.websector.ui.buttons.SimpleButton;
import ascb.util.Proxy;

class de.websector.games.parachute.slides.SlideButton extends SimpleButton
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// mc
	private var bg: MovieClip;
	private var arrow: MovieClip;
	// vars
	private var txtField : TextField;
	private var holdStatus : Boolean;
	private var alphaInactive: Number = 100; 
	
	private var COLOR_NORMAL: Number = 0x333333;
	private var COLOR_HOVER: Number = 0xFFFFFF;
	
	private var hideArrow: Boolean = false;	
		
	function SlideButton() 
	{
		super();
		alphaInactive = 100; // override superclass
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (txt: String, hArrow: Boolean): Void 
	{		
		hideArrow = hArrow;
		arrow = this.bg.arrow;
		if (hideArrow) this.bg.arrow._visible = false;
		txtField.autoSize = "left";
		txtField.html = true;
		txtField.htmlText = txt;
		txtField.textColor = COLOR_NORMAL;	
		
		super.init();
	};
	///////////////////////////////////////////////////////////
	// mouse events
	///////////////////////////////////////////////////////////		
	public function pressEvent() : Void 
	{
		super.pressEvent ();
		txtField.textColor = COLOR_HOVER;
		showArrow(COLOR_HOVER);
		bg.gotoAndStop("over");
	}

	public function rollOverEvent() : Void 
	{
		super.rollOverEvent ();
		txtField.textColor = COLOR_HOVER;
		showArrow(COLOR_HOVER);
		bg.gotoAndStop("over");		
	}

	public function rollOutEvent() : Void 
	{
		super.rollOutEvent ();
		txtField.textColor = COLOR_NORMAL;
		showArrow(COLOR_NORMAL);
		bg.gotoAndStop("normal");		
	}
	private function showArrow (_color: Number): Void 
	{
		if (hideArrow) 
		{
			arrow._visible = false;
		}
		else
		{
			var myColor : Color = new Color (arrow);
			myColor.setRGB(_color);
		}
	};
	
}