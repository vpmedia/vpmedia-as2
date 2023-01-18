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
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.data.Stack;
import vegas.errors.IllegalArgumentError;
import vegas.util.AbstractTypeable;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * TypedQueue is a wrapper for Stack instances that ensures that only values of a specific type can be added to the wrapped stack.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.data.Stack ;
 * import vegas.data.stack.SimpleStack ;
 * import vegas.data.stack.TypedStack ;
 * 
 * var s:Stack = new SimpleStack() ;
 * s.push("item1") ;
 * s.push("item2") ;
 * s.push("item3") ;
 * 
 * var ts:Stack = new TypedStack(String, s) ;
 * ts.push("item4") ;
 * 
 * trace("stack >> " + ts.size() + " : " + ts) ;
 * trace("stack.toSource : " + ts.toSource()) ;
 * 
 * ts.push(2) ;
 * }
 * @author eKameleon
 */
class vegas.data.stack.TypedStack extends AbstractTypeable implements ICloneable, Iterable, Stack 
{

	/**
	 * Creates a new TypedStack instance.
	 * @param type the type class of this ITypeable object.
	 * @param stack the Stack reference protected with this ITypeable object.
	 * @throws IllegalArgumentError if the {@code type} argument is {@code null} or {@code undefined}.
	 * @throws IllegalArgumentError if the {@code stack} argument is {@code null} or {@code undefined}.
	 */
	public function TypedStack( type:Function , stack:Stack) 
	{
		super( type ) ;
		if ( stack == null  ) 
		{
			throw new IllegalArgumentError("TypedStack constructor failed, argument 'stack' must not be 'null' or 'undefined'.") ;
		}
		_stack = stack ;
		if (_stack.size() > 0) 
		{
			var it:Iterator = _stack.iterator() ;
			while (it.hasNext()) 
			{
				validate(it.next()) ;
			}
		}
	}

	/**
	 * Removes all of the elements from this Stack (optional operation).
	 */
	public function clear():Void 
	{
		_stack.clear() ;
	}
	
	/**
	 * Returns a shallow copy of this Stack (optional operation).
	 * @return a shallow copy of this Stack (optional operation).
	 */
	public function clone() 
	{
		return new TypedStack(getType(), _stack.clone()) ;
	}

	/**
	 * Returns {@code true} if this Stack contains no elements.
	 * @return {@code true} if this Stack contains no elements.
	 */
	public function isEmpty():Boolean 
	{
		return _stack.isEmpty() ;
	}

	/**
	 * Returns an iterator over the elements in this Stack.
	 * @return an iterator over the elements in this Stack.
	 */
	public function iterator():Iterator 
	{
		return _stack.iterator() ;
	}

	/**
	 * Looks at the object at the top of this stack without removing it from the stack.
	 */
	public function peek() 
	{
		return _stack.peek() ;
	}

	/**
	 * Removes the object at the top of this stack and returns that object as the value of this function.
	 */
	public function pop() 
	{
		return _stack.pop() ;
	}

	/**
	 * Pushes an item onto the top of this stack.
	 */
	public function push(o):Void 
	{
		validate(o) ;
		_stack.push(o) ;
	}

	/**
	 * Returns the 1-based position where an object is on this stack.
	 */
	public function search(o):Number 
	{
		return _stack.search(o) ;
	}
	
	/**
	 * Sets the type of this ITypeable object.
	 */
	public function setType(type:Function):Void 
	{
		super.setType(type) ;
		_stack.clear() ;
	}

	/**
	 * Returns the number of elements in this Stack.
	 * @return the number of elements in this Stack.
	 */
	public function size():Number 
	{
		return _stack.size() ;
	}
	
	/**
	 * Returns the array representation of all the elements of this Stack.
	 * @return the array representation of all the elements of this Stack.
	 */
	public function toArray():Array 
	{
		return _stack.toArray() ;
	}

	/**
	 * Returns a eden representation of the object.
	 * @return a string representation the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = TypeUtil.toString(_type) ;
		var sourceB:String = Serializer.toSource(_stack) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return _stack.toString() ;
	}

	private var _stack:Stack ;
	
}