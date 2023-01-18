// =========================================================================================
// Class: Animation
// 
// Ryan Taylor
// August 2, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;
import com.boostworthy.animation.types.Animation_I;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.types.Animation extends BaseObject implements Animation_I
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds a reference to the object getting animated.
	private var m_objScope:Object;
	
	// Holds the property getting animated.
	private var m_strProperty:String;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	private function Animation()
	{
	}
	
	// =====================================================================================
	// UPDATE FUNCTIONS
	// =====================================================================================
	
	// Scope
	// 
	// Read-only access for the scope of the object being animated.
	public function get Scope():Object
	{
		// Return the scope.
		return m_objScope;
	}
	
	// Property
	// 
	// Read-only access for the property of the object being animated.
	public function get Property():String
	{
		// Return the property.
		return m_strProperty;
	}
	
	// =====================================================================================
	// UPDATE FUNCTIONS
	// =====================================================================================
	
	// Update
	// 
	// Returns the status of this animation.
	public function Update():Boolean
	{
		// Return 'false' by default.
		return false;
	}
}