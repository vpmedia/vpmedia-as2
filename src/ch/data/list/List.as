/*
Class	List
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 oct. 2005
*/

//imports
import ch.data.list.DataNode;

/**
 * Represents a data structure.
 * <p>If you want to iterate on you data, you can
 * use a {@link ch.data.list.ListIterator}.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 oct. 2005
 * @version		1.0
 */
interface ch.data.list.List
{
	/**
	 * Get the size of the {@code List}.
	 * <p>The size corresponds to the number of elements
	 * contained into the {@code List}.</p>
	 * 
	 * @return	The size.
	 */
	public function size(Void):Number;
	
	/**
	 * Add an {@code Object} to the {@code List}.
	 * <p>The object is automatically converted to
	 * a {@code DataNode} and added via the
	 * {@link #addNode(DataNode)} method.</p>
	 * 
	 * @param	data	The {@code Object}.
	 */
	public function addObject(data:Object):Void;
	
	/**
	 * Add a {@code DataNode} to the {@code List}.
	 * 
	 * @param	node	The {@code DataNode}.
	 */
	public function addNode(node:DataNode):Void;
	
	/**
	 * Get the {@code Object} at the specified index.
	 * 
	 * @param	index	The index of the {@code Object}.
	 * @return	The {@code Object}.
	 */
	public function getObjectAt(index:Number):Object;
	
	/**
	 * Get the node at the specified index.
	 * 
	 * @param	index	The index of the {@code DataNode}.
	 * @return	The {@code DataNode}.
	 */
	public function getNodeAt(index:Number):DataNode;
	
	/**
	 * Remove an {@code Object} from the {@code List}.
	 * <p>The {@code Object} is issued from the {@code DataNode}
	 * returned by the {@link #removeNode()} method.</p>
	 * <p>The {@code Object} returned depending of the structure
	 * used by the {@code List} (FIFO, LIFO, ...)</p>
	 * <p>If the {@code List} is empty, {@code null} is returned.</p>
	 * 
	 * @return	The removed {@code Object}.
	 */
	public function removeObject(Void):Object;
	
	/**
	 * Remove a {@code DataNode} from the {@code List}.
	 * <p>The {@code DataNode} returned depending of the structure
	 * used by the {@code List} (FIFO, LIFO, ...)</p>
	 * <p>If the {@code List} is empty, {@code null} is returned.</p>
	 * 
	 * @return	The removed {@code DataNode}.
	 */
	public function removeNode(Void):DataNode;
	
	/**
	 * Get the first {@code DataNode} of the {@code List}.
	 * 
	 * @return	The first {@code DataNode}.
	 */
	public function getFirstNode(Void):DataNode;
}