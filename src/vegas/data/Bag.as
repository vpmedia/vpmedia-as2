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

// TODO TypedBag, Buffer, TreeBag ??

import vegas.data.Collection;
import vegas.data.Set;

/**
 * Defines a collection that counts the number of times an object appears in the collection.
 * 
 * @author eKameleon
 */
interface vegas.data.Bag extends Collection 
{

	/**
	 * (Violation) Returns true if the bag contains all elements in the given collection, respecting cardinality.
	 */
	function containsAll(c:Collection):Boolean ;
	
	/**
	 * Insert all elements represented in the given collection.
	 */
	function insertAll(c:Collection):Boolean ;

	/**
	 * Add n copies of the given object to the bag and keep a count. 
	 */
	function insertCopies(o, nCopies:Number):Boolean ;

	/**
	 * Returns the number of occurrences (cardinality) of the given object currently in the bag.
	 */
	function getCount(o):Number ;
	
	/**
	 * (Violation) Removes all elements represented in the given collection, respecting cardinality.
	 */
	function removeAll(c:Collection):Boolean ;

	/**
	 * Removes the given number of occurrences from the bag.
	 */
	function removeCopies(o, nCopies:Number):Boolean ; 

	/**
	 * (Violation) Removes any members of the bag that are not in the given collection, respecting cardinality.
	 */
	function retainAll(c:Collection):Boolean ;

	/**
	 * Returns the Set of unique members that represent all members in the bag.
	 */
	function uniqueSet():Set ;

}
