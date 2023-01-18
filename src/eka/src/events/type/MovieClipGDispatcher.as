
/* ---------- MovieClipGDispatcher 1.0.0

	Name : MovieClipGDispatcher
	Package : eka.src.events.type
	Version : 1.0.0
	Date :  2005-04-18
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

import com.gskinner.event.* ;

class eka.src.events.type.MovieClipGDispatcher extends MovieClip {

	// ----o Author Properties

	public static var className:String = "MovieClipGDispatcher" ;
	public static var classPackage:String = "eka.src.events.type";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Constructor
	
	private function MovieClipGDispatcher() {}

	// ----o Public Properties

	public function dispatchEvent(p_eventObj:Object):Void {}
	public function addEventListener(p_event:String,p_obj:Object,p_function:String):Void {}
	public function removeEventListener(p_event:String,p_obj:Object,p_function:String):Void {}
	public function eventListenerExists(p_event:String,p_obj:Object,p_function:String):Boolean { return ; }
	public function removeAllEventListeners(p_event:String):Void {} ;
	
	// ----o Static Private Properties

	static private var __initDispatcher = GDispatcher.initialize (MovieClipGDispatcher.prototype) ;
	
	// ----o Public Methods
	
	public function updateEvent(eventType:String, o):Void {
		var oE:Object = { type:eventType , target:this } ;
		if (o) for (var sP:String in o) oE[sP] = o[sP] ;
		dispatchEvent( oE ) ;
	}

}
