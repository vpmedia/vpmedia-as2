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
	
import andromeda.data.map.SubTreeMap;
import andromeda.data.map.TreeMapNode;
import andromeda.data.map.TreeMapSet;

import vegas.core.CoreObject;
import vegas.core.HashCode;
import vegas.core.ICloneable;
import vegas.core.IComparable;
import vegas.core.IComparator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.data.Set;
import vegas.data.SortedMap;
import vegas.errors.NoSuchElementError;
import vegas.errors.NullPointerError;
import vegas.util.Comparater;

/**
 * This class provides a red-black tree implementation of the SortedMap interface. 
 * Elements in the Map will be sorted by either a user-provided IComparator object, or by the natural ordering of the keys.
 * <p><b>Example :</b></p>
 * {@code
 * import andromeda.data.iterator.TreeMapIterator ;
 * import andromeda.data.map.TreeMap ;
 * 
 * import vegas.util.comparators.StringComparator ;
 * 
 * var tree:TreeMap = new TreeMap( StringComparator.getStringComparator() ) ;
 * 
 * trace ( "put key1/value1 : " + tree.put("key1", "value1") ) ;
 * trace ( "put key2/value2 : " +  tree.put("key2", "value2") ) ;
 * //tree.put("key3", "value3") ;
 * 
 * trace( "size : " + tree.size() ) ;
 * trace( "tree : " + tree) ;
 * tree.put("Adobe", "Mountain View, CA");
 * tree.put("IBM", "White Plains, NY");
 * tree.put("Learning Tree", "Los Angeles, CA");
 * tree.put("Microsoft", "Redmond, WA");
 * tree.put("Netscape", "Mountain View, CA");
 * tree.put("O'Reilly", "Sebastopol, CA");
 * tree.put("Sun", "Mountain View, CA");
 * //var low = sortedMap.firstKey() ;
 * 
 * //var high = sortedMap.lastKey() ;
 * //trace("low : " + low);
 * //trace("high : " + high);
 * var it = tree.keySet().iterator();
 * for (int i = 0; i <= 6; i++) 
 * {
 *     if (i == 3)
 *     {
 *         low = it.next();
 *     }
 *     if (i == 6)
 *     {
 *         high = it.next();
 *     }
 *     else
 *     {
 *         it.next();
 *     }
 * }
 * trace(low);
 * trace(high);
 * trace(tree.subMap(low, high));
 * trace(tree.headMap(high));
 * trace(tree.tailMap(low));
 * }
 * @author eKameleon
 */
class andromeda.data.map.TreeMap extends CoreObject implements SortedMap, ICloneable, Iterable 
{

	/**
	 * Creates a new TreeMap instance.
	 * @param comp the IComparator used in this map to ordering the keys.
	 * @param map a map to fill the TreeMap.
	 */
	public function TreeMap ( comp:IComparator , map ) 
	{
		
		if (NIL == null)
		{
			NIL = new TreeMapNode(null, null, BLACK) ;
			NIL.parent = NIL ;
			NIL.left   = NIL ;
			NIL.right  = NIL ;
		}
		
		_fabricateTree(0);
		
		_comparator = comp ;
		
		if (map instanceof SortedMap) 
		{
			_comparator = map.comparator ;
			// TODO finish this instruction
		} 
		else if (map instanceof Map) 
		{
			putAll(map) ;
		}
	}
	
	/**
	 * Color status of a node (black node).
	 */
	static public var BLACK:Number = 1 ;
	
	/**
	 * Color status of a node (red node).
	 */
	static public var RED:Number = -1 ;
	
	/**
	 * Sentinal node, used to avoid null checks for corner cases and make the delete rebalance code simpler. 
	 * The rebalance code must never assign the parent, left, or right of nil, but may safely reassign the color to be black. 
	 * This object must never be used as a key in a TreeMap, or it will break bounds checking of a SubMap.
	 */
	static public var NIL:TreeMapNode = null ;
	
	/**
	 * (read-only) The root node of this TreeMap.
	 */
	public function get root():TreeMapNode
	{
		return _rootEntry ;	
	}
	
	/**
	 * Removes all elements in the map.
	 */
	public function clear():Void 
	{
		if (_size > 0)
		{
			_modCount++ ;
        	_rootEntry = NIL ;
			_size = 0 ;
		}
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
	
	}
	
