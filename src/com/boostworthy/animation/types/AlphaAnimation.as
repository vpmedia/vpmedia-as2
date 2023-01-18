// =========================================================================================
// Class: AlphaAnimation
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

import com.boostworthy.animation.types.PropertyAnimation;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.types.AlphaAnimation extends PropertyAnimation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function AlphaAnimation(objScope:Object, strProperty:String, nTargetValue:Number, nDuration:Number, strTransition:String)
	{
		// Pass the parameters along to this object's superclass to be set and stored.
		super(objScope, strProperty, nTargetValue, nDuration, strTransition);
		
		// Set this object's visibility to 'true'.
		objScope._visible = true;
	}
	
	// =====================================================================================
	// UPDATE FUNCTIONS
	// =====================================================================================
	
	// Update
	// 
	// Updates this animation based on time.
	public function Update():Boolean
	{
		// Find out how long the animation has been going.
		var nTime:Number = getTimer() - m_nStartTime;
		
		// Check to see if the animation duration has been reached.
		if(nTime < m_nDuration)
		{
			// Animate the object's property.
			m_objScope._alpha = m_fncTransition(nTime, m_nStartValue, m_nChangeValue, m_nDuration);
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Set the object's property to the exact target value.
			m_objScope._alpha = m_nTargetValue;
			
			// Check to see if the alpha property is equal to '0'.
			if(m_objScope._alpha == 0)
			{
				// Shut off the visibilty of this object.
				// There are two benefits to this. First off, it disables it; meaning it cannot
				// recieve mouse events, etc. Secondly, and more importantly, it take it off the 
				// processor load. This will lead to much greater performance when hiding objects.
				m_objScope._visible = false;
			}
			
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}