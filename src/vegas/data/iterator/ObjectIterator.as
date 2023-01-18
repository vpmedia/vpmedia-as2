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
import vegas.util.MathsUtil;

/**
 * Converts an object to an iterator.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.data.iterator.ObjectIterator ;
 * import vegas.data.iterator.Iterator ;
 * 
 * var o:Object = {} ;
 * for (var i:Number = 0 ; i<5; i++)
 * {
 *      o["prop"+i] = "item"+i ;
 * }
 * 
 * var it:Iterator = new ObjectIterator(o) ;
 * trace ("-- object iterator") ;
 * 
 * while (it.hasNext())
 * {
 *     var next = it.next() ;
 *     var index = ObjectIterator(it).index() ;
 *     var key = it.key() ;
 *     trace ("it >> " + index + " :: " + key + " : " + next) ;
 * }
 * 
 * trace ("-- it seek 1") ;
 * 
 * it.seek(1) ;
 * 
 * while (it.hasNext())
 * {
 *     it.next() ;
 *     trace ("it remove : " + it.remove()) ;
 * }
 * 
 * trace ("-- it reset") ;
 * 
 * it.reset() ;
 * 
 * while (it.hasNext())
 * {
 *     var next = it.next() ;
 *     var index = ObjectIterator(it).index() ;
 *     var key = it.key() ;
 *     trace ("it >> " + index + " :: " + key + " : " + next) ;
 * }
 * }
 * @author eKameleon
 */
class vegas.data.iterator.ObjectIterator extends CoreObject implements Iterator 
{

	/**
	 * Creates a new ObjectIterator instance.
	 */
	public function ObjectIterator(o) 
	{
		_o = o ;
		_a = new Array() ;
		_k = -1 ;
		for (var each:String in o) 
		{
			if (typeof(o[each]) != "function") 
			{
				_a.push(each) ;
			}
		}
		_len = _a.length ;
	}
	
	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iteration has more elements.
	 */	
	public function hasNext():Boolean 
	{
		return _k <  (_len - 1) ;
	}

	/**
	 * Returns the current index of the internal pointer of the iterator (optional operation).
	 * @return the current index of the internal pointer of the iterator (optional operation).
	 */
	public function index():Number 
	{
		return _k ;
	}

	/**
	 * Returns the current key value of the internal pointer of the iterator (optional operation).
	 * @return the current key value of the internal pointer of the iterator (optional operation).
	 */
	public function key() 
	{
		return _a[_k] ;
	}

	/**
	 * Returns the next element in the iteration.
	 * @return the next element in the iteration.
	 */
	public function next() 
	{
		return _o[ _a[++_k] ] ;
	}

	/**
	 * Removes from the object the last element returned by the iterator (optional operation).
	 */
	public function remove() 
	{
		var p:String = _a[_k] ;
		_a.splice(_k--, 1) ;
		delete _o[p] ;
		_len -- ;
		return p ;
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
		_k = MathsUtil.clamp ((n-1), -1, _len) ;
	}
	
	/**
	 * The internal array.
	 */
	private var _a:Array ;
	
	/**
	 * The internal key.
	 */
	private var _k:Number ;
	
	/**
	 * The internal object reference.
	 */
	private var _o ;
	
	/**
	 * The internal size of the array.
	 */
	private var _len:Number ;
	
}