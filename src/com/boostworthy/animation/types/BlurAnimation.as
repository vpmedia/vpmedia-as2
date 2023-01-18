// =========================================================================================
// Class: BlurAnimation
// 
// Ryan Taylor
// October 24, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import flash.filters.BlurFilter;
import com.boostworthy.animation.types.Animation;
import com.boostworthy.animation.Transitions;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.types.BlurAnimation extends Animation
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Default value(s).
	private static var DEFAULT_BLUR_X:Number  = 0;
	private static var DEFAULT_BLUR_Y:Number  = 0;
	private static var DEFAULT_QUALITY:Number = 3;
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Hold the start, target, and change in value for the property.
	private var m_nStartX:Number, m_nTargetX:Number, m_nChangeX:Number;
	private var m_nStartY:Number, m_nTargetY:Number, m_nChangeY:Number;
	
	// Holds the blur object to be applied to the target object.
	private var m_objBlur:BlurFilter;
	
	// Holds a copy of all filters active on the target object.
	private var m_aFilters:Array;
	
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
	public function BlurAnimation(objScope:Object, strProperty:String, nBlurX:Number, nBlurY:Number, nQuality:Number, nDuration:Number, strTransition:String)
	{
		// Loop through the arguments.
		for(var i:Number = 0; i < 7; i++)
		{
			// Check for undefined parameters.
			if(arguments[i] == undefined)
			{
				// Output a message alerting the user that incorrect parameters were passed
				// and this object is being deleted.
				trace("BlurAnimation :: Constructor :: ERROR -> Argument '" + i + "' is undefined.");
				
				// Delete this object.
				delete this;
			}
		}
		
		// Store the parameters.
		m_objScope    = objScope;
		m_strProperty = strProperty;
		m_nTargetX    = nBlurX;
		m_nTargetY    = nBlurY;
		m_nDuration   = nDuration;
		
		// Create a new array to hold the target object's filters.
		m_aFilters = new Array();
		
		// Check to see if the target object has any filters applied to it already.
		if(m_objScope.filters.length)
		{
			// Loop through the filters and check for a blur filter.
			for(var i:Number = 0; i < m_objScope.filters.length; i++)
			{
				// Check the filter to see if it is a blur filter.
				if(m_objScope.filters[i].__proto__ == BlurFilter.prototype)
				{
					// Create a new blur filter from the values of the existing blur filter.
					m_objBlur = new BlurFilter(m_objScope.filters[i].blurX, m_objScope.filters[i].blurY, m_objScope.filters[i].quality);
				}
				else
				{
					// Add all other existing filters to the filters array.
					m_aFilters.push(m_objScope.filters[i]);
				}
			}
		}
		else
		{
			// Create a new blur filter using the default and specified values.
			m_objBlur = new BlurFilter(DEFAULT_BLUR_X, DEFAULT_BLUR_Y, nQuality);
		}
		
		// Find and store the remaing necessary data.
		m_fncTransition = Transitions[strTransition];
		m_nStartX       = m_objBlur.blurX;
		m_nStartY       = m_objBlur.blurY;
		m_nChangeX      = m_nTargetX - m_nStartX;
		m_nChangeY      = m_nTargetY - m_nStartY;
		m_nStartTime    = getTimer();
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
			// Temporarily make a copy of the filters array.
			var aFilters:Array = m_aFilters.concat();
		
			// Animate the blur properties.
			m_objBlur.blurX = m_fncTransition(nTime, m_nStartX, m_nChangeX, m_nDuration);
			m_objBlur.blurY = m_fncTransition(nTime, m_nStartY, m_nChangeY, m_nDuration);
			m_objBlur.blurX = m_objBlur.blurX < 0.01 ? 0 : m_objBlur.blurX;
			m_objBlur.blurY = m_objBlur.blurY < 0.01 ? 0 : m_objBlur.blurY;
			
			// Add the blur to the temporary filters array.
			aFilters.push(m_objBlur);
			
			// Apply the filters array to the target object.
			m_objScope.filters = aFilters;
			
			// Return 'true' indicating that the object was updated.
			return true;
		}
		else
		{
			// Set the blur properties to the exact target values.
			m_objBlur.blurX = m_nTargetX;
			m_objBlur.blurY = m_nTargetY;
			
			// Add the blur to the filters array.
			m_aFilters.push(m_objBlur);
			
			// Apply the filters to the target object.
			m_objScope.filters = m_aFilters;
			
			// Return 'false' indicating that the object was not updated.
			return false;
		}
	}
}