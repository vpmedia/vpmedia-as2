// =========================================================================================
// Class: MoveAnimation
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

class com.boostworthy.animation.types.MoveAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Hold the start, target, and change in value for the properties.
	private var m_nStartValue_X:Number, m_nTargetValue_X:Number, m_nChangeValue_X:Number;
	private var m_nStartValue_Y:Number, m_nTargetValue_Y:Number, m_nChangeValue_Y:Number;
	
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
	public function MoveAnimation(mcScope:MovieClip, nTargetValueX:Number, nTargetValueY:Number, nDuration:Number, strTransition:String)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 5; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("MoveAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope       = mcScope;
		m_strProperty    = "move";
		m_nTargetValue_X = nTargetValueX;
		m_nTargetValue_Y = nTargetValueY;
		m_nDuration      = nDuration;
		
		// Find and store the remaing necessary data.
		m_fncTransition  = Transitions[strTransition];
		m_nStartValue_X  = m_objScope._x;
		m_nStartValue_Y  = m_objScope._y;
		m_nChangeValue_X = m_nTargetValue_X - m_nStartValue_X;
		m_nChangeValue_Y = m_nTargetValue_Y - m_nStartValue_Y;
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
			m_objScope._x = m_fncTransition(nTime, m_nStartValue_X, m_nChangeValue_X, m_nDuration);
			m_objScope._y = m_fncTransition(nTime, m_nStartValue_Y, m_nChangeValue_Y, m_nDuration);
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Set the object's properties to the exact target value.
			m_objScope._x = m_nTargetValue_X;
			m_objScope._y = m_nTargetValue_Y;
			
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}