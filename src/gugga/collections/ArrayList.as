import gugga.collections.IIterable;
import gugga.collections.IIterator; 
import gugga.collections.ArrayListIterator;
/**
 * @author todor
 */
class gugga.collections.ArrayList extends Array implements IIterable
{
	public function addItem(aValue):Void
	{
		this.push(aValue);
	}

	public function addAll(aArray:Array):Void
	{
		for(var i:Number = 0; i < aArray.length; i++)
		{
			addItem(aArray[i]);
		}
	}
	
	public function removeItem(aValue):Void
	{
		var itemIndex:Number = indexOf(aValue);
		if(itemIndex != -1)
		{
			this.splice(itemIndex, 1);
		}
	}
	
	public function removeAt(aIndex:Number) : Object
	{
		var result : Object = null;
		if (0 <= aIndex && aIndex < this.length)
		{
			result = this[aIndex];
			this.splice(aIndex, 1);
		}
		
		return result;
	}
	
	public function containsItem(aValue):Boolean
	{
		var itemIndex:Number = indexOf(aValue);
		
		if(itemIndex == -1)
		{
			return false;
		}
		
		return true;
	}
	
	public function indexOf(aValue):Number
	{
		var result:Number = -1;
		for(var i:Number = 0; i < this.length; i++)  
		{
			if(this[i] == aValue)
			{
				result = i;
				break;
			}
		}
		return result;
	}
	
	public function isEmpty(aValue):Boolean
	{
		if(this.length <= 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	public function getItem(aIndex:Number)
	{
		return this[aIndex];
	}
	
	public function clone() : ArrayList
	{
		var result : ArrayList = new ArrayList();
		result.addAll(this);
		return result;
	}
	
	/**
	 * Returns an ArrayListIterator provided with a shallow copy of the ArrayList. 
	 * Once you get the iterator its independent of the changes made on the ArrayList.
	 * 
	 * Iterating over a shallow copy of the list makes the iteration much more robust, 
	 * but it still doesn't protect you from accessing an empty reference in case you 
	 * completely destroy an object refered by an ArrayList item after the iterator is instantiated.         
	 */
	public function getIterator() : IIterator
	{
		var iterator : IIterator = new ArrayListIterator(this.clone());
		return iterator;
	}	
}