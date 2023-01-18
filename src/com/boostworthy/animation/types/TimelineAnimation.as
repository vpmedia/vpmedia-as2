// =========================================================================================
// Class: TimelineAnimation
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

class com.boostworthy.animation.types.TimelineAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds the target frame.
	private var m_nTargetFrame:Number;
	
	// Holds either a -1 or 1 depending on which direction on the timeline
	// the playhead must move to get to the target frame.
	private var m_nDirection:Number;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function TimelineAnimation(objScope:Object, strProperty:String, nTargetFrame:Number)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 3; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("TimelineAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope     = objScope;
		m_strProperty  = strProperty;
		m_nTargetFrame = nTargetFrame;
		
		// Find the direction the playhead needs to move.
		m_nDirection   = (m_objScope["_currentframe"] < m_nTargetFrame) ? 1 : -1;
	}
	
	// =====================================================================================
	// UPDATE FUNCTIONS
	// =====================================================================================
	
	// Update
	// 
	// Updates this animation based on time.
	public function Update():Boolean
	{
		// Find out which frame the playhead is currently on.
		var nCurrentFrame:Number = m_objScope["_currentframe"];
		
		// Check to see if the playhead has reached the target frame yet.
		if(nCurrentFrame != m_nTargetFrame)
		{
			// Move the playhead over one frame in the direction of the target frame.
			m_objScope.gotoAndStop(nCurrentFrame + m_nDirection);
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}