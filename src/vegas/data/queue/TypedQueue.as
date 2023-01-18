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

import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.data.Queue;
import vegas.errors.IllegalArgumentError;
import vegas.util.AbstractTypeable;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * TypedQueue is a wrapper for Queue instances that ensures that only values of a specific type can be added to the wrapped queue.
 * @author eKameleon
 */
class vegas.data.queue.TypedQueue extends AbstractTypeable implements Iterable, Queue 
{

	/**
	 * Creates a new TypedQueue instance.
	 * @param type The type of all elements insert in the Queue.
	 * @param queue The Queue to be wrapped. 
	 */
	public function TypedQueue(type:Function, queue:Queue) 
	{
		super(type) ;
		if (!queue) 
		{
			throw new IllegalArgumentError("TypedQueue constructor failed, the argument 'queue' must not be 'null' or 'undefined'.") ;
		}
		_queue = queue ;
		if (_queue.size() > 0) 
		{
			var it:Iterator = _queue.iterator() ;
			while (it.hasNext()) 
			{
				validate(it.next()) ;
			}
		}
	}
	
	/**
	 * Removes all elements in this typed queue.
	 */
	public function clear():Void 
	{
		_queue.clear() ;
	}

	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		return new TypedQueue(_type, _queue.clone()) ;
	}

	/**
	 * Removes the head of this queue and return true if removes.
	 * @return {@code true} if the Queue is dequeue.
	 */
	public function dequeue():Boolean 
	{
		return _queue.dequeue() ;
	}

	/**
	 * Retrieves, but does not remove, the head of this queue.
	 */
	public function element() 
	{
		return _queue.element() ;
	}
	
	/**
	 * Inserts the specified element into this queue, if possible and return true.
	 */
	public function enqueue(o):Boolean 
	{
		validate(o) ;
		return _queue.enqueue(o) ;  
	} 

	/**
	 * Returns {@code true} if this queue is empty.
	 * @return {@code true} if this queue is empty.
	 */
	public function isEmpty():Boolean 
	{
		return _queue.isEmpty() ;
	}

	/**
	 * Returns the iterator representation of the object.
	 * @return the iterator representation of the object.
	 */
	public function iterator():Iterator 
	{
		return _queue.iterator() ;
	}

	/**
	 * Retrieves, but does not remove, the head of this queue, returning null if this queue is empty.
	 */
	public function peek() 
	{
		return _queue.peek() ;
	}
	
	/**
	 * Retrieves and removes the head of this queue.
	 */
	public function poll() 
	{
		return _queue.poll() ;
	}

	/**
	 * Sets the type of this ITypeable object.
	 */
	public function setType(type:Function):Void 
	{
		super.setType(type) ;
		_queue.clear() ;
	}

	/**
	 * Returns the size of this queue.
	 * @return the size of this queue.
	 */
	public function size():Number 
	{
		return _queue.size() ;
	}

	/**
	 * Returns an array representation of this queue.
	 * @return an array representation of this queue.
	 */
	public function toArray():Array 
	{
		return _queue.toArray() ;
	}

	/**
	 * Returns the eden representation of the object.
	 * @return the string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = TypeUtil.toString(_type) ;
		var sourceB:String = Serializer.toSource(_queue) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String 
	{
		return _queue.toString() ;
	}

	/**
	 * The internal queue reference.
	 */	
	private var _queue:Queue ;

}