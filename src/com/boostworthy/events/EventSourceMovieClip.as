// =========================================================================================
// Class: EventSourceMovieClip
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

import com.boostworthy.core.BaseMovieClip;
import com.boostworthy.events.EventSource_I;
import com.boostworthy.events.EventDispatcher;
import com.boostworthy.events.Event;
import com.boostworthy.utils.FunctionUtil;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.events.EventSourceMovieClip extends BaseMovieClip implements EventSource_I
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// An event dispatcher instance to use through composition.
	private var m_objDispatcher:EventDispatcher;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	private function EventSourceMovieClip()
	{
		// Create a new event dispatcher instance.
		m_objDispatcher = new EventDispatcher(this);
	}
	
	// =====================================================================================
	// SOURCE FUNCTIONS
	// =====================================================================================
	
	// Event Source Functions
	// 
	// These will be overriden by the event dispatcher during init.
	
	public function AddEventListener(objScope:Object, strEventHandler:String, strEventName:String):Void
	{
		// Add the event listener.
		m_objDispatcher.AddEventListener(objScope, strEventHandler, strEventName);
	}
	
	public function RemoveEventListener(objScope:Object, strEventHandler:String, strEventName:String):Void
	{
		// Remove the event listener.
		m_objDispatcher.RemoveEventListener(objScope, strEventHandler, strEventName)
	}
	
	public function DispatchEvent(objEvent:Event):Void
	{
		// Dispatch the event.
		m_objDispatcher.DispatchEvent(objEvent);
	}
}