	/**
	 * Returns the comparator associated with this sorted map, or null if it uses its keys' natural ordering.
	 * @return the comparator associated with this sorted map, or null if it uses its keys' natural ordering.
	 */
	public function comparator():IComparator 
	{
		return _comparator ;
	}
	
	/**
	 * Compares two elements by the set comparator, or by natural ordering.
	 * @param o1 the first object.
	 * @param o2 the second object.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @throws NullPointerError if o1 and o2 is null with natural ordering.
	 */
	public function compare( o1, o2 ):Number
	{
		if ( o1 == null || o2 == null )
		{
			throw new NullPointerError(this + " ") ;	
		}
		if ( _comparator == null )
		{
			if ( o1 instanceof IComparable )
			{
				return IComparable(o1).compareTo(o2) ;
			}
			else
			{
				return HashCode.compare( o1, o2 ) ;
			} 
		}
		else
		{
			return _comparator.compare(o1, o2) ;	
		}
	}

	/**
	 * Returns {@code true} if this map contains a mapping for the specified key.
	 * @param key the key to look for.
	 * @return {@code true} if this map contains a mapping for the specified key.
	 */
	public function containsKey( key ):Boolean 
	{
		return getNode(key) != NIL ;
	}

	/**
	 * Returns {@code true} if this map maps one or more keys to the specified value.
	 * @param value the value to look for.
	 * @return {@code true} if this map maps one or more keys to the specified value.
	 */
	public function containsValue( value ):Boolean 
	{
		var node:TreeMapNode = firstNode() ;
		while (node != NIL)
		{
			if ( Comparater.compare(value, node.value )) 
			{
				return true ;
			}	
			node = successor(node) ;
		}		
		return false ;
	}

	/**
	 * Returns a "set view" of this TreeMap's entries. 
	 * The set is backed by the TreeMap, so changes in one show up in the other.  
	 * The set supports element removal, but not element addition.
	 * @return a set view of the entries of this TreeMap.
	 */
	public function entrySet():Set
	{
		if (_entries == null)
		{
			_entries = new TreeMapSet( this ) ;
		}
		return _entries ;
	}

	/**
	 * Returns the first (lowest) key currently in this sorted map.
	 * @return the first (lowest) key currently in this sorted map.
	 */
	public function firstKey() 
	{
		if (_rootEntry == NIL)
		{
      		throw new NoSuchElementError(this + " firstKey failed, no element in this TreeMap.");
		}
    	return firstNode().key ;
	}
	
	/**
	 * Returns the first sorted node in the map, or {@code null} if empty.
	 * @return the first sorted node in the map, or {@code null} if empty.
	 */
	public function firstNode():TreeMapNode
	{
		var node:TreeMapNode = _rootEntry ;
		while (node.left != NIL)
		{
			node = node.left ;	
		}	
		return node ;
	}
	
	/**
	 * Return the value in this TreeMap associated with the supplied key, or {@code } if the key maps to nothing.
	 * @param key the key for which to fetch an associated value.
	 * @return what the key maps to, if present.
	 */
	public function get(key) 
	{
		return getNode(key).value ;
	}
	
	/**
	 * Returns the array representation of all keys in this TreeMap.
	 * @return the array representation of all keys in this TreeMap.
	 */
	public function getKeys():Array 
	{
		return null ;
	}

	/**
	 * Returns the modCount value of this TreeMap instance.
	 * @return the modCount value of this TreeMap instance.
	 */
	public function getModCount():Number
	{
		return _modCount ;	
	}

	/**
	 * Returns the TreeMapNode associated with key, or the NIL node if no such node exists in the tree.
	 * @param key the key to search for.
	 * @return the node where the key is found, or NIL.
	 */
	public function getNode( key )
	{
		var current:TreeMapNode = _rootEntry ;
		while ( current != NIL )
		{
			var comparison = compare(key, current.key ) ;
			if (comparison > 0)
			{
				current = current.right ;
			}
			else if (comparison < 0 )
			{
				current = current.left ;
			}
			else
			{
				return current ;	
			}	
		}
		return current ;
	}
	
	public function getValues():Array
	{
		return null ;
	}

	/**
	 * Returns a view of this Map including all entries with keys less than {@code toKey}.
	 * The returned map is backed by the original, so changes in one appear in the other.
	 * @param toKey the exclusive cutoff point.
	 * @return a view of the map less than the cutoff.
	 */
	public function heapMap(toKey):SortedMap 
	{
		return new SubTreeMap( NIL, toKey);
	}
	
