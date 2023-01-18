// =========================================================================================
// Class: Tween
// 
// Ryan Taylor
// February 3, 2007
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;
import com.boostworthy.animation.tweens.Tween_I;
import com.boostworthy.animation.Transitions;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.tweens.Tween extends BaseObject implements Tween_I
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Default values.
	private static var DEFAULT_TRANSITION:String = Transitions.LINEAR;
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// A reference to the object to be tweened.
	private var m_objToTween:Object;
	
	// The object's property that is getting tweened.
	private var m_strProperty:String;
	
	// Holds the first and last frame numbers.
	private var m_nFirstFrame:Number, m_nLastFrame:Number;
	
	// Hold the start, target, and change in the properties value.
	private var m_nStartValue:Number, m_nTargetValue:Number, m_nChangeValue:Number;
	
	// Holds the transitions string constant for referencing the transition method.
	private var m_strTransition:String;
	
	// Holds a reference to the transition method being used for this tween.
	private var m_fncTransition:Function;
	
	// Determines whether or not this tween has changed and needs compared towards
	// it's target value again.
	private var m_bIsDirty:Boolean;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function Tween(objToTween:Object, strProperty:String, nTargetValue:Number, nFirstFrame:Number, nLastFrame:Number, strTransition:String)
	{
		// Store the necessary information for this tween.
		m_objToTween    = objToTween;
		m_strProperty   = strProperty;
		m_nTargetValue  = nTargetValue;
		m_nFirstFrame   = nFirstFrame;
		m_nLastFrame    = nLastFrame;
		m_strTransition = strTransition;
		m_fncTransition = Transitions[m_strTransition];
	}
	
	// =====================================================================================
	// TWEEN FUNCTIONS
	// =====================================================================================
	
	// Clone
	// 
	// Returns a new tween object that is a clone of this object.
	public function Clone():Tween_I
	{
		// Return a new tween object.
		return new Tween(m_objToTween, m_strProperty, m_nTargetValue, m_nFirstFrame, m_nLastFrame, m_strTransition);
	}
	
	// RenderFrame
	// 
	// Renders the specified frame of this tween.
	public function RenderFrame(nFrame:Number):Void
	{
		// Check to see if the frame is before the first frame of this tween and
		// whether or not a starting value has been stored.
		if(nFrame < m_nFirstFrame && m_nStartValue != null)
		{
			// Set the object's property back to it's starting value.
			m_objToTween[m_strProperty] = m_nStartValue;
			
			// Mark this tween as being dirty.
			m_bIsDirty = true;
		}
		// Check to see if the frame is within the frames of this tween.
		else if(nFrame >= m_nFirstFrame && nFrame <= m_nLastFrame)
		{
			// Calculate the amount of time passed during this tween based on the frames.
			var nTime:Number = (nFrame - m_nFirstFrame) / (m_nLastFrame - m_nFirstFrame);
			
			// Check to see if a starting value has been set yet.
			if(m_nStartValue == null && nFrame == m_nFirstFrame)
			{
				// Store the starting value.
				m_nStartValue = m_objToTween[m_strProperty];
				
				// Calculate the change in value.
				m_nChangeValue = m_nTargetValue - m_nStartValue;
			}
				
			// Tween the object's property based on the time.
			m_objToTween[m_strProperty] = m_fncTransition(nTime, m_nStartValue, m_nChangeValue, 1);
			
			// Mark this tween as being dirty.
			m_bIsDirty = true;
		}
		// Check to see if the current frame is beyond the last from on this tween.
		else if(nFrame > m_nLastFrame && m_bIsDirty)
		{
			// Set the object's property to it's target value.
			m_objToTween[m_strProperty] = m_nTargetValue;
			
			// Mark this tween as being not dirty.
			m_bIsDirty = false;
		}
	}
	
	// GetFirstFrame
	// 
	// Gets this tween's first frame number.
	public function GetFirstFrame():Number
	{
		// Return the frame number.
		return m_nFirstFrame;
	}

	// GetLastFrame
	// 
	// Gets this tween's last frame number.
	public function GetLastFrame():Number
	{
		// Return the frame number.
		return m_nLastFrame;
	}
}