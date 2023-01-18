// =========================================================================================
// Class: AnimationEvent
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

class com.boostworthy.animation.events.AnimationEvent extends Event
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Event type constants.
	// These should be used instead of their corresponding strings to
	// ensure that the specified event type exists.
	public static var START:String  = "animation started";
	public static var CHANGE:String = "animation changed";
	public static var FINISH:String = "animation finished";
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds a reference to the target object getting animated.
	private var m_objTarget:Object;
	
	// Holds the property getting animated.
	private var m_strProperty:String;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function AnimationEvent(strEventType:String, objTarget:Object, strProperty:String)
	{
		// Init this object as the specified event type.
		super(strEventType);
		
		// Store information about the event.
		m_objTarget   = objTarget;
		m_strProperty = strProperty;
	}
	
	// =====================================================================================
	// GETTER FUNCTIONS
	// =====================================================================================
	
	// Target
	// 
	// Read-only access for the scope of the target object being animated.
	public function get Target():Object
	{
		// Return the target scope.
		return m_objTarget;
	}
	
	// Property
	// 
	// Read-only access for the property of the object being animated.
	public function get Property():String
	{
		// Return the target property.
		return m_strProperty;
	}
}