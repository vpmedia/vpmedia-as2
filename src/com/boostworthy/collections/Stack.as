// =========================================================================================
// Class: Stack
// 
// Ryan Taylor
// January, 4, 2007
// http://www.boostworthy.com
// 
// Stores data in a 'first on, last off' fashion. Each element placed in this collection
// can be of any data type. To mandate that the elements must be of a specific type, use
// the 'TypedStack' object instead.
// 
// Example:
// 
// import com.boostworthy.collections.Stack;
// import com.boostworthy.collections.iterators.Iterator_I;
// 
// var objStack:Stack = new Stack();
// 
// objStack.AddElement("a");
// objStack.AddElement(2);
// objStack.AddElement(3);
// objStack.AddElement("d");
// 
// var objIterator:Iterator_I = objStack.GetIterator();
// 
// while(objIterator.HasNext())
// {
//      trace(objIterator.Next());
// }
// 
// Output:
// 
// d
// 3
// 2
// a
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.collections.Collection_I;
import com.boostworthy.collections.iterators.Iterator_I;
import com.boostworthy.collections.iterators.IteratorType;
import com.boostworthy.collections.iterators.ForwardArrayIterator;
import com.boostworthy.collections.iterators.ReverseArrayIterator;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.collections.Stack implements Collection_I
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Array for storing all data in this collection.
	private var m_aData:Array;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function Stack()
	{
		// Clear this collection.
		Clear();
	}
	
	// =====================================================================================
	// COLLECTION FUNCTIONS
	// =====================================================================================
	
	// Clear
	// 
	// Clears any data being stored by this collection object.
	public function Clear():Void
	{
		// Create a new array, thus clearing the stored data in a previous array if applicable.
		m_aData = new Array();
	}
	
	// AddElement
	// 
	// Adds a new element to this object's data array.
	public function AddElement(objElement:Object):Void
	{
		// Add the new element to the first index in the array.
		m_aData.unshift(objElement);
	}
	
	// RemoveElement
	// 
	// Removes an element from this object's data array.
	public function RemoveElement(objElement:Object):Void
	{
		// Get the element's index.
		var nIndex:Number = GetElementIndex(objElement);
		
		// Only take action if the element was found in the data array.
		if(nIndex != null)
		{
			// Remove the element from the data array.
			m_aData.splice(nIndex, 1);
		}
	}
	
	// GetElementIndex
	// 
	// Loops through the data array and checks each element against the passed element.
	// If the element is found in the data array, it's index is returned, otherwise
	// 'null' is returned indicating that it was not found in the data array.
	private function GetElementIndex(objElement:Object):Number
	{
		// Loop through the data array.
		for(var i:Number = 0; i < m_aData.length; i++)
		{
			// Compare the two elements.
			if(m_aData[i] === objElement)
			{
				// Return the element's index.
				return i;
			}
		}
		
		// Return 'null' since no match was made.
		return null;
	}
	
	// GetLength
	// 
	// Gets the length of this collection.
	public function GetLength():Number
	{
		// Return the data array length.
		return m_aData.length;
	}
	
	// =====================================================================================
	// OVERRIDE FUNCTIONS
	// =====================================================================================
	
	// GetIterator
	// 
	// Returns an iterator of the specified type. A copy of the data array is passed to the
	// iterator to maintain strong encapsulation.
	public function GetIterator(nIterator:Number):Iterator_I
	{
		// Check to see if the specified iterator is a forward array iterator.
		if(nIterator == IteratorType.ARRAY_FORWARD)
		{
			// Return a forward array iterator.
			return new ForwardArrayIterator(m_aData.concat());
		}
		// Check to see if the specified iterator is a reverse array iterator.
		else if(nIterator == IteratorType.ARRAY_REVERSE)
		{
			// Return a reverse array iterator.
			return new ReverseArrayIterator(m_aData.concat());
		}
		// The iterator type is unknown or was not specified.
		else
		{
			// Return the default iterator type.
			return new ForwardArrayIterator(m_aData.concat());
		}
	}
}