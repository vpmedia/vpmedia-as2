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

import asgard.display.DisplayLoader;

import vegas.data.map.HashMap;

/**
 * Collect all DisplayLoader in the application.
 * @author eKameleon
 */
class asgard.display.DisplayLoaderCollector 
{

	/**
	 * Returns {@code true} if the collector contains the specified DisplayLoader defined by this name.
	 */
	static public function contains( sName:String ):Boolean 
	{
		return _map.containsKey( sName ) ;	
	}

	/**
	 * Returns the DisplayLoader in the collector specified by the string name in parameter.
	 */	
	static public function get(sName:String):DisplayLoader 
	{
		return DisplayLoader(_map.get(sName)) ;	
	}
	
	/**
	 * Inserts a DisplayLoader in the collector.
	 */
	static public function insert(sName:String, dObject:DisplayLoader):Boolean 
	{
		return (_map.put(sName, dObject) != null) ;
	}
	
	/**
	 * Removes a DisplayLoader in the collector.
	 */
	static public function remove(sName:String):Void 
	{
		_map.remove(sName) ;
	}
	
	static private var _map:HashMap = new HashMap() ;
	
}
