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

import vegas.data.iterator.OrderedIterator;

/**
 * Defines an iterator that operates over an ordered list. This iterator allows both forward and reverse iteration through the list.
 * @author eKameleon
 */
interface vegas.data.iterator.ListIterator extends OrderedIterator 
{

	/**
	 * Inserts the specified element into the list (optional operation).
	 */
	function insert(o):Void ;

	/**
	 * Returns the index of the element that would be returned by a subsequent call to next.
	 * @return the index of the element that would be returned by a subsequent call to next.
	 */
	function nextIndex():Number ;	
	
	/**
	 * Returns the index of the element that would be returned by a subsequent call to previous.
	 * @return the index of the element that would be returned by a subsequent call to previous.
	 */
	function previousIndex():Number ;
	
	/**
	 * Replaces the last element returned by next or previous with the specified element (optional operation).
	 */
	function set(o):Void ;
	
}