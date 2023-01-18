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

import vegas.errors.AbstractError;
import vegas.errors.ErrorElement;

/**
 * Thrown to indicate that the code has attempted to cast an object to a subclass of which it is not an instance.
 * @author eKameleon
 */
class vegas.errors.ClassCastError extends AbstractError 
{
	
	/**
	 * Creates a new ClassCastError instance.
	 */
	function ClassCastError(message : String, e : ErrorElement) 
	{
		super(message, e);
	}

}