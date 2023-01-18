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

/**
 * A simple representation of the {@code Collection} interface.
 * @author eKameleon
 */
class vegas.data.collections.SimpleCollection extends AbstractCollection 
{
	
	/**
	 * Creates a new SimpleCollection instance.
	 * @param ar an optional array to fill the collection.
	 */
	public function SimpleCollection( ar:Array ) 
	{
		super(ar) ;
	}

	/**
	 * Returns a shallow copy of this collection (optional operation).
	 * @return a shallow copy of this collection.
	 */
	public function clone() 
	{
		return new SimpleCollection( toArray() ) ;
	}
	
	/**
	 * Returns {@code true} if this collection contains all of the elements of the specified collection.
	 * @return {@code true} if this collection contains all of the elements of the specified collection.
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
	 * Appends all of the elements in the specified collection to the end of this Collection, in the order that they are returned by the specified collection's iterator (optional operation).
	 */
	public function insertAll(c:Collection):Boolean {
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
	 * Removes from this Collection all the elements that are contained in the specified Collection (optional operation).
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
	 * Retains only the elements in this Collection that are contained in the specified Collection (optional operation).
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