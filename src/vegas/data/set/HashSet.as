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
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterator;
import vegas.data.map.HashMap;
import vegas.data.Set;
import vegas.data.set.AbstractSet;
import vegas.util.serialize.Serializer;

/**
 * Hash Set based implementation of the Set interface. 
 * @author eKameleon
 */
class vegas.data.set.HashSet extends AbstractSet 
{

	/**
	 * Creates a new HashSet instance.
	 * <p>You can use an optional parameter in this constructor with different type : an Array or a Collection instance to fill the Set object.</p>
	 */
	public function HashSet() 
	{
		_map = new HashMap() ;
		if (arguments.length == 0) 
		{
			return ;
		}
		var arg = arguments[0] ;
		var it:Iterator ;
		if (arg instanceof Array) 
		{
			it = new ArrayIterator(arg) ;
		}
		else if (arg instanceof Collection) 
		{
			it = arg.iterator() ;
		}
		if ( it != null ) 
		{
			while (it.hasNext()) 
			{
				insert(it.next()) ;
			}
		}
	}

	/**
	 * Removes all of the elements from this Set (optional operation).
	 */
	/*override*/ public function clear():Void 
	{
		_map.clear() ;
	}
	
	/**
	 * Returns a shallow copy of this Set (optional operation).
	 * @return a shallow copy of this Set (optional operation).
	 */
	/*override*/ public function clone() 
	{
		var s:Set = new HashSet() ; 
		if (size() > 0) {
			var it:Iterator = _map.keyIterator() ;
			while(it.hasNext()) {
				s.insert(it.next()) ;
			}
		}
		return s ;
	}

	/**
	 * Returns {@code true} if this Set contains the specified element.
	 * @return {@code true} if this Set contains the specified element.
	 */
	/*override*/ public function contains(o):Boolean 
	{
		return _map.containsKey(o) ;
    }

	/**
	 * Adds the specified element to this set if it is not already present.
	 */
	/*override*/ public function insert(o):Boolean 
	{
		return _map.put(o, PRESENT) == null ;
    }

	/**
	 * Returns true if this set contains no elements.
	 * @return true if this set contains no elements.
	 */
	/*override*/ public function isEmpty():Boolean 
	{
		return _map.isEmpty() ;
	}

	/**
	 * Returns an iterator over the elements in this Set.
	 * @return an iterator over the elements in this Set.
	 */
	/*override*/ public function iterator():Iterator 
	{
		return _map.keyIterator() ;
	}

	/**
	 * Removes the specified element from this set if it is present.
	 */
    /*override*/ public function remove(o):Boolean 
    {
		return _map.remove(o) == PRESENT ;
    }

	/**
	 * Returns the number of elements in this set (its cardinality).
	 * @return the number of elements in this set (its cardinality).
	 */
	/*override*/ public function size():Number 
	{
		return _map.size() ;
	}

	/**
	 * Returns the array representation of all the elements of this Set.
	 * @return the array representation of all the elements of this Set.
	 */
	/*override*/ public function toArray():Array 
	{
		return _map.getKeys() ;
	}

	/**
	 * Returns a Eden representation of this object.
	 * @return a string representing the source code of the object.
	 */
	/*override*/ public function toSource(indent:Number, indentor:String):String 
	{
		return Serializer.getSourceOf(this, [Serializer.toSource(toArray())]) ;
	}
	
	private var _map:HashMap ;
	
	static private var PRESENT = new Object() ;

}