	/**
	 * Find the "highest" node which is &lt; key. If key is nil, return last node.
	 * @param key the upper bound, exclusive.
	 * @return the previous node.
	 */
	public function highestLessThan( key ):TreeMapNode
	{
		if (key  == NIL)
		{
			return lastNode() ;	
		}
		
		var last:TreeMapNode = NIL ;
		var current:TreeMapNode = _rootEntry ;
		var comparison:Number = 0 ;
		
		while(current != NIL)
		{
			last = current ;
			comparison = compare(key, current.key) ;
			if (comparison > 0)
			{
				current = current.right ;	
			}	
			else if (comparison < 0)
			{
				current = current.left ;	
			}
			else
			{
				return predecessor( last ) ;	
			}
		}
		return comparison <= 0 ? predecessor(last) : last ;
		
	}
	
	/**
	 * Returns {@code true} if this TreeMap is empty.
	 * @return {@code true} if this TreeMap is empty.
	 */
	public function isEmpty():Boolean 
	{
		return _size == 0 ;
	}
	
	public function iterator():Iterator 
	{
		return null ;
	}

	public function keyIterator():Iterator 
	{
			return null ;
	}

	/**
	 * Returns the last (highest) key in the map.
	 * @return the last (highest) key in the map.
	 * @throws NoSuchElementError if the TreeMap is empty.
	 */
	public function lastKey() 
	{
		if (_rootEntry == NIL)
		{
			throw new NoSuchElementError(this + " lastKey method failed if the TreeMap is empty.") ;
		}
		return lastNode().key ;
	}
	
	/**
	 * Returns the last sorted node in the map, or nil if empty.
	 * @return the last sorted node in the map, or nil if empty.
	 */
	public function lastNode():TreeMapNode
	{
		var node:TreeMapNode = _rootEntry ;
		while( node.right != NIL)
		{
			node = node.right ;	
		}
		return node ;
	}
	
	/**
	 * Find the "lowest" node which is &gt;= key. If key is nil, return either NIL or the first node, depending on the parameter {@code first}.
	 * @param key the lower bound, inclusive.
	 * @param first {@code true} to return the first element instead of NIL for NIL key.
	 * @return the next node.
	 */
	public function lowestGreaterThan( key, first:Boolean ):TreeMapNode
	{
		if (key == NIL)
		{
			return first ? firstNode() : NIL ;	
		}
		
		var last:TreeMapNode = NIL ;
		var current:TreeMapNode = _rootEntry ;
		var comparison:Number = 0 ;

    	while (current != NIL)
      	{
	        last = current;
    	    comparison = compare(key, current.key) ;
        	if (comparison > 0)
        	{
          		current = current.right ;
        	}
        	else if (comparison < 0)
        	{
          		current = current.left ;
        	}
        	else
        	{
          		return current ;
        	}
      	}
    	
    	return comparison > 0 ? successor(last) : last;
    
	}

  	/**
  	 * Returns the node preceding the given one, or nil if there isn't one.
  	 * @param node the current node, not NIL.
  	 * @return the prior node in sorted order.
  	 */
	public function predecessor( node:TreeMapNode ):TreeMapNode
	{
		if ( node.left != NIL )
		{
			node = node.left ;
			while( node.right != NIL )
			{
				node = node.right ;	
			}	
			return node ;
		}
		
		var parent:TreeMapNode = node.parent ;
		
		// Exploit fact that NIL.left == NIL and node is non-nil.
		while( node == parent.left )
		{
			node = parent ;
			parent = node.parent ;	
		}
		return parent ;
	}
	
	/**
	 * Puts the supplied value into the Map, mapped by the supplied key.
	 * @param key the key used to locate the value.
	 * @param value the value to be stored in the {@code Map}.
	 * @return the prior mapping of the key, or {@code null} if there was none.
	 */
	public function put(key, value) 
	{
		
		var comparison:Number   = 0 ;
		var current:TreeMapNode = _rootEntry ;
		var parent:TreeMapNode  = NIL ;

		while (current != NIL)
		{
			parent = current ;
			comparison = compare(key, current.key) ;
			if (comparison > 0)
			{
				current = current.right ;
			}
			else if (comparison <0)
			{
				current = current.left ;
			}
			else
			{
				current.setValue(value) ;
				return current.getValue() ; 
			}
		}
		
		// creates new node
		var n:TreeMapNode = new TreeMapNode(key, value, RED) ;
		n.parent = parent ;
		
		// insert node in the tree
		_modCount ++ ;
		_size ++ ;
		if (parent == NIL)
		{
			_rootEntry = n ;
			return null ;	
		}
		if (comparison > 0)
		{
			parent.right = n ;	
		}
		else
		{
			parent.left = n ;
		}
		
		_insertFixup( n ) ;
		return null ;
		
	}
	
