// =========================================================================================
// Interface: EventSource_I
// 
// Ryan Taylor
// July 29, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.events.Event;

////////////////////////////////////////////////////////////////////////////////////////////

interface com.boostworthy.events.EventSource_I
{
	// =====================================================================================
	// INTERFACE DECLERATIONS
	// =====================================================================================
	
	public function AddEventListener(objScope:Object, strEventHandler:String, strEventName:String):Void
	public function RemoveEventListener(objScope:Object, strEventHandler:String, strEventName:String):Void
	public function DispatchEvent(objEvent:Event):Void
}