// =========================================================================================
// Class: Timeline
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
import com.boostworthy.collections.Stack;
import com.boostworthy.collections.iterators.Iterator_I;
import com.boostworthy.collections.iterators.IteratorType;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.Timeline extends BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Default values.
	private var DEFAULT_FRAME_RATE:Number = 60;
	private var DEFAULT_LOOP:Boolean      = false;
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// The frame rate for this timeline to play at.
	private var m_nFrameRate:Number;
	
	// The necessary refresh rate to achieve the desired frame rate.
	private var m_nRefreshRate:Number;
	
	// A stack for storing all tweens in this timeline.
	private var m_objTweenStack:Stack;
	
	// Stores the current interval's ID.
	private var m_nIntervalID:Number;
	
	// The current frame the playhead of this timeline is at.
	private var m_nFrame:Number;
	
	// The length (in frames) of this timeline.
	private var m_nLength:Number;
	
	// Determines whether or not this timeline loops when the last
	// frame is finished.
	private var m_bLoop:Boolean;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function Timeline(nFrameRate:Number)
	{
		// Set the frame rate.
		SetFrameRate(nFrameRate);
		
		// Create a new tween stack.
		m_objTweenStack = new Stack();
		
		// Set the starting frame and length.
		m_nFrame = m_nLength = 1;
		
		// Set the default loop value.
		Loop = DEFAULT_LOOP;
	}
	
	// =====================================================================================
	// TIMELINE API FUNCTIONS
	// =====================================================================================
	
	// SetFrameRate
	// 
	// Sets the frame rate this timeline plays at.
	public function SetFrameRate(nFrameRate:Number):Void
	{
		// Set the new frame rate or default frame rate if the passed
		// value is not valid.
		m_nFrameRate = (nFrameRate > 0) ? nFrameRate : DEFAULT_FRAME_RATE;
		
		// Calculate the refresh rate based on the new frame rate.
		m_nRefreshRate = Math.floor(1000 / m_nFrameRate);
	}
	
	// AddTween
	// 
	// Adds a new tween to this timeline.
	public function AddTween(objTween:Tween_I):Void
	{
		// Get a clone of the tween.
		var objNewTween:Tween_I = objTween.Clone();
		
		// Determine the length of this timeline based on the last frame
		// of the new tween.
		m_nLength = (objNewTween.GetLastFrame() > m_nLength) ? objNewTween.GetLastFrame() : m_nLength;
		
		// Add the new tween to the stack.
		m_objTweenStack.AddElement(objNewTween);
		
		// Compute frame data for each tween.
		ComputeFrameData(objNewTween.GetFirstFrame(), objNewTween.GetLastFrame());
	}
	
	// Play
	// 
	// Plays this timeline from the current frame.
	public function Play():Void
	{
		// Stop the playhead.
		this.Stop();
		
		// Create a new interval to automatically call the 'NextFrame' method
		// at the necessary refresh rate.
		m_nIntervalID = _global.setInterval(this, "NextFrame", m_nRefreshRate);
	}
	
	// PlayReverse
	// 
	// Plays this timeline in reverse from the current frame.
	public function PlayReverse():Void
	{
		// Stop the playhead.
		this.Stop();
		
		// Create a new interval to automatically call the 'PrevFrame' method
		// at the necessary refresh rate.
		m_nIntervalID = _global.setInterval(this, "PrevFrame", m_nRefreshRate);
	}
	
	// Stop
	// 
	// Stops this timeline at the current frame.
	public function Stop():Void
	{
		// Clear the interval.
		_global.clearInterval(m_nIntervalID);
	}
	
	// GotoAndPlay
	// 
	// Moves the playhead to desired frame and then plays from there.
	public function GotoAndPlay(nFrame:Number):Void
	{
		// Stop the playhead.
		this.Stop();
		
		// Move to the desired frame.
		SetFrame(nFrame);
		
		// Begin playing from the current frame.
		this.Play();
	}
	
	// GotoAndPlayReverse
	// 
	// Moves the playhead to desired frame and then plays in reverse from there.
	public function GotoAndPlayReverse(nFrame:Number):Void
	{
		// Stop the playhead.
		this.Stop();
		
		// Move to the desired frame.
		SetFrame(nFrame);
		
		// Begin playing from the current frame.
		this.PlayReverse();
	}
	
	// GotoAndStop
	// 
	// Moves the playhead to desired frame and then stops.
	public function GotoAndStop(nFrame:Number):Void
	{
		// Move to the desired frame.
		SetFrame(nFrame);
	}
	
	// PrevFrame
	// 
	// Move the playhead backwards one frame.
	public function PrevFrame():Void
	{
		// Move backwards one frame.
		SetFrame(m_nFrame - 1);
	}
	
	// NextFrame
	// 
	// Move the playhead forwards one frame.
	public function NextFrame():Void
	{
		// Move forwards one frame.
		SetFrame(m_nFrame + 1);
	}
	
	// Length
	// 
	// Returns the length (in frames) of this timeline.
	public function get Length():Number
	{
		// Return the length.
		return m_nLength;
	}
	
	// Loop
	// 
	// Getter/setter for the loop setting.
	// Determines whether the playhead loops back to the first frame
	// and continues playing when the last frame is reached or not.
	
	public function get Loop():Boolean
	{
		// Return the current loop setting.
		return m_bLoop;
	}
	
	public function set Loop(bLoop:Boolean):Void
	{
		// Set the new loop setting.
		m_bLoop = bLoop;
	}
	
	// =====================================================================================
	// TIMELINE INTERNAL FUNCTIONS
	// =====================================================================================
	
	// SetFrame
	// 
	// Sets the current frame of the playhead.
	private function SetFrame(nFrame:Number):Void
	{
		// Check to see if the frame is greater than the timeline length.
		if(nFrame > m_nLength)
		{
			// Check to see if looping is enabled.
			if(m_bLoop)
			{
				// Move back to frame '1'.
				nFrame = 1;
			}
			else
			{
				// Stop the playhead.
				this.Stop();
			}
		}
		
		// Check to see if the frame is less than the timeline's first frame.
		if(nFrame < 1)
		{
			// Check to see if looping is enabled.
			if(m_bLoop)
			{
				// Move back to the last frame.
				nFrame = m_nLength;
			}
			else
			{
				// Stop the playhead.
				this.Stop();
			}
		}
		
		// Maintain a valid frame number.
		m_nFrame = Math.min(Math.max(1, nFrame), m_nLength);
		
		// Update the tweens.
		Update();
	}
	
	// ComputeFrameData
	// 
	// Computes the necessary frame data for each tween.
	private function ComputeFrameData(nFirstFrame:Number, nLastFrame:Number):Void
	{
		// Get an iterator instance from the tween stack.
		// In this case, we need a reverse iterator in order to correctly
		// calculate the frames in the correct order.
		var objTweenIterator:Iterator_I = m_objTweenStack.GetIterator(IteratorType.ARRAY_REVERSE);
		
		// Loop through each frame of this timeline.
		for(var i:Number = nFirstFrame; i <= nLastFrame; i++)
		{
			// Loop through the tweens.
			while(objTweenIterator.HasNext())
			{
				// Render frame 'i' of each tween.
				objTweenIterator.Next().RenderFrame(i);
			}
			
			// Reset the iterator.
			objTweenIterator.Reset();
		}
		
		// Update the timeline.
		Update();
	}
	
	// Update
	// 
	// Loops through the tween stack and renders the current frame of each tween.
	private function Update():Void
	{
		// Get an iterator instance from the tween stack.
		var objIterator:Iterator_I = m_objTweenStack.GetIterator();
		
		// Loop through the tweens.
		while(objIterator.HasNext())
		{
			// Render the current frame of each tween.
			objIterator.Next().RenderFrame(m_nFrame);
		}
		
		// Manually update the display.
		updateAfterEvent();
	}
}