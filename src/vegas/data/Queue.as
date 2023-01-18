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

import vegas.core.ISerializable;
import vegas.data.iterator.Iterator;

/**
 * A collection designed for holding elements prior to processing. Besides basic Collection operations, queues provide additional insertion, extraction, and inspection operations.
 * <p>
 * Queues typically, but do not necessarily, order elements in a FIFO (first-in-first-out) manner.
 * </p>
 * <p>Whatever the ordering used, the head of the queue is that element which would be removed by a call to remove() or poll().</p>
 * @author eKameleon
 */
interface vegas.data.Queue extends ISerializable 
{
	
	/**
	 * Removes all of the elements from this queue (optional operation).
	 */
	function clear():Void ;
	
	/**
	 * Returns the shallow copy of this queue.
	 */
	function clone() ;
	
	/**
	 * Retrieves and removes the head of this queue.
	 */
	function dequeue():Boolean ;

	/**
	 * Retrieves, but does not remove, the head of this queue.
	 */
	function element() ;
	
	/**
	 * Inserts the specified element into this queue, if possible.
	 */
	function enqueue(o):Boolean ;

	/**
	 * Returns {@code true} if this queue contains no elements.
	 * @return {@code true} if this queue is empty else {@code false}.
	 */
	function isEmpty():Boolean ;

	/**
	 * Returns the iterator of this queue.
	 */
	function iterator():Iterator ;
	
	/**
	 * Retrieves, but does not remove, the head of this queue, returning null if this queue is empty.
	 */
	function peek() ;
	
	/**
	 * Retrieves and removes the head of this queue.
	 */
	function poll() ;

	/**
	 * Returns the number of elements in this queue.
	 */
	function size():Number ;

	/**
	 * Returns an array containing all of the elements in this collection.
	 */
	function toArray():Array ;

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	function toString():String ;
	
}