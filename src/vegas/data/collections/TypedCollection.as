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

import vegas.core.ICloneable;
import vegas.data.Collection;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.errors.IllegalArgumentError;
import vegas.util.AbstractTypeable;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * TypedCollection is a wrapper for Collection instances that ensures that only values of a specific type can be added to the wrapped collection.
 * @author eKameleon
 */
class vegas.data.collections.TypedCollection extends AbstractTypeable implements ICloneable, Iterable, Collection 
{

	/**
	 * Creates a new TypedCollection.
	 * @throws IllegalArgumentError if the specified collection in argument is {@code null} or {@code undefined} 
	 */
	public function TypedCollection(p_type:Function , co:Collection) 
	{
		super(p_type) ;
		if (!co) 
		{
			throw new IllegalArgumentError("Argument 'co' must not be 'null' or 'undefined'.") ;
		}
		if (co.size() > 0) 
		{
			var it:Iterator = co.iterator() ;
			while ( it.hasNext() ) 	validate(it.next()) ;
		}
		_co = co ;
	}

	/**
	 * Removes all of the elements from this collection (optional operation).
	 */
	public function clear():Void 
	{
		_co.clear() ;
	}
	
	/**
	 * Returns a shallow copy of this collection.
	 * @return a shallow copy of this collection.
	 */
	public function clone() 
	{
		return new TypedCollection(getType(), _co.clone()) ;
	}

	/**
	 * Returns {@code true} if this collection contains the specified element.
	 * @return {@code true} if this collection contains the specified element.
	 */
	public function contains(o):Boolean 
	{
		return _co.contains(o) ;
    }

	/**
	 * Returns the element from this collection at the passed index.
	 */
	public function get(id:Number) 
	{
		return _co.get(id) ;
	}

	/**
	 * Inserts an elements into the Collection.
	 */
    public function insert(o):Boolean 
    {
		validate(o) ;
		return _co.insert(o) ;
    }

	/**
	 * Returns {@code true} if this collection contains no elements.
	 * @return {@code true} if the collection is empty else {@code false}.
	 */
	public function isEmpty():Boolean 
	{
		return _co.isEmpty() ;
	}

	/**
	 * Returns an iterator over the elements in this collection.
	 * @return an iterator over the elements in this collection.
	 */
	public function iterator():Iterator 
	{
		return _co.iterator() ;
	}

	/**
	 * Removes a single instance of the specified element from this collection, if it is present (optional operation).
	 */
    public function remove(o):Boolean 
    {
		return _co.remove(o);
    }

	/**
	 * Sets the type of the ITypeable object.
	 */
	public function setType(type:Function):Void 
	{
		super.setType(type) ;
		_co.clear() ;
	}

	/**
	 * Returns the number of elements in this collection.
	 */
	public function size():Number 
	{
		return _co.size() ;
	}
	
	/**
	 * Returns an array containing all of the elements in this collection.
	 * @return an array representation of all the elements in this wrapped collection.
	 */
	public function toArray():Array 
	{
		return _co.toArray() ;
	}

	/**
	 * Returns the Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = TypeUtil.toString(_type) ;
		var sourceB:String = Serializer.toSource(_co) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return _co.toString() ;
	}
	
	/**
	 * The internal collection of this wrapped Collection.
	 */
	private var _co:Collection ;
	
}