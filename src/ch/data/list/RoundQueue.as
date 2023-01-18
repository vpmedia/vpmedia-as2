/*
Class	RoundQueue
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 oct. 2005
*/


//import
import ch.data.list.DataNode;
import ch.data.list.List;

/**
 * FIFO data structure.
 * <p>That means the first {@link Object} you add
 * to the {@code Queue} will be the first to be removed when you
 * call the {@link #remove()} method.</p>
 * <p>The difference of this data structure with a simple {@link ch.data.list.Queue}
 * is that the first {@link DataNode} is linked to the last. It means that
 * if you use a {@link ch.data.list.ListIterator}, you can loop infinitely if you
 * are based on the {@link ch.data.list.ListIterator#next()} and
 * {@link ch.data.list.ListIterator#previous()} methods.</p>
 * <p>You can increase the speed of the class if you must transfer
 * very much times data tought different {@link List} with using
 * the {@link #addNode(DataNode)} and {@link #removeNode()} methods.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 oct. 2005
 * @version		1.0
 */
class ch.data.list.RoundQueue implements List
{
	//---------//
	//Variables//
	//---------//
	private var			_last:DataNode; //last node
	private var			_size:Number; //size
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new empty Queue.
	 */
	public function RoundQueue(Void)
	{
		_last = null;
		_size = 0;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the size of the {@code List}.
	 * <p>The size corresponds to the number of elements
	 * contained into the {@code List}.</p>
	 * 
	 * @return	The size.
	 */
	public function size(Void):Number
	{
		return _size;
	}
	
	/**
	 * Add an {@code Object} to the {@code List}.
	 * <p>The object is automatically converted to
	 * a {@code DataNode} and added via the
	 * {@link #addNode(DataNode)} method.</p>
	 * 
	 * @param	data	The {@code Object}.
	 */
	public function addObject(data:Object):Void
	{
		addNode(new DataNode(data));
	}
	
	/**
	 * Add a {@code DataNode} to the {@code List}.
	 * 
	 * @param	node	The {@code DataNode}.
	 */
	public function addNode(node:DataNode):Void
	{
		//check the size
		if (_size == 0)
		{
			_last = node;
			node.next = node;
			node.previous = node;
		}
		
		//insert the node
		var first:DataNode = _last.next;
		var prev:DataNode = _last;
		
		first.previous = node;
		node.next = first;
		prev.next = node;
		node.previous = prev;
		
		_last = node;
		
		//incrementing the size
		_size++;
	}
	
	/**
	 * Get the {@code Object} at the specified index.
	 * <p>This method use the {@link #getNodeAt(Number)} to
	 * retreive the data.</p>
	 * 
	 * @param	index	The index of the {@code Object}.
	 * @return	The {@code Object}.
	 */
	public function getObjectAt(index:Number):Object
	{
		return getNodeAt(index).getData();
	}
	
	/**
	 * Get the node at the specified index.
	 * 
	 * @param	index	The index of the {@code DataNode}.
	 * @return	The {@code DataNode}.
	 */
	public function getNodeAt(index:Number):DataNode
	{
		if (index < 0 || index >= size())
		{
			throw new Error(this+".getNodeAt : index is out of bounds");
		}
		
		var node:DataNode = getFirstNode();
		
		//loop back
		while (index > 0)
		{
			node = node.next;
			index--;
		}
		
		//return the node
		return node;
	}
	
	/**
	 * Remove an {@code Object} from the {@code List}.
	 * <p>The {@code Object} is issued from the {@code DataNode}
	 * returned by the {@link #removeNode()} method.</p>
	 * <p>The {@code Object} returned depending of the structure
	 * used by the {@code List} (FIFO, LIFO, ...)</p>
	 * <p>If the {@code List} is empty, {@code null} is returned.</p>
	 * 
	 * @return	The removed {@code Object} or {@code null}.
	 */
	public function removeObject(Void):Object
	{
		return (_size == 0) ? null : removeNode().getData();
	}
	
	/**
	 * Remove a {@code DataNode} from the {@code List}.
	 * <p>The {@code DataNode} returned depending of the structure
	 * used by the {@code List} (FIFO, LIFO, ...)</p>
	 * <p>If the {@code List} is empty, {@code null} is returned.</p>
	 * 
	 * @return	The removed {@code DataNode}.
	 */
	public function removeNode(Void):DataNode
	{
		//check the size
		if (_size == 0)
		{
			return null;
		}
		
		//remove
		var removed:DataNode = getFirstNode();
		
		//if there is only one node
		if (_size == 1)
		{
			_last = null;
		}
		else
		{
			var first:DataNode = removed.next;
			var prev:DataNode = removed.previous;
			
			first.previous = prev;
			prev.next = first;
		}
		
		//clear the data
		removed.next = null;
		removed.previous = null;
		
		//decrementing the size
		_size--;
		
		return removed;
	}
	
	/**
	 * Get the first {@code DataNode} of the {@code List}.
	 * 
	 * @return	The first {@code DataNode}.
	 */
	public function getFirstNode(Void):DataNode
	{
		return _last.next;
	}
	
	/**
	 * Get the last {@code DataNode} of the {@code List}.
	 * 
	 * @return	The last {@code DataNode}.
	 */
	public function getLastNode(Void):DataNode
	{
		return _last;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the Queue instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.list.Queue";
	}
}