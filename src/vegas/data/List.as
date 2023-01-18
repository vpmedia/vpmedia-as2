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

import vegas.data.Collection;
import vegas.data.iterator.ListIterator;

/**
 * An ordered collection (also known as a sequence). The user of this interface has precise control over where in the list each element is inserted. The user can access elements by their integer index (position in the list), and search for elements in the list.
 * @author eKameleon
 */
interface vegas.data.List extends Collection 
{
	
	/**
	 * Returns {@code true} if this list contains all of the elements of the specified collection.
	 */
	function containsAll(c:Collection):Boolean ;

	/**
	 * Indicates whether some other object is "equal to" this one.
	 */
	function equals(o):Boolean ;

	/**
	 * Returns the index in this list of the first occurrence of the specified element, or -1 if this list does not contain this element.
	 */
	function indexOf(o):Number ;
	
	/**
	 * Appends all of the elements in the specified collection to the end of this list, in the order that they are returned by the specified collection's iterator (optional operation).
	 */
	function insertAll(c:Collection):Boolean ;
	
	/**
	 * Inserts all of the elements in the specified collection into this list at the specified position (optional operation).
	 */
	function insertAllAt(id:Number, c:Collection):Boolean ;

	/**
	 * Inserts the specified element at the specified position in this list (optional operation).
	 */
	function insertAt(id:Number, o):Void ;

	/**
	 * Returns the index in this list of the last occurrence of the specified element, or -1 if this list does not contain this element.
	 */
	function lastIndexOf(o):Number ;
	
	/**
	 * Returns a list iterator of the elements in this list (in proper sequence).
	 */
	function listIterator():ListIterator ;

	/**
	 * Removes from this list all the elements that are contained in the specified collection (optional operation).
	 */
	function removeAll(c:Collection):Boolean ;

	/**
	 * Removes the element at the specified position in this list (optional operation).
	 */
	function removeAt(id:Number) ;

	/**
	 * Removes from this list all the elements that are contained between the specific {@code from} and the specific {@code to} position in this list (optional operation).
	 */
	function removeRange(from:Number, to:Number):Void ;
	
	/**
	 * Removes from this list all the elements that are contained between the specific {@code id} position and the end of this list (optional operation).
	 */
	function removesAt(id:Number, len:Number) ;

	/**
	 * Retains only the elements in this list that are contained in the specified collection (optional operation).
	 */
	function retainAll(c:Collection):Boolean ;

	/**
	 * Replaces the element at the specified position in this list with the specified element (optional operation).
	 */
	function setAt(id:Number, o) ;
	
	/**
	 * Returns a view of the portion of this list between the specified fromIndex, inclusive, and toIndex, exclusive.
	 */
	function subList(fromIndex:Number, toIndex:Number):List ;

}
