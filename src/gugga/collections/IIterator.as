import gugga.collections.LinkedListItem;

/**
 * @author Todor Kolev
 */
interface gugga.collections.IIterator 
{
	public function reset() : Void;
	public function iterate() : Boolean;
	public function current() : Object;
}