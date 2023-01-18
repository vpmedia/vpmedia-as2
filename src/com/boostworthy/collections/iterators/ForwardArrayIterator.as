// =========================================================================================
// Class: ForwardArrayIterator
// 
// Ryan Taylor
// January, 4, 2007
// http://www.boostworthy.com
// 
// Iterates through an array by starting with '0' and then incrementing the index until
// the array length is reached.
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
// var objIterator:Iterator_I = objQueue.GetIterator(IteratorType.ARRAY_FORWARD);
// 
// while(objIterator.HasNext())
// {
//      trace(objIterator.Next());
// }
// 
// Output:
// 
// a
// 2
// 3
// d
// =========================================================================================
// 
// +          +          +          +          +          +          +          +          +
// 
// =========================================================================================

// IMPORTS /////////////////////////////////////////////////////////////////////////////////

import com.boostworthy.core.BaseObject;
import com.boostworthy.collections.iterators.Iterator_I;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.collections.iterators.ForwardArrayIterator extends BaseObject implements Iterator_I
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
	public function ForwardArrayIterator(aData:Array)
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
		// Determine if the index is less than the length of the data array.
		return m_nIndex < m_aData.length;
	}
	
	// Next
	// 
	// Returns the element at the current index and then moves on to the next.
	public function Next():Object
	{
		// Return the element at the current index and then increment the index.
		return m_aData[m_nIndex++];
	}
	
	// Reset
	// 
	// Resets this iterator.
	public function Reset():Void
	{
		// Set the index to '0'.
		m_nIndex = 0;
	}
}