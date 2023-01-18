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

/**
 * An object that implements the Enumeration interface generates a series of elements, one at a time. Successive calls to the nextElement method return successive elements of the series.
 * @author eKameleon
 */
interface vegas.data.Enumeration 
{
	
	/**
	 * Tests if this enumeration contains more elements.
	 * @return {@code true} if and only if this enumeration object contains at least one more element to provide; false otherwise.
	 */
	function hasMoreElements():Boolean ;
	
	/**
	 * Returns the next element of this enumeration if this enumeration object has at least one more element to provide.
	 * @return the next element of this enumeration.
	 */
	function nextElement() ;
		
}