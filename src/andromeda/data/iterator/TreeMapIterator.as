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

import vegas.core.CoreObject;
import vegas.data.iterator.Iterator;
import vegas.errors.ConcurrentModificationError;
import vegas.errors.IllegalStateError;
import vegas.errors.NoSuchElementError;
import vegas.errors.NullPointerError;

/**
 * Iterate over TreeMap's entries. 
 * This implementation is parameterized  to give a sequential view of keys, values, or entries.
 * @author eKameleon
 */
class andromeda.data.iterator.TreeMapIterator extends CoreObject implements Iterator 
{
	
	/**
	 * Creates a new TreeMapIterator instance.
	 * @param tree the TreeMap reference of this iterator.
	 * @param type the type of this iterator.
	 */
	public function TreeMapIterator( tree:TreeMap , type:Number , first:TreeMapNode, max:TreeMapNode ) 
	{
		
		if ( tree == null )
		{
			throw new NullPointerError(this + " constructor failed, the TreeMap reference passed in argument not must be 'null' or 'undefined'.") ;	
		}
		_tree = tree ;
		_knownMod = _tree.getModCount() ;
		_type = type ;
		_max  = max   || TreeMap.NIL ;
		_next = first || tree.firstNode();
     	
	}

	/**
	 * The iterator types for an ENTRIES value.
	 */
	static public var ENTRIES:Number = 2 ;

	/**
	 * The iterator types for an KEYS value.
	 */
	static public var KEYS:Number = 0 ;

	/**
	 * The iterator types for an VALUES value.
	 */
	static public var VALUES:Number = 1 ;

    /**
     * Returns {@code true} if the Iterator has more elements.
     * @return {@code true} if there are more elements.
     */
	public function hasNext() : Boolean 
	{
		return _next != _max ;
	}

	public function key() 
	{
		// throw an error.
	}

	/**
	 * Returns the next element in the Iterator's sequential view.
	 * @return the next element.
	 * @throws ConcurrentModificationError if the TreeMap was modified.
	 * @throws NoSuchElementError if there is none.
	 */
	public function next() 
	{
      	if (_knownMod != _tree.getModCount())
      	{
        	throw new ConcurrentModificationError(this + " key() method failed, the TreeMap was modified.");
      	}
		if ( _next == _max )
		{
        	throw new NoSuchElementError(this + " key() method failed, if there is none");
		}
      	_last = _next ;
      	_next = _tree.successor(_last);
      	
      	// trace(this + " next : " + _next) ;
		
		if ( _type == VALUES )
		{
        	return _last.value ;
		}
		else if ( _type == KEYS )
		{
        	return _last.key;
		}
		return _last ;
	}
    /**
     * Removes from the backing TreeMap the last element which was fetched with the {@code next()} method.
     * @throws ConcurrentModificationError if the TreeMap was modified.
     * @throws IllegalStateError if called when there is no last element.
     */
	public function remove() 
	{
      	if (_last == null)
      	{
        	throw new IllegalStateError(this + " remove() method failed if the TreeMap was modified." );
      	}
		if ( _knownMod != _tree.getModCount() )
		{
			throw new ConcurrentModificationError( this + " remove() method failed if called when there is no last element." );
		}
		_tree.removeNode( _last ) ;
      	_last = null;
      	_knownMod ++ ;
	}

	public function reset() : Void 
	{
		// throw an error.
	}

	public function seek(n : Number) : Void 
	{
		// throw an error.	
	}
	
    /** 
     * The number of modifications to the backing Map that we know about.
     */
    private var _knownMod:Number ;

	/**
	 * The last Entry returned by a next() call.
	 */
	private var _last:TreeMapNode ;

    /**
     * The last node visible to this iterator. This is used when iterating on a SubMap.
     */
    private var _max:TreeMapNode ;

	/**
	 * The next entry that should be returned by next().
	 */
	private var _next:TreeMapNode ;

	/**
	 * The TreeMap reference of this SubTreeMap.
	 */
	private var _tree:TreeMap ;

	/**
	 * The type of this Iterator : KEYS or VALUES or ENTRIES.
	 */
	private var _type:Number ;

}