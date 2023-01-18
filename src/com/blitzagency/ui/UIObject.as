/**
* @author Patrick Matte
* last revision January 30th 2006
*/

import mx.events.EventDispatcher;

class com.blitzagency.ui.UIObject extends MovieClip{
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;

	public function UIObject(){
		EventDispatcher.initialize(this);
	}

}