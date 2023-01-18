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
import vegas.data.iterator.ListIterator;
import vegas.data.List;
import vegas.data.list.AbstractList;
import vegas.errors.ConcurrentModificationError;
import vegas.errors.IllegalArgumentError;
import vegas.errors.IllegalStateError;
import vegas.errors.IndexOutOfBoundsError;
import vegas.errors.NoSuchElementError;
import vegas.util.MathsUtil;

/**
 * Converts an {@code ArrayList} or other list based on the {@code AbstractList} class to an {@code ListIterator}.
 * @author eKameleon
 */
class vegas.data.iterator.ListItr extends CoreObject implements ListIterator 
{

	/**
	 * Creates a new ListItr instance.
	 */
	public function ListItr(li:List) 
	{
		if (!li)
		{
			throw new IllegalArgumentError(this + "constructor, 'li' argument must not be 'null' nor 'undefined'.") ;
		}
		_list = li ;
		_key = 0 ;
		_listast = -1 ;
		_expectedModCount = AbstractList(_list).getModCount() ;
	}
	
	// ----o Public Methods

	public function checkForComodification():Void {
		var l:AbstractList = AbstractList(_list) ;
	    if (l.getModCount() != _expectedModCount) 
	    {
	    	throw new ConcurrentModificationError(this + " checkForComodification") ;
	    }
	}

	public function hasNext():Boolean {
		return _key < _list.size() ;
	}
	
	public function hasPrevious():Boolean { 
		return _key != 0 ;
	}

	public function insert(o):Void {
		checkForComodification() ;
		try {
			_list.insertAt(_key++, o) ;
			_listast = -1 ;
			_expectedModCount = AbstractList(_list).getModCount() ;
		} catch (e:ConcurrentModificationError) {
			throw new ConcurrentModificationError() ;
		}	
	}

	public function key() {
		return _key ;
	}

	public function next() {
		if (hasNext()) {
			var next = _list.get(_key) ;
			_listast = _key ;
			_key++ ;
			return next ;
		} else {
			throw new NoSuchElementError ;
		}
	}
	
	public function nextIndex():Number {
		return _key ;
	}
		
	public function previous() {
		checkForComodification() ;
		try {
			var i:Number = _key - 1 ;
			var prev = _list.get(i) ;
			_listast = _key  = i ;
			return prev ;
		} catch(e:IndexOutOfBoundsError) {
			checkForComodification();
			throw new NoSuchElementError ;
		}
	}

	public function previousIndex():Number {
		return _key - 1 ;
	}

	public function remove() {
		if (_listast == -1) throw new IllegalStateError ;
		checkForComodification() ;
		try {
			_list.removeAt(_listast) ;
			if (_listast < _key) _key -- ;
			_listast = -1 ;
			_expectedModCount = AbstractList(_list).getModCount() ;
		} catch (e:ConcurrentModificationError) {
			throw new ConcurrentModificationError() ;
		}
	}

	public function reset():Void {
		_key = 0 ;
		_listast = -1 ;
	}

	public function seek(n:Number):Void {
		_key = MathsUtil.clamp(n, 0, _list.size()) ;
		_listast = _key - 1 ;
	}

	public function set(o):Void {
		if (_listast == -1) throw new IllegalStateError() ;
		checkForComodification() ;
		try {
			_list.setAt(_listast, o) ;
			_expectedModCount = AbstractList(_list).getModCount() ;
		} catch (e:ConcurrentModificationError) {
			throw new ConcurrentModificationError() ;
		}
	}
	
	// ----o Private Properties
	
	private var _list:List ; // Collection
	private var _key:Number ;
	private var _listast:Number ;
	private var _expectedModCount:Number ;

}