// =========================================================================================
// Class: AnimationManager
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

import com.boostworthy.events.EventSourceObject;
import com.boostworthy.animation.Renderer;
import com.boostworthy.animation.types.Animation;
import com.boostworthy.animation.events.AnimationEvent;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.Framebuffer extends EventSourceObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Default value(s).
	private var DEFAULT_BUSY_MODE:Boolean = false;
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds all animation objects to be rendered.
	private var m_aBuffer:Array;
	
	// Holds an instance of the renderer that will render the contents of the buffer.
	private var m_objRenderer:Renderer;
	
	// Toggles busy mode on/off.
	// Busy mode, when active, prevents an animation from being interrupted by a new 
	// animation until the current animation is finished.
	private var m_bIsBusyMode:Boolean;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function Framebuffer(nRefreshRate:Number)
	{
		// Create a new array for the buffer.
		PurgeBuffer();
		
		// Create a new renderer to render the contents of the buffer.
		m_objRenderer = new Renderer(this, "RenderBuffer", nRefreshRate, false);
		
		// Set the default setting for busy mode.
		(DEFAULT_BUSY_MODE) ? EnableBusyMode() : DisableBusyMode();
	}
	
	// =====================================================================================
	// BUFFER FUNCTIONS
	// =====================================================================================
	
	// AddBufferObject
	// 
	// Adds an animation object to the buffer assuming an animation object with the
	// same target object and property doesn't already exist in the buffer.
	public function AddBufferObject(objAnimation:Animation):Void
	{
		// Check the buffer to make sure the object doesn't already exist.
		if(GetBufferID(objAnimation) == null)
		{
			// Add the animation object.
			m_aBuffer.push(objAnimation);
			
			// Start rendering the animation objects inside the buffer.
			m_objRenderer.StartRendering();
			
			// Broadcast that a new animation is now starting.
			DispatchEvent(new AnimationEvent(AnimationEvent.START, objAnimation.Scope, objAnimation.Property));
		}
		else
		{
			// Check to see if busy mode is disabled.
			if(!m_bIsBusyMode)
			{
				// Remove the current instance of the animation.
				RemoveBufferObject(objAnimation);
				
				// Add the new instance of the animation.
				AddBufferObject(objAnimation);
			}
			// Busy mode is active.
			else
			{
				// Output a message alerting the user that an entry for that animation object
				// already exists in the buffer.
				trace("Framebuffer :: AddBufferObject :: WARNING -> An animation object for " + objAnimation.Scope.toString() + "'s property '" + objAnimation.Property + "' already exists in the buffer.");
			}
		}
	}
	
	// RemoveBufferObject
	// 
	// Removes an animation object from the buffer.
	public function RemoveBufferObject(objAnimation:Animation):Void
	{
		// Get the animation object's buffer ID.
		var nBufferID:Number = GetBufferID(objAnimation);
		
		// Check for a valid ID indicating that the animation object exists
		// in the buffer.
		if(nBufferID != null)
		{
			// Remove the animation object from the buffer.
			m_aBuffer.splice(nBufferID, 1);
			
			// Check the buffer to see if anything remains in it.
			if(m_aBuffer.length < 1)
			{
				// Hault the renderer since the buffer is now empty.
				m_objRenderer.StopRendering();
			}
			
			// Broadcast that an animation is now finishing.
			DispatchEvent(new AnimationEvent(AnimationEvent.FINISH, objAnimation.Scope, objAnimation.Property));
		}
		else
		{
			// Output a message alerting the user that an entry for that animation object
			// does not exist in the buffer.
			trace("Framebuffer :: AddBufferObject :: WARNING -> An animation object for " + objAnimation.Scope.toString() + "'s property '" + objAnimation.Property + "' does not exist in the buffer, and therefore cannot be removed.");
		}
	}
	
	// RemoveBufferObjectAll
	// 
	// Removes all animation objects whose target object match the passed parameter.
	public function RemoveBufferObjectAll(objScope:Object):Void
	{
		// Loop through the buffer.
		for(var i:Number = 0; i < m_aBuffer.length; i++)
		{
			// Get the current entry.
			var objEntry:Animation = m_aBuffer[i];
			
			// Check the object scopes to see if they are a match.
			if(objEntry.Scope == objScope)
			{
				// Remove the animation object from the buffer.
				m_aBuffer.splice(i, 1);
				
				// Check the buffer to see if anything remains in it.
				if(m_aBuffer.length > 0)
				{
					// Restart the loop to check for more instances.
					i = 0;
				}
				else
				{
					// Hault the renderer since the buffer is now empty.
					m_objRenderer.StopRendering();
				}
				
				// Broadcast that an animation is now finishing.
				DispatchEvent(new AnimationEvent(AnimationEvent.FINISH, objEntry.Scope, objEntry.Property));
			}
		}
	}
	
	// GetBufferID
	// 
	// Checks the buffer for an animation object and returns it's ID. If the object
	// doesn't exist in the buffer, 'null' is returned.
	private function GetBufferID(objAnimation:Animation):Number
	{
		// Loop through the buffer.
		for(var i:Number = 0; i < m_aBuffer.length; i++)
		{
			// Get the current entry.
			var objEntry:Animation = m_aBuffer[i];
			
			// Check the object scopes and properties to see if they are a match.
			if(objEntry.Scope == objAnimation.Scope && objEntry.Property == objAnimation.Property)
			{
				// Return the buffer ID.
				return i;
			}
		}
		
		// Return 'null' indicating that the animation object does not
		// exist in the buffer.
		return null;
	}
	
	// PurgeBuffer
	// 
	// Clears the buffer.
	public function PurgeBuffer():Void
	{
		// Hault the renderer since the buffer is about to be empty.
		m_objRenderer.StopRendering();
		
		// Check to see if there is anything in the buffer.
		if(m_aBuffer.length > 0)
		{
			// Loop through the buffer.
			for(var i:Number = 0; i < m_aBuffer.length; i++)
			{
				// Get the current entry.
				var objEntry:Animation = m_aBuffer[i];
				
				// Broadcast that an animation is now finishing.
				DispatchEvent(new AnimationEvent(AnimationEvent.FINISH, objEntry.Scope, objEntry.Property));
			}
		}
		
		// Create a new array for the buffer.
		m_aBuffer = new Array();
	}
	
	// =====================================================================================
	// RENDER FUNCTIONS
	// =====================================================================================
	
	// RenderBuffer
	// 
	// Called upon at the set refresh rate by the renderer whenever the buffer
	// contains entries. Updates each animation object in the buffer until an animation
	// is completed, then it removes the object from the buffer.
	private function RenderBuffer():Void
	{
		// Loop through the buffer.
		for(var i:Number = 0; i < m_aBuffer.length; i++)
		{
			// Get the current entry.
			var objEntry:Animation = m_aBuffer[i];
			
			// Broadcast that an animation is changing.
			DispatchEvent(new AnimationEvent(AnimationEvent.CHANGE, objEntry.Scope, objEntry.Property));
			
			// Update the animation object.
			// If false is returned, the animation is complete and the
			// animation object should be removed from the buffer.
			if(!objEntry.Update())
			{
				// Remove the animation object from the buffer.
				RemoveBufferObject(objEntry);
			}
		}
		
		// Update the display.
		updateAfterEvent();
	}
	
	// =====================================================================================
	// BUSY MODE FUNCTIONS
	// =====================================================================================
	
	// EnableBusyMode
	// 
	// Enables busy mode.
	// Animations will not be overriden by new animations.
	public function EnableBusyMode():Void
	{
		// Set busy mode to 'true'.
		m_bIsBusyMode = true;
	}
	
	// DisableBusyMode
	// 
	// Disables busy mode.
	// Animations will be overriden by new animations.
	public function DisableBusyMode():Void
	{
		// Set busy mode to 'false'.
		m_bIsBusyMode = false;
	}
}