// =========================================================================================
// Class: InstanceManager
// 
// Ryan Taylor
// September 2, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;
import com.boostworthy.events.EventSourceObject;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.managers.InstanceManager extends BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds a list of all instances of a particular object.
	private var m_aInstances:Array;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function InstanceManager()
	{
		// Create a new instance list.
		ClearInstanceList();
	}
	
	// =====================================================================================
	// LIST FUNCTIONS
	// =====================================================================================
	
	// AddInstance
	// 
	// Adds a new instance of an object to the instance list unless
	// the instance already exists in the list.
	public function AddInstance(objInstance:Object):Void
	{
		// Check for an existing instance ID for the object.
		var nInstanceID:Number = GetInstanceID(objInstance);
		
		// If no instance ID exists, add the object instance to the list.
		if(nInstanceID == null)
		{
			// Add the object instance to the list.
			m_aInstances.push(objInstance);
		}
		else
		{
			// Output a message alerting the user that an entry for that animation object
			// already exists in the buffer.
			trace("InstanceManager :: AddInstance :: WARNING -> The object instance '" + objInstance.toString() + "' already exists in the instance list.");
		}
	}
	
	// RemoveInstance
	// 
	// Removes an object instance from the instance list.
	public function RemoveInstance(objInstance:Object):Void
	{
		// Check for an existing instance ID for the object.
		var nInstanceID:Number = GetInstanceID(objInstance);
		
		// If the instance has and ID, remove it from the list.
		if(nInstanceID != null)
		{
			// Remove the instance from the list.
			m_aInstances.splice(nInstanceID, 1);
		}
		else
		{
			// Output a message alerting the user that an entry for that animation object
			// already exists in the buffer.
			trace("InstanceManager :: RemoveInstance :: WARNING -> The object instance '" + objInstance.toString() + "' does not exist in the instance list and therefore cannot be removed.");
		}
	}
	
	// GetInstanceID
	// 
	// Checks the instance list to see if the object instance passed exists
	// in the list, and if so, returns the index of the entry. If no match is
	// found, 'null' is returned.
	private function GetInstanceID(objInstance:Object):Number
	{
		// Loop through the instance list.
		for(var i:Number = 0; i < m_aInstances.length; i++)
		{
			// Check to see if the object matches the entry in the
			// instance list.
			if(objInstance === m_aInstances[i])
			{
				// Return the instance ID.
				return i;
			}
		}
		
		// Return 'null' indicating that the object instance does not
		// exist in the instance list.
		return null;
	}
	
	// ClearInstanceList
	// 
	// Erases any previous list by creating a new array for the list.
	public function ClearInstanceList():Void
	{
		// Create a new array for the instance list.
		m_aInstances = new Array();
	}
	
	// GetInstanceAt
	// 
	// Returns the instance at the given index ID.
	public function GetInstanceAt(nID:Number):Object
	{
		// Return the instance at the given index ID.
		return m_aInstances[nID];
	}
	
	// Length
	// 
	// Read-only access to the length of the instance list.
	public function get Length():Number
	{
		// Return the length of the instance list.
		return m_aInstances.length;
	}
}