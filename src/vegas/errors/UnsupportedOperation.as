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
import vegas.logging.LogEventLevel;

/**
 * Thrown to indicate that the requested operation is not supported.
 * @author eKameleon
 */
class vegas.errors.UnsupportedOperation extends AbstractError 
{

	/**
	 * Creates a new UnsupportedOperation instance.
	 */
	public function UnsupportedOperation(message:String, errorElement:ErrorElement) 
	{
		super(message, errorElement) ;
	}

	/**
	 * Returns the internal LogEventLevel used in the constructor of this instance.
	 * You can overrides this method if you want change the internal LogEventLevel of the error.
	 */
	public function getLevel():Number
	{
		return LogEventLevel.FATAL ;	
	}

}
