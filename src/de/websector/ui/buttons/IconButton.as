// *******************************************
//	 CLASS: GraphicButton 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;
import de.websector.ui.buttons.SimpleButton;

class de.websector.ui.buttons.IconButton extends SimpleButton
{
	// vars
	private var holdStatus : Boolean;
	
	
	function IconButton() 
	{
		super();
		init();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (holdStatus: Boolean): Void 
	{
		super.init();
		this.holdStatus = (holdStatus != undefined) ? holdStatus : false;
	};			
	///////////////////////////////////////////////////////////
	// mouse events
	///////////////////////////////////////////////////////////		
	public function pressEvent() : Void 
	{
		super.pressEvent ();
		
		if (holdStatus) 
		{
			this.gotoAndStop("over");
			this.bg.enabled = holdStatus = false;
		}
		else
		{
			this.gotoAndStop("over");
		}		
	}

	public function rollOverEvent() : Void 
	{
		super.rollOverEvent ();
		this.gotoAndStop("over");
	}

	public function rollOutEvent() : Void 
	{
		super.rollOutEvent ();
		this.gotoAndStop("normal");
	}
	
	
	///////////////////////////////////////////////////////////
	// misc
	///////////////////////////////////////////////////////////	
	// 
	// function: setStartStatus
	public function setStartStatus (): Void 
	{
		this.gotoAndStop("normal");
		this.bg.enabled = holdStatus = true;		
	};

	
}