	/**
	 * Copies all elements of the given map into this TreeMap.
	 * If this map already has a mapping for a key, the new mapping replaces the current one.
	 * @param m the map to be added.
	 */
	public function putAll(m:Map):Void 
	{
		// 
	}
	
	/**
	 * Construct a tree from sorted keys in linear time, with values of "".
	 * @param keys the iterator over the sorted keys.
	 * @param count the number of nodes to insert.
	 */
	public function putKeysLinear( keys:Iterator, count:Number)
	{
    	_fabricateTree(count);
    	var node:TreeMapNode = firstNode() ;
		while (--count >= 0)
      	{
        	node.key = keys.next();
        	node.value = "";
        	node = successor(node);
      	}
  	}

	/**
	 * Removes from the TreeMap and returns the value which is mapped by the supplied key. 
	 * If the key maps to nothing, then the TreeMap remains unchanged, and {@code null} is returned.
	 * @param key the key used to locate the value to remove.
	 * @return whatever the key mapped to, if present.
	 */
	public function remove(key) 
	{
		var n:TreeMapNode = getNode(key) ;
		if (n == NIL)
		{
			return null ;	
		}
		var result = n.getValue() ;
		removeNode( n ) ;
		return result ;
	}
	
	/**
	 * Removes node from tree. This will increment modCount and decrement size.
	 * The TreeMapNode must exist in the tree.
	 * @param node the node to remove.
	 */
	public function removeNode( node:TreeMapNode ):Void
	{
		var child:TreeMapNode ;
		var splice:TreeMapNode ;
		
		_modCount ++ ;
		_size -- ;
		
		// Find splice, the node at the position to actually remove from the tree.
		if (node.left == NIL)
		{
			// Node to be deleted has 0 or 1 children.
			splice = node ;
			child = node.right ;	
		}
		else if (node.right == NIL)
		{
			// Node to be deleted has 1 child.
			splice = node ;
			child = node.left ;	
		}
		else
		{
			// Node has 2 children. Splice is node's predecessor, and we swap its contents into node.
			splice = node.left ;
			while( splice.right != NIL)
			{
				splice = splice.right ;	
			}
			child = splice.left ;
			node.key = splice.key ;
			node.value = splice.value ;
		}
		
		// Unlink splice from the tree.
		var parent:TreeMapNode = splice.parent ;
		if (child != NIL)
		{
			child.parent = parent ;	
		}
		if (parent == NIL)
		{
			// Special case for 0 or 1 node remaining.
			_rootEntry = child ;
			return ;	
		}
		if (splice == parent.left)
		{
			parent.left = child ;
		}
		else
		{
			parent.right = child ;	
		}
		if(splice.color == BLACK)
		{
			_deleteFixup(child, parent) ;	
		}
	}
	
	/**
	 * Returns the node following the given one, or nil if there isn't one.
	 * @param node the current node, not NIL.
	 * @return the next node in sorted order.
	 */
	public function successor( node:TreeMapNode ):TreeMapNode
	{
		if (node.right != NIL)
		{
			node = node.right ;
			while( node.left != NIL)
			{
				node = node.left ;	
			}
			return node ;
		}
		
		var parent:TreeMapNode = node.parent ;
		// Exploit fact that NIL.right == NIL and node is non-nil.
		while (node == parent.right)
		{
			node = parent ;
			parent = parent.parent ;	
		}
		return parent ;
	}
	
	/**
	 * Returns the number of key-value mappings currently in this Map.
	 * @return the number of key-value mappings currently in this Map.
	 */
	public function size():Number 
	{
		return _size ;
	}

	/**
	 * Returns a view of this Map including all entries with keys greater or equal to {@code fromKey} 
	 * and less than {@code toKeys} ( a half-open interval ).
	 * The returned map is backed by the original, so changes in one appear in the other.
	 * @param fromKey fromKey the (inclusive) low cutoff point.
	 * @param toKey toKey the (exclusive) high cutoff point.
	 * @return a view of the map between the cutoffs.
	 */
	public function subMap(fromKey, toKey):SortedMap 
	{
		return new SubTreeMap( fromKey, toKey ) ;
	}
	
