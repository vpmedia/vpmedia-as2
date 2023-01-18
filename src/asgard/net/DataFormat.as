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
 * The DataFormat class provides values that specify how downloaded data is received.
 * @author eKameleon
 */
class asgard.net.DataFormat 
{

	/**
	 * Specifies that downloaded data is received as raw binary data.
	 */
	static public var BINARY:String = "binary" ;
	
	/**
	 * Specifies that downloaded data is received as text.
	 */
	static public var TEXT:String = "text" ;
	
	/**
	 * Specifies that downloaded data is received as URL-encoded variables.
	 */
	static public var VARIABLES:String = "variables" ;
	
	/**
	 * Returns {@code true} if the passed argument is valid.
	 * @return {@code true} if the passed argument is valid.
	 */
	static public function validate(sFormat:String):Boolean 
	{
		return (sFormat == DataFormat.BINARY) || (sFormat == DataFormat.TEXT) || (sFormat == DataFormat.VARIABLES) ;
	}

}