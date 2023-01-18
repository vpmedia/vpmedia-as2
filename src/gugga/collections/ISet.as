import gugga.collections.IIterator;
import gugga.collections.IIterable;
/**
 * @author stefan
 */
interface gugga.collections.ISet extends IIterable
{
	public function addElement(aElement:Object):Void;
	
	public function containsElement(aElement:Object):Boolean;
	
	public function getAllElements():Array;
}