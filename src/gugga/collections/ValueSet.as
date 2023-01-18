import gugga.collections.IIterable;
import gugga.collections.IIterator;
import gugga.collections.ArrayList;
import gugga.collections.ArrayListIterator;
import gugga.collections.ISet;
/**
 * @author Barni
 */
class gugga.collections.ValueSet implements ISet
{
	public function addElement(aElement:String):Void
	{
		this[aElement] = null;
	}
	
	public function containsElement(aElement:String):Boolean
	{
		return (this[aElement] === null);	
	}
	
	public function getAllElements():Array
	{
		var result:Array = new Array();
		for (var i : String in this) 
		{
			result.push(i);
		}
		
		return result;
	}
	
	public function getIterator () : IIterator
	{
		var list : ArrayList = new ArrayList();
		list.addAll(this.getAllElements());
		return new ArrayListIterator(list);
	}
}