// *******************************************
//	 CLASS: StageCover 
//	 by Jens Krause [www.websector.de]
// *******************************************

class de.websector.games.parachute.util.StageCover
{	
	private var AUTHOR: String = "Jens Krause [www.websector.de]";	
	// mc	
	private var mc_coverHolder: MovieClip;	
	private var mc_cover: MovieClip;
	// vars
	public static var counter: Number = 0;	
	private var customize: Boolean;
	private var c: Boolean;
  
    function StageCover (mc_target: MovieClip, mc_coverHolder: MovieClip, b: Boolean) 
    {
		this.mc_coverHolder = mc_coverHolder; 
		customize = b;
    }	
	///////////////////////////////////////////////////////////
	// init
	///////////////////////////////////////////////////////////
	public function init (): Void 
	{

	};
	///////////////////////////////////////////////////////////
	// misc
	///////////////////////////////////////////////////////////	
	public function showCover (): Void 
	{
		var o: Object = new Object ();
		o._x = o._y = 0;
		
		if (customize)
		{
			o._width = mc_coverHolder._width;
			o._height = mc_coverHolder._height;	
		}
		else
		{
			o._width = Stage.width;
			o._height = Stage.height;			
		}

		o._alpha = 0;

		mc_cover = mc_coverHolder.attachMovie('mc_cover', 'myCover' + counter, mc_coverHolder.getNextHighestDepth(), o);		
		
		mc_cover.onPress = function () {};
		mc_cover.useHandCursor = false;
		
		counter++;
		c = true;
	};
	
	public function removeCover (): Void 
	{
		// Swap the depth of the movie clip to a level at or below 1048575 before doing removeMovieClip(). 
		// FLASH BUG
		// Flash TechNote 19435
		// http://www.macromedia.com/cfusion/knowledgebase/index.cfm?id=tn_19435
		mc_cover.swapDepths(1048575);
		mc_cover.removeMovieClip();
		c = false;
	};
	///////////////////////////////////////////////////////////
	// getter / setter
	///////////////////////////////////////////////////////////		
	public function get covered (): Boolean 
	{
		return c;
	};		
	public function set covered (_c: Boolean ): Void 
	{
		c = _c;
	};
	
}