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

import vegas.data.iterator.OrderedIterator;

/**
 * The IStepper interface.
 * @author eKameleon
 */
interface lunas.core.IStepper extends OrderedIterator 
{
	
	/**
	 * Returns the maximum value of the stepper.
	 * @return the maximum value of the stepper.
	 */
	function getMaximum():Number ;

	/**
	 * Returns the minimum value of the stepper.
	 * @return the minimum value of the stepper.
	 */
	function getMinimum():Number ;

	/**
	 * Returns the step size value of the stepper.
	 * @return the step size value of the stepper.
	 */
	function getStepSize():Number ;

	/**
	 * Returns the current value of the stepper.
	 * @return the current value of the stepper.
	 */
	function getValue():Number ;	
	
	/**
	 * Sets the maximum value of the stepper.
	 */
	function setMaximum(n:Number):Void ;
	
	/**
	 * Sets the minimum value of the stepper.
	 */
	function setMinimum(n:Number):Void ;
	
	/**
	 * Sets the step size value of the stepper.
	 */
	function setStepSize(n:Number):Void ;

	/**
	 * Sets the current value of the stepper.
	 */
	function setValue(n:Number):Void ;

}
	