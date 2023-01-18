// =========================================================================================
// Class: BaseMovieClip
// 
// Ryan Taylor
// July 30, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.utils.TypeUtil;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.core.BaseMovieClip extends MovieClip
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// Holds a reference to this object's hit area.
	private var m_mcHitArea:MovieClip;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	private function BaseMovieClip()
	{
		// Set the default hit area.
		HitArea = this["mcHitArea"];
	}
	
	// =====================================================================================
	// BASIC FUNCTIONS
	// =====================================================================================
	
	// toString
	// 
	// Outputs this object's type in a string format.
	public function toString():String
	{
		// Return the string.
		return "[type " + TypeUtil.GetType(this) + "]";
	}
	
	// Visible
	// 
	// Getter/setters for this object's visibility.
	// The advantage to calling these over '_visible' is that additional operations
	// may occur upon changing the visibility, such as stopping the timeline playhead.
	
	public function get Visible():Boolean
	{
		// Return the current visibility state.
		return _visible;
	}
	
	public function set Visible(bVisible:Boolean):Void
	{
		// Only take action if the visibility is changing.
		if(bVisible != _visible)
		{
			// Set the visibility state.
			_visible = bVisible;
			
			// Check to see if the visibility is set to 'false'.
			if(!bVisible)
			{
				// Stop this object's timeline playhead.
				this.stop();
			}
		}
	}
	
	// HitArea
	// 
	// Getter/setters for this object's hit area.
	
	public function get HitArea():MovieClip
	{
		// Return a reference to the hit area.
		return m_mcHitArea;
	}
	
	public function set HitArea(mcHitArea:MovieClip):Void
	{
		// Store a reference to the new hit area.
		m_mcHitArea = mcHitArea;
		
		// Make sure a valid hit area was passed.
		if(m_mcHitArea)
		{
			// Set the new hit area.
			hitArea = m_mcHitArea;
			
			// Hide the new hit area.
			m_mcHitArea._visible = false;
		}
		else
		{
			// Set the hit area to 'hull' so that the entire object
			// is used as the hit area.
			hitArea = null;
		}
	}
}