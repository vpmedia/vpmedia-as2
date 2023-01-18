/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.core.ApplicationID;

import asgard.config.Config;
import asgard.config.ConfigurableObject;

/**
 * Update all allow domains of the application with the array 'security' in the configuration of the application.
 * @author eKameleon
 */
class andromeda.system.ApplicationPolicy extends ConfigurableObject 
{
	
	/**
	 * Creates a new ApplicationPolicy instance.
	 */
	private function ApplicationPolicy() 
	{
		//
	}
	
	/**
	 * Returns the singleton reference of the ApplicationPolicy.
	 * @return the singleton reference of the ApplicationPolicy.
	 */
	static public function getInstance():ApplicationPolicy 
	{
		if (!_instance) 
		{
			_instance = new ApplicationPolicy() ;
		}
		return _instance ;
	}
	
	/**
	 * Update the allow domains of the application and use the array 'security' in the config file.
	 */
	/*override*/  public function setup():Void 
	{
		var security:Array = Config.getInstance()[ApplicationID.SECURITY] ;
		if (security.length > 0) 
		{
			var domain:String ;
			var l:Number = security.length ;
			while(--l > -1) 
			{
				getLogger().info( this + ' - System.security.allowDomain : {0} ' , security[l] ) ;		
				System.security.allowDomain(security[l]) ;
			}
		}
	}
	
	/**
	 * The internal singleton reference of the ApplicationPolicy.
	 */
	static private var _instance:ApplicationPolicy ;
	
}