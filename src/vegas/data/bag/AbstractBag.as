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
import vegas.core.types.Int;
import vegas.data.Bag;
import vegas.data.bag.BagFormat;
import vegas.data.bag.HashBag;
import vegas.data.Collection;
import vegas.data.iterator.BagIterator;
import vegas.data.iterator.Iterator;
import vegas.data.List;
import vegas.data.list.ArrayList;
import vegas.data.Map;
import vegas.data.map.MapUtil;
import vegas.data.Set;
import vegas.data.set.HashSet;
import vegas.errors.IllegalArgumentError;
import vegas.errors.UnsupportedOperation;
import vegas.util.serialize.Serializer;

/**
 * This class provides a skeletal implementation of the {@code Bag} interface, to minimize the effort required to implement this interface.
 * <p>To implement a bag, the programmer needs only to extend this class and provide implementations for the cursor, insert and size methods. For supporting the removal of elements, the cursor returned by the cursor method must additionally implement its remove method.</p>
 * @author eKameleon
 */
class vegas.data.bag.AbstractBag extends CoreObject implements Bag 
{

	/**
	 * Creates a new AbstractBag instance.
	 * @param m a Map reference.
	 */
	private function AbstractBag( m:Map ) 
	{
		if (m) 
		{
			_setMap(m) ;
		}
	}
	
	/**
	 * Removes all of the elements from this bag.
	 */
	public function clear():Void 
	{
		_mods ++ ;
		_map.clear() ;
		_total = 0 ;
	}

	/**
	 * Returns the shallow copy of this bag.
	 * @return the shallow copy of this bag.
	 */
	public function clone() 
	{
		return null ;
	}

	/**
	 * Returns {@code true} if this bag contains the object passed in argument.
	 * @return {@code true} if this bag contains the object passed in argument.
	 */
	public function contains(o):Boolean 
	{
		return _map.containsKey(o);
	}

	/**
	 * Returns {@code true} if thie bag contains all object in the passed collection in argument.
	 * @return {@code true} if thie bag contains all object in the passed collection in argument.
	 */
	public function containsAll(c:Collection):Boolean 
	{
		return containsAllInBag(new HashBag(c)) ;
	}
	
	/**
	 * Returns {@code true} if thie bag contains all object in the passed bag in argument.
	 * @return {@code true} if thie bag contains all object in the passed bag in argument.
	 */
	public function containsAllInBag(b:Bag):Boolean 
	{
		var result:Boolean = true ;
		var i:Iterator = b.uniqueSet().iterator() ;
        while (i.hasNext()) 
        {
			var current = i.next();
            var contains:Boolean = getCount(current) >= b.getCount(current) ;
            result = result && contains ;
        }
        return result;
	}

	/**
	 * Unsupported by bag objects.
	 * @throws UnsupportedOperation the 'get' method is unsupported with a bag object.
	 */	
	public function get(id:Number) 
	{
		throw new UnsupportedOperation("The 'get' method is unsupported with a bag object.") ;
	}

	/**
	 * Returns the count of the specified object passed in argument.
	 */
	public function getCount(o):Number 
	{
        var result:Number = 0;
        var count:Number = MapUtil.getNumber(_map, o);
        if (count != null) 
        {
            result = count ;
        }
        return result;
	}

	/**
	 * This method is used in the BagIterator class.
	 */
	public function getModCount():Number 
	{
		return _mods ;
	}

	/**
	 * Add 1 copy of the given object to the bag and keep a count. 
	 */	
	public function insert(o):Boolean 
	{
		return insertCopies(o, 1) ;
	}

	/**
	 * Insert all elements represented in the given collection.
	 */
	public function insertAll(c:Collection):Boolean 
	{
		var changed:Boolean = false;
        var i:Iterator = c.iterator() ;
		var added:Boolean ;
        while (i.hasNext()) 
        {
			added = insert(i.next());
            changed = changed || added ;
        }
        return changed;
	}

	/**
	 * Add n copies of the given object to the bag and keep a count. 
	 */
	public function insertCopies(o, nCopies:Number):Boolean 
	{
		_mods++ ;
        if (nCopies > 0) 
        {
            var count:Number = nCopies + getCount(o) ;
            _map.put(o, new Int(count));
            _total += nCopies;
            return count == nCopies ;
        }
        else 
        {
            return false;
        }
	}
	
	/**
	 * Returns {@code true} if the bag is empty.
	 * @return {@code true} if the bag is empty.
	 */
	public function isEmpty():Boolean 
	{
		return _map.isEmpty() ;
    }
	
