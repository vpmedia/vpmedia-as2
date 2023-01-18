/**
 * FTween Example - Eased Panel Resizing
 * 
 * This example demonstrates simple height/width easing using FTween as well 
 * as my StageProxy class.  
 * 
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 * 
 * Compiles in FlashDevelop. No FLA necessary. 
 * @mtasc -swf com/bumpslide/example/ftween/SpringyBox.swf -header 500:400:31:eeeedd -main 
 * @author David Knape 
 */

 import com.bumpslide.util.*;

class com.bumpslide.example.ftween.PanelTest extends com.bumpslide.core.MtascApplet
{
	/**
	* Static main entry point
	* @param	root_mc
	*/
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( PanelTest, root_mc );		
	}
	
	// our panel clips
	var panel1_mc:MovieClip;
	var panel2_mc:MovieClip;
	
	/**
	* on startup, 
	*/
	private function init() {		
		
		// don't buffer stage resize events.  let's make this smooth
		//stage.eventMode = StageProxy.PASS_THRU;
						
		createEmptyMovieClip('panel1_mc', 1);
		createEmptyMovieClip('panel2_mc', 2);
		Draw.box(panel1_mc, 10, 10, 0x333333);
		Draw.box(panel2_mc, 10, 10, 0x333333);
		updatePanels();
	}
	
	private function onStageResize() {
		clearMessage();
		message( 'Stage is now '+stage.width+' x ' + stage.height );	
		updatePanels();
	}
	
	/**
	 * The stage will be divided up horizontally 35/65%
	 * padding will be around the edges and in the middle 
	 */
	private function updatePanels() {		
		
		var padding = 40;
		
		var availableWidth  = stage.width  - padding*3; 
		var availableHeight = stage.height - padding*2;
		
		var leftWidth = Math.round( availableWidth * .35 );
		var rightWidth = availableWidth - leftWidth;
		var panelHeight = Math.round( availableHeight );
		
		panel1_mc._x = panel1_mc._y = panel2_mc._y = padding;
		
		FTween.ease( panel1_mc, ['_height', '_width'], [panelHeight, leftWidth]);
		FTween.ease( panel2_mc, ['_height', '_width', '_x'], [panelHeight, rightWidth, leftWidth+padding*2]);
	}
	
	
	
	
	
	
	
}
