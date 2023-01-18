/*
Class	Heap
Package	ch.data.tree
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	29 oct. 2005
*/

//import
import ch.util.Comparator;

/**
 * Manage a heap data structure.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		29 oct. 2005
 * @version		2.0
 */
class ch.data.tree.Heap
{
	//---------//
	//Variables//
	//---------//
	private var		_nodes:Array; //data of the heap
	private var		_comp:Comparator; //comparator
	private var		_index:Number; //the current index
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new empty Heap.
	 * <p>{@code comp} is the {@code Comparator} that
	 * will be used for the add/remove of the {@code Object}
	 * into the {@code Heap}.</p>
	 * 
	 * @param	comp	The {@code Comparator}.
	 * @throws	Error	If {@code comp} is {@code null}.
	 */
	public function Heap(comp:Comparator)
	{
		//check comp
		if (comp == null)
		{
			throw new Error(this+".<init> : comp is undefined");
		}
		
		//init
		_comp = comp;
		_nodes = [];
		_index = 1; //the index 0 is never used !
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the size of the {@code Heap}.
	 * 
	 * @return	The size.
	 */
	public function size(Void):Number
	{
		return _index-1;
	}
	
	/**
	 * Get the {@code Comparator} of the {@code Heap}.
	 * 
	 * @return	The {@code Comparator}.
	 */
	public function getComparator(Void):Comparator
	{
		return _comp;
	}
	
	/**
	 * Get an {@code Object} at the specified index.
	 * 
	 * @param	The index.
	 * @return	The {@code Object} at {@code index}.
	 * @throws	Error	If {@code index} is out of range.
	 */
	public function getObjectAt(index:Number):Object
	{
		if (index < 0 || index > size())
		{
			throw new Error(this+".getObjectAt : index is out of bounds");
		}
		
		return _nodes[index+1];
	}
	
	/**
	 * Get the index of an {@code Object} into the {@code Heap}.
	 * 
	 * @param	obj		The object.
	 * @return	The index of the object or -1.
	 * @throws 	Error	If {@code obj} is {@code null}.
	 */
	public function indexOf(obj:Object):Number
	{
		if (obj == null)
		{
			throw new Error(this+".indexOf : obj not defined");
		}
		
		for (var i:Number=0 ; i<_index ; i++)
		{
			if (_nodes[i] == obj)
			{
				return i-1;
			}
		}
		
		return -1;
	}
	
	/**
	 * Update the object at a specified index.
	 * 
	 * @param	index		The index to update.
	 * @throws	Error		If the index is invalid.
	 */
	public function updateObjectAt(index:Number):Void
	{
		if (index < 0 || index > size())
		{
			throw new Error(this+".updateObjectAt : invalid index ("+index+")");
		}
		
		//current object
		var current:Number = index+1;
		var obj:Object = _nodes[current];
		
		//push the object up & down
		if (current > 1 && _comp.compare(obj, _nodes[getParent(current)]) < 0)
		{
			pushUp(current, obj);
		}
		else
		{
			pushDown(current);
		}
	}
	
	/**
	 * Update an object into the {@code Heap}.
	 * <p>If {@code obj} is not in the {@code Heap}, nothing
	 * will append.</p>
	 * 
	 * @param	obj		The object to update.
	 */
	public function updateObject(obj:Object):Void
	{
		var ind:Number = indexOf(obj);
		
		if (ind == -1) return;
		
		updateObjectAt(ind);
	}
	
	/**
	 * Add an {@code Object} to the {@code Heap}.
	 * <p>The {@code Heap} will use the {@code Comparator}
	 * to compare {@code obj} to the inserted {@code Object},
	 * so the type of {@code obj} must be checked in the
	 * {@code Comparator}.<p>
	 * <p>In all cases, the {@code Object} who is the lower
	 * will be stand at the top of the {@code Heap}.</p>
	 * 
	 * @param	obj		The {@code Object} to add.
	 */
	public function addObject(obj:Object):Void
	{
		pushUp(_index++, obj);
	}
	
	/**
	 * Remove the top {@code Object} of the {@code Heap}.
	 * <p>After the removing, the {@code Heap} is updated
	 * to keep always the lower {@code Object} at the top.</p>
	 * <p>If there is no data in the {@code Heap}, {@code null} is
	 * returned.</p>
	 * 
	 * @return	The removed {@code Object}.
	 */
	public function removeObject(Void):Object
	{
		//check the size
		if (size() == 0)
		{
			return null;
		}
		
		//remove the top
		var removed:Object = _nodes[1];
		
		//set the last as the first
		_nodes[1] = _nodes[--_index]; 
		
		//push the object down
		pushDown(1);
		
		return removed;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the Heap instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.tree.Heap";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private function getParent(index:Number):Number
	{
		return Math.floor(index/2);
	}
	
	private function pushUp(index:Number, obj:Object):Void
	{
		var current:Number = index;
		
		//insert the object at the goot place
		while (current > 1)
		{
			//get the parent
			var parent:Number = getParent(current);
			
			//compare the objects
			var size:Number = _comp.compare(obj, _nodes[parent]);
			
			//if obj is lower than the parent
			//we switch
			if (size < 0)
			{
				_nodes[current] = _nodes[parent];
				current = parent;
			}
			//ok we stop here
			else
			{
				break;
			}
		}
		
		//init
		_nodes[current] = obj;
	}
	
	private function pushDown(index:Number):Void
	{
		var current:Number = index;
		
		//get the first child
		var child:Number = current*2;
		
		//update the heap
		while (child < _index)
		{
			//check if there is another one
			if (child < _index)
			{
				var child2:Number = child+1;
				if (_comp.compare(_nodes[child], _nodes[child2]) > 0)
				{
					//the child2 is lower than the first child
					child = child2;
				}
			}
			
			//compare the current node and 
			//the child
			if (_comp.compare(_nodes[current], _nodes[child]) > 0)
			{
				var temp:Object = _nodes[current];
				_nodes[current] = _nodes[child];
				_nodes[child] = temp;
				
				//index
				current = child;
				child *= 2;
			}
			//we can stop here
			else
			{
				break;
			}
		}
	}
}