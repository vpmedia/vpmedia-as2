/**
* Alignment utilities
* 
* When designing resizable apps, it is often the case that movie clips need 
* to be programmatically aligned and/or centered.  The static methods in this
* class take care of the math involved in many of these cases.  When used on their
* own, they are handy.  When used in conjunction with StageProxy, they are stellar.
* 
* StageProxy is a singleton that proxies Stage.onResize events and can be used to 
* maintain min and max stage dimensions.  By default, the stageProxy's height and 
* width properties are used as the default value for the containerSize in these 
* methods.
* 
* The methods also assume that the 0,0 registration point on the to-be-aligned 
* clip is in the top-left corner.  If this is not the case, you can compensate
* by adjusting the clipSize, or just do the calculation by hand.
* 
* @author David Knape
*/

import com.bumpslide.util.StageProxy;

class com.bumpslide.util.Align
{
	
	/**
	* Right-aligns a clip
	* 
	* Example Usage: 
	*   Align.right( mymenu_mc );
	* 
	* @param	clip
	* @param	containerSize
	* @param	clipSize
	*/
	static public function right(clip:MovieClip, containerSize:Number, clipSize:Number) : Void { 		
		if(containerSize==null) containerSize = StageProxy.getInstance().width;
		if(clipSize==null) clipSize = clip._width;	
		
		clip._x = Math.round( containerSize - clipSize );		
	}	
	
	/**
	* Centers a clip horizontally
	* 
	* Example Usage: 
	*   Align.center( mymenu_mc );
	* 
	* @param	clip
	* @param	containerSize
	* @param	clipSize
	*/
	static public function center( clip:MovieClip, containerSize:Number, clipSize:Number ) : Void {	
		if(containerSize==null) containerSize = StageProxy.getInstance().width;
		if(clipSize==null) clipSize = clip._width;	
		
		clip._x = Math.round( (containerSize-clipSize) / 2);
	}
	
	
	/**
	* Centers a clip vertically 
	* 
	* Example Usage: 
	*   Align.middle( mymenu_mc );
	* 
	* @param	clip
	* @param	containerSize
	* @param	clipSize
	*/
	static public function middle( clip:MovieClip, containerSize:Number, clipSize:Number ) : Void {	
		if(containerSize==null) containerSize = StageProxy.getInstance().height;
		if(clipSize==null) clipSize = clip._height;	
		
		clip._y = Math.round( (containerSize-clipSize) / 2);
	}
	
	/**
	* Aligns a clip with the bottom of a container
	* 
	* Example Usage: 
	*   Align.bottom( mymenu_mc );
	* 
	* @param	clip
	* @param	containerSize
	* @param	clipSize
	*/
	static public function bottom( clip:MovieClip, containerSize:Number, clipSize:Number ) : Void {	
		if(containerSize==null) containerSize = StageProxy.getInstance().height;
		if(clipSize==null) clipSize = clip._height;	
		
		clip._y = Math.round(containerSize-clipSize);
	}	
	
	/**
	* Stacks movie clips as if they are in a VBox 
	* 
	* MovieClip height is pulled from a setter (height) if found. 
	* Otherwise, positions are calulated based on getBounds results.
	* 
	* @param	clips
	* @param	padding
	*/
	static public function vbox( clips:Array, padding:Number ) : Void {
		if(padding==null) padding = 0;
		var count = clips.length;
		if(count<2) return;		
			
		// calculate starting position
		var yPos:Number;
		var mc = clips[0];	
		if(mc.height!=null) {
			yPos = mc._y + mc.height + padding;
		} else {
			yPos = mc.getBounds( mc._parent ).yMax + padding;
		}
		//trace('[vbox] starting y position = ' + yPos );
		for(var n=1; n<count; ++n) {
			mc = clips[n];
			if(mc._visible==false) continue;
						
			// use 'height' getter if found
			if(mc.height!=null) {
				
				// using 'height', and assuming top at _y=0 (no bounds checking)
				mc._y = Math.round( yPos );
				yPos += mc.height + padding;
				
			} else {
				
				// using getBounds to determing height and y position
				mc._y = Math.round( yPos + mc._y - mc.getBounds( mc._parent ).yMin );	
				yPos = mc.getBounds( mc._parent ).yMax + padding;
				
			}
			//trace('[vbox] (clip '+n+') '+mc._name+'._y = ' + mc._y );	
			//trace('[vbox] y position = ' + yPos );
		}		
	}
	
	/**
	* arranges movie clips in a row as if they are in a HBox 
	* 
	* @param	clips
	* @param	padding
	*/
	static public function hbox( clips:Array, padding:Number ) : Void {
		if(padding==null) padding = 0;
		var count = clips.length;
		if(count<2) return;		
		var xPos:Number = clips[0].getBounds( clips[0]._parent ).xMax + padding;	
		for(var n=1; n<count; ++n) {
			var mc = clips[n];
			if(mc._visible==false) continue;
			mc._x = Math.round( xPos + mc._x - mc.getBounds( mc._parent ).xMin);		
			xPos = mc.getBounds( mc._parent ).xMax + padding;
		}		
	}
		
	/**
	* Private Constructor
	*/
	private function Align(){}
}
