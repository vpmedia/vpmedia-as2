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

/**
 * The IStepper interface.
 * @author eKameleon
 */
interface lunas.display.components.IStepper 
{
	
	function getNextValue():Number ;
	
	function getPreviousValue():Number ;

	function getMaximum():Number ;
	
	function getMinimum():Number ;
	
	function getValue():Number ;	
	
	function getStepSize():Number ;
		
	function setMaximum(n:Number):Void ;
	
	function setMinimum(n:Number):Void ;
	
	function setStepSize(n:Number):Void ;

	function setValue(n:Number):Void ;

}
	