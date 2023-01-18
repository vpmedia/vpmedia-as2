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

import vegas.data.Collection;
import vegas.data.collections.AbstractCollection;
import vegas.data.iterator.Iterator;
import vegas.data.Set;

/**
 * This class provides a skeletal implementation of the Set interface to minimize the effort required to implement this interface.
 * A collection that contains no duplicate elements.
 * @author eKameleon
 */
class vegas.data.set.AbstractSet extends AbstractCollection implements Set 
{

	/**
	 * Creates a new AbstractSet instance.
	 */
	private function AbstractSet(ar) 
	{
		super(ar);
	}
	
	/**
	 * Returns {@code true} if this set contains all of the elements of the specified collection.
	 * @return {@code true} if this set contains all of the elements of the specified collection.
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
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean 
	{
		if (o == this) return true ;
		if ( ! (o instanceof Set) ) 
		{
			return false ;
		}
		var c:Collection = Collection(o) ;
		if (c.size() != size()) return false ;
		return this.containsAll(c) ;
	}

	/**
	 * Appends all of the elements in the specified collection to the end of this Set, in the order that they are returned by the specified collection's iterator (optional operation).
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
	 * Removes from this Set all the elements that are contained in the specified Collection (optional operation).
	 */
	public function removeAll(c:Collection):Boolean 
	{
		var b:Boolean = false ;
		if (size() > c.size()) 
		{
			var it:Iterator = c.iterator() ;
			while (it.hasNext()) 
			{
				b = remove(it.next()) ;
			}
		} 
		else 
		{
			var it:Iterator = iterator() ;
			while (it.hasNext()) 
			{
				if (c.contains(it.next())) 
				{
					it.remove() ;
					b = true ;
				}
			}
			
		}
		return b ;
	}

	/**
	 * Retains only the elements in this Set that are contained in the specified Collection (optional operation).
	 */
	public function retainAll(c:Collection):Boolean 
	{
		var b:Boolean = false ;
		var it:Iterator = iterator() ;
		while(it.hasNext()) 
		{
			if ( ! c.contains(it.next()) ) 
			{
				it.remove() ;
				b = true ;
			}
		}
		return b ;
	}
}