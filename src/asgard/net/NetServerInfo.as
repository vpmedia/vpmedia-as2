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

import vegas.core.CoreObject;
import vegas.util.serialize.Serializer;

/**
 * Defines the information object in a onStatus callback method.
 * @author eKameleon
 * @version 1.0.0.0
 */	
class asgard.net.NetServerInfo extends CoreObject 
{
	
	/**
	 * Creates a new NetServerInfo object.
	 * @param oInfo a primitive object with the properties 'code', 'level', 'description' and 'application'.
	 */
	public function NetServerInfo( oInfo ) 
	{
		if ( oInfo != null )
		{
			description = oInfo.description || null ;
			code        = oInfo.code || null ;
			level       = oInfo.level || null ;
			application = oInfo.application || null ;
		} 
	}

	/**
	 * This object exist if the server return an application error object. 
	 * This property exist with FMS when the SSAS {@code application.rejectConnection()} method is invoqued. 
	 */
	public var application ;

	/**
	 * The code of this information object.
	 */
	public var code:String ;
	
	/**
	 * The description of this information object.
	 */
	public var description:String ;
	
	/**
	 * The level of this information object.
	 */
	public var level:String ;

	/**
	 * Returns the {@code Object} representation of this instance.
	 * @return the {@code Object} representation of this instance.
	 */
	public function toObject():Object 
	{
		return { description:description, code:code, level:level , application:application } ;
	}

	/**
	 * Returns the Eden String representation of the object.
	 * @return the Eden String representation of the object.
	 */	
	public function toSource(indent : Number, indentor : String):String 
	{
		return "new asgard.net.NetServerInfo(" + Serializer.toSource(toObject()) + ")" ;
	}
	
	/**
	 * Returns the String representation of this object.
	 * @return the String representation of this object.
	 */
	public function toString():String
	{
		var s:String = "[NetServerInfo" ;
		if (code != null)
		{
			s += " code:" + code ;	
		}
		if (level != null)
		{
			s += " level:" + level ;	
		}
		if (description != null)
		{
			s += " description:" + description ;	
		}
		if (application != null)
		{
			s += " application:" + application  ;	
		}
		s += "]" ;
		return s ;
	}

}