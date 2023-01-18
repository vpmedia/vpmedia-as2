/**
*	@author Ralf Siegel
*	@deprecated will use standard classes if available
*/
interface logging.util.List
{
	/**
	* Adds the specified item to the list.
	*
	* @return true when the item was added successfully, otherwise false
	*/
	public function addItem(o:Object):Boolean;
	
	/**
	* Adds all items to the list.
	*
	* @return true when all items were added successfully, otherwise false
	*/
	public function addAll(list:List):Boolean;

	/**
	* Clear all items in the list
	*/	
	public function clear():Void;

	/**
	* Checks whether the given object is an item of that list
	*
	* @return true if the list contains the object		
	*/	
	public function containsItem(o:Object):Boolean;

	/**
	* Gets the item at the specified index
	*
	* @return the requested object
	*/	
	public function getItem(index:Number):Object;

	/**
	* Return the index number of a given list item
	*
	* @return the index
	*/	
	public function indexOf(o:Object):Number;

	/**
	* Checks whether the list is empty or not
	*
	* @return true if empty, otherwise false
	*/	
	public function isEmpty():Boolean;
	
	/**
	* Removes an item from the list
	*
	* @return true if the empty was removed successfully, otherwise false (e.g. because it didn't exist)
	*/	
	public function removeItem(o:Object):Boolean;
	
	/**
	* Returns the number of items in the list
	*
	* @return the number of items in the list
	*/
	public function size():Number;

	/**
	* Returns the list as array object
	*
	* @return an Array object
	*/	
	public function toArray():Array;	
}