	/**
	 * Returns a view of this Map including all entries with keys greater or equal to {@code fromKey}.
	 * The returned map is backed by the original, so changes in one appear in the other.
	 * @param fromKey the (inclusive) low cutoff point.
	 * @return a view of the map above the cutoff.
	 */
	public function tailMap( fromKey ):SortedMap 
	{
		return new SubTreeMap( fromKey, NIL );
	}

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String
	{
		var it:Iterator = entrySet().iterator() ;

		var pos:Number ;
		var r:String = "{" ;
		
		for (pos = size() ; pos > 0 ; pos--)
		{
			var n:TreeMapNode = it.next() ;
			r += n.key ;
			r += '=' ;
			r += n.value ;
			if (pos > 1)
			{
				r += ", " ;	
			}
		}
		r += "}" ;
		return r ;
	} 

    /**
     * The Comparator used to maintain order in this TreeMap, or null if this TreeMap uses its elements natural ordering.
     */
	private var _comparator:IComparator = null ;

	/**
	 * The cache for {@link entrySet}.
	 */
	private var _entries:TreeMapSet ;

	/**
     * The number of structural modifications to the tree.
     */
	private var _modCount:Number = 0 ;

	/**
	 * The root of the tree.
	 */
	private var _rootEntry:TreeMapNode = null ;

	/**
     * The number of entries in the tree
     */
	private var _size:Number = 0 ;

	/**
	 * Decrement the size of the TreeMap.
	 */
	private function _decrementSize():Void 
	{
		_modCount ++ ;
		_size -- ;
	}
	
	/**
	 * Maintain red-black balance after deleting a node.
	 * @param node the child of the node just deleted, possibly NIL.
	 * @param parent parent the parent of the node just deleted, never NIL.
	 */
	private function _deleteFixup( node:TreeMapNode , parent:TreeMapNode ):Void
	{
		// TODO if (parent == nil) throw new InternalError();

	    // If a black node has been removed, we need to rebalance to avoid violating the "same number of black nodes on any path" rule.
	    // If node is red, we can simply recolor it black and all is well.
	    
	    var sibling:TreeMapNode ;
	    
	    while( node != _rootEntry && node.color == BLACK )
	    {
	    	
	    	if (node == parent.left)
	    	{
	    		// Rebalance left side.
	    		sibling = parent.right ;
	    		
	    		// TODO if (sibling == NIL) throw new InternalError() ;
	    		
	    		if (sibling.color == RED)
	    		{
	    			// Case 1 : Sibling is red.
	    			// Recolor sibling and parent, and rotate parent left. 	
	    			sibling.color = BLACK ;
	    			parent.color = RED ;
	    			_rotateLeft(parent) ;
	    			sibling = parent.right ;
	    		}
	    		
	    		if ( sibling.left.color == BLACK && sibling.right.color == BLACK )
	    		{
	    			// Case 2 : Sibling has no red children.
	    			// Recolor sibling and move top parent.
	    			sibling.color = RED ;
	    			node = parent ;
	    			parent = parent.parent ;
	    		}
	    		else
	    		{
	    			if (sibling.right.color == BLACK)
	    			{
	    				// Case 3: Sibling has red left child.
	    				// Recolor sibling and left child, rotate sibling right.
	    				sibling.left.color = BLACK ;
	    				sibling.color = RED ;
	    				_rotateRight(sibling) ;
	    				sibling = parent.right ;
	    			}
	    			// Case 4: Sibling has red right child. 
	    			// Recolor sibling, right child, and parent, and rotate parent left.
	    			sibling.color = parent.color ;
	    			parent.color = BLACK ;
	    			sibling.right.color = BLACK ;
	    			_rotateLeft( parent ) ;
	    			node = _rootEntry ;
	    		}
	    		
	    	}
	    	else
	    	{
	    		
	    		// Symmetric "mirror" of left-side case.
	    		sibling = parent.left ;
	    		
	    		// TODO if (sibling == NIL) throw new InternalError() ;
	    		
	    		if (sibling.color == RED)
	    		{
	    			// Case 1 : Sibling is red.
	    			// Recolor sibling and parent, and rotate parent right.	
	    			sibling.color = BLACK ;
	    			parent.color = RED ;
	    			_rotateRight(parent) ;
	    			sibling = parent.left ;
	    		}
	    		
	    		if ( sibling.right.color == BLACK && sibling.left.color == BLACK)
	    		{
	    			// Case 2: Sibling has no red children.
	    			// Recolor sibling, and move to parent.
	    			sibling.color = RED ;
	    			node = parent ;
	    			parent = parent.parent ;
	    		}
	    		else
	    		{
	    			if (sibling.left.color == BLACK)
	    			{
	    				// Case 3: Sibling has red right child.
	    				// Recolor sibling and right child, rotate sibling left.
                    	sibling.right.color = BLACK;
                    	sibling.color = RED;
                    	_rotateLeft(sibling);
                    	sibling = parent.left;
	    			}
	                // Case 4: Sibling has red left child. Recolor sibling,
	                // left child, and parent, and rotate parent right.
	                sibling.color = parent.color;
                	parent.color = BLACK;
                	sibling.left.color = BLACK;
                	_rotateRight(parent);
                	node = root ; 
	    		}
	    		
	    	}
	    }
	    node.color = BLACK ;
	}
	
