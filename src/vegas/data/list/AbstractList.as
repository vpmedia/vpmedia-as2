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

// FIXME bug with SimpleCollection inherit, for the moment i use AbstractCollection inherit !  

import vegas.data.Collection;
import vegas.data.collections.AbstractCollection;
import vegas.data.iterator.Iterator;
import vegas.data.iterator.ListIterator;
import vegas.data.iterator.ListItr;
import vegas.data.List;
import vegas.data.list.ArrayList;
import vegas.errors.IndexOutOfBoundsError;

/**
 * This class provides a skeletal implementation of the List interface to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class vegas.data.list.AbstractList extends AbstractCollection implements List 
{
	
	/**
	 * Creates a new AbstractList instance.
	 */
	public function AbstractList(ar:Array) 
	{
		super(ar) ;
	}

	/**
	 * Returns {@code true} if this collection contains the specified element.
	 * @return {@code true} if this collection contains the specified element.
	 */
	public function containsAll(c:Collection):Boolean 
	{
		var it:Iterator = c.iterator() ;
		while(it.hasNext()) 
		{
			if ( ! contains(it.next()) ) return false ;
		}
		return true ;
	}

	/**
	 * Indicates whether some other object is "equal to" this one.
	 */
	public function equals(o):Boolean 
	{
		return false ;
	}

	/**
	 * This method is used by the {@code ListItr} class only.
	 */
	public function getModCount():Number 
	{
		return _modCount ;
	}

    /**
     * Inserts the specified element at the specified position in this list (optional operation).
     * @param id index at which the specified element is to be inserted.
     * @param o element to be inserted.
     */
	public function insertAt(id:Number, o):Void 
	{
		if (id<0 || id>size()) throw new IndexOutOfBoundsError() ;
		_a.splice(id, 0, o) ;
	}

    /**
     * Appends all of the elements in the specified collection to the end of this list, in the order that they are returned by the specified collection's iterator.
     * The behavior of this operation is undefined if the specified collection is modified while the operation is in progress.  
     * @param c the elements to be inserted into this list.
     * @return {@code true} if this list changed as a result of the call.
     */
	public function insertAll(c:Collection):Boolean 
	{
		if (c.size() > 0) 
		{
			var it:Iterator = c.iterator() ;
			while(it.hasNext()) 
			{
				insert(it.next()) ;
			}
			return true ;
		}
		else 
		{
			return false ;
		}
	}

	/**
	 * Inserts all of the elements in the specified collection into this list at the specified position (optional operation).
	 */
	public function insertAllAt(id:Number, c:Collection):Boolean {
		if (id <0 || id > size()) return false ;
		var aC:Array = c.toArray() ;
		var aB = _a.slice(0, id) ;
		var aE = _a.slice(id) ;
		_a = aB.concat(aC, aE) ;
		return true ;
	}

    /**
     * Returns the index in this list of the last occurrence of the specified element, or -1 if the list does not contain this element.
     * @param o element to search for.
     * @return the index in this list of the last occurrence of the specified element, or -1 if the list does not contain this element.
     */
	public function lastIndexOf(o):Number 
	{
		var l:Number = _a.length ;
		while (--l > -1) 
		{
			if (_a[l] == o) return l ;
		}
		return -1 ;
	}

	/**
	 * Returns a list iterator of the elements in this list (in proper sequence).
	 * @return a list iterator of the elements in this list (in proper sequence).
	 */
	public function listIterator():ListIterator 
	{ 
		var li:ListIterator = new ListItr(this) ;
		var n:Number = arguments[0] ;
		if (typeof (n) == "number")
		{
			li.seek(n) ;
		}
		return li ;
	}

   
	/**
	 * Removes all elements defined in the specified Collection in the list.
	 * @return {@code true} if all elements are find and remove in the list.
	 */
	public function removeAll(c:Collection):Boolean 
	{
		var b:Boolean = false ;
		var it:Iterator = iterator() ;
		while (it.hasNext()) 
		{
			if ( c.contains(it.next()) ) 
			{
				it.remove() ;
				b = true ;
			}
		}
		return b ;
	}

    /**
     * Removes an element at the specified position in this list.
     * @param  id index of the element to be removed from the List.
     */
	public function removeAt(id:Number) 
	{
		return removesAt(id, 1) ;
	}

	/**
	 * Removes from this list all the elements that are contained between the specific {@code from} and the specific {@code to} position in this list (optional operation).
	 */
	public function removeRange(from:Number , to:Number):Void 
	{
		if (from == undefined) return ;
		var it:ListIterator = listIterator(from) ;
		var l:Number = to - from ;
		for (var i:Number = 0 ; i<l ; i++) 
		{
			it.next() ; 
			it.remove() ;
		}
	}

    /**
     * Removes the specified count of elements at the specified position in this list.
     * @param  id index of the first element to be removed from the List.
     * @return len the number of elements that was removed from the list.
     */
	public function removesAt(id:Number, len:Number) 
	{
		var d:Number = len - id ;
		var old = _a.slice(id, d) ;
		_a.splice(id, len);
		return old ; 
	}
	
	/**
	 * Retains only the elements in this list that are contained in the specified collection (optional operation).
	 */
	public function retainAll(c:Collection):Boolean {
		var b:Boolean = false ;
		var it:Iterator = iterator() ;
		while(it.hasNext()) {
			if ( ! c.contains(it.next()) ) {
				it.remove() ;
				b = true ;
			}
		}
		return b ;
	}

    /**
     * Replaces the element at the specified position in this list with the specified element.
     * @param id index of element to replace.
     * @param o element to be stored at the specified position.
     * @return the element previously at the specified position.
     */
	public function setAt(id:Number, o) 
	{
		if (_a[id] == undefined) 
		{
			return ;
		}
		_a[id] = o ;
	}

	/**
	 * Sets the modCount property of this list.
	 */
	public function setModCount(n:Number):Void 
	{
		_modCount = n ;
	}

	/**
	 * Returns a subList of the LinkedList. The subList is an ArrayList instance.
	 * @return a subList of the LinkedList. The subList is an ArrayList instance.
	 */
	public function subList(begin:Number, end:Number):List 
	{
		var l:List = new ArrayList() ;
		var it:ListIterator = listIterator() ;
		var d:Number = (end - begin) + 1 ; 
		for (var i:Number = begin ; i<= d ; i++) 
		{
			l.insert(it.next()) ;
		}
		return l ;
	}

	private var _modCount:Number = 0 ;
	
}