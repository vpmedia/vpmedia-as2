// *******************************************
//	 CLASS: Border 
//	 by Jens Krause [www.websector.de]
// *******************************************

import ascb.util.Proxy;

class de.websector.games.parachute.Border
{
	private var AUTHOR: String = "Jens Krause [www.websector.de]";
 	// mc	
 	private var mc_bg:MovieClip;
 	private var diffX:Number;
  	private var diffY:Number;

   	function Border (_bg:MovieClip, _diffX:Number, _diffY:Number)
   	{		
   		mc_bg = _bg;
   		diffX = _diffX;
   		diffY = _diffY;
   	}
	//
	// min x
	public function getMinX ():Number
	{
		var minX = diffX;
		return (minX);
	}
	//
	// max x
	public function getMaxX ():Number
	{
		var maxX = mc_bg._width - diffX;
		return (maxX);
	}
	//
	// min x
	public function getMinY ():Number
	{
		var minY = diffY;
		return (minY);
	}
	//
	// max x
	public function getMaxY ():Number
	{
		var maxX = mc_bg._height - diffY;
		return (maxX);
	}	
}