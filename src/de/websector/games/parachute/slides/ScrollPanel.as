// *******************************************
//	 CLASS: ScrollPanel 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

class de.websector.games.parachute.slides.ScrollPanel extends MovieClip
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
	// mc	
	private var scrollBar: MovieClip;
	private var mc_content: MovieClip;
	private var dragButton: MovieClip;
	private var mask: MovieClip;
	private var mc_contentHolder: MovieClip;
	// vars	
	private var drag: Boolean;
	private var acc: Number = 5; // acceleration
	
	private var startX: Number;
	private var contentStartX: Number;
	private var startY: Number;
	private var contentPosY: Number;
	
	private var contentHeight: Number;
	private var contentDist: Number;
	private var distance: Number;	
	private	var extraHeight: Number = 5;

	private var dB_height: Number;
	private var dB_halfHeight: Number;
						
	function ScrollPanel() 
	{
		super();
	}
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////	
	public function init (targetMC: String): Void 
	{
		drag = false;
		startX = scrollBar._x;  

		startY = scrollBar._y; 
		dragButton._y = startY;
		dragButton._visible = scrollBar._visible = false;
		
		scrollBar.onPress = function () {};
		scrollBar.useHandCursor = false;
		
		mc_content = mc_contentHolder.attachMovie(targetMC, "mc_content", mc_contentHolder.getNextHighestDepth());
		
		this.onEnterFrame = Proxy.create (this, initScroll);
	};
	private function initScroll (): Void 
	{
		this.onEnterFrame = undefined;

		contentStartX = mc_content._x;
		contentPosY = mc_content._y;
		contentHeight = mc_content._height;
		contentDist = contentHeight - mask._height;	
		
		if (contentDist > 0)
		{
			initDragButton();
			dragButton._visible = scrollBar._visible = true; 
			// mouse events
			this.onMouseDown = Proxy.create (this, mouseDown);
			this.onMouseUp = Proxy.create (this, mouseUp);				
		}

	};
	private function initDragButton (): Void 
	{
		var p1: Number = contentHeight * 100 / mask._height;
		var p2: Number = p1 / 100;
		p2 = (p2 < 9) ? this.mask._height / p2 : this.mask._height / 9;
		dragButton._height = Math.round(p2);
		
		dB_height = dragButton._height;
		dB_halfHeight = dB_height / 2;
	
		distance = this.scrollBar._height - dB_height - extraHeight;

	};
	///////////////////////////////////////////////////////////
	// scroll
	///////////////////////////////////////////////////////////		
	private function scroll (): Void 
	{
		var posY: Number = dragButton._y - startY;
		// percent of distance
		var percent: Number = (posY * 100) / distance;
		// new position for content
		var newYPos: Number = contentPosY - (contentDist * percent / 100);
		var newDist: Number = newYPos - mc_content._y;
		newDist = Math.round(newDist / acc);
		mc_content._y += newDist;		

		if ((!this.drag && newDist == 0))
		{
			mc_content._y = Math.round (mc_content._y);
			this.onEnterFrame = undefined;
		}			
	};
	//
	// drag button
	private function mouseDown (): Void 	
	{
		if (!drag && _parent.show)
		{
			// localToGlobal			
			var o: Object = { x: this._xmouse, y: this._ymouse};
	   		this.localToGlobal(o);

			if (this.scrollBar.hitTest (o.x, o.y, false))
			{
				var yPos: Number;

				// drag
				if (this._ymouse <= dB_halfHeight && dragButton._y != startY)
				{
					yPos = startY;
				}
				else if (this._ymouse >= mask._height - dB_height && dragButton._y < mask._height - dB_height)
				{
					yPos = mask._height - dB_height;
				}
				else if (this._ymouse >= dB_halfHeight && this._ymouse <= mask._height - dB_height)
				{
					yPos = this._ymouse - dB_halfHeight;
				}
				this.dragButton._y = yPos;
				dragButton.startDrag (false, startX, startY, startX, (mask._height - dB_height));
				this.drag = true;
				// scroll
				this.onEnterFrame = Proxy.create (this, scroll);
			}
		}
	};
	//
	// finish drag
	private function mouseUp (): Void 
	{
		drag = false;
		dragButton.stopDrag ();
	};

	public function startPos (): Void 
	{
		if (this.onEnterFrame) this.onEnterFrame = undefined;
		dragButton._y = startY;
		mc_content._y = startY;
	};	
}
