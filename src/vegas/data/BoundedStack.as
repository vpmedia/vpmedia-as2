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

import vegas.data.Stack;

/**
 * Defines a stack that is bounded in size. The size of the stack can vary, but it can never exceed a preset maximum number of elements. This interface allows the querying of details associated with the maximum number of elements.
 * @author eKameleon
 */
interface vegas.data.BoundedStack extends Stack 
{

	/**
	 * Returns {@code true} if the object is full.
	 */
	function isFull():Boolean ;

	/**
	 * Returns the max number of occurrences in the given stack.
	 */
	function maxSize():Number ;

}