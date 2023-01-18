// =========================================================================================
// Class: PulseAnimation
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

import com.boostworthy.animation.types.Animation;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.types.PulseAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Set the minimum and maximum values output by the pulse.
	private var m_nMin:Number, m_nMax:Number;
	
	// Sets the duration of the pulse in milliseconds.
	private var m_nDuration:Number;
	
	// Holds the starting time of the animation in milliseconds.
	private var m_nStartTime:Number;
	
	// Holds the distance between the min/max and the median.
	private var m_nValue:Number;
	
	// The median value of the min/max.
	private var m_nMedian:Number;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function PulseAnimation(objScope:Object, strProperty:String, nMin:Number, nMax:Number, nDuration:Number)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 5; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("PulseAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope    = objScope;
		m_strProperty = strProperty;
		m_nMin        = nMin;
		m_nMax        = nMax;
		m_nDuration   = nDuration;
		
		// Find and store the remaing necessary data.
		m_nValue      = (m_nMax - m_nMin) / 2;
		m_nMedian     = m_nMin + m_nValue;
		m_nStartTime  = getTimer();
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
		
		// Pulse the property.
		m_objScope[m_strProperty] = m_nMedian + (Math.cos((nTime / m_nDuration) * (Math.PI * 2)) * m_nValue);
			
		// Return 'true' indicating that the object was updated.
		return true;
	}
}