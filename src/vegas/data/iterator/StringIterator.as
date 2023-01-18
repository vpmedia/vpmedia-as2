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
import vegas.util.MathsUtil;

/**
 * Converts a string to an iterator.
 * <p><b>Example :</b></p>
 * {@code
 * import  vegas.data.iterator.Iterator ;
 * import  vegas.data.iterator.StringIterator ;
 * 
 * var s = "coucou?" ;
 * 
 * var it:Iterator = new StringIterator(s) ;
 * it.seek(1) ;
 * while(it.hasNext())
 * {
 *     var char = it.next() ;
 *     trace (it.key() + ' : ' + char) ;
 * }
 * trace (s) ;
 * }
 * @author eKameleon
 */
class vegas.data.iterator.StringIterator extends CoreObject implements Iterator 
{

	/**
	 * Creates a new StringIterator instance.
	 * @param s the String object to enumerate.
	 */
	public function StringIterator(s:String) 
	{
		_s = new String(s) ;
		_k = -1 ;
		_size = s.length ;
	}

	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iteration has more elements.
	 */	
	public function hasNext():Boolean 
	{
		return _k < _size-1  ;
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
		return _s.charAt( ++_k );
	}

	/**
	 * Removes from the underlying collection the last element returned by the iterator (optional operation).
	 */
	public function remove() 
	{
		throw new UnsupportedOperation(this + " 'remove' method in unsupported.") ;
	}

	/**
	 * Reset the internal pointer of the iterator (optional operation).
	 */
	public function reset():Void 
	{
		_k = -1 ;
	}

	/**
	 * Change the position of the internal pointer of the iterator (optional operation).
	 */
	public function seek(n:Number):Void 
	{
		_k = MathsUtil.clamp (n-1, -1, _size-1) ;
	}
	
	/**
	 * The internal key.
	 */
	private var _k:Number ;

	/**
	 * The internal string instance.
	 */
	private var _s:String ;
	
	/**
	 * The internal size.
	 */
	private var _size:Number ;
	
}