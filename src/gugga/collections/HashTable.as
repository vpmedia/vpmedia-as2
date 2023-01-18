import gugga.collections.IHashTable;
import gugga.collections.IIterator;
import gugga.collections.ArrayList;
import gugga.collections.ArrayListIterator;
/**
 * @author todor
 */
class gugga.collections.HashTable extends Object implements IHashTable
{
	public function add(aKey, aValue : Object) : Void
	{
		this[aKey] = aValue;
	}
	
	public function remove(aKey) : Object
	{
		var result : Object = this[aKey]; 
		delete this[aKey];
		return result;
	}
	
	public function containsValue(aValue:Object):Boolean
	{
		var result:Boolean = false;
		for(var key:String in this) 
		{
			if(this[key] == aValue)
			{
				result = true;
				break;
			}
		}
		return result;
	}
	
	public function containsKey(aKey):Boolean
	{
		var result:Boolean = false;
		if(this[aKey] != undefined && this[aKey] != null)
		{
			result = true;
		}
		
		return result;
	}
	
	public function getKeyByValue(aValue:Object):String
	{
		var result:String = null;
		for(var key:String in this) 
		{
			if(this[key] == aValue)
			{
				result = key;
				break;
			}
		}
		return result;
	}
	
	public function getValue (aKey) : Object 
	{
		return this[aKey];	
	} 
	
	public function get IsEmpty():Boolean
	{
		for(var key:String in this) 
		{
			return false;
		}
		return true;
	}
	
	public function get count():Number
	{
		var itemsCount:Number = 0;
		for(var key:String in this)
		{
			itemsCount++;
		}
		return itemsCount;
	}
	
	public function clone() : IHashTable
	{
		var result : HashTable = new HashTable();
		for (var key : String in this)
		{
			result.add(key, this[key]);
		}
		
		return result;
	}
	
	/**
	 * Returns an array containing all elements of the set.
	 */
	private function getAllElements() : Array
	{
		var result:Array = new Array();
		for (var i : String in this) 
		{
			result.push(this[i]);
		}
		
		return result;
	}
	
	/**
	 * Returns an iterator for the value objects of the table.
	 */
	public function getIterator () : IIterator
	{
		var list : ArrayList = new ArrayList();
		list.addAll(this.getAllElements());
		return new ArrayListIterator(list);	
	}
}