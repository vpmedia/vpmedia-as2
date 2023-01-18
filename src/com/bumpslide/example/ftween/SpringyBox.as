import com.bumpslide.util.*;

/**
 * FTween Example - Springy Box following mouse
 * 
 * This is a simple example of using my FTween class to tween a movie clip's position
 * to a moving target.
 * 
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 * 
 * Compiles in FlashDevelop. No FLA necessary. 
 * @mtasc -swf com/bumpslide/example/ftween/SpringyBox.swf -version 8 -header 600:400:31:eeeedd -main 
 * @author David Knape 
 */
class com.bumpslide.example.ftween.SpringyBox extends com.bumpslide.core.MtascApplet
{	
	/**
	* Static main entry point
	* @param	root_mc
	*/
	static function main(root_mc:MovieClip) {			
		ClassUtil.applyClassToObj( SpringyBox, root_mc );	
	}

	// source
	private var sourceUrl : String = "SpringyBox.as";
	
	// our box
	var box_mc:MovieClip;
	var line_mc:MovieClip;
	
	// our config options
	var BOX_SIZE = 32;
	var attraction = .08;  
	var friction = .1;		
	
	/**
	* Draw a box and center it
	*/
	private function init() 
	{		
		// create child clips
		createEmptyMovieClip('box_mc', 1);
		createEmptyMovieClip('line_mc', 2);
			
		// draw a box
		Draw.box(box_mc, BOX_SIZE, BOX_SIZE, 0x333333, 100);				
		
		// animate
		onEnterFrame = followMouse;
		
		// monitor framerate
		FramerateMonitor.display( this );		
	}
	
	/**
	 * track mouse by applying an FTween to the box_mc
	 */
	function followMouse() 
	{
		FTween.spring( box_mc, ['_x', '_y'], [_xmouse-BOX_SIZE/2, _ymouse-BOX_SIZE/2], attraction, friction );	
		showTargetLine();
	}
	
	/**
	* Draws a line from the box's current location to its target
	*/
	function showTargetLine() 
	{
		line_mc.clear();
		line_mc.lineStyle(0, 0x88aadd, 100);
		line_mc.moveTo(_xmouse, _ymouse);
		line_mc.lineTo(box_mc._x+BOX_SIZE/2, box_mc._y+BOX_SIZE/2);
	}	
}
