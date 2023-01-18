

/* ---------- 	BasicGDispatcher 1.0.0

	Name : BasicGDispatcher
	Package : eka.src.events.type
	Version : 1.0.0
	Date :  2004-09-13
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

import com.gskinner.event.* ;

class eka.src.events.type.BasicGDispatcher {

	// ----o Author Properties

	public static var className:String = "BasicGDispatcher" ;
	public static var classPackage:String = "eka.src.events.type";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Public Properties

	public function dispatchEvent(p_eventObj:Object):Void {}
	public function addEventListener(p_event:String,p_obj:Object,p_function:String):Void {}
	public function removeEventListener(p_event:String,p_obj:Object,p_function:String):Void {}
	public function eventListenerExists(p_event:String,p_obj:Object,p_function:String):Boolean { return ; }
	public function removeAllEventListeners(p_event:String):Void {} ;
	
	// ----o Static Private Properties

	static private var __initDispatcher = GDispatcher.initialize (BasicGDispatcher.prototype) ;

	// ----o Public Methods
	
	public function updateEvent(eventType:String, o):Void {
		var oE:Object = { type:eventType , target:this } ;
		if (o) for (var sP:String in o) oE[sP] = o[sP] ;
		dispatchEvent( oE ) ;
	}

}
