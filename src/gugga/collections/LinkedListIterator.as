import gugga.collections.IIterator;
import gugga.collections.LinkedListItem;
import gugga.debug.Assertion;

/**
 * @author Todor Kolev
 */
class gugga.collections.LinkedListIterator implements IIterator 
{
	private var mCurrentItem : LinkedListItem;
	private var mStartItem : LinkedListItem;
	
	private var mIsValid : Boolean = false;
	public function get IsValid() : Boolean { return mIsValid; }
	
	public function LinkedListIterator(aStartItem : LinkedListItem)
	{
		mStartItem = aStartItem;
		reset();
	}
	
	public function reset() : Void
	{
		mCurrentItem = new LinkedListItem();
		mCurrentItem.NextItem = mStartItem;
		
		mIsValid = false;
	}

	public function iterate() : Boolean 
	{
		mCurrentItem = mCurrentItem.NextItem;
		
		if(mCurrentItem)
		{	
			mIsValid = true;
			return true;
		}
		else
		{
			mIsValid = false;
			return false;
		}
	}

	public function current() : Object 
	{
		Assertion.failIfFalse(
				mIsValid, 
				"There is no valid value of the current item", this, arguments);
		return mCurrentItem.Data;
	}
	
	public function get Current() : Object 
	{
		return current();
	}
	
	public function get CurrentListItem() : LinkedListItem 
	{
		Assertion.failIfFalse(
				mIsValid, 
				"There is no valid current item", this, arguments);
		return mCurrentItem;
	}
}