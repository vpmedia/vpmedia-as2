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
 * Defines the methods that objects that participate in a validation operation.
 * @author eKameleon
 */
interface vegas.core.IValidator 
{
	
	/**
	 * Returns true if the IValidator object validate the value.
	 * @return {@code true} is this specific value is valid.
	 */
	function supports(value):Boolean ;
	
	/**
	 * Evaluates the condition it checks and updates the IsValid property.
	 */
	function validate(value):Void ;
	
}
