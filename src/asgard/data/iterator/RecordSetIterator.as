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

import asgard.data.remoting.RecordSet;

import vegas.core.CoreObject;
import vegas.data.iterator.Iterator;
import vegas.util.MathsUtil;

/**
 * Converts an {@code RecordSet} instance to an iterator.
 * @author eKameleon
 */
class asgard.data.iterator.RecordSetIterator extends CoreObject implements Iterator 
{

	/**
	 * Creates a new RecordSetIterator instance.
	 * @param rs the RecordSet reference of this iterator.
	 */
	public function RecordSetIterator(rs:RecordSet) {
		_rs = rs ;
		_k = -1;
	}

	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iteration has more elements.
	 */	
	public function hasNext() : Boolean 
	{
		return _k < (_rs.size() - 1) ;
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
		return _rs.getItemAt( ++_k );
	}

	/**
	 * Removes from the underlying collection the last element returned by the iterator (optional operation).
	 */
	public function remove() 
	{
		return _rs.removeItemAt(_k--);
	}

	/**
	 * Reset the internal pointer of the iterator (optional operation).
	 */
	public function reset() : Void 
	{
		_k = -1 ;
	}

	/**
	 * Change the position of the internal pointer of the iterator (optional operation).
	 */	
	public function seek(n : Number) : Void 
	{
		_k = MathsUtil.clamp ((n-1), -1, _rs.size()) ;
	}
	
	private var _k:Number ; 
	private var _rs:RecordSet ;

}