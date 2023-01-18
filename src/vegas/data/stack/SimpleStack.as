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

import vegas.core.ICloneable;
import vegas.data.Collection;
import vegas.data.collections.AbstractCollection;
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.data.iterator.ProtectedIterator;
import vegas.data.Stack;

/**
 * The based implementation of the Stack interface.
 * The Stack interface represents a last-in-first-out (LIFO) stack of objects.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.data.iterator.Iterator ;
 * import vegas.data.Stack ;
 * import vegas.data.stack.SimpleStack ;
 * 
 * var s:Stack = new SimpleStack() ;
 * 
 * s.push("item1") ;
 * s.push("item2") ;
 * s.push("item3") ;
 * 
 * trace ("stack peek : " + s.peek()) ;
 * trace ("stack pop : " + s.pop()) ;
 * 
 * trace ("stack.toSource : " + s.toSource()) ;
 * trace ("toString : " + s) ;
 * 
 * trace ("stack iterator") ;
 * var i:Iterator = s.iterator() ;
 * while (i.hasNext())
 * {
 *     trace ( " - " + i.next()) ;
 * }
 * }
 * @author eKameleon
 */
class vegas.data.stack.SimpleStack extends AbstractCollection implements Iterable, ICloneable, Collection, Stack 
{

	/**
	 * Creates a new SimpleStack instance.
	 * @param ar an array to fill the Stack
	 */
	public function SimpleStack(ar:Array) 
	{
		super(ar) ;
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new SimpleStack(_a) ;
	}

	/**
	 * Returns an element but if id = 0, it's the last element in the stack.
	 * @return an element but if id = 0, it's the last element in the stack.
	 */
	public function get(id:Number) 
	{ 
		var a:Array = toArray() ;
		return a[id] ;
	}

	/**
	 * Returns an iterator over the elements in this Stack.
	 * @return an iterator over the elements in this Stack.
	 */
	public function iterator():Iterator 
	{
		return (new ProtectedIterator(new ArrayIterator(toArray()))) ;
	}

	/**
	 * Looks at the object at the top of this stack without removing it from the stack.
	 */
	public function peek() 
	{
		return _a[_a.length - 1] ;
	}

	/**
	 * Removes the object at the top of this stack and returns that object as the value of this function.
	 * @return the removed object value.
	 */
	public function pop() 
	{
		return isEmpty() ? null : _a.pop() ;
	}

	/**
	 * Pushes an item into the top of this stack.
	 */
	public function push(o):Void 
	{
		_a.push(o) ;
	}

	/**
	 * Returns the index of an element in the Stack.
	 * @return the index of an element in the Stack.
	 */
	public function search(o):Number 
	{
		return indexOf(o) ;
	}

	/**
	 * Returns the array representation of all the elements of this Stack.
	 * @return the array representation of all the elements of this Stack.
	 */
	public function toArray():Array 
	{
		var aReverse:Array = _a.slice() ;
		aReverse.reverse() ;
		return aReverse ;
	}

}