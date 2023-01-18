import gugga.utils.HashUtil;
import gugga.collections.IIterable;
import gugga.collections.IIterator;
import gugga.collections.ArrayList;
import gugga.collections.ArrayListIterator;
import gugga.collections.ISet;
/**
 * ObjectSet is collection of unique objects. 
 * You can search the collection for a certain object very fast.    
 * 
 * @see gugga.utils.HashUtil
 * 
 * @author stefan
 */
class gugga.collections.ObjectSet implements ISet
{
	/**
	 * Adds an element to the set and keeps it unique. 
	 * 
	 * @param Object to add to the set
	 */
	public function addElement(aElement:Object):Void
	{
		var hash : String = HashUtil.hash(aElement);
		this[hash] = aElement;
	}
	
	/**
	 * Performs check on the set for an object.
	 * 
	 * @param Object to search for
	 */
	public function containsElement(aElement:Object):Boolean
	{
		var hash : String = HashUtil.hash(aElement);
		return (this[hash] == aElement);
	}
	
	/**
	 * Returns an array containing all elements of the set.
	 */
	public function getAllElements():Array
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