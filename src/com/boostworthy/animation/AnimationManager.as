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
import com.boostworthy.animation.Framebuffer;
import com.boostworthy.animation.events.AnimationEvent;
import com.boostworthy.animation.types.PropertyAnimation;
import com.boostworthy.animation.types.FunctionAnimation;
import com.boostworthy.animation.types.MoveAnimation;
import com.boostworthy.animation.types.SizeAnimation;
import com.boostworthy.animation.types.ScaleAnimation;
import com.boostworthy.animation.types.AlphaAnimation;
import com.boostworthy.animation.types.ColorAnimation;
import com.boostworthy.animation.types.PulseAnimation;
import com.boostworthy.animation.types.TimelineAnimation;
import com.boostworthy.animation.types.BlurAnimation;
import com.boostworthy.managers.TimeoutManager;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.AnimationManager extends EventSourceObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds an instance of the framebuffer.
	private var m_objFramebuffer:Framebuffer;
	
	// Holds an instance of the timeout manager.
	private var m_objTimeoutManager:TimeoutManager;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function AnimationManager(nRefreshRate:Number)
	{
		// Create a new framebuffer and pass it the desired refresh rate.
		m_objFramebuffer = new Framebuffer(nRefreshRate);
		
		// Create a new timeout manager to handle delays.
		m_objTimeoutManager = new TimeoutManager();
		
		// Add animation event listeners to the framebuffer.
		m_objFramebuffer.AddEventListener(this, "OnAnimEvent", AnimationEvent.START);
		m_objFramebuffer.AddEventListener(this, "OnAnimEvent", AnimationEvent.CHANGE);
		m_objFramebuffer.AddEventListener(this, "OnAnimEvent", AnimationEvent.FINISH);
	}
	
	// OnAnimEvent
	// 
	// Called whenever an animation event occurs.
	private function OnAnimEvent(objEvent:AnimationEvent):Void
	{
		// Allow the event to bubble.
		DispatchEvent(objEvent);
	}
	
	// =====================================================================================
	// ANIMATION FUNCTIONS
	// =====================================================================================
	
	// ANIMATION SYNTAX
	// 
	// Property:
	// objScope        -> The scope of the object whose property is being animated.
	// strProperty     -> The name of the property being animated.
	// nTargetValue(s) -> The value the property is getting animated to.
	// nDuration       -> The duration of the animation in milliseconds.
	// strTransition   -> The name of the transition to be used for the animation.
	// nDelay          -> [OPTIONAL] The time in milliseconds to delay the animation from starting.
	// 
	// Color:
	// nTargetColor    -> The hexidecimal color value to animate to. Example '0x336666'.
	// 
	// Pulse:
	// nMin            -> The minimum value output to the property by the pulse.
	// nMax            -> The maximum value output to the property by the pulse.
	// nDuration       -> The amount of time it takes for one wave cycle (Min -> Max -> Min).
	
	// Property
	// 
	// Animates any property to the desired target value.
	public function Property(objScope:Object, strProperty:String, nTargetValue:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new PropertyAnimation(objScope, strProperty, nTargetValue, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Property", nDelay, objScope, strProperty, nTargetValue, nDuration, strTransition);
		}
	}
	
	// Functions
	// 
	// Animates any getter/setter function values to the desired target value.
	public function Functions(objScope:Object, strGetFunction:String, strSetFunction:String, nTargetValue:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new FunctionAnimation(objScope, strGetFunction, strSetFunction, nTargetValue, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Functions", nDelay, objScope, strGetFunction, strSetFunction, nTargetValue, nDuration, strTransition);
		}
	}
	
	// Move
	// 
	// Animates a movieclip instance to the desired X and Y coordinates.
	public function Move(mcScope:MovieClip, nTargetX:Number, nTargetY:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new MoveAnimation(mcScope, nTargetX, nTargetY, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Move", nDelay, mcScope, nTargetX, nTargetY, nDuration, strTransition);
		}
	}
	
	// Size
	// 
	// Animates the width and height of the desired movie clip.
	public function Size(mcScope:MovieClip, nTargetWidth:Number, nTargetHeight:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new SizeAnimation(mcScope, nTargetWidth, nTargetHeight, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Size", nDelay, mcScope, nTargetWidth, nTargetHeight, nDuration, strTransition);
		}
	}
	
	// Scale
	// 
	// Animates the scale of a movie clip to the desired target scale values.
	public function Scale(mcScope:MovieClip, nTargetScaleX:Number, nTargetScaleY:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new ScaleAnimation(mcScope, nTargetScaleX, nTargetScaleY, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Scale", nDelay, mcScope, nTargetScaleX, nTargetScaleY, nDuration, strTransition);
		}
	}
	
	// Alpha
	// 
	// Animates the alpha of a movie clip to the desired value.
	public function Alpha(objScope:Object, nTargetAlpha:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new AlphaAnimation(objScope, "_alpha", nTargetAlpha, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Alpha", nDelay, objScope, nTargetAlpha, nDuration, strTransition);
		}
	}
	
	// ColorFade
	// 
	// Animates a movie clip's color to the desired target value. The target value
	// needs passed as a 'ColorValue', allowing maximum flexibity.
	// 
	// NOTE: A movie clip must be passed to 'InitColor' in this object before it can
	// have it's color animated.
	public function ColorFade(objScope:Object, nTargetColor:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new ColorAnimation(objScope, "color", nTargetColor, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "ColorFade", nDelay, objScope, nTargetColor, nDuration, strTransition);
		}
	}
	
	// Pulse
	// 
	// Pulses an object's property back and forth between a minimum and maximum
	// value using a sine wave. In this case, the duration is how long a single
	// wave cycle takes to occur, thus impacting the speed of the pulse.
	public function Pulse(objScope:Object, strProperty:String, nMin:Number, nMax:Number, nDuration:Number, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new PulseAnimation(objScope, strProperty, nMin, nMax, nDuration));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Pulse", nDelay, objScope, strProperty, nMin, nMax, nDuration);
		}
	}
	
	// Timeline
	// 
	// Animates a movie clip's playhead to the desired target frame on it's timeline.
	public function Timeline(objScope:Object, nTargetFrame:Number, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new TimelineAnimation(objScope, "timeline", nTargetFrame));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Timeline", nDelay, objScope, nTargetFrame);
		}
	}
	
	// Blur
	// 
	// Animates a blur filter on an object to the specified values.
	// A quality of '2' or '3' is recommended as well as the blur 'X' and 'Y' being powers of '2'.
	// Example: Blur(obj, 32, 32, 2, 1000, "Linear");
	public function Blur(objScope:Object, nBlurX:Number, nBlurY:Number, nQuality:Number, nDuration:Number, strTransition:String, nDelay:Number):Void
	{
		// Check to see if a delay is being used.
		if(!nDelay)
		{
			// Add the new animation object to the framebuffer.
			m_objFramebuffer.AddBufferObject(new BlurAnimation(objScope, "blur", nBlurX, nBlurY, nQuality, nDuration, strTransition));
		}
		else
		{
			// Add a timeout that will re-call this function when the delay is up.
			m_objTimeoutManager.AddTimeout(this, "Blur", nDelay, objScope, nBlurX, nBlurY, nQuality, nDuration, strTransition);
		}
	}
	
	// =====================================================================================
	// BUFFER FUNCTIONS
	// =====================================================================================
	
	// Remove
	// 
	// Removes all instances of an object from the framebuffer.
	public function Remove(objScope:Object):Void
	{
		// Remove the object from the framebuffer.
		m_objFramebuffer.RemoveBufferObjectAll(objScope);
	}
	
	// RemoveAll
	// 
	// Clears the framebuffer.
	public function RemoveAll():Void
	{
		// Purge the framebuffer.
		m_objFramebuffer.PurgeBuffer();
	}
	
	// =====================================================================================
	// COLOR FUNCTIONS
	// =====================================================================================
	
	// InitColor
	// 
	// Makes a movie clip capable of having it's color animated by setting a starting color.
	public function InitColor(mcTarget:MovieClip, nColor:Number):Void
	{
		// Create the new color object.
		var objColor:Color = new Color(mcTarget);
		
		// Set the color transformation.
        objColor.setTransform({ra:0, rb:((nColor >> 16) & 255), ga:0, gb:((nColor >> 8) & 255), ba:0, bb:(nColor & 255)});
	}
	
	// =====================================================================================
	// BUSY MODE FUNCTIONS
	// =====================================================================================
	
	// BusyMode
	// 
	// Enables/disables busy mode.
	// When busy mode is enabled, a value must finish being animated before a new animation
	// for the same value can occur. 
	public function set BusyMode(bEnable:Boolean):Void
	{
		// Check to see if busy mode is being enabled or disabled.
		if(bEnable)
		{
			// Enable busy mode.
			m_objFramebuffer.EnableBusyMode();
		}
		else
		{
			// Disable busy mode.
			m_objFramebuffer.DisableBusyMode();
		}
	}
}