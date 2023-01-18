/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.data.iterator.ListIterator;
import vegas.data.list.LinkedList;
import vegas.data.list.LinkedListEntry;
import vegas.errors.ConcurrentModificationError;
import vegas.errors.IllegalArgumentError;
import vegas.errors.IllegalStateError;
import vegas.errors.IndexOutOfBoundsError;
import vegas.errors.NoSuchElementError;
import vegas.errors.UnsupportedOperation;

/**
 * Converts a {@code LinkedList} to a specific {@code ListIterator}.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.data.iterator.LinkedListIterator ;
 * import vegas.data.list.LinkedList ;
 * 
 * var list:LinkedList = new LinkedList() ;
 * list.insert("item1") ;
 * list.insert("item2") ;
 * list.insert("item3") ;
 * var it:LinkedListIterator = LinkedListIterator( list.listIterator(2) ) ;
 * trace(it.hasPrevious() + " : " + it.previous()) ; // true : item2
 * }
 * @author eKameleon
 */
class vegas.data.iterator.LinkedListIterator extends CoreObject implements ListIterator
{

	/**
	 * Creates a new LinkedListIterator instance.
	 */
	function LinkedListIterator( index:Number , list:LinkedList )
	{
		
		if (list == null)
		{
			throw new IllegalArgumentError(this + " constructor failed, the list passed in argument not must be 'null' or 'undefined'.") ;	
		}
		
		this._list = list ;
		
		seek(index) ;
		
	}

	/**
	 * This method check the comodification of the LinkedList and test if the iterator is valid and can continue to process.
	 */
	public function checkForComodification() 
	{
	    if ( this._list.getModCount() != this._expectedModCount )
	    {
			throw new ConcurrentModificationError(this + " check for comodification failed with a LinkedList." ) ;
		}
    }

	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iteration has more elements.
	 */	
	public function hasNext():Boolean 
	{
		return this._nextIndex != this._list.size() ;
	}

	/**
	 * Checks to see if there is a previous element that can be iterated to.
	 * <p><b>Example :</b></p>
	 * {@code
	 * var list:LinkedList = new LinkedList() ;
	 * list.insert("item1") ;
	 * list.insert("item2") ;
	 * list.insert("item3") ;
	 * var it:ListIterator = list.listIterator(2) ;
	 * trace( it.hasPrevious() ) ;
	 * }
	 */
	public function hasPrevious():Boolean 
	{
		 return this._nextIndex != 0 ;
	}

	/**
	 * Inserts the specified element into the list (optional operation).
	 * <p><b>Example :</b></p>
	 * {@code
	 * var list:LinkedList = new LinkedList() ;
	 * list.insert("item1") ;
	 * list.insert("item2") ;
	 * list.insert("item3") ;
	 * 
	 * var it:ListIterator = list.listIterator(1) ;
	 * it.insert("item0") ;
	 * 
	 * trace(list) ;
	 * }
	 * <p><b>Attention :</b> Dont' use this method in a loop with hasPrevious() and previous() method.</p> 
	 */
	public function insert( o ):Void 
	{
	    this.checkForComodification();
	    this._lastReturned = this._list.getHeader() ;
	    this._list._insertBefore(o, this._next) ;
	    this._nextIndex ++ ;
	    this._expectedModCount ++ ;
	}

	/**
	 * Unsupported operation in this iterator, uses nextIndex() and previousIndex() method.
	 * @throws UnsupportedOperation if the user call this method, this method is unsupported.
	 */
	public function key() 
	{
		throw new UnsupportedOperation(this + " 'key' method is unsupported.") ;
		return null ;
	}

	/**
	 * Returns the next element in the iteration.
	 * @return the next element in the iteration.
	 */
	public function next() 
	{
		this.checkForComodification();
		
	    if ( this._nextIndex == this._list.size() )
	    {
			throw new NoSuchElementError(this + " 'next' method failed.");
	    }

	    this._lastReturned = this._next ;
	   this. _next = this._next.next ;
	    this._nextIndex ++ ;
	    
	    return this._lastReturned.element ;
	}

	/**
	 * Returns the index of the element that would be returned by a subsequent call to next.
	 * @return the index of the element that would be returned by a subsequent call to next.
	 */
	public function nextIndex() : Number 
	{
		return this._nextIndex ; 
	}

	/**
	 * Returns the previous element in the collection.
	 * @return the previous element in the collection.
	 */
	public function previous() 
	{
	    if (this._nextIndex == 0)
	    {
			throw new NoSuchElementError(this + " 'previous' method failed.");
	    }

	   	this._lastReturned = this._next = this._next.previous ;
	    this._nextIndex-- ;
	    this.checkForComodification();
	    return this._lastReturned.element ;
	}

	/**
	 * Returns the index of the element that would be returned by a subsequent call to previous.
	 * @return the index of the element that would be returned by a subsequent call to previous.
	 */
	public function previousIndex() : Number 
	{
		return this._nextIndex - 1 ;
	}

	/**
	 * Removes from the underlying collection the last element returned by the iterator (optional operation).
	 */
	public function remove() 
	{
		this.checkForComodification() ;
        var lastNext:LinkedListEntry = this._lastReturned.next;
		try 
		{
           this._list._removeEntry( this._lastReturned ) ;
        }
        catch ( e:NoSuchElementError ) 
        {
			throw new IllegalStateError( this + " 'remove' method failed.") ;
		}
	    if ( this._next == this._lastReturned)
	    {
			this._next = lastNext ;
	    }
		else
		{
			this._nextIndex-- ;
		}
	    this._lastReturned = this._list.getHeader() ;
	    this._expectedModCount++;
	}

	/**
	 * Reset the internal pointer of the iterator (optional operation).
	 */
	public function reset() : Void 
	{
		seek(0) ;
	}

	/**
	 * Change the position of the internal pointer of the iterator (optional operation).
	 */
	public function seek(n:Number) : Void 
	{

		this._lastReturned = this._list.getHeader() ;
		
		this._expectedModCount = this._list.getModCount() ;

		var size:Number = _list.size() ;
		
		if (n < 0 || n > size)
	    {
	    	throw new IndexOutOfBoundsError(this + " seek failed, index:" + n + ", size:" + size + "." ) ;
	    }
		
		if ( n < ( size >> 1 ) ) 
	    {
			
			_next = _list.getHeader().next ;
			
			for ( _nextIndex = 0 ; _nextIndex < n ; _nextIndex ++ )
			{
			    _next = _next.next ;
			}
	    } 
	    else 
	    {
			_next = _list.getHeader()  ;
			for ( _nextIndex = size ; _nextIndex > n ; _nextIndex-- )
			{
				_next = _next.previous ;
			}
		}
	}

	/**
	 * Replaces the last element returned by next or previous with the specified element (optional operation).
	 */
	public function set( o ):Void 
	{
		
		if (_lastReturned == _list.getHeader())
		{
			throw new IllegalStateError(this + " 'set' method failed.");
		}
	    
	    this.checkForComodification();
	    this._lastReturned.element = o ;
	    
	}

	/**
	 * The last list entry returned.
	 */
	private var _lastReturned:LinkedListEntry = null ;
	
	/**
	 * The list reference of this iterator.
	 */
	private var _list:LinkedList = null ;
	
	/**
	 * The next entry.
	 */
	private var _next:LinkedListEntry = null ;
	
	/**
	 * The next index in the iterator.
	 */
	private var _nextIndex:Number = null ;
	
	/**
	 * The internal expected mod count value.
	 */
	private var _expectedModCount:Number = null ;

}