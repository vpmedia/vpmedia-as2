// =========================================================================================
// Class: TimeoutManager
// 
// Ryan Taylor
// October 1st, 2006
// http://www.boostworthy.com
// 
// Manager for handeling the new, undocumented 'setTimeout' method in Flash 8. Useful
// for dealing with multiple timeouts, especially when they may need to be cleared
// before the timeout expires.
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.managers.TimeoutManager extends BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds the list of active timeouts.
	private var m_aTimeouts:Array;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function TimeoutManager()
	{
		// Create a new array for the timeouts list.
		m_aTimeouts = new Array();
	}
	
	// =====================================================================================
	// INTERVAL FUNCTIONS
	// =====================================================================================
	
	// AddTimeout
	// 
	// Creates a new timeout and adds it to the timeouts list. A timeout ID is returned for
	// the sake of passing it to 'RemoveTimeout' if more than one timeout is pointed towards
	// the same function.
	public function AddTimeout(objScope:Object, strFunc:String, nRate:Number):Number
	{
		// Declare variable(s).
		var nIndex:Number, bValidRate:Boolean, nTimeoutID:Number;
		
		// Check for a valid rate.
		bValidRate = ValidateRate(nRate);
			
		// Check to see if the function exists and the rate is valid.
		if(objScope[strFunc] != undefined && bValidRate)
		{
			// Create the new timeout.
			nTimeoutID = _global["setTimeout"](this, "DispatchTimeout", nRate, objScope, strFunc, arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]);
				
			// Add the new timeout to the timeouts list.
			m_aTimeouts.push({nTimeoutID:nTimeoutID, objScope:objScope, strFunc:strFunc});
				
			// Return the timeout ID.
			return nTimeoutID;
		}
		
		// Return 'null' indicating that the timeout was not added.
		return null;
	}
	
	// RemoveTimeout
	// 
	// Clears a timeout and removes it from the timeouts list. If not timeout ID is passed, the
	// first occurance of the specified function will be removed. If more than one timeout is set
	// to call the same function, the timeout ID returned from the 'AddTimeout' method can be passed
	// to specify the instance to remove.
	public function RemoveTimeout(objScope:Object, strFunc:String, nTimeoutID:Number):Void
	{
		// Declare varible(s).
		var nIndex:Number;
		
		// Get the timeout's index number.
		nIndex = CheckForTimeout(objScope, strFunc, nTimeoutID);
		
		// Make sure the timeout exists.
		if(nIndex != null)
		{
			// Clear the timeout.
			_global["clearTimeout"](m_aTimeouts[nIndex].nTimeoutID);
			
			// Remove the timeout from the timeouts list.
			m_aTimeouts.splice(nIndex, 1);
		}
	}
	
	// CheckForTimeout
	// 
	// Checks for an timeout and returns it's index if it
	// exists. If it does not exist, 'NULL' is returned instead.
	private function CheckForTimeout(objScope:Object, strFunc:String, nTimeoutID:Number):Number
	{
		// Loop through the timeouts list.
		for(var i:Number = 0; i < m_aTimeouts.length; i++)
		{
			// Check to see if a timeout ID was supplied.
			if(nTimeoutID != undefined)
			{
				// Check for the timeout.
				if(m_aTimeouts[i].objScope == objScope && m_aTimeouts[i].strFunc == strFunc && m_aTimeouts[i].nTimeoutID == nTimeoutID)
				{
					// Return the index of the timeout.
					return i;
				}
			}
			else
			{
				// Check for the timeout.
				if(m_aTimeouts[i].objScope == objScope && m_aTimeouts[i].strFunc == strFunc)
				{
					// Return the index of the timeout.
					return i;
				}
			}
		}
		
		// Return 'NULL' indicating that the timeout does not exist.
		return null;
	}
	
	// ValidateRate
	// 
	// Validates the rate attempting to be assigned to a new timeout.
	private function ValidateRate(nRate:Number):Boolean
	{
		// Check for a valid number.
		if(nRate != undefined && nRate != null && nRate > 0)
		{
			// Return 'TRUE'
			return true;
		}
		
		// Return 'FALSE'.
		return false;
	}
	
	// Clear
	// 
	// Clears and removes all timeouts.
	public function Clear():Void
	{
		// Loop through the timeouts list.
		for(var i:Number = 0; i < m_aTimeouts.length; i++)
		{
			// Clear the timeout.
			_global["clearTimeout"](m_aTimeouts[i].nTimeoutID);
		}
			
		// Create a new array.
		m_aTimeouts = new Array();
	}
	
	// DispatchTimeout
	// 
	// Calls the specified method and passes along any addition arguments as well. This extra step
	// is taken instead of calling the method directly using 'setTimeout' so that the timeout can be
	// removed from the timeouts queue.
	private function DispatchTimeout(objScope:Object, strFunc:String):Void
	{
		// Call the specified method and pass any parameters.
		objScope[strFunc](arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]);
		
		// Remove the timeout from the timeout queue.
		RemoveTimeout(objScope, strFunc);
	}
}