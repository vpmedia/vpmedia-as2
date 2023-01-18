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
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.errors.UnsupportedOperation;

/**
 * Converts a {@code Map} to an iterator.
 * @author eKameleon
 */
class vegas.data.iterator.MapIterator extends CoreObject implements Iterator 
{

	/**
	 * Creates a new MapIterator instance.
	 * @param m the Map reference of this iterator. 
	 */
	public function MapIterator (m:Map) 
	{
		_m = m ;
		_i = new ArrayIterator(m.getKeys()) ;
		_k = null ;
	}

	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iteration has more elements.
	 */	
	public function hasNext():Boolean 
	{
		return _i.hasNext() ;
	}

	/**
	 * Returns the current key of the internal pointer of the iterator (optional operation).
	 * @return the current key of the internal pointer of the iterator (optional operation).
	 */
	public function key() 
	{
		return _k ;
	}

	/**
	 * Returns the next element in the iteration.
	 * @return the next element in the iteration.
	 */
	public function next() 
	{
		_k = _i.next() ;
		return _m.get(_k) ;
	}

	/**
	 * Removes from the underlying collection the last element returned by the iterator (optional operation).
	 */
	public function remove() 
	{
		_i.remove() ;
		return _m.remove(_k) ;
	}

	/**
	 * Reset the internal pointer of the iterator (optional operation).
	 */
	public function reset():Void 
	{
		_i.reset() ;
	}

	/**
	 * Change the position of the internal pointer of the iterator (optional operation).
	 */	
	public function seek(n:Number):Void 
	{
		throw new UnsupportedOperation("'seek' method is unsupported in MapIterator object.") ;
	}
	
	private var _m:Map ; 
	
	private var _i:ArrayIterator ; 
	
	private var _k ; // current key
	
}