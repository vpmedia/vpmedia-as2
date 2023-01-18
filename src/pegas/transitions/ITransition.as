/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.process.Action;

/**
 * The ITransition interface define all process in the application who creates transition effects.
 * @author eKameleon
 */
interface pegas.transitions.ITransition extends Action 
{

	/**
	 * Returns the id of this ITransition .
	 * @return the id of this ITransition .
	 */
	function getID() ;
	
	/**
	 * Sets the id of this ITransition .
	 */
	function setID( id ):Void ;
	
}