// *******************************************
//	 CLASS: SimpleButton 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;
import mx.events.EventDispatcher;

class de.websector.ui.buttons.SimpleButton extends MovieClip
{
	// mc 
	private var bg :MovieClip;
	// vars
	private var alphaInactive: Number = 50;
	// events
	private var dispatchEvent: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;	
		
	function SimpleButton() 
	{
		super();
		EventDispatcher.initialize(this);
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init() : Void 
	{
		initBG();
		// mouse events
		bg.onRelease = Proxy.create (this, releaseEvent);
		bg.onPress = Proxy.create (this, pressEvent);
		bg.onRollOver = bg.onDragOver = Proxy.create (this, rollOverEvent);	
		bg.onRollOut = bg.onDragOut = bg.onReleaseOutside = Proxy.create (this, rollOutEvent);		
	}	
	private function initBG (): Void 
	{	
		if (bg == undefined) 
		{
			bg = this.createEmptyMovieClip("bg", 1);	
		}
		else 
		{
			bg.clear();
		}

		var x1: Number = 0;
		var x2: Number = this._width;
		var y1: Number = 0;
		var y2: Number = this._height;
				
		bg.beginFill(0xFFFFFF, 0);		
		bg.moveTo(x1, y1);
		bg.lineTo(x2, y1);
		bg.lineTo(x2, y2);
		bg.lineTo(x1, y2);
		bg.lineTo(x1, y1);
		bg.endFill();		
	};
	///////////////////////////////////////////////////////////
	// mouse events
	///////////////////////////////////////////////////////////		
	public function pressEvent() : Void 
	{
		this.dispatchEvent({target:this, type:'press'});	
	}
	public function releaseEvent() : Void 
	{
		this.dispatchEvent({target:this, type:'release'});
	}		
	public function rollOverEvent() : Void 
	{
		this.dispatchEvent({target:this, type:'rollOver'});
	}	
	public function rollOutEvent() : Void 
	{
		this.dispatchEvent({target:this, type:'rollOut'});
	}
	///////////////////////////////////////////////////////////
	// misc
	///////////////////////////////////////////////////////////		
	public function isActive (b: Boolean): Void 
	{
		this.bg.enabled = b;
		this._alpha = (b) ? 100 : alphaInactive;
	};
	public function showHandCursor (b: Boolean): Void 
	{
		this.bg.useHandCursor = b;
	};		
}