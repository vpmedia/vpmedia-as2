/**
* Template for main application class
* 
* Note: Rename 'app' to something unique to your project.
* 
* Copyright (c) 2006, David Knape and contributing authors
* Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
* 
* @author David Knape
*/
 
 
import com.bumpslide.util.*;
import com.bumpslide.data.*;
import com.mosesSupposes.fuse.*;
import org.asapframework.util.debug.*;

class app.App extends MovieClip 
{	

	// static reference to instance of this class
	static private var _instance : App;
	
	/**
	 *  Main entry point (called from timeline)
	 *  
	 *  @param	root
	 */
	static public function main( root:MovieClip ) {		
		// make _root be an instance of this class
		ClassUtil.applyClassToObj( App, root );	
	}
	
	/**
	 *  static method for finding instance of this class
	 */ 
	static public function getInstance():App {
		return _instance;
	}	
	
	/**
	 * Constructor 
	 * 
	 * private, called from static main function above
	 */	
	private function App() {

		// save instance
		_instance = this;
		
		// stop the root timeline
		stop();
		
		_focusrect = false;
	
		// init tweening engine
		ZigoEngine.simpleSetup( Shortcuts, PennerEasing );				
		ZigoEngine.AUTOSTOP = true;
		
		// disable flash player right click menu options
		var menu = new ContextMenu();
		menu.hideBuiltInItems();		
		
		// configure stage proxy
		var stage:StageProxy = StageProxy.getInstance();
		stage.maxWidth  = 3000;
		stage.maxHeight = 3000;
		stage.minWidth  = 780;
		stage.minHeight = 550;
		//stage.eventMode = StageProxy.PASS_THRU;
		stage.update();
		
		// load config or somethings, and then start
		onConfigLoaded();  // fakery
	}	

	
	// config success, start app
	function onConfigLoaded(evt:Object){

		// If in development mode, we skipped the preloader, so just start the app.
		// In production, wait for the preloader to tell us to start.
		if(_root == this) {
			gotoAndStop('start');
		}		
	}
	
}
