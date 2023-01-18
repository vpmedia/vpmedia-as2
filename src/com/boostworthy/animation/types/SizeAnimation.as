// =========================================================================================
// Class: SizeAnimation
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
import com.boostworthy.animation.Transitions;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.types.SizeAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Hold the start, target, and change in value for the properties.
	private var m_nStartValue_W:Number, m_nTargetValue_W:Number, m_nChangeValue_W:Number;
	private var m_nStartValue_H:Number, m_nTargetValue_H:Number, m_nChangeValue_H:Number;
	
	// Sets the duration of the animation in milliseconds.
	private var m_nDuration:Number;
	
	// Holds the starting time of the animation in milliseconds.
	private var m_nStartTime:Number;
	
	// Holds a reference to the transition function being used for this animation.
	private var m_fncTransition:Function;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function SizeAnimation(mcScope:MovieClip, nTargetValueW:Number, nTargetValueH:Number, nDuration:Number, strTransition:String)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 5; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("SizeAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope       = mcScope;
		m_strProperty    = "size";
		m_nTargetValue_W = nTargetValueW;
		m_nTargetValue_H = nTargetValueH;
		m_nDuration      = nDuration;
		
		// Find and store the remaing necessary data.
		m_fncTransition  = Transitions[strTransition];
		m_nStartValue_W  = m_objScope._width;
		m_nStartValue_H  = m_objScope._height;
		m_nChangeValue_W = m_nTargetValue_W - m_nStartValue_W;
		m_nChangeValue_H = m_nTargetValue_H - m_nStartValue_H;
		m_nStartTime     = getTimer();
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
			// Animate the object's properties.
			m_objScope._width  = m_fncTransition(nTime, m_nStartValue_W, m_nChangeValue_W, m_nDuration);
			m_objScope._height = m_fncTransition(nTime, m_nStartValue_H, m_nChangeValue_H, m_nDuration);
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Set the object's properties to the exact target value.
			m_objScope._width  = m_nTargetValue_W;
			m_objScope._height = m_nTargetValue_H;
			
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}