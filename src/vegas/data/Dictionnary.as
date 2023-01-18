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

import vegas.data.Enumeration;

/**
 * The Dictionary is an interface such as Map, which maps keys to values. Every key and every value is an object. In any one Dictionary object, every key is associated with at most one value.
 * @author eKameleon
 */
interface vegas.data.Dictionnary 
{
	
	/**
	 * Returns an enumeration of the keys in this dictionary.
	 */
	function getKeys():Enumeration ;

	/**
	 * Returns the value to which the key is mapped in this dictionary.
	 */
	function get(key) ;

	/**
	 * Returns an enumeration of the values in this dictionary.
	 */
	function getValues():Enumeration ;

	/**
	 * Returns {@code true} if this dictionnary contains no elements.
	 * @return {@code true} if this dictionnary is empty else {@code false}.
	 */
	function isEmpty():Boolean ;
	
	/**
	 * Maps the specified key to the specified value in this dictionary.
	 */
	function put( key , value ) ;
	
	/**
	 * Removes the key (and its corresponding value) from this dictionary.
	 */
	function remove(key) ;

	/**
	 * Returns the number of entries (dinstint keys) in this dictionary.
	 * @return the number of entries.
	 */
	function size():Number ;
	
}