	/**
	 * Construct a perfectly balanced tree consisting of n "blank" nodes. 
	 * This permits a tree to be generated from pre-sorted input in linear time.
	 * @param count the number of blank nodes, non-negative.
	 */
	private function _fabricateTree ( count:Number ):Void
	{
		
		if (count == 0)
		{
			_rootEntry = NIL ;
			_size = 0 ;	
			return ;
		}
		
		// Make the root node.
		_rootEntry = new TreeMapNode(null, null, BLACK) ;
		_size = count ;
		
		var row:TreeMapNode = _rootEntry ;
		var rowSize:Number ;
		
		var left:TreeMapNode ;
		var last:TreeMapNode ;
		var next:TreeMapNode ;
		var parent:TreeMapNode ;
		var right:TreeMapNode ;
		
		// Fill each row that is completely full of nodes.
		for (var rowSize = 2 ; (rowSize + rowSize) <= count ; rowSize <<=1 )
		{
			parent = row ;
			last   = null ;
			for ( var i:Number = 0 ; i < rowSize ; i += 2 )
			{
				left  = new TreeMapNode(null, null, BLACK) ;
				right = new TreeMapNode(null, null, BLACK) ;
				
				left.parent = parent ;
				left.right  = right ;
				
				right.parent = parent ;
				parent.left  = left ;
				
				next = parent.right ; 
				parent.right = right ;
				
				parent = next ;
				
				if (last != null)
				{
					last.right = left ;	
				}
				
				last = right ;
			}
			row = row.left ;
		}
		
		// Now do the partial final row in red.
		var overflow:Number = count - rowSize ;
		parent = row ;
		var j:Number ;
		for ( j = 0 ; j < overflow ; j += 2 )
		{
			
			left  = new TreeMapNode(null, null, RED) ;
			right = new TreeMapNode(null, null, RED) ;
			
			left.parent = parent ;
			right.parent = parent ;
			
			parent.left = left ;
			next = parent.right ;
			
			parent.right = right ;
			parent = next ;
			
		}
		
		// Add a lone left node if necessary.
   	 	if ( (j - overflow) == 0 )
      	{
        	
        	left = new TreeMapNode(null, null, RED) ;
        	left.parent = parent ;
        	parent.left = left ;
        	parent = parent.right ;
        	left.parent.right = NIL ;
		}
		
		// Unlink the remaining nodes of the previous row.
    	while (parent != NIL)
      	{
        	next = parent.right ;
        	parent.right = NIL ;
        	parent = next;
      	}
		
	}
	
	/**
	 * Increment the size of the TreeMap.
	 */
	private function _incrementSize():Void 
	{
		_modCount ++ ;
		_size ++ ;
	}
	
