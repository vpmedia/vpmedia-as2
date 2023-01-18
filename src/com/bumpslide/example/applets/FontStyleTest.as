 import com.bumpslide.util.*;

/**
 * FontStyleTest is a simple test of using inline style sheets
 * 
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 * 
 * Compiles in FlashDevelop. No FLA necessary. 
 * @mtasc -swf com/bumpslide/example/applets/FontStyleTest.swf -header 500:400:31:eeeedd -main 
 * @author David Knape
 */
	
class com.bumpslide.example.applets.FontStyleTest extends com.bumpslide.core.MtascApplet
{
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( FontStyleTest, root_mc );		
	}
	
	// some handy stylesheet code
	private var styleSheet:TextField.StyleSheet;
		
	// CSS styles
	private var styles = "	
		p {
			fontFamily: Trebuchet MS;
			color: #333333;
			fontSize: 18;
		}
		
		.success {
			color: #333399;
			fontWeight: bold;
		}	
	";
	
	
	var text_mc:MovieClip
	
	private function init() {
		
		// smooth stage resize events...
		stage.eventMode = StageProxy.PASS_THRU;
		
		// init styles
		styleSheet = new TextField.StyleSheet();
		styleSheet.parse( styles );
		
		// create holder for text so we can center it with Align.center
		createEmptyMovieClip('text_mc', 3);		
		
		// put a text field on the stage
		text_mc.createTextField('hello_txt', 1, 0, 0, 300, 20);	
		var txt:TextField = text_mc.hello_txt;
		txt.autoSize = true;
		txt.styleSheet = styleSheet;
		txt.htmlText = '<p>If styles are working, <span class="success">this should be blue</span>.</p>';
		
		onStageResize();
	}
	
	function onStageResize() {
		Align.center( text_mc );
		Align.middle( text_mc, stage.height*.7 );	
	}	
}