	/**
	 * Returns the bag iterator.
	 * @return the bag iterator.
	 */
	public function iterator():Iterator 
	{
		return new BagIterator(this, _extractList().iterator()) ;
	}

	/**
	 * Removes the object in argument in the bag.
	 */
	public function remove(o):Boolean 
	{
		return removeCopies(o, getCount(o));
	}

	/**
	 * (Violation) Removes all elements represented in the given collection, respecting cardinality.
	 */
	public function removeAll(c:Collection):Boolean 
	{
        var result:Boolean = false ;
        if (c != null) 
        {
            var i:Iterator = c.iterator() ;
            while (i.hasNext()) 
            {
				var next = i.next() ;
                var changed:Boolean = removeCopies(next, 1) ;
                result = result || changed ;
            }
        }
        return result ;
    }

	/**
	 * Removes the given number of occurrences from the bag.
	 */
	public function removeCopies(o, nCopies:Number):Boolean 
	{
		_mods++;
        var result:Boolean = false;
        var count:Number = getCount(o) ;
        if (nCopies <= 0) 
        {
        	result = false;
        }
        else if (count > nCopies) 
        {
            _map.put(o, new Int(count - nCopies)) ;
            result = true ;
            _total -= nCopies ;
        } 
        else // count > 0 && count <= i 
        {   
            result = (_map.remove(o) != null) ; // need to remove all
            _total -= count ;
        }
        return result;
	}

	/**
	 * (Violation) Removes any members of the bag that are not in the given collection, respecting cardinality.
	 */
	public function retainAll(c:Collection):Boolean 
	{
		return retainAllInBag(new HashBag(c));
	}

	/**
	 * (Violation) Removes any members of the bag that are not in the given bag.
	 */
	public function retainAllInBag(b:Bag):Boolean 
	{
        var result:Boolean = false ;
        var excess:Bag = new HashBag() ;
        var i:Iterator = uniqueSet().iterator() ;
        while (i.hasNext()) 
        {
            var cur = i.next() ;
            var count1:Number = getCount(cur) ;
            var count2:Number = b.getCount(cur) ;
            if ( 1 <= count2 && count2 <= count1) 
            {
                excess.insertCopies(cur, count1 - count2) ;
            }
            else 
            {
                excess.insertCopies(cur, count1) ;
            }
        }
        if (!excess.isEmpty()) 
        {
        	result = removeAll(excess) ;
        }
        return result;
    }

	/**
	 * Returns the number of elements in this bag (its cardinality).
	 * @return the number of elements in this bag (its cardinality).
	 */
	public function size():Number 
	{
		return _total ;
	}
	
	/**
	 * Returns the array representation of the bag.
	 * @return the array representation of the bag.
	 */
	public function toArray():Array 
	{
		return _extractList().toArray();
	}

	/**
	 * Returns the Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return Serializer.getSourceOf(this, [Serializer.toSource(_map)]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return (new BagFormat()).formatToString(this) ;
	}

	/**
	 * Returns the Set of unique members that represent all members in the bag.
	 * @return the Set of unique members that represent all members in the bag.
	 */
	public function uniqueSet():Set 
	{
		return new HashSet(_map.getKeys()) ;
	}

	/**
	 * The internal map.
	 */
	private var _map:Map = null ;
	
	/**
	 * The internal mod value.
	 */	
	private var _mods:Number = 0 ;
	
	/**
	 * The internal total value.
	 */
	private var _total:Number = 0 ;
	
	/**
	 * This method calculate the total value. 
	 */
	private function _calcTotalSize():Number 
	{
        _total = _extractList().size() ;
        return _total ;
    }

	/**
	 * Returns a List.
	 */
	private function _extractList():List 
	{
        var result:List = new ArrayList() ;
        var i:Iterator  = uniqueSet().iterator();
        while (i.hasNext()) 
        {
            var current = i.next() ;
			var l:Number = getCount(current) ;
            while (--l > -1) 
            {
            	result.insert(current);
            }
        }
        return result ;
    }

	/**
	 * Returns the internal map reference.
	 */
	private function _getMap():Map 
	{
		return _map ;
	}
	
	/**
	 * Sets the internal map reference.
	 * @throws IllegalArgumentError
	 */
	private function _setMap(m:Map):Void 
	{
		if (m == null || m.isEmpty() == false) 
		{
            throw new IllegalArgumentError("In this bag, the map must be non-null and empty.") ;
        }
        _map = m ;
	}

}