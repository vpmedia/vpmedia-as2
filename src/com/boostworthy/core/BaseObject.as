﻿// =========================================================================================
// Class: BaseObject
// 
// Ryan Taylor
// July 30, 2006
// http://www.boostworthy.com
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.utils.TypeUtil;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.core.BaseObject
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	private function BaseObject()
	{
	}
	
	// =====================================================================================
	// BASIC FUNCTIONS
	// =====================================================================================
	
	// toString
	// 
	// Outputs this object's type in a string format.
	public function toString():String
	{
		// Return the string.
		return "[type " + TypeUtil.GetType(this) + "]";
	}
}