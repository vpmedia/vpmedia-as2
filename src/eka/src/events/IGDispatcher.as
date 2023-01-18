
/* ---------- IGDispatcher [interface]

	Name : IGDispatcher
	Package : eka.src.events
	Version : 1.0.0
	Date :  2005-04-18
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net

----------  */

interface eka.src.events.IGDispatcher {
	
	function dispatchEvent(p_eventObj:Object):Void ;
	
	function addEventListener(p_event:String,p_obj:Object,p_function:String):Void ;
	
	function removeEventListener(p_event:String,p_obj:Object,p_function:String):Void ;
	
	function eventListenerExists(p_event:String,p_obj:Object,p_function:String):Boolean ;
	
	function removeAllEventListeners(p_event:String):Void ;
	
	
}
