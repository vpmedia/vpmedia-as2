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
	
import andromeda.data.iterator.TreeMapIterator;
import andromeda.data.map.BasicMapEntry;
import andromeda.data.map.TreeMap;
import andromeda.data.map.TreeMapNode;

import vegas.core.CoreObject;
import vegas.data.iterator.Iterator;
import vegas.data.Set;
import vegas.util.Comparater;

/**
 * This set is use in the TreeMap class to defined a set of all key in the TreeMap.
 * @author eKameleon
 */
class andromeda.data.map.TreeMapSet extends CoreObject implements Set
{
	
	/**
	 * Creates a new TreeMapSet instance.
	 */
	function TreeMapSet( _tree:TreeMap ) 
	{
		this._tree = _tree ;
	}


	/**
	 * Removes all of the elements from this collection (optional operation).
	 */	
	public function clear():Void
	{
		_tree.clear();
	}

	public function clone() 
	{
	
	}

	/**
	 * Returns {@code true} if this collection contains the specified element.
	 * @return {@code true} if this collection contains the specified element.
	 */
	public function contains( o ):Boolean
	{
		if ( ! o instanceof BasicMapEntry )
		{
			return false ;	
		}
		
		var entry:BasicMapEntry = BasicMapEntry(o) ;
		var node:TreeMapNode = _tree.getNode( entry.getKey() ) ;
		
		return (node != TreeMap.NIL) && ( Comparater.compare( entry.getValue() , node.value ) ) ; 
		
	}
	

	public function get(id : Number)
	{
	
	}

	public function insert(o) : Boolean 
	{
		return null;
	}

	public function isEmpty() : Boolean 
	{
		return null;
	}


	/**
	 * Returns the iterator of this TreeMapSet.
	 * @return the iterator of this TreeMapSet.
	 */
	public function iterator():Iterator
	{
		var it:Iterator = new TreeMapIterator( _tree, TreeMapIterator.ENTRIES ) ;
		return it ;	
	}

	/**
	 * Removes a single instance of the specified element from this collection, if it is present (optional operation).
	 * @return a boolean value if the object passed in argument is remove.
	 */
	public function remove( o ):Boolean
	{
		if ( ! o instanceof BasicMapEntry )
		{
			return false ;	
		}
		var entry:BasicMapEntry = BasicMapEntry(o) ;
		var node:TreeMapNode = _tree.getNode( entry.getKey() ) ;
		if ( node != TreeMap.NIL &&Comparater.compare( entry.getValue() , node.value ) )
		{
			_tree.removeNode( node ) ;
			return true ;
		}
		return false ;
	}

	/**
	 * Returns the size of this iterator.
	 * @return the size of this iterator.
	 */
	public function size():Number
	{
		return _tree.size() ;
	}
	
	public function toArray() : Array 
	{
		return null;
	}
	
	/**
	 * 
	 */
	public function toString():String
	{
		return "[TreeMapSet]" ;	
	}

	/**
	 * The TreeMap reference of this SubTreeMap.
	 */
	private var _tree:TreeMap ;
	



}