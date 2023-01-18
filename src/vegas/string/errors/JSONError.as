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

import vegas.errors.FatalError;

/**
 * This JSONError is throw in the JSON static methods.
 * @author eKameleon
 */
class vegas.string.errors.JSONError extends FatalError 
{

	/**
	 * Creates a new JSONError instance.
	 */
	public function JSONError(message:String, at:Number, source:String) 
	{
		super( formatMessage(message, at, source ) ) ;
	}

	/**
	 * The 'at' property.
	 */
	public var at:Number ;
	
	/**
	 * The source of the json error.
	 */
	public var source:String ;
	
	public function formatMessage( message:String , at:Number, source:String ):String
	{
		var ret:String = message || "" ;
		
		if (!isNaN(at)) 
		{
			ret += ", at:" + at ;
		}
		
		if (source) 
		{
			ret += " in \"" + source + "\"";
		}
		
		this.at = at ;
		this.source = source ;
		
		return ret ;
	}
	
}
