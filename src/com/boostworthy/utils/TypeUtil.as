// =========================================================================================
// Class: TypeUtil
// 
// Ryan Taylor
// March 25, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

class com.boostworthy.utils.TypeUtil
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// This is a static class and therefore the constructor is private.
	private function TypeUtil()
	{
	}
	
	// =====================================================================================
	// TYPE FUNCTIONS
	// =====================================================================================
	
	// GetType
	// 
	// Returns the given object type. If that object type isn't already know, it is
	// found first, then returned.
	public static function GetType(objType:Object):String
	{
		// Check to see if the type needs to be found first.
		if(objType.__type__ == undefined)
		{
			// Unlock the _global object.
			_global.ASSetPropFlags(_global, null, 0, true);
			
			// Find and set the type property.
			FindAndSetType(objType, _global);
		}
		
		// Return the type.
		return objType.__type__;
	}
	
	// =====================================================================================
	// INTERNAL FUNCTIONS
	// =====================================================================================
	
	// FindAndSetType
	// 
	// Finds an object's type and adds a new property to the object that accesses it.
	private static function FindAndSetType(objType:Object, objPackage:Object):Void
	{
		// Loop through all objects in the package.
		for(var i:String in objPackage)
		{
			// Check for the object.
			if(typeof(objPackage[i]) == "function")
			{
				// Set the type property.
				objPackage[i].prototype.__type__ = i;
					
				// Add the property to the object.
				_global.ASSetPropFlags(objPackage[i].prototype, "__type__", 1, true);
			}
			// Check for a package.
			else if(typeof(objPackage[i]) == "object")
			{
				// Check for the object in the package.
				FindAndSetType(objType, objPackage[i]);
			}
		}
	}
}