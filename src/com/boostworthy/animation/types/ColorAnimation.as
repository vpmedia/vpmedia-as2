// =========================================================================================
// Class: ColorAnimation
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

class com.boostworthy.animation.types.ColorAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Hold the start, target, and change in values for the property.
	private var m_nStart_R:Number,  m_nStart_G:Number,  m_nStart_B:Number;
	private var m_nTarget_R:Number, m_nTarget_G:Number, m_nTarget_B:Number;
	private var m_nChange_R:Number, m_nChange_G:Number, m_nChange_B:Number;
	
	// Sets the duration of the animation in milliseconds.
	private var m_nDuration:Number;
	
	// Holds the starting time of the animation in milliseconds.
	private var m_nStartTime:Number;
	
	// Holds a reference to the transition function being used for this animation.
	private var m_fncTransition:Function;
	
	// Holds an instance of the color object to make the target object
	// able to accept color transformations.
	private var m_objColor:Color;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function ColorAnimation(objScope:Object, strProperty:String, nTargetColor:Number, nDuration:Number, strTransition:String)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 5; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("ColorAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope      = objScope;
		m_strProperty   = strProperty;
		m_nDuration     = nDuration;
		m_fncTransition = Transitions[strTransition];
		m_objColor      = new Color(m_objScope);
		
		// Find and store the necessary color values.
		var objTrans:Object = m_objColor.getTransform();
		m_nStart_R  = objTrans.rb;
		m_nStart_G  = objTrans.gb;
		m_nStart_B  = objTrans.bb;
		m_nTarget_R = (nTargetColor >> 16) & 255;
		m_nTarget_G = (nTargetColor >> 8) & 255;
		m_nTarget_B = nTargetColor & 255;
		m_nChange_R = m_nTarget_R - m_nStart_R;
		m_nChange_G = m_nTarget_G - m_nStart_G;
		m_nChange_B = m_nTarget_B - m_nStart_B;
		
		// Get the starting time of this animation.
		m_nStartTime = getTimer();
	}
	
	// =====================================================================================
	// UPDATE FUNCTIONS
	// =====================================================================================
	
	// Update
	// 
	// Updates this animation based on time.
	public function Update():Boolean
	{
		// Declare variable(s).
		var nTime:Number, nR:Number, nG:Number, nB:Number;
		
		// Find out how long the animation has been going.
		nTime = getTimer() - m_nStartTime;
		
		// Check to see if the animation duration has been reached.
		if(nTime < m_nDuration)
		{
			// Animate the R, G, and B values.
			nR = m_fncTransition(nTime, m_nStart_R, m_nChange_R, m_nDuration);
			nG = m_fncTransition(nTime, m_nStart_G, m_nChange_G, m_nDuration);
			nB = m_fncTransition(nTime, m_nStart_B, m_nChange_B, m_nDuration);
			
			// Apply the values to the color object.
			m_objColor.setTransform({rb:nR, gb:nG, bb:nB});
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Make sure the final values are exact.
			m_objColor.setTransform({rb:m_nTarget_R, gb:m_nTarget_G, bb:m_nTarget_B});
			
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}