	/**
	 * Maintains the red-black balance after inserting a new node.
	 * @param n the newly inserted node.
	 */
	private function _insertFixup( n:TreeMapNode ):Void
	{
		// Only need to rebalance when parent is a RED node, and while at least
		// 2 levels deep into the tree (ie: node has a grandparent). Remember
		// that NIL.color == BLACK.
		while( n.parent.color == RED && n.parent.parent != NIL )
		{
			if ( n.parent == n.parent.parent.left )
			{
				var uncle:TreeMapNode = n.parent.parent.right ;
				if (uncle.color == RED)
				{
					// Case 1. Uncle is RED: Change colors of parent, uncle, and grandparent, and move n to grandparent.
	                n.parent.color     = BLACK ;
	                uncle.color        = BLACK ;
	                uncle.parent.color = RED ;
	                n = uncle.parent ;
				}
				else
				{
					if ( n == n.parent.right )
					{
						 // Case 2. Uncle is BLACK and x is right child. 
						 // Move n to parent, and rotate n left.
						 n = n.parent;
                    	_rotateLeft(n);
					}
					// Case 3. Uncle is BLACK and x is left child.
					// Recolor parent, grandparent, and rotate grandparent right.
					n.parent.color        = BLACK ;
					n.parent.parent.color = RED ;
					_rotateRight ( n.parent.parent ) ;
					
				}
			}
			else
			{
				// FIXME finish this method !!
			}	
		}
	}
	
	/**
	 * Returns the last sorted node in the map, or nil if empty.
	 * @return the last sorted node in the map, or nil if empty.
	 */
	private function _lastNode():TreeMapNode
	{
		var node:TreeMapNode = _rootEntry ;
		while( node.right != NIL )
		{
			node = node.right ;	
		}
		return node ;
	}
	
	/**
	 * Returns the key of the specified Entry passed in argument.
	 * @return the key of the specified Entry passed in argument.
	 * @throws NoSuchElementError if the entry passed in argument not must be 'null' or 'undefined'.
	 */
	private function _key( e:TreeMapNode ) 
	{
        if (e==null) 
        {
        	throw new NoSuchElementError( this + " the entry passed in argument not must be 'null' or 'undefined'.") ;
        }
        return e.key ;
    }
	
	/**
	 * Returns the node preceding the given one, or nil if there isn't one.
	 * @param n the current node, not NIL.
	 * @return the prior node in sorted order.
	 */
	private function _predecessor( node:TreeMapNode ):TreeMapNode
	{
		if (node.left != NIL)
		{
			node = node.left ;
			while ( node.right != NIL )
			{
				node = node.right ;	
			}
			return node ;
		}
		
		var parent:TreeMapNode = node.parent ;
		
		// Exploit fact that nil.left == nil and node is non-nil.
		while (node == parent.left)
		{
			node = parent ;
			parent = node.parent ;	
		}
		return parent ;
		
	}
	
	/**
	 * Rotate node n to the left.
	 * @param node the node to rotate.
	 */
	private function _rotateLeft( node:TreeMapNode ):Void
	{
		
		var child:TreeMapNode = node.right ;
		
		// Establish node.right link.
		node.right = child.left ;
		if (child.left != NIL)
		{
			child.left.parent = node ;	
		}
		
		// Establish child->parent link.
		child.parent = node.parent ;
		if (node.parent != NIL)
		{
			if ( node == node.parent.left )
			{
				node.parent.left = child ;	
			}
			else
			{
				node.parent.right = child ;	
			}
		}
		else
		{
			_rootEntry = child ;	
		}
		
		// Link n and child.
		child.left  = node ;
		node.parent = child ;
		
	}
	
	/**
	 * Rotate node n to the right.
	 * @param node the node to rotate.
	 */
	private function _rotateRight( node:TreeMapNode ):Void
	{
		var child:TreeMapNode = node.left ;
		
		// Establish node left link.
		node.left = child.right ;
		if (child.right != NIL)
		{
			child.right.parent = node ;
		}
		
		// Establish child->parent link
		child.parent = node.parent ;
		if (node.parent != NIL)
		{
			if ( node == node.parent.right )
			{
				node.parent.right = child ;	
			}
			else
			{
				node.parent.left = child ;	
			}
		}
		else
		{
			_rootEntry = child ;	
		}
		
		// Link n and child.
		child.right  = node ;
		node.parent = child ;
		
	}
	
	private function _valueSearchNull( n:TreeMapNode ):Boolean 
	{
        if (n.getValue() == null) 
        {
        	return true ;
        }
        return (n.left  != null && _valueSearchNull(n.left)) ||
               	(n.right != null && _valueSearchNull(n.right)) ;
    }

    private function _valueSearchNonNull( n:TreeMapNode, value):Boolean 
    {
        if (value == n.getValue()) return true ;
        return (n.left  != null && _valueSearchNonNull(n.left, value)) || 
        		(n.right != null && _valueSearchNonNull(n.right, value));
    }

}