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
import vegas.data.iterator.Iterator;
import vegas.errors.UnsupportedOperation;

/**
 * Protect an iterator. This class protect the remove, reset and seek method. 	
 * @author eKameleon 
 */
class vegas.data.iterator.ProtectedIterator extends CoreObject implements Iterator 
{

	/**
	 * Creates a new ProtectedIterator instance.
	 * @param iterator the iterator to protected.
	 */
	public function ProtectedIterator (iterator:Iterator) 
	{
		_i = iterator ;
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
		return _i.key() ;
	}

	/**
	 * Returns the next element in the iteration.
	 * @return the next element in the iteration.
	 */
	public function next() 
	{
		return _i.next() ;
	}

	/**
	 * Unsupported method in all ProtectedIterator.
	 * @throws UnsupportedOperation the remove method is unsupported in a ProtectedIterator instance.
	 */
	public function remove() 
	{
		throw new UnsupportedOperation(this + " 'remove' method in unsupported.") ;
	}

	/**
	 * Unsupported method in all ProtectedIterator.
	 * @throws UnsupportedOperation the reset method is unsupported in a ProtectedIterator instance.
	 */
	public function reset():Void 
	{
		throw new UnsupportedOperation(this + " 'reset' method in unsupported.") ;
	}

	/**
	 * Unsupported method in all ProtectedIterator.
	 * @throws UnsupportedOperation the seek method is unsupported in a ProtectedIterator instance.
	 */
	public function seek(n:Number):Void 
	{
		throw new UnsupportedOperation(this + " 'seek' method in unsupported.") ;
	}

	/**
	 * Internal iterator.
	 */
	private var _i:Iterator ;
	
}