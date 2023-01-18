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
import vegas.data.iterator.Iterator;
import vegas.data.Set;
import vegas.errors.IllegalArgumentError;
import vegas.util.AbstractTypeable;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * TypedSet is a wrapper for Set instances that ensures that only values of a specific type can be added to the wrapped Set.
 * @author eKameleon
 */
class vegas.data.set.TypedSet extends AbstractTypeable implements ICloneable, Set 
{

	/**
	 * Creates a new TypedSet instance.
	 */
	public function TypedSet( type:Function , set:Set) 
	{
		super( type ) ;
		if (!set) throw new IllegalArgumentError("TypedSet constructor failed, argument 'p_set' must not be 'null' or 'undefined'.") ;
		_set = set ;
		if (_set.size() > 0) 
		{
			var it:Iterator = _set.iterator() ;
			while (it.hasNext()) 
			{
				validate(it.next()) ;
			}
		}
	}

	/**
	 * Removes all of the elements from this Set (optional operation).
	 */
	public function clear():Void 
	{
		_set.clear() ;
	}

	/**
	 * Returns a shallow copy of this Set (optional operation).
	 * @return a shallow copy of this Set (optional operation).
	 */
	public function clone() 
	{
		return _set.clone() ;
	}

	/**
	 * Returns {@code true} if this Set contains the specified element.
	 * @return {@code true} if this Set contains the specified element.
	 */
	public function contains(o):Boolean 
	{
		return _set.contains(o) ;
    }

	/**
	 * Returns an element in the set at the specified position.
	 * @param id the position of the element in the Set.
	 * @return the value of the specified element in the Set.
	 */
	public function get(id:Number) 
	{
		return _set.get(id) ;
	}

	/**
	 * Adds the specified element to this set if it is not already present.
	 * @param o the object to insert in the Set.
	 */
    public function insert(o):Boolean 
    {
		validate(o) ;
		return _set.insert(o) ;
    }

	/**
	 * Returns {@code true} if this set contains no elements.
	 * @return {@code true} if this set contains no elements.
	 */
	public function isEmpty():Boolean 
	{
		return _set.isEmpty() ;
	}

	/**
	 * Returns an iterator over the elements in this set.
	 * @return an iterator over the elements in this set.
	 */
	public function iterator():Iterator 
	{
		return _set.iterator() ;
	}

	/**
	 * Removes the specified element from this set if it is present.
	 */
    public function remove(o):Boolean 
    {
		return _set.remove(o);
    }

	/**
	 * Sets the type of the ITypeable object.
	 * @param type the type function use to restrict all elements in this Set.
	 */
	public function setType(type:Function):Void 
	{
		super.setType(type) ;
		_set.clear() ;
	}

	/**
	 * Returns the number of elements in this set (its cardinality).
	 * @return the number of elements in this set (its cardinality).
	 */
	public function size():Number 
	{
		return _set.size() ;
	}

	/**
	 * Returns the array representation of all the elements of this Set.
	 * @return the array representation of all the elements of this Set.
	 */
	public function toArray():Array 
	{
		return _set.toArray() ;
	}

	/**
	 * Returns a eden String representation of this object.
	 * @return a string representation the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = TypeUtil.toString(_type) ;
		var sourceB:String = Serializer.toSource(_set) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String 
	{
		return _set.toString() ;
	}

	private var _set:Set ;

	
}