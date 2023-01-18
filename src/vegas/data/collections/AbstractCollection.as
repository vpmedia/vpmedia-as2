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
import vegas.core.ICloneable;
import vegas.data.Collection;
import vegas.data.collections.CollectionFormat;
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.util.serialize.Serializer;

/**
 * This class provides a skeletal implementation of the {@code Collection} interface, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class vegas.data.collections.AbstractCollection extends CoreObject implements Collection, ICloneable, Iterable 
{
	
	/**
	 * Creates a new AbstractCollection.
	 * @param ar (optional) an array to fill the collection.
	 */
	private function AbstractCollection(ar:Array) 
	{
		if(ar.length > 0) 
		{
			_a = [].concat(arguments[0]) ;
		}
		else 
		{
			_a = [] ;
		}
	}
	
	/**
	 * Removes all of the elements from this collection (optional operation).
	 */
	public function clear():Void 
	{ 
		_a.splice(0) ;
	}
	
	/**
	 * Returns a shallow copy of this collection (optional operation).
	 * <p>Overrides this method in the concrete class.</p>
	 */
	public function clone() 
	{
		return null ;
	}
	
	/**
	 * Returns {@code true} if this collection contains the specified element.
	 * @return {@code true} if this collection contains the specified element.
	 */
	public function contains(o):Boolean 
	{ 
		return indexOf(o) >- 1  ;
	}

	/**
	 * Returns the element from this collection at the passed index.
	 * @return the element from this collection at the passed index.
	 */
	public function get(id:Number) 
	{ 
		return _a[id] ;
	}
	
	/**
	 * Returns the index of an element in the collection.
	 * @return the index of an element in the collection.
	 */
	public function indexOf(o):Number 
	{
		var l:Number = _a.length ;
		for (var i:Number = 0 ; i<l ; i++) 
		{
			if (_a[i] == o) return i ;
		}
		return -1 ; 
	}

	/**
	 * Inserts an element in the collection.
	 */
	public function insert(o):Boolean 
	{
		if (o == undefined) 
		{
			return false ;
		}
		_a.push(o);
		return true ;
	}

	/**
	 * Returns {@code true} if this collection contains no elements.
	 * @return {@code true} if this collection contains no elements.
	 */
	public function isEmpty():Boolean 
	{ 
		return _a.length == 0 ;
	}

	/**
	 * Returns an iterator over the elements in this collection.
	 * @return an Iterator over the elements in this collection.
	 * @see Iterator
	 * @see Iterable
	 */
	public function iterator():Iterator 
	{ 
		return new ArrayIterator(_a) ;
	}

	/**
	 * Removes a single instance of the specified element from this collection, if it is present (optional operation).
	 */
	public function remove(o):Boolean 
	{
		var it:Iterator = iterator() ;
		if (o == null) 
		{
			while(it.hasNext()) 
			{
				if (it.next() == null) 
				{
					it.remove() ;
					return true ;
				}
			}
		}
		else 
		{
			while (it.hasNext()) 
			{
				if (o == it.next() ) 
				{
					it.remove() ;
					return true ;
				}
			}
		}
		return false ;
	}

	/**
	 * Returns the number of elements in this collection.
	 * @return the number of elements in this collection.
	 */
	public function size():Number 
	{ 
		return _a.length ;
	}

	/**
	 * Returns an array containing all of the elements in this collection.
	 * @return an array containing all of the elements in this collection.
	 */
	public function toArray():Array 
	{ 
		return _a.concat() ;
	}

	/**
	 * Returns a Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return Serializer.getSourceOf(this, [Serializer.toSource(_a)]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return (new CollectionFormat()).formatToString(this) ;
	}

	/**
	 * The internal array of the collection.
	 */	
	private var _a:Array ;

}