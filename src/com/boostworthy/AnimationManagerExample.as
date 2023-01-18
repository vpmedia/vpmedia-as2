// =========================================================================================
// Class: AnimationManagerExample
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
import com.boostworthy.animation.AnimationManager;
import com.boostworthy.animation.Transitions;
import com.boostworthy.animation.events.AnimationEvent;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.AnimationManagerExample extends BaseMovieClip
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds an instance of the animation manager.
	private var m_objAnimManager:AnimationManager;
	
	// The box movie clip instance on the stage.
	private var m_mcBox:MovieClip;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function AnimationManagerExample()
	{
		// Create a new instance of the animation manager.
		m_objAnimManager = new AnimationManager();
		
		// Uncomment these to sample event usage.
		/*
		// Add event listeners for the animation events.
		m_objAnimManager.AddEventListener(this, "OnAnimEvent", AnimationEvent.START);
		m_objAnimManager.AddEventListener(this, "OnAnimEvent", AnimationEvent.CHANGE);
		m_objAnimManager.AddEventListener(this, "OnAnimEvent", AnimationEvent.FINISH);
		*/

		// Use the 'InitColor' method to initially set the starting color of
		// a movie clip before you animate it's color.
		m_objAnimManager.InitColor(m_mcBox, 0x166EAD);
		
		// Delegate the mouse down event handler.
		onMouseDown = AnimateBox;
	}
	
	// OnAnimEvent
	// 
	// Called when an animation event is dispatched by the animation manager.
	private function OnAnimEvent(objEvent:AnimationEvent):Void
	{
		// Trace out information about the animation event.
		trace(objEvent.Type + " -> " + objEvent.Target + ", " + objEvent.Property);
	}
	
	// =====================================================================================
	// ANIMATION FUNCTIONS
	// =====================================================================================
	
	// AnimateBox
	// 
	// Animates the box.
	public function AnimateBox():Void
	{
		// Below are some examples of different methods available. To see all
		// methods, open AnimationManager.as to browse the selection and see the
		// necessary parameters.
		
		m_objAnimManager.Move(m_mcBox, _xmouse, _ymouse, 500, Transitions.QUINT_OUT);
		
		// On these next two, an additional, optional parameter 'delay' is passed.
		// It is the time in milliseconds to delay the start of the animation.
		
		m_objAnimManager.Scale(m_mcBox, Math.random() * 200, Math.random() * 200, 500, Transitions.QUINT_OUT, 1000);
		
		m_objAnimManager.ColorFade(m_mcBox, 0x336666, 500, Transitions.QUINT_OUT, 1000);
	}
}