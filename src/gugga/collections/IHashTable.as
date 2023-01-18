import gugga.collections.IIterable;
/**
 * @author stefan
 */
interface gugga.collections.IHashTable extends IIterable
{
	public function add(aKey, aObject : Object) : Void;
	
	public function remove(aKey) : Object;
	
	public function containsValue(aObject : Object) : Boolean;
	
	public function containsKey(aKey) : Boolean;
	
	public function getKeyByValue(aValue : Object) : String;
	
	public function getValue (aKey) : Object; 
	
	public function clone() : IHashTable;
}