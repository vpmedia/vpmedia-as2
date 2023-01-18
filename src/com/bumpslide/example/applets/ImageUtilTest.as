/**
 *  Test Applet for ImageUtil methods
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 * 
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/applets/ImageUtilTest.swf -header 500:400:31:eeeedd -main  -trace com.bumpslide.util.Debug.trace 
 *  @author David Knape
 */

import com.bumpslide.ui.Button;
import com.bumpslide.util.*;
import com.bumpslide.core.MtascApplet;

class com.bumpslide.example.applets.ImageUtilTest extends MtascApplet
{	
	// path changes depending on test context
	var IMAGE_URL_1 : String = "com/bumpslide/example/applets/sample.jpg";
	var IMAGE_URL_2 : String = "sample.jpg";
	
	var holder_mc:MovieClip;
	var image_mc:MovieClip;
	var imageLoaded:Boolean = false;	
	var q:QueuedLoader;
	
	function ImageUtilTest() {
		super();
				
		stage.minWidth = 32;
		stage.minHeight = 32;
		stage.maxWidth = 3000;
		stage.maxWidth = 3000;
		stage.eventMode =  StageProxy.PASS_THRU;
		
		createEmptyMovieClip('holder_mc', 1);
		
		q = new QueuedLoader();
		// one of these should work... :)
		q.loadItem( holder_mc.createEmptyMovieClip( 'image1_mc', 1), IMAGE_URL_1, null, onImageLoaded, this );
		q.loadItem( holder_mc.createEmptyMovieClip( 'image2_mc', 2), IMAGE_URL_2, null, onImageLoaded, this );	
	}
	
	function onImageLoaded(l,t,target) {
		// save reference to the clip that actually loaded
		image_mc = target;
		imageLoaded = true;
		stage.update();
	}
	
	function onStageResize() {
		if(!imageLoaded) return;
		clearMessage();
		ImageUtil.resizeImage( holder_mc, image_mc, stage.width, stage.height, true, true );
		Align.center( holder_mc );
		Align.middle( holder_mc );
	}
	
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( ImageUtilTest, root_mc );		
	}
	
}
