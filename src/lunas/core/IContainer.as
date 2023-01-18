/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.data.iterator.Iterator;

/**
 * This interface is used to creates container components.
 * @author eKameleon
 */
interface lunas.core.IContainer 
{

	/**
	 * Adds a visual child in the display.
	 */
	function addChild( o , oInit) ;

	/**
	 * Adds childs in the container at the specified index.
	 */
	function addChildAt(o, index:Number, oInit)  ;

	/**
	 * Clear the container.
	 */
	function clear():Void ;

	/**
	 * Returns {@code true} if the model contains the specified child reference.
	 * @return {@code true} if the model contains the specified child reference.
	 */
	function contains( oChild ):Boolean ;

	/**
	 * Returns the child reference in the container with the specified index value.
	 * @return the child reference in the container with the specified index value.
	 */
	function getChildAt(index:Number) ;

	/**
	 * Returns the child reference in the container specified by the passed-in key number.
	 * @return the child reference in the container specified by the passed-in key number.
	 */
	function getChildByKey(key:Number) ;

	/**
	 * Returns the child reference in the container specified by the passed-in key name.
	 * @return the child reference in the container specified by the passed-in key name.
	 */
	function getChildByName(name:String) ;
	
	/**
	 * Returns the internal model reference of this container.
	 * @return the internal model reference of this container.
	 */
	function iterator():Iterator ;

	/**
	 * Returns the index number value of the specified child reference in argument.
	 * @return the index number value of the specified child reference in argument.
	 */
	function indexOf( oChild ):Number ;
	
	/**
	 * Removes the specified child in argument.
	 * @return the removed child.
	 */
	function removeChild( oChild ):Void ;

	/**
	 * Removes the specified child defines with the index value in argument.
	 * @return the removed child.
	 */
	function removeChildAt(index:Number):Void ;

	/**
	 * Removes all childs in the model defined for the first item by the specified index value, 
	 * this method remove the first child and all to the {@code size - 1} items.
	 */
	function removeChildsAt(index:Number, len:Number):Void ;

	/**
	 * Removes a range of childs in the model.
	 * @return the array representation of all removed items.
	 */
	function removeRange(from:Number, to:Number):Void ;

	/**
	 * Sets the specified child index (move the child in the model).
	 */
	function setChildIndex( oChild, index:Number):Void ;
	
	/**
	 * Returns the number of childs in the container.
	 * @return the number of childs in the container.
	 */
	function size():Number ;
	 
}