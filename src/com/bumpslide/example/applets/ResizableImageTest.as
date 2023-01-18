/**
 *  Test of com.bumpslide.ui.ResizableImage
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *  Use this as a base for creating new applets.
 * 
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/applets/ResizableImageTest.swf -header 500:400:31:333333 -main 
 *  @author David Knape
 */

import com.bumpslide.util.*;
import com.bumpslide.ui.ResizableImage;
import com.bumpslide.core.MtascApplet;

class com.bumpslide.example.applets.ResizableImageTest extends MtascApplet
{	
	var border_mc:MovieClip;
	var image_mc:ResizableImage;
	
	var BORDER_WIDTH = 1;
	var PADDING = 50;
	//var imagePath =  'com/bumpslide/example/applets/';
	var imagePath =  '';
	
	var sourceUrl = "ResizableImageTest.as";
	
	private function init() 
	{		
		// make stage min size super small and allow for smooth resizes
		stage.eventMode = StageProxy.PASS_THRU;
		stage.minHeight = 100;
		stage.minWidth = 100;		
		
		// create border
		createEmptyMovieClip('border_mc', 1);
		
		// create resizable image
		image_mc = ResizableImage.create( 'image_mc', this );
		image_mc.addEventListener( ResizableImage.EVENT_IMAGE_LOADED, this );
		
		image_mc.loadImage( imagePath + 'sample.jpg' );
		onMouseDown = toggleSmoothing;
		
		// use white for message text
		_message_txt.textColor = 0xffffff;
		
		message('Click to toggle smoothing.');
	}
	
	function toggleSmoothing() {		
		image_mc.applySmoothing = !image_mc.applySmoothing;
		clearMessage();
		message("Smoothing is " + (image_mc.applySmoothing ? "ON" : "OFF") );
	}
	
	function onImageLoaded() {
		stage.update();
	}
	
	function onStageResize() {
		image_mc.setSize( stage.width-BORDER_WIDTH*2-PADDING*2, stage.height-BORDER_WIDTH*2-PADDING*2);
		Align.middle( image_mc );
		Align.center( image_mc );
		
		border_mc.clear();
		Draw.box( border_mc, image_mc.width + BORDER_WIDTH*2, image_mc.height + BORDER_WIDTH*2, 0xffffff, 100 );
		border_mc._x = image_mc._x - BORDER_WIDTH;
		border_mc._y = image_mc._y - BORDER_WIDTH;
		
	}
	
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( ResizableImageTest, root_mc );		
	}
	
}
