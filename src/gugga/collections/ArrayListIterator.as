import gugga.collections.IIterator;
import gugga.debug.Assertion;
import gugga.collections.ArrayList;

/**
 * ArrayListIterator implements the common IIterator interface for iterating collections.
 * 
 * ArrayList is an Array and usually you should iterate over it using "for". This class allows 
 * abstract use of ArrayList where its type is not well known by the consumer in a polymorphic use.
 * 
 * ArrayListIterator iterates over a shallow copy of the ArrayList, which makes the iteration 
 * independent of the changes made on the ArrayList after the iterator is istantiated.
 * 
 * @see ArrayList
 * 
 * @author stefan 
 */
class gugga.collections.ArrayListIterator implements IIterator 
{
	private var mArrayList : ArrayList;
	private var mCurrent : Number;
	private var mIsValid : Boolean;
	public function get IsValid() : Boolean { return mIsValid; }
	
	/**
	 * Creates instances and sets the cursor to invalid in case the provided ArrayList is empty.    
	 * 
	 * @param ArrayList shallow copy to iterate over
	 */
	public function ArrayListIterator(aArrayList : ArrayList)
	{
		mArrayList = aArrayList;
		reset();
	}
	
	/**
	 * Resets the cursor to the first element and retains its invalid state in case the ArrayList resource is empty.
	 */
	public function reset()  : Void
	{
		mCurrent = -1;
		mIsValid = false;	
	}

	/**
	 * Moves the cursor one step forward and returns Boolean value indicating is it valid.
	 */
	public function iterate() : Boolean 
	{
		mCurrent++;
		
		mIsValid = !(mArrayList[mCurrent] == null || mArrayList[mCurrent] == undefined);
		
		return mIsValid;
	}

	/**
	 * Returns current item and throws exception in case it isn't valid. 
	 */
	public function current() : Object 
	{
		Assertion.failIfFalse(
				mIsValid, 
				"There is no valid value of the current item for index " + mCurrent, this, arguments);
				
		return mArrayList[mCurrent];
	}
	
	/**
	 * Getter for mCurrent.
	 */
	public function get Current() : Object 
	{
		return current();
	}
	
	/**
	 * Returns copy of the Iterator and resets cursor. 
	 */
	public function clone () : IIterator
	{
		return new ArrayListIterator(mArrayList.clone());
	}
}