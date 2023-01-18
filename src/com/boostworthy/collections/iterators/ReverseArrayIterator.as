// =========================================================================================
// Class: ReverseArrayIterator
// 
// Ryan Taylor
// January, 4, 2007
// http://www.boostworthy.com
// 
// Iterates through an array by starting with the array length and then decrementing the 
// index until '0' is reached.
// 
// Example:
// 
// import com.boostworthy.collections.Queue;
// import com.boostworthy.collections.iterators.Iterator_I;
// import com.boostworthy.collections.iterators.IteratorType;
// 
// var objQueue:Queue = new Queue();
// 
// objQueue.AddElement("a");
// objQueue.AddElement(2);
// objQueue.AddElement(3);
// objQueue.AddElement("d");
// 
// var objIterator:Iterator_I = objQueue.GetIterator(IteratorType.ARRAY_REVERSE);
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

import com.boostworthy.core.BaseObject;
import com.boostworthy.collections.iterators.Iterator_I;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.collections.iterators.ReverseArrayIterator extends BaseObject implements Iterator_I
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// MEMBERS /////////////////////////////////////////////////////////////////////////////
	
	// Holds the array of data to be iterated through.
	private var m_aData:Array;
	
	// Stores the current index for the iteration process.
	private var m_nIndex:Number;
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// Init this object.
	public function ReverseArrayIterator(aData:Array)
	{
		// Store the supplied data array.
		m_aData = aData;
		
		// Reset this iterator.
		Reset();
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
		// Determine whether the index is greater than '0' or not.
		return m_nIndex > 0;
	}
	
	// Next
	// 
	// Returns the element at the current index and then moves on to the next.
	public function Next():Object
	{
		// Decrement the index and then return the element at that index.
		return m_aData[--m_nIndex];
	}
	
	// Reset
	// 
	// Resets this iterator.
	public function Reset():Void
	{
		// Set the index to the length of the data array.
		m_nIndex = m_aData.length;
	}
}