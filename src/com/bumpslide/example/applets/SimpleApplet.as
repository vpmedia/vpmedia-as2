import com.bumpslide.util.*;
import com.bumpslide.core.MtascApplet;

/**
 *  Simple Applet Template Including FlashDevelop mtasc quick-build
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *  Use this as a base for creating new applets.
 * 
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/applets/SimpleApplet.swf -header 500:400:31:eeeedd -main 
 *  @author David Knape
 */

class com.bumpslide.example.applets.SimpleApplet extends MtascApplet
{	
	// gives us right-click to view source link
	var sourceUrl : String = "SimpleApplet.as";
	
	// on init show message text
	private function init() {		
		message("Hello, Flash Nerds.");		
	}
	
	// trace StageProxy dimensions on resize
	function onStageResize() {
		Debug.trace( "Stage size: "+stage.width+'x'+stage.height);
	}
	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( SimpleApplet, root_mc );		
	}
	
}
