// =========================================================================================
// Class: IntervalManager
// 
// Ryan Taylor
// February 11, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;
import com.boostworthy.managers.InstanceManager;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.managers.IntervalManager extends BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// CONSTANTS ///////////////////////////////////////////////////////////////////////////
	
	// Sets the rate at which garbage collection automatically occurs.
	private static var GARBAGE_COLLECTION_RATE:Number = 1000;
	
	// CLASS MEMBERS ///////////////////////////////////////////////////////////////////////
	
	// Holds an instance manager to manage all instance of this object.
	private static var c_objInstanceManager:InstanceManager = new InstanceManager();
	
	// Holds a global instance of this object.
	private static var c_objInstance:IntervalManager = new IntervalManager();
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds the list of active intervals.
	private var m_aIntervals:Array = new Array();
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function IntervalManager()
	{
		// Add this instance to the instance manager.
		c_objInstanceManager.AddInstance(this);
		
		// Create a new array for the intervals list.
		m_aIntervals = new Array();
	}
	
	// =====================================================================================
	// INTERVAL FUNCTIONS
	// =====================================================================================
	
	// AddInterval
	// 
	// Creates a new interval and adds it to the intervals list.
	public function AddInterval(objScope:Object, strFunc:String, nRate:Number):Void
	{
		// Declare variable(s).
		var nIndex:Number, bValidRate:Boolean, nIntervalID:Number;
		
		// Get the interval's index number.
		nIndex = CheckForInterval(objScope, strFunc);
		
		// Make sure the interval exists.
		if(nIndex == null)
		{
			// Check for a valid rate.
			bValidRate = ValidateRate(nRate);
			
			// Check to see if the function exists and the rate is valid.
			if(objScope[strFunc] != undefined && bValidRate)
			{
				// Create the new interval.
				nIntervalID = _global.setInterval(objScope, strFunc, nRate, arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]);
				
				// Add the new interval to the intervals list.
				m_aIntervals.push({nIntervalID:nIntervalID, objScope:objScope, strFunc:strFunc});
			}
		}
	}
	
	// RemoveInterval
	// 
	// Clears an interval and removes it from the intervals list.
	public function RemoveInterval(objScope:Object, strFunc:String):Void
	{
		// Declare varible(s).
		var nIndex:Number;
		
		// Get the interval's index number.
		nIndex = CheckForInterval(objScope, strFunc);
		
		// Make sure the interval exists.
		if(nIndex != null)
		{
			// Clear the interval.
			_global.clearInterval(m_aIntervals[nIndex].nIntervalID);
			
			// Remove the interval from the intervals list.
			m_aIntervals.splice(nIndex, 1);
		}
	}
	
	// CheckForInterval
	// 
	// Checks for an interval and returns it's index if it
	// exists. If it does not exist, 'NULL' is returned instead.
	private function CheckForInterval(objScope:Object, strFunc:String):Number
	{
		// Loop through the intervals list.
		for(var i:Number = 0; i < m_aIntervals.length; i++)
		{
			// Check for the interval.
			if(m_aIntervals[i].objScope == objScope && m_aIntervals[i].strFunc == strFunc)
			{
				// Return the index of the interval.
				return i;
			}
		}
		
		// Return 'NULL' indicating that the interval does not exist.
		return null;
	}
	
	// ValidateRate
	// 
	// Validates the rate attempting to be assigned to a new interval.
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
	
	// Length
	// 
	// Read-only access to the length of the intervals list.
	public function get Length():Number
	{
		// Return the length.
		return m_aIntervals.length;
	}
	
	// Clear
	// 
	// Clears and removes all intervals.
	public function Clear():Void
	{
		// Loop through the intervals list.
		for(var i:Number = 0; i < m_aIntervals.length; i++)
		{
			// Clear the interval.
			_global.clearInterval(m_aIntervals[i].nIntervalID);
		}
			
		// Create a new array.
		m_aIntervals = new Array();
	}
	
	// GarbageCollect
	// 
	// Checks all intervals being managed by this object to see if any of them
	// are calling 'undefined' functions and removes them if necessary.
	public function GarbageCollect():Void
	{
		// Loop through the intervals list.
		for(var i:Number = 0; i < m_aIntervals.length; i++)
		{
			trace(m_aIntervals[i].objScope + ", " + m_aIntervals[i].strFunc+ ", " + m_aIntervals[i].objScope[m_aIntervals[i].strFunc]);
			// Check to see if the interval is calling an 'undefined' function.
			if(m_aIntervals[i].objScope[m_aIntervals[i].strFunc] == undefined)
			{
				// Clear the interval.
				_global.clearInterval(m_aIntervals[i].nIntervalID);
				
				// Remove the interval from the intervals list.
				m_aIntervals.splice(i, 1);
				
				// Decrement 'i' to recheck the same index since the next element is now
				// located in the current index.
				i--;
			}
		}
	}
	
	// GBRoutine
	// 
	// Called by the garbage collection routine interval.
	// Calls upon the class garbage collection method.
	private function GBRoutine():Void
	{
		// Garbage collect for all interval managers.
		GarbageCollectAll();
	}
	
	// =====================================================================================
	// CLASS FUNCTIONS
	// =====================================================================================
	
	// ClearAll
	// 
	// Globally clears all intervals that were created by an interval manager.
	public static function ClearAll():Void
	{
		// Loop through all instances.
		for(var i:Number = 0; i < c_objInstanceManager.Length; i++)
		{
			// Clear all intervals in each manager.
			c_objInstanceManager.GetInstanceAt(i).Clear();
		}
	}
	
	// GarbageCollectAll
	// 
	// Checks all interval managers for intervals calling 'undefined' functions, and
	// clears them accordingly.
	public static function GarbageCollectAll():Void
	{
		// Loop through all instances.
		for(var i:Number = 0; i < c_objInstanceManager.Length; i++)
		{
			// Clear all intervals in each manager.
			c_objInstanceManager.GetInstanceAt(i).GarbageCollect();
		}
	}
}