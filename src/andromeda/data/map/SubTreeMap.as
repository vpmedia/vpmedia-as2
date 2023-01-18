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
	
import andromeda.data.map.TreeMap;
import andromeda.data.map.TreeMapNode;

import vegas.core.IComparator;
import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.data.map.HashMap;
import vegas.data.Set;
import vegas.data.SortedMap;
import vegas.errors.IllegalArgumentError;
import vegas.errors.NoSuchElementError;
import vegas.errors.NullPointerError;

/**
 * Implementation of a submap and other map ranges. 
 * This class provides a view of a portion of the original backing TreeMap, and throws {@link IllegalArgumentError} for attempts to access beyond that range.
 * @author eKameleon
 */
class andromeda.data.map.SubTreeMap extends HashMap implements SortedMap 
{
	
	/**
	 * Create a SubMap representing the elements between minKey (inclusive) and maxKey (exclusive). 
	 * If minKey is NIL, SubMap has no lower bound (headMap). 
	 * If maxKey is NIL, the SubMap has no upper bound (tailMap).
	 * @param minKey the lower bound.
	 * @param maxKey the upper bound.
	 * @param tree the reference of the TreeMap of this SubTreeMap.
	 * @throws NullPointerError if the {@code tree} argument is {@code null} or {@code undefined}.
	 * @throws IllegalArgumentError if {@code minKey} > {@code maxKey}.
	 */
	public function SubTreeMap( minKey , maxKey , tree:TreeMap ) 
	{
		if (tree == null)
		{
			throw new NullPointerError(this + " the 'tree' argument not must be 'null' or 'undefined.") ;	
		}

		if (NIL == null)
		{
			NIL	= TreeMap.NIL ;
		}
		this.tree = tree ; 
		if (minKey != NIL && maxKey != NIL && tree.compare(minKey, maxKey) > 0)
		{
			throw new IllegalArgumentError(this + " minKey > maxKey.");
		}
      	this.minKey = minKey;
      	this.maxKey = maxKey;
	}

	/**
	 * Sentinal node, used to avoid null checks for corner cases and make the delete rebalance code simpler. 
	 * The rebalance code must never assign the parent, left, or right of nil, but may safely reassign the color to be black. 
	 * This object must never be used as a key in a TreeMap, or it will break bounds checking of a SubMap.
	 */
	static public var NIL:TreeMapNode = null ;

    /**
     * The cache for {@link #entrySet()}.
     */
    private var entries:Set ;

    /**
     * The upper range of this view, exclusive, or nil for unbounded.
     */
	public var maxKey ;

    /**
     * The lower range of this view, inclusive, or nil for unbounded.
     */
	public var minKey ;

	/**
	 * The TreeMap reference of this SubTreeMap.
	 */
	public var tree:TreeMap ;

	/**
	 * Removes all elements in this SubTreeMap and in the TreeMap of this object.
	 */
	public function clear():Void
	{
      	var current:TreeMapNode ;
		var next:TreeMapNode = tree.lowestGreaterThan(minKey, true);
      	var max:TreeMapNode = tree.lowestGreaterThan(maxKey, false);
      	while (next != max)
        {
			current = next ; 
          	next = tree.successor(current) ;
          	tree.removeNode(current) ;
        }
	}

	/**
	 * Returns the comparator associated with this sorted map, or null if it uses its keys' natural ordering.
	 * @return the comparator associated with this sorted map, or null if it uses its keys' natural ordering.
	 */
	public function comparator() : IComparator 
	{
		return tree.comparator() ;
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		
	}

	/**
	 * Returns {@code true} if this map contains a mapping for the specified key.
	 * @param key the key to look for.
	 * @return {@code true} if this map contains a mapping for the specified key.
	 */
	public function containsKey(key) : Boolean 
	{
		return null;
	}

	/**
	 * Returns {@code true} if this map maps one or more keys to the specified value.
	 * @param value the value to look for.
	 * @return {@code true} if this map maps one or more keys to the specified value.
	 */
	public function containsValue(value) : Boolean 
	{
		return null;
	}

	/**
	 * Returns the first (lowest) key currently in this sorted map.
	 * @return the first (lowest) key currently in this sorted map.
	 */
	public function firstKey() 
	{
		var node:TreeMapNode = tree.lowestGreaterThan( minKey, true ) ;
		if (node == NIL || ! keyInRange ( node.key ))
		{
			throw new NoSuchElementError(this + " the first key is nil or out of the range.") ;	
		}
		return node.key ;
	}

	public function heapMap(toKey) : SortedMap 
	{
		return null;
	}
	
    /**
     * Check if {@code key} is in within the range bounds for this SubMap. 
     * The lower ("from") SubMap range is inclusive, and the upper ("to") bound is exclusive. 
     * @param key the key to check.
     * @return {@code true} if the key is in range.
     */
	public function keyInRange( key ):Boolean
	{
		return ( ( minKey == NIL || tree.compare(key, minKey) ) >= 0 && ( maxKey == NIL || tree.compare(key, maxKey) < 0 ) ) ;
	}

	/**
	 * Returns the last (highest) key currently in this sorted map.
	 * @return the last (highest) key currently in this sorted map.
	 */
	public function lastKey() 
	{
	
	}

	/**
	 * Returns a view of the portion of this sorted map whose keys range from fromKey, inclusive, to toKey, exclusive.
	 * @return a view of the portion of this sorted map whose keys range from fromKey, inclusive, to toKey, exclusive.
	 */
	public function subMap(fromKey, toKey) : SortedMap 
	{
		return null;
	}

	/**
	 * Returns a view of the portion of this sorted map whose keys are greater than or equal to fromKey.
	 * @return a view of the portion of this sorted map whose keys are greater than or equal to fromKey.
	 */
	public function tailMap(fromKey) : SortedMap 
	{
		if ( !keyInRange(fromKey) )
		{
        	throw new IllegalArgumentError(" the key is outside the range.") ;
		}
      	return new SubTreeMap( fromKey, maxKey ) ;
	}



	public function get(key) 
	{
	
	}

	public function getKeys() : Array 
	{
		return null;
	}

	public function getValues() : Array 
	{
		return null;
	}

	public function isEmpty() : Boolean 
	{
		return null;
	}

	public function iterator() : Iterator 
	{
		return null;
	}

	public function keyIterator() : Iterator 
	{
		return null;
	}

	public function put(key, value) 
	{
	
	}

	public function putAll(m : Map) : Void 
	{
	
	}

	public function remove(key) 
	{
	
	}

	public function size() : Number 
	{
		return null;
	}

	public function toString() : String 
	{
		return null;
	}

	public function toSource(indent : Number, indentor : String) : String 
	{
		return null;
	}

}