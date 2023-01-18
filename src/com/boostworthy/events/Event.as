// =========================================================================================
// Class: Event
// 
// Ryan Taylor
// July 29, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

class com.boostworthy.events.Event
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Event type constants.
	// These should be used instead of their corresponding strings to
	// ensure that the specified event type exists.
	public static var ADDED:String    = "added";
	public static var ACTIVATE:String = "activate";
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Stores the event type of this event object.
	private var m_strType:String;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function Event(strEventType:String)
	{
		// Make sure an event type was specified.
		if(strEventType != undefined)
		{
			// Set the event type.
			m_strType = strEventType;
		}
		else
		{
			// Output a message alerting the user that an event type must be specified.
			trace("Event :: Init :: ERROR -> " + this.toString() + ": An event type must be specified in the constructor.");
		}
	}
	
	// =====================================================================================
	// TYPE FUNCTIONS
	// =====================================================================================
	
	// Type
	// 
	// Getter function that grants the event type read-only access.
	public function get Type():String
	{
		// Return the event type.
		return m_strType;
	}
}