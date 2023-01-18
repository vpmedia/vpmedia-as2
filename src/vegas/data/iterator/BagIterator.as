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
import vegas.data.bag.AbstractBag;
import vegas.data.iterator.Iterator;
import vegas.errors.ConcurrentModificationError;
import vegas.errors.UnsupportedOperation;

/**
 * Converts an Bag to an iterator.
 * @author eKameleon
 */
class vegas.data.iterator.BagIterator extends CoreObject implements Iterator 
{

	/**
	 * Creates a new BagIterator instance.
	 * @param parent the bag (@code AbstractBag) used in this iterator.
	 * @param support the iterator to support this iterator.
	 */
    public function BagIterator( parent:AbstractBag, support:Iterator ) 
    {
		_parent = parent;
		_support = support ;
		_current = null;
		_mods = parent.getModCount() ;
	}

	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iteration has more elements.
	 */	
	public function hasNext():Boolean 
	{
		return _support.hasNext() ;
	}

	/**
	 * Unsupported method in all BagIterator.
	 * @throws UnsupportedOperation {@ode key} method in unsupported.
	 */
	public function key() 
	{
		throw new UnsupportedOperation(this + " 'key' method in unsupported.") ;
	}

	/**
	 * Returns the next element in the iteration.
	 * @return the next element in the iteration.
	 */
	public function next() 
	{
		if (_parent.getModCount() != _mods) 
		{
			throw new ConcurrentModificationError();
		}
        _current = _support.next() ;
		return _current;
    }

	/**
	 * Removes from the underlying collection the last element returned by the iterator (optional operation).
	 */
	public function remove() 
	{
		if (_parent.getModCount() != _mods) 
		{
            throw new ConcurrentModificationError();
        }
        _support.remove() ;
        _parent.removeCopies(_current, 1);
		_mods++ ;
    }

	/**
	 * Unsupported method in all BagIterator.
	 * @throws UnsupportedOperation {@code reset} method in unsupported.
	 */
	public function reset():Void 
	{
		throw new UnsupportedOperation(this + " 'reset' method in unsupported.") ;
	}

	/**
	 * Unsupported method in all BagIterator.
	 * @throws UnsupportedOperation {@code seek} method in unsupported.
	 */
	public function seek(n:Number):Void 
	{
		throw new UnsupportedOperation(this + " 'seek' method in unsupported.") ;
	}

	private var _current = null ;

	private var _mods:Number = 0;

	private var _parent:AbstractBag = null ;

	private var _support:Iterator = null ;

}