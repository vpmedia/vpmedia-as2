

/* ---------- 	ArrayGDispatcher 1.0.0

	Name : ArrayGDispatcher
	Package : eka.src.events.type
	Version : 1.0.0
	Date :  2005-02-09
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

import com.gskinner.event.* ;

class eka.src.events.type.ArrayGDispatcher extends Array {

	// ----o Author Properties

	public static var className:String = "ArrayGDispatcher" ;
	public static var classPackage:String = "eka.src.events.type";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Init GDispatcher Methods

	static private var __initDispatcher = GDispatcher.initialize (ArrayGDispatcher.prototype) ;

	// ----o Public Properties

	public function dispatchEvent(p_eventObj:Object):Void {}
	public function addEventListener(p_event:String,p_obj:Object,p_function:String):Void {}
	public function removeEventListener(p_event:String,p_obj:Object,p_function:String):Void {}
	public function eventListenerExists(p_event:String,p_obj:Object,p_function:String):Boolean { return ; }
	public function removeAllEventListeners(p_event:String):Void {} ;
	
	// ----o Constructor
	
	function ArrayGDispatcher () {
		splice.apply(this, [0, 0].concat(arguments));
	}
	
	// ----o Public Methods
	
	public function updateEvent(eventType:String, o):Void {
		var oE:Object = { type:eventType , target:this } ;
		if (o) for (var sP:String in o) oE[sP] = o[sP] ;
		dispatchEvent( oE ) ;
	}

}
