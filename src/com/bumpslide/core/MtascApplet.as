import com.bumpslide.util.*;


 /**
 * "Quick MTASC Build" Base Class for FlashDevelop applets
 * 
 * This is a Base class that can be used to quickly build small test applets 
 * that can be compiled in FlashDevelop without the use of the Flash IDE. 
 * 
 * All you need to do is make a new class that extends this one, modify the 
 * static main function and the "@mtasc" compile setting.  Then, use the 
 * "Quick MTASC Build" command in FlashDevelop to spit out your SWF.  
 * 
 * This class automatically creates an instance of StageProxy and provides you 
 * with a couple of helper functions. 
 * 
 * Copyright (c) 2006, David Knape and contributing authors
 * Released under the open-source MIT license. See MIT_LICENSE.txt for full license terms.
 * 
 * @mtasc -swf myapplet.swf -header 500:400:31:eeeedd -main 
 * @author David Knape 
 */

class com.bumpslide.core.MtascApplet extends MovieClip {	
	
	/**
	 *  Static main entry point
	 * 
	 *  This must be copied and updated in each subclass
	 *  Mtasc is giving an error of duplicate main entry point 
	 *  unless this is commented out.  
	 *
	 *  @param	root_mc
	 */
	//static function main(root_mc:MovieClip) : Void {			
	//	ClassUtil.applyClassToObj( CLASS_NAME_GOES_HERE, root_mc );		
	//}
		
	
	/**
	 *  Test by tracing message to Luminic box
	 */
	private function onLoad() {
		//Debug.trace( '[MtascApplet] (onLoad)');
	}
	
	
	
	//--------------------------------------------------------------
	// The rest is behind the scenes stuff
	//--------------------------------------------------------------
	
	/**
	 *  Source URL
	 * 
	 *  If this is set to the download location for the applet source,
	 *  a 'View Source' option will appear in the right-click menu.
	 *  Note, you should be able to set this using flashvars.
	 */ 
	private var sourceUrl : String = null;
	
	// simple message text
	private var _message_txt : TextField;
	
	private var onStageResize : Function;
	
	/**
	 *  Constructor
	 */
	private function MtascApplet (){
		//Debug.trace('[MtascApplet] (CTOR)');
		initMenu();	
		initMessageText();
		stage.addEventListener( StageProxy.ON_RESIZE_EVENT, d(onStageResize));
		init();
	}
	
	/**
	* startup stuff
	*/
	private function init() {
			
	}
	
	/**
	 *  configure context menu and optionally allow view source
	 */ 
	private function initMenu() {
		var cm:ContextMenu = new ContextMenu();
		cm.hideBuiltInItems();			
		if(sourceUrl!=null) {
		    cm.customItems.push( new ContextMenuItem("View Source", Delegate.create( this, viewSource) ) ); 
		}
		menu = cm;	
	}
	
	
	/**
	 * create text field to hold simple debug messages
	 */
	private function initMessageText() {
		//Debug.trace('Init message text');
		createTextField('_message_txt', 9999879, 10, 10, 300, 100);
		_message_txt.setNewTextFormat( new TextFormat('Verdana', 10, 0x000000) );
		_message_txt.wordWrap = true;
		_message_txt.autoSize = true;
		_message_txt.multiline = true;
		_message_txt.condenseWhite = true;
	}
	
	private function clearMessage() {
		_message_txt.text = '';
	}
	private function message(s:String) {
		_message_txt.text += s+"\n";
	}
	
	
	/**
	 * Shortcut to stage proxy
	 * 
	 * @return stage proxy instance
	 */
	private function get stage() : StageProxy {
		return StageProxy.getInstance();
	}
	
	/**
	 *  view source url  
	 */
	private function viewSource() { 
		if(sourceUrl!=null) getURL(sourceUrl, '_blank');
	}
	
	
	/**
	* shortcut to Delegate.create with 'this' as the first param
	* @param	func
	*/ 
	private function d(func:Function) {
		var args:Array = arguments.concat();
		args.unshift(this);		
		return Delegate.create.apply( null, args );
	}
}
