// =========================================================================================
// Class: EventDispatcher
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

import com.boostworthy.core.BaseObject;
import com.boostworthy.events.EventSource_I;
import com.boostworthy.events.EventListener;
import com.boostworthy.events.Event;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.events.EventDispatcher extends BaseObject implements EventSource_I
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// The event queue will hold all the events.
	private var m_aEventQueue:Array;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// This is a static class and therefore the constructor is private.
	public function EventDispatcher()
	{
		// Create a new event queue.
		m_aEventQueue = new Array();
	}
	
	// =====================================================================================
	// QUEUE FUNCTIONS
	// =====================================================================================
	
	// AddEventListener
	// 
	// Adds an event and it's handler to the event queue.
	public function AddEventListener(objScope:Object, strEventHandler:String, strEventName:String):Void
	{
		// Validate the parameters to ensure that a legit entry is entered into the event queue.
		if(objScope != undefined && strEventHandler != undefined && strEventName != undefined)
		{
			// Check the queue for the event and handler.
			if(GetQueueID(objScope, strEventHandler, strEventName) == null)
			{
				// Since an entry does not currently exist for the event and handler, add a new 
				// entry into the queue.
				m_aEventQueue.push(new EventListener(objScope, strEventHandler, strEventName, this));
			}
			else
			{
				// Output a message alerting the user that an entry for that event and handler
				// alreadt exist in the queue.
				trace("EventDispatcher :: AddEventListener :: WARNING -> The event '" + strEventName + "' is already registered to the '" + strEventHandler + "' handler and will not be added again.");
			}
		}
		else
		{
			// Output a message alerting the user that this method was used incorrectly.
			trace("EventDispatcher :: AddEventListener :: ERROR -> Three parameters required: [objScope:Object, strEventHandler:String, strEventName:String].");
		}
	}
	
	// RemoveEventListener
	// 
	// Removes an event for the given handler from the queue.
	public function RemoveEventListener(objScope:Object, strEventHandler:String, strEventName:String):Void
	{
		// Get the queue ID for the requested entry.
		var nEventQueueID:Number = GetQueueID(objScope, strEventHandler, strEventName);
		
		// Make sure a valid queue ID was returned.
		if(nEventQueueID != null)
		{
			// Remove the entry from the queue.
			m_aEventQueue.splice(nEventQueueID, 1);
		}
		else
		{
			// Output a message alerting the user that an entry for that event and handler
			// does not exist in the queue.
			trace("EventDispatcher :: RemoveEventListener :: WARNING -> The event '" + strEventName + "' and  '" + strEventHandler + "' handler do not exist in the event queue.");
		}
	}
	
	// GetQueueID
	// 
	// Checks the event queue for an entry with the given event
	// and handler. Returns the queue ID if an entry exists, otherwise
	// returns null.
	private function GetQueueID(objScope:Object, strEventHandler:String, strEventName:String):Number
	{
		// Loop through the event queue.
		for(var i:Number = 0; i < m_aEventQueue.length; i++)
		{
			// Get the queue entry.
			var objEntry:EventListener = m_aEventQueue[i];
			
			// Check for a matching entry.
			if(objEntry.Scope == objScope && objEntry.EventHandler == strEventHandler && objEntry.EventName == strEventName)
			{
				// Return the queue ID of the entry.
				return i;
			}
		}
		
		// Return 'null' indicating that an entry for the given event
		// and handler does not currently exist in the event queue.
		return null;
	}
	
	// =====================================================================================
	// DISPATCH FUNCTIONS
	// =====================================================================================
	
	// DispatchEvent
	// 
	// Dispatches the passed event object to all handlers in the queue
	// associated with the event type.
	public function DispatchEvent(objEvent:Event):Void
	{
		// Make a local copy of the queue list incase it changes during
		// this process.
		var aEventQueue:Array = m_aEventQueue.concat();
		
		// Loop through the event queue.
		for(var i:Number = 0; i < aEventQueue.length; i++)
		{
			// Get the queue entry.
			var objEntry:EventListener = aEventQueue[i];
			
			// Check the entry for the event type being dispatched.
			//if(objEntry.EventName == objEvent.Type && objEntry.Source == this)
			if(objEntry.EventName == objEvent.Type)
			{
				// Dispatch the event to the corresponding handler.
				objEntry.Scope[objEntry.EventHandler](objEvent);
			}
		}
	}
}