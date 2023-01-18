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
import vegas.data.iterator.Iterator;
import vegas.data.map.MultiHashMap;
import vegas.data.Set;
import vegas.data.set.HashSet;
import vegas.errors.UnsupportedOperation;

/**
 * The MultiHashSet is a MutliHashMap that contains no duplicate elements in a specified key.
 * @author eKameleon
 * @see MultiMap
 */
class vegas.data.set.MultiHashSet extends MultiHashMap implements Set 
{

	/**
	 * Creates a new MultiHashSet instance.
	 */
	public function MultiHashSet() 
	{
		super(arguments[0]) ;
		_internalSet = new HashSet() ;
	}

	/**
	 * This clears each collection in the map, and so may be slow.
	 */
	public function clear():Void 
	{
		super.clear() ;
		_internalSet.clear() ;
	}

	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	/*override*/ public function clone() 
	{
		var m:MultiHashSet = new MultiHashSet() ;
		var vItr:Iterator = valueIterator() ;
		var kItr:Iterator = keyIterator() ;
		while (kItr.hasNext()) 
		{
			var key = kItr.next() ;
			var value = vItr.next() ;
			m.putCollection(key, value) ;
		}
		return m ;
	}

	/**
	 * Checks whether the map contains the value specified .
	 * @param o the object to search in this instance.
	 * @return {@code true} if the MultiHashSet container the passed-in object.
	 */
	public function contains(o):Boolean 
	{
		var len:Number = arguments.length ;
		if (len == 1) 
		{
			var value = arguments[0] ;
			var it:Iterator = _map.iterator() ;
			while (it.hasNext()) 
			{
				var cur = it.next() ;
				if (cur.contains(value)) 
				{
					return true ;
				}
			}
		} 
		else if (len == 2) 
		{
			return ( getSet(arguments[0] ).contains(arguments[1]) == true);
		}
		return false ;
	}

	/**
	 * Creates a new instance of the map value Collection(Set) container.
	 * This method can be overridden to use your own collection type.
	 */
	/*override*/ public function createCollection():Collection 
	{
		return new HashSet() ;	
	}

	/**
	 * This method is unsupported, use getSet method.
	 * @param a number
	 * @throws UnsupportedOperation the MultiHashSet does not support the get() method, use getSet()
	 */
	public function get( id:Number ) 
	{
		throw new UnsupportedOperation("This MultiHashSet does not support the get() method, use getSet().") ;
		return null ;
	}

	/**
	 * Returns the Set defined in the map with the specified key.
	 * @param key the key in the map 
	 * @return the Set defined in the map with the specified key.
	 */
	public function getSet( key ) /*Set*/ 
	{
		return super.get(key) ;
	}

	/**
	 * This method always throws an {@code UnsupportedOperation} because this method is not supported by this Set.
	 * @param o a object to insert.
	 * @throws UnsupportedOperation the MultiHashSet instance does not support the insert() method.
	 */
	public function insert(o):Boolean 
	{
		throw new UnsupportedOperation("This MultiHashSet does not support the insert() method.") ;
		return null ;
	}

	/**
	 * Adds the value to the Set associated with the specified key.
	 * @return {@code true} if the value is inserted in the object.
	 */
	/*override*/ public function put(key, value):Boolean 
	{
		if(_internalSet.contains(value)) return false ;
		if (!containsKey(key)) 
		{
			_map.put(key , createCollection()) ;
		}
		var b:Boolean = _map.get(key).insert(value) ;
		return _internalSet.insert(value) ;
	}

	/**
	 * Adds a collection of values to the collection associated with the specified key.
	 */
	/*override*/ public function putCollection(key, c:Collection):Void 
	{
		if (!containsKey(key)) 
		{
			_map.put(key , createCollection()) ;
		}
		var s:HashSet = _map.get(key) ;
		var it:Iterator = c.iterator() ;
		var value ;
		while(it.hasNext()) 
		{
			value = it.next() ;
			if (_internalSet.insert(value)) 
			{
				s.insert(value) ;
			}	
		}
	}
	
	/**
	 * Removes a specific value from map.
	 * <p><b>Note :</b> Use Set implementation and not Map implementation !</p>
	 */
	/*override*/ public function remove( o /* key, value*/ ):Boolean 
	{
		var len:Number = arguments.length ;
		var key ;
		var value ;
		if (len == 2) 
		{
			key = arguments[0] ;
			value = arguments[1] ;
			var c:Collection = _map.get(key) ;
			var b:Boolean = c.remove(value) ;
			return _internalSet.remove(value) ;
		}
		else 
		{
			key = arguments[0] ;
			var s:Set = _map.get(key) ;
			if (s) 
			{
				var it:Iterator = s.iterator() ;
				while(it.hasNext()) 
				{
					_internalSet.remove(it.next()) ;
				}
				_map.remove(key) ;
				return true ;
			}
			else 
			{
				return false ;	
			}
			
		}
	}
	
	/**
	 * Returns an array containing the combination of values from all keys.
	 * @return an array containing the combination of values from all keys.
	 */
	public function toArray():Array 
	{
		return getValues() ;
	}

	private var _internalSet:HashSet ;

}