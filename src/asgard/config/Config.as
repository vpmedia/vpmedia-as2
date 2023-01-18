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

/**
 * The dynamic Config singleton. This object is a global reference to register all external properties.
 * @author eKameleon
 */
dynamic class asgard.config.Config extends CoreObject 
{
	
	private function Config() 
	{
		super();
	}

	static public function getInstance():Config 
	{
		
		if( !__instance) __instance = new Config() ;
		return __instance ;
		
	}

	static private var __instance:Config ;

	private var prototype ;
	
}