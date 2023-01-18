/**
 * A simple class to handle creating rectangular masks
 * 
 * @author Patrick Mineault
 * @version 1.0 Sat Jan 15 02:01:01 2005
 */
 class com.cetdemi.Timeline.Mask extends MovieClip
 {
	/**
	* Reference to the mask movieclip
	*/
	var mc:MovieClip;

	/**
	* Constructor
	* 
	* @param root A reference to the root of the timeline
	* @param target The target of the mask
	* @param The level in which to create the mask
	*/
	function Mask(root:MovieClip, target:String, level:Number)	{
		mc = root.createEmptyMovieClip(target + 'Mask', level);
		root[target].setMask(mc);
	}
	
	/**
	* Draws the rectangle to be used at a mask
	* 
	* @param obj An object containing x,y,w and h parameters that specify the bounds of the rectangle
	*/
	function drawRectangle(obj:Object)
	{
		with(mc)
		{
			beginFill(0x000000);
			moveTo(obj.x, obj.y);
			lineTo(obj.x + obj.w, obj.y);
			lineTo(obj.x + obj.w, obj.y + obj.h);
			lineTo(obj.x, obj.y + obj.h);
			endFill();
		}
	}
}