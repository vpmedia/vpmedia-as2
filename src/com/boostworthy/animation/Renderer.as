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

import com.boostworthy.core.BaseObject;
import com.boostworthy.managers.IntervalManager;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.animation.Renderer extends BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Default settings.
	private var DEFAULT_AUTO_START:Boolean  = true;
	private var DEFAULT_REFRESH_RATE:Number = 15;
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds an instance of the interval manager.
	private var m_objIntervalManager:IntervalManager;
	
	// Holds the scope of function being called for rendering.
	private var m_objScope:Object;
	
	// Holds the name of the function being called at the set scope.
	private var m_strFunction:String;
	
	// Holds the refresh rate for how often the renderer will call the function
	// getting rendered. The rate is in milliseconds.
	private var m_nRefreshRate:Number;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function Renderer(objScope:Object, strFunction:String, nRefreshRate:Number, bAutoStart:Boolean)
	{
		// Make sure a valid function is being set for rendering.
		if(objScope[strFunction] != undefined)
		{
			// Create an instance of the interval manager.
			m_objIntervalManager = new IntervalManager();
			
			// Set defaults if necessary.
			nRefreshRate = (nRefreshRate == undefined || nRefreshRate == null) ? DEFAULT_REFRESH_RATE : nRefreshRate;
			bAutoStart   = (bAutoStart == undefined) ? DEFAULT_AUTO_START : bAutoStart;
			
			// Store the scope and function to be rendered.
			m_objScope     = objScope;
			m_strFunction  = strFunction;
			m_nRefreshRate = nRefreshRate;
			
			// Check to see if the rendering should automatically begin.
			if(bAutoStart)
			{
				// Start rendering.
				StartRendering();
			}
		}
		else
		{
			// Output a message alerting the user that the function being set for rendering
			// does not exist, and therefore this object is being deleted for memory sake.
			trace("Renderer :: Init :: WARNING -> The function '" + strFunction + "' does not exist in the object '" + objScope.toString() + "', and therefore, this object is being deleted.");
			
			// Delete this object.
			delete this;
		}
	}
	
	// =====================================================================================
	// INTERVAL FUNCTIONS
	// =====================================================================================
	
	// StartRendering
	// 
	// Starts rendering the function at the specific refresh rate.
	public function StartRendering():Void
	{
		// Add the entry from the interval manager.
		m_objIntervalManager.AddInterval(m_objScope, m_strFunction, m_nRefreshRate);
	}
	
	// StopRendering
	// 
	// Stops rendering until 'StartRendering' is called again.
	public function StopRendering():Void
	{
		// Remove the entry from the interval manager.
		m_objIntervalManager.RemoveInterval(m_objScope, m_strFunction);
	}
}