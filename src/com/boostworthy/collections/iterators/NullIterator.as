// =========================================================================================
// Class: NullIterator
// 
// Ryan Taylor
// January, 4, 2007
// http://www.boostworthy.com
// 
// In certain cases, such as a leaf object in a composite pattern, a null iterator is needed
// to maintain elegant code. Instead of making special checks using if statements, a null
// iterator will plug right into a loop and return 'false' when 'HasNext' is checked.
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;
import com.boostworthy.collections.iterators.Iterator_I;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.collections.iterators.NullIterator extends BaseObject implements Iterator_I
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
	public function NullIterator()
	{
	}
	
	// =====================================================================================
	// ITERATIVE FUNCTIONS
	// =====================================================================================
	
	// HasNext
	// 
	// Returns a boolean value indicating whether or not the collection has another object
	// beyond the current index.
	public function HasNext():Boolean
	{
		// Return 'false' to instantly end any iteration.
		return false;
	}
	
	// Next
	// 
	// Returns the element at the current index and then moves on to the next.
	public function Next():Object
	{
		// Return 'null' since no data is actually being iterated through.
		return null;
	}
	
	// Reset
	// 
	// Resets this iterator.
	public function Reset():Void
	{
		// This method is only present to meet the criteria of the iterator interface.
	}
}