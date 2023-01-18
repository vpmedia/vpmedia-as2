// =========================================================================================
// Class: ArrayUtil
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

import com.boostworthy.utils.MathUtil;

////////////////////////////////////////////////////////////////////////////////////////////

class com.boostworthy.utils.ArrayUtil
{
	// =====================================================================================
	// CLASS DECLERATIONS
	// =====================================================================================
	
	// =====================================================================================
	// EVENT FUNCTIONS
	// =====================================================================================
	
	// Constructor
	// 
	// This is a utility class, so the constructor isn't actually used.
	private function ArrayUtil()
	{
	}
	
	// =====================================================================================
	// ARRAY FUNCTIONS
	// =====================================================================================
	
	// Clone
	// 
	// Returns a clone of the passed subject array.
	public static function Clone(aSubject:Array):Array
	{
		// Return the cloned array.
		return aSubject.concat();
	}
	
	// InsertElement
	// 
	// Inserts an element into the subject array at the given index and returns
	// the resulting array.
	public static function InsertElement(aSubject:Array, objElement:Object, nIndex:Number):Array
	{
		// Split the subject array into two seperate arrays at the insert point.
		var aA:Array = aSubject.slice(0, nIndex - 1);
		var aB:Array = aSubject.slice(nIndex, aSubject.length - 1);
		
		// Add element to part 'A'.
		aA.push(objElement);
		
		// Merge parts 'A' and 'B' and return the new array.
		return Merge(aA, aB);
	}
	
	// RemoveElement
	// 
	// Removes all instances of an element from the given array and then
	// returns the resulting array.
	public static function RemoveElement(aSubject:Array, objElement:Object):Array
	{
		// Loop through the subject array.
		for(var i:Number = 0; i < aSubject.length; i++)
		{
			// Check to see if the entry matches the element.
			if(aSubject[i] === objElement)
			{
				// Remove the element from the array.
				aSubject.splice(i, 1);
			}
		}
		
		// Return the resulting array.
		return aSubject;
	}
	
	// CheckForElement
	// 
	// Checks the given array for an element. Returns the index of the element if it
	// exists in the subject array, otherwise 'null' is returned.
	public static function CheckForElement(aSubject:Array, objElement:Object):Number
	{
		// Loop through the subject array.
		for(var i:Number = 0; i < aSubject.length; i++)
		{
			// Check to see if the entry matches the element.
			if(aSubject[i] === objElement)
			{
				// Return the index of the entry.
				return i;
			}
		}
		
		// Return 'null' indicating that the element does not exist
		// in the subject array.
		return null;
	}
	
	// Compare
	// 
	// Compares two arrays to see if they are identical or not.
	public static function Compare(aA:Array, aB:Array):Boolean
	{
		// Start by comparing the lengths of the two arrays.
		if(aA.length != aB.length)
		{
			// Return 'false' indicating that the arrays are not identical.
			return false;
		}
		
		// Next, loop through the two arrays and compare each entry.
		for(var i:Number = 0; i < aA.length; i++)
		{
			// Check to see if the two entries match.
			if(aA[i] !== aB[i])
			{
				// Return 'false' indicating that the arrays are not identical.
				return false;
			}
		}
		
		// Return 'true' indicating that the arrays are identical.
		return true;
	}
	
	// Swap
	// 
	// Swaps two elements at the given indexes of the subject array.
	public static function Swap(aSubject:Array, nA:Number, nB:Number):Array
	{
		// Validate the value of index 'A'.
		if(nA >= aSubject.length || nA < 0)
		{
			// Output a message alerting the user that index 'A' is invalid.
			trace("ArrayUtil :: Swap :: ERROR -> Index 'A' (" + nA + ") is not a valid index in the array '" + aSubject.toString() + "'.");
			
			// Return the unmodifed subject array.
			return aSubject;
		}
		
		// Validate the value of index 'B'.
		if(nB >= aSubject.length || nB < 0)
		{
			// Output a message alerting the user that index 'B' is invalid.
			trace("ArrayUtil :: Swap :: ERROR -> Index 'B' (" + nB + ") is not a valid index in the array '" + aSubject.toString() + "'.");
			
			// Return the unmodifed subject array.
			return aSubject;
		}
		
		// Temporarily store the element from index 'A'.
		var objElement:Object = aSubject[nA];
		
		// Place the element in index 'B' in index 'A'.
		aSubject[nA] = aSubject[nB];
		
		// Place the element that was in index 'A' in index 'B'.
		aSubject[nB] = objElement;
		
		// Return the resulting array.
		return aSubject;
	}
	
	// Shuffle
	// 
	// Takes an array and returns a shuffled version of it.
	public static function Shuffle(aOld:Array):Array
	{
		// Create a new array to old the shuffled entries.
		var aNew:Array = new Array();
		
		// Shuffle until the old array is empty.
		while(aOld.length > 0)
		{
			// Select a random entry from the old array to remove and place into
			// the new array.
			aNew[aNew.length] = aOld.splice(MathUtil.GetRandomNumber(0, aOld.length - 1), 1);
		}
		
		// Return the new, shuffled array.
		return aNew;
	}
	
	// Merge
	// 
	// Merges and returns the contents of two arrays into one array.
	public static function Merge(aA:Array, aB:Array):Array
	{
		// Get a clone of array 'B'.
		var aC:Array = Clone(aB);
		
		// Loop through array 'A'.
		for(var i:Number = aA.length - 1; i > -1; i--)
		{
			// Add each element from array 'A' into array 'C'.
			aC.unshift(aA[i]);
		}
		
		// Return array 'C'.
		return aC;
	}
	
	// Sort
	// 
	// Uses the insertion sort algorithm to sort the contents of the subject array.
	// The resulting array is returned with elements in ascending order (smallest to largest).
	public static function Sort(aSubject:Array):Array
	{
		// Declare variable(s).
		var i:Number, j:Number, objElement:Object;
		
		// Loop through the contents of the subject array.
		// We start at index '1' because the while loop checks each previous
		// element for it's comparison.
		for(i = 1; i < aSubject.length; i++)
		{
			// Get the element at index 'i'.
			objElement = aSubject[i];
			
			// Set 'j' equal to 'i'.
			j = i;
			
			// Count backwards starting at 'j' until a larger element is found.
			while((j > 0) && (aSubject[j - 1] > objElement))
			{
				// Move each element backwards one index and decrement 'j'.
				aSubject[j] = aSubject[--j];
			}
			
			// Place the element at index 'i' into index 'j'.
			aSubject[j] = objElement;
		}
		
		// Return the sorted version of the subject array.
		return aSubject;
	}
	
	// CreateIndexMap
	// 
	// 
	public static function CreateIndexMap(aA:Array, aB:Array):Array
	{
		// 
		var aC:Array = new Array();
		
		// 
		for(var i:Number = 0; i < aA.length; i++)
		{
			// 
			for(var j:Number = 0; j < aB.length; j++)
			{
				// 
				if(aA[i] == aB[j])
				{
					// 
					aC[i] = j;
					
					// 
					j = aB.length;
				}
			}
		}
		
		// 
		return aC;
	}
}