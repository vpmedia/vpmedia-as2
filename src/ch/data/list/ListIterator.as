/*
Class	ListIterator
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 oct. 2005
*/

//import
import ch.data.list.DataNode;
import ch.data.list.List;

/**
 * Navigator of List.
 * <p>This class may be used to iterate tought a {@link List}. The
 * state of the {@link List} is not verified, so during your iteration
 * be careful to not remove data to keep your {@code ListIterator}
 * synchronized with your {@code List}.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 oct. 2005
 * @version		1.0
 */
class ch.data.list.ListIterator
{
	//---------//
	//Variables//
	//---------//
	private var			_source:List; //list
	private var			_currentIndex:Number; //current index
	private var			_currentNode:DataNode; //current node
	private var			_modeAdvance:Boolean; //mode
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ListIterator.
	 * <p>If {@code source} is {@code null}, an {@code Error}
	 * is thrown.</p>
	 * 
	 * @param	source	The {@code List} source.
	 * @throws	Error	If {@code source} is {@code null}.
	 */
	public function ListIterator(source:List)
	{
		//check if the source exists
		if (source == null)
		{
			throw new Error(this+".<init> : source is undefined");
		}
		
		_source = source;
		_currentIndex = -1;
		_currentNode = null;
		_modeAdvance = true;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the source of the {@code ListIterator}.
	 * 
	 * @return	The {@code List} source.
	 */
	public function getSource(Void):List
	{
		return _source;
	}
	
	/**
	 * Get the current index.
	 * <p>If the {@link #next()} method has not been
	 * called, -1 will be returned.</p>
	 * 
	 * @return	The current index or -1.
	 */
	public function getCurrentIndex(Void):Number
	{
		return _currentIndex;
	}
	
	/**
	 * Get the current {@code DataNode}.
	 * <p>If the {@link #next()} method has not been
	 * called, {@code null} will be returned.</p>
	 * 
	 * @return	The current node or {@code null}.
	 */
	public function getCurrentNode(Void):DataNode
	{
		return _currentNode;
	}
	
	/**
	 * Get if there is another {@code DataNode} after
	 * the current one.
	 * 
	 * @return	{@code true} if the {@link #next()} method can be called.
	 */
	public function hasNext(Void):Boolean
	{
		return ((_currentIndex == -1 && _source.size() > 0) || (_currentIndex > -1 && _currentNode.next != null));
	}
	
	/**
	 * Get if there is another {@code DataNode} before
	 * the current one.
	 * 
	 * @return	{@code true} if the {@link #previous()} method can be called.
	 */
	public function hasPrevious(Void):Boolean
	{
		return (_currentIndex > -1 && _currentNode.previous != null);
	}
	
	/**
	 * Get the next available index.
	 * <p>If the {@link #hasNext()} method returns {@code false},
	 * then the size of the {@code List} -1 is returned.</p>
	 * 
	 * @return	The next available index.
	 */
	public function nextIndex(Void):Number
	{
		return (hasNext()) ? _currentIndex+1 : _currentIndex;
	}
	
	/**
	 * Iterate to the next {@code DataNode}.
	 * <p>The {@code Object} returned is the data contained
	 * into the new {@code DataNode}.</p>
	 * <p>If there is no more {@code DataNode}, an {@code Error}
	 * is thrown.</p>
	 * 
	 * @return	The {@code Object} of the new {@code DataNode}.
	 * @throws	Error	If {@link #hasNext()} is {@code false}.
	 */
	public function next(Void):Object
	{
		//check the mode
		if (_modeAdvance)
		{
			//get the next index
			_currentIndex = nextIndex();
			
			//check if we can occurate
			if (_currentIndex > -1)
			{
				_currentNode = (_currentIndex == 0) ? _source.getFirstNode() : _currentNode.next;
				return _currentNode.getData();
			}
			
			//error
			throw new Error(this+".next : no such element");
		}
		
		//switch the mode
		_modeAdvance = true;
		return _currentNode.getData();
	}
	
	/**
	 * Get the previous available index.
	 * <p>If the {@link #hasPrevious()} method returns {@code false},
	 * then the size of the {@code List} -1 is returned.</p>
	 */
	public function previousIndex(Void):Number
	{
		var index:Number = _currentIndex;
		
		//if there is no more node
		if (!hasPrevious())
		{
			return index;
		}
		
		//decrement the index
		index--;
		
		return (index < 0) ? _source.size()-1 : index;
	}
	
	/**
	 * Iterate to the previous {@code DataNode}.
	 * <p>The {@code Object} returned is the data contained
	 * into the new {@code DataNode}.</p>
	 * <p>If there is no previous {@code DataNode} or the {@link #next()}
	 * method hasn't be called, an {@code Error} is thrown.</p>
	 * 
	 * @return	The {@code Object} of the new {@code DataNode}.
	 * @throws	Error	If {@link #hasPrevious()} is {@code false} or
	 * 					if {@link #next()} hasn't be called.
	 */
	public function previous(Void):Object
	{
		//check the mode
		if (!_modeAdvance)
		{
			//get the previous index
			_currentIndex = previousIndex();
			
			if (_currentIndex > -1)
			{
				_currentNode = _currentNode.previous;
				return _currentNode.getData();
			}
			
			//error
			throw new Error(this+".previous : no such element");
		}
		
		//check if we iterate already one time
		if (_currentIndex == -1)
		{
			throw new Error(this+".previous : no such element");
		}
		
		//ok switch the mode
		_modeAdvance = false;
		return _currentNode.getData();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ListIterator instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.list.ListIterator";
	}
}