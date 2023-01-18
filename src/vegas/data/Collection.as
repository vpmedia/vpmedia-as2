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
 * The root interface in the collection hierarchy. A collection represents a group of objects, known as its elements. Some collections allow duplicate elements and others do not. Some are ordered and others unordered. 
 * @author eKameleon
 */
interface vegas.data.Collection extends ISerializable 
{

	/**
	 * Removes all of the elements from this collection (optional operation).
	 */
	function clear():Void ;

	/**
	 * Returns a shallow copy of this collection (optional operation)
	 */
	function clone() ;

	/**
	 * Returns {@code true} if this collection contains the specified element.
	 * @return {@code true} if this collection contains the specified element.
	 */
	function contains(o):Boolean ;
	
	/**
	 * Returns the element from this collection at the passed index.
	 */
	function get(id:Number) ;

	/**
	 * Ensures that this collection contains the specified element (optional operation).
	 */
	function insert(o):Boolean ;
	
	/**
	 * Returns {@code true} if this collection contains no elements.
	 * @return {@code true} if this collection is empty else {@code false}.
	 */
	function isEmpty():Boolean ;

	/**
	 * Returns an iterator over the elements in this collection.
	 */
	function iterator():Iterator ;
	
	/**
	 * Removes a single instance of the specified element from this collection, if it is present (optional operation).
	 */
	function remove(o):Boolean ;
	
	/**
	 * Returns the number of elements in this collection.
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
