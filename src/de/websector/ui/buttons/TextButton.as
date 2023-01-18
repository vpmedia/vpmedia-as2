// *******************************************
//	 CLASS: TextButton 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;
import de.websector.ui.buttons.SimpleButton;

class de.websector.ui.buttons.TextButton extends SimpleButton
{
	// vars
	private var txtField : TextField;
	private var holdStatus : Boolean;

	private var COLOR_NORMAL: Number;
	private var COLOR_HOVER: Number;

	
	function TextButton() 
	{
		super();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (txt: String, colorNormal: Number, colorHover: Number, holdStatus: Boolean): Void 
	{		
		txtField.autoSize = "left";
		txtField.htmlText = txt;
		
		COLOR_NORMAL = colorNormal;
		COLOR_HOVER = colorHover;
		txtField.textColor = COLOR_NORMAL;
		this.holdStatus = holdStatus;	
		
		super.init();
	};
				
	///////////////////////////////////////////////////////////
	// mouse events
	///////////////////////////////////////////////////////////		
	public function pressEvent() : Void 
	{
		super.pressEvent ();
		
		if (holdStatus) 
		{
			txtField.textColor = COLOR_HOVER;
			this.bg.enabled = holdStatus = false;
		}
		else
		{
			txtField.textColor = COLOR_NORMAL;
		}
	}

	public function rollOverEvent() : Void 
	{
		super.rollOverEvent ();
		txtField.textColor = COLOR_HOVER;
	}

	public function rollOutEvent() : Void 
	{
		super.rollOutEvent ();
		txtField.textColor = COLOR_NORMAL;
	}
	///////////////////////////////////////////////////////////
	// misc
	///////////////////////////////////////////////////////////	
	// 
	// function: setStartStatus
	public function setStartStatus (): Void 
	{
			txtField.textColor = COLOR_NORMAL;
			this.bg.enabled = holdStatus = true;		
	};
	// 
	// function: setActive
	public function setActive (b: Boolean): Void 
	{
		this.bg.enabled = b;
	}; 		
}