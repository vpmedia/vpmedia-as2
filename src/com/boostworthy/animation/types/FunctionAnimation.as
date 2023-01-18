// =========================================================================================
// Class: FunctionAnimation
// 
// Ryan Taylor
// October 8, 2006
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

class com.boostworthy.animation.types.FunctionAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Hold the getter and setter function names.
	private var m_strGetFunction:String, m_strSetFunction:String;
	
	// Hold the start, target, and change in value for the property.
	private var m_nStartValue:Number, m_nTargetValue:Number, m_nChangeValue:Number;
	
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
	public function FunctionAnimation(objScope:Object, strGetFunction:String, strSetFunction:String, nTargetValue:Number, nDuration:Number, strTransition:String)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 6; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("FunctionAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope       = objScope;
		m_strProperty    = strGetFunction;
		m_strGetFunction = strGetFunction;
		m_strSetFunction = strSetFunction;
		m_nTargetValue   = nTargetValue;
		m_nDuration      = nDuration;
		
		// Find and store the remaing necessary data.
		m_fncTransition  = Transitions[strTransition];
		m_nStartValue    = m_objScope[m_strGetFunction]();
		m_nChangeValue   = m_nTargetValue - m_nStartValue;
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
			// Animate the object's getter/setter value.
			m_objScope[m_strSetFunction](m_fncTransition(nTime, m_nStartValue, m_nChangeValue, m_nDuration));
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Set the object's getter/setter value to the exact target value.
			m_objScope[m_strSetFunction](m_nTargetValue);
			
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}