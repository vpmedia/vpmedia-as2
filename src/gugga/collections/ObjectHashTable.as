import gugga.utils.HashUtil;
import gugga.collections.IHashTable;
import gugga.collections.IIterator;
import gugga.collections.ArrayListIterator;
import gugga.collections.ArrayList;

 /**
 * ObjectHashTable can be used to collect Object to Object pairs.
 * An unique hash is assigned to the key objects first time they get added to an ObjectHashTable collection.
 * 
 * Value objects may be of any type, while the key objects should be of Object type.
 * If you need a value type keys use a HashTable object instead.  
 * 
 * @see gugga.utils.HashUtil
 * 
 * @author stefan
 */ 
class gugga.collections.ObjectHashTable extends Object implements IHashTable
{
	/**
	 * Adds a key-value pair to the hash table.
	 * 
	 * @param Object, which is the key in the map. The Object key should be an instance of Object. 
	 * @param Object value, that is associated to the key. The Object value may be of any type. 
	 */
	public function add(aKey, aObject : Object) : Void
	{
		var hash : String = HashUtil.hash(aKey);
		this[hash] = aObject;
	}
	
	/**
	 * Removes a key-value pair from the hash table.
	 * This method will return undefined if you provide an incorrect key object.
	 * 
	 * @param Object key for the pair that should be removed 
	 */
	public function remove(aKey) : Object
	{
		var hash : String = HashUtil.hash(aKey);
		var result : Object = this[hash]; 
		delete this[hash];
		return result;
	}
	
	/**
	 * Checks if an object exists in the table.
	 * 
	 * @param Object searching for 
	 */
	public function containsValue(aObject:Object) : Boolean
	{		
		var result : Boolean = false;
		
		for(var hash : String in this)
		{
			if(this[hash] == aObject)
			{
				result = true;
			}
		}

		return result;
	}
	
	/**
	 * Checks if the table has a key with corresponding value.
	 * 
	 * @param Object key searching for 
	 */
	public function containsKey(aKey):Boolean
	{
		var hash : String = HashUtil.hash(aKey);
		
		var result:Boolean = false;
		if(this[hash] != undefined && this[hash] != null)
		{
			result = true;
		}
		
		return result;
	}
	
	/**
	 * Gets the key for an object.
	 * The key returned is not the original key object, but its hash.
	 * 
	 * @param Object value to find the key for
	 */
	public function getKeyByValue(aValue:Object):String
	{
		var result:String = null;
		for(var hash:String in this) 
		{
			if(this[hash] == aValue)
			{
				result = hash;
				break;
			}
		}
		return result;
	}
	
	/**
	 * Gets value from the table, specified by its key.
	 * 
	 * @param Object key for the value Object to return (if exists)
	 */
	public function getValue (aKey) : Object
	{
		var hash : String = HashUtil.hash(aKey);
		return this[hash];
	}
	
	/**
	 * Indicates whenever the table is empty.
	 */
	public function get IsEmpty():Boolean
	{
		for(var key:String in this) 
		{
			return false;
		}
		return true;
	}
	
	/**
	 * Counts the key-value pairs in the table.
	 */ 
	public function get count():Number
	{
		var itemsCount:Number = 0;
		for(var key:String in this)
		{
			itemsCount++;
		}
		return itemsCount;
	}
	
	/**
	 * Makes a shallow copy of itself.
	 */
	public function clone() : IHashTable
	{
		var result : ObjectHashTable = new ObjectHashTable();
		for (var key : String in this)
		{
			result.addWithStringKey(key, this[key]);
		}
		
		return result;
	}
	
	/**
	 * Adds an object to the table with a string key, instead of object key 
	 * 
	 *  @param String key for the value Object to add
	 *  @param Object to add
	 */
	private function addWithStringKey (aKey : String, aObject : Object) : Void
	{
		this[aKey] = aObject;
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