/**
 * @author todor
 */
class test_framework.collections.ArrayList extends Array
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
	
	public function removeAt(aIndex:Number)
	{
		if (0 <= aIndex && aIndex < this.length)
		{
			this.splice(aIndex, 1);
		}
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
}