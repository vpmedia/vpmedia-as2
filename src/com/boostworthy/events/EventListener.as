// =========================================================================================
// Class: EventListener
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

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.events.EventListener extends BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds the scope of the object who contains the event handler.
	private var m_objScope:Object;
	
	// Holds the name of the function that will be called when the event occurs.
	private var m_strEventHandler:String;
	
	// Holds the name of the event that this listener is listening for.
	private var m_strEventName:String;
	
	// Holds a reference to the source of the event.
	private var m_objSource:Object;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function EventListener(objScope:Object, strEventHandler:String, strEventName:String, objSource:Object)
	{
		// Store the listener information.
		m_objScope        = objScope;
		m_strEventHandler = strEventHandler;
		m_strEventName    = strEventName;
		m_objSource       = objSource;
	}
	
	// =====================================================================================
	// GETTER FUNCTIONS
	// =====================================================================================
	
	// Scope
	// 
	// Read-only access to the object scope.
	public function get Scope():Object
	{
		// Return the object scope.
		return m_objScope;
	}
	
	// EventHandler
	// 
	// Read-only access to the event handler.
	public function get EventHandler():String
	{
		// Return the event handler.
		return m_strEventHandler;
	}
	
	// EventName
	// 
	// Read-only access to the event name.
	public function get EventName():String
	{
		// Return the name of the event.
		return m_strEventName;
	}
	
	// Source
	// 
	// Read-only access to the source of the event.
	public function get Source():Object
	{
		// Return a reference to the event source.
		return m_objSource;
	}
}