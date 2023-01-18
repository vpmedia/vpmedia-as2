// =========================================================================================
// Class: VirtualTimelineExample
// 
// Ryan Taylor
// March 23, 2007
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseMovieClip;
import com.boostworthy.animation.Timeline;
import com.boostworthy.animation.tweens.Tween;
import com.boostworthy.animation.tweens.Tween_I;
import com.boostworthy.animation.Transitions;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.VirtualTimelineExample extends BaseMovieClip
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds an instance of the timeline object for the example animation.
	private var m_objTimeline:Timeline;
	
	// The box movie clip instance on the stage.
	private var m_mcBox:MovieClip;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function VirtualTimelineExample()
	{
		// Create the example animation.
		CreateAnimation();
		
		// Delegate the mouse event handlers.
		onMouseDown = PlayTimelineForwards;
		onMouseUp   = PlayTimelineBackwards;
	}
	
	// =====================================================================================
	// ANIMATION FUNCTIONS
	// =====================================================================================
	
	// CreateAnimation
	// 
	// Creates a new virtual timeline animation.
	private function CreateAnimation():Void
	{
		// Create a new timeline object.
		// The parameter '60' is the frames per second you would like the timeline
		// to play at. '60' also happens to be the default value if nothing is passed,
		// but I wanted to pass it as an example.
		m_objTimeline = new Timeline(60);

		// Create a series of tween objects.
		// When they are added to a timeline, they are cloned and then added, so you can
		// create these seperately and add them to multiple timeline objects if you wanted to.
		var objTween_1:Tween_I  = new Tween(m_mcBox, "_x",         400, 1,   60,  Transitions.SINE_IN_AND_OUT);
		var objTween_2:Tween_I  = new Tween(m_mcBox, "_y",         140, 40,  80,  Transitions.SINE_IN_AND_OUT);
		var objTween_3:Tween_I  = new Tween(m_mcBox, "_rotation", -180, 40,  80,  Transitions.SINE_IN_AND_OUT);
		var objTween_4:Tween_I  = new Tween(m_mcBox, "_x",         60,  61,  120, Transitions.SINE_IN_AND_OUT);
		var objTween_5:Tween_I  = new Tween(m_mcBox, "_y",         90,  100, 140, Transitions.SINE_IN_AND_OUT);
		var objTween_6:Tween_I  = new Tween(m_mcBox, "_rotation",  0,   100, 140, Transitions.SINE_IN_AND_OUT);
		var objTween_7:Tween_I  = new Tween(m_mcBox, "_x",         400, 121, 180, Transitions.SINE_IN_AND_OUT);
		var objTween_8:Tween_I  = new Tween(m_mcBox, "_y",         350, 160, 220, Transitions.SINE_IN_AND_OUT);
		var objTween_9:Tween_I  = new Tween(m_mcBox, "_rotation",  90,  150, 190, Transitions.SINE_IN_AND_OUT);
		var objTween_10:Tween_I = new Tween(m_mcBox, "_rotation",  180, 191, 230, Transitions.SINE_IN_AND_OUT);
		var objTween_11:Tween_I = new Tween(m_mcBox, "_x",         60,  191, 270, Transitions.SINE_IN_AND_OUT);
		var objTween_12:Tween_I = new Tween(m_mcBox, "_xscale",    50,  191, 230, Transitions.SINE_IN_AND_OUT);
		var objTween_13:Tween_I = new Tween(m_mcBox, "_yscale",    50,  191, 230, Transitions.SINE_IN_AND_OUT);
		var objTween_14:Tween_I = new Tween(m_mcBox, "_xscale",    100, 231, 270, Transitions.SINE_IN_AND_OUT);
		var objTween_15:Tween_I = new Tween(m_mcBox, "_yscale",    100, 231, 270, Transitions.SINE_IN_AND_OUT);

		// Add each tween to the timeline object.
		m_objTimeline.AddTween(objTween_1);
		m_objTimeline.AddTween(objTween_2);
		m_objTimeline.AddTween(objTween_3);
		m_objTimeline.AddTween(objTween_4);
		m_objTimeline.AddTween(objTween_5);
		m_objTimeline.AddTween(objTween_6);
		m_objTimeline.AddTween(objTween_7);
		m_objTimeline.AddTween(objTween_8);
		m_objTimeline.AddTween(objTween_9);
		m_objTimeline.AddTween(objTween_10);
		m_objTimeline.AddTween(objTween_11);
		m_objTimeline.AddTween(objTween_12);
		m_objTimeline.AddTween(objTween_13);
		m_objTimeline.AddTween(objTween_14);
		m_objTimeline.AddTween(objTween_15);
	}
	
	// PlayTimelineForwards
	// 
	// Plays the virtual timeline forwards.
	public function PlayTimelineForwards():Void
	{
		// Play the timeline.
		m_objTimeline.Play();
	}
	
	// PlayTimelineBackwards
	// 
	// Plays the virtual timelline backwards.
	public function PlayTimelineBackwards():Void
	{
		// Play the timeline in reverse.
		m_objTimeline.PlayReverse();
	}
}