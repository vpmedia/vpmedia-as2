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

import andromeda.model.IModel;

import vegas.data.map.HashMap;
import vegas.errors.Warning;

/**
 * This collector use a Map to register all IModel in the application.
 * @author eKameleon
 */
class andromeda.model.ModelCollector 
{

	/**
	 * Removes all IModel references in the collector.
	 */
	static public function clear():Void 
	{
		_map.clear() ;	
	}
	
	/**
	 * Returns {@code true} if the collector contains the IModel register with the id passed in argument.
	 * @param id the id of the model register in the model.
	 * @return {@code true} if the collector contains the IModel register with the id passed in argument.
	 */
	static public function contains( id ):Boolean 
	{
		return _map.containsKey( id ) ;	
	}
	
	/**
	 * Returns {@code true} if the collector contains the IModel passed in argument.
	 * @param model the IModel to search in the model.
	 * @return {@code true} if the collector contains the IModel passed in argument.
	 */
	static public function containsModel( model:IModel ):Boolean
	{
		return _map.containsValue( model ) ;	
	}
	
	/**
	 * Returns the IModel reference with the name passed in argument.
	 * @return the IModel reference with the name passed in argument.
	 * @throws Warning if the the specified name isn't register in the collector.
	 */
	static public function get( id ):IModel 
	{

		if (!contains( id ) ) 
		{
			throw new Warning("[ModelCollector] get(" + id + ") failed. The specified id isn't register in the collector." ) ;
		} ;
		return IModel( _map.get( id ) ) ;	
	}
	
	/**
	 * Insert a IModel in the collector and indexed it with the string name in the first parameter.
	 * @param id the id key of the model in the collector.
	 * @param model the IModel reference register in the map of the collector.
	 * @return {@code true} if the  specified model is inserted in the model.
	 * @throws Warning if the specified name is already registered in the collector.
	 */
	static public function insert( id , model:IModel ):Boolean 
	{
		if ( contains(id) ) 
		{
			throw new Warning( "[ModelCollector] insert method failed. An IModel instance is already registered with '" + id + "' id." ) ;
		} ;
		return _map.put(id, model) == null ;	
	}
	
	/**
	 * Returns {@code true} if the collector is empty.
	 * @return {@code true} if the collector is empty.
	 */
	static public function isEmpty():Boolean 
	{
		return _map.isEmpty() ;	
	}

	/**
	 * Removes the IModel in the collector specified by the argument {@code id}. 
	 * @param id the id of the model to unregister in the collector.
	 */
	static public function remove( id ):Void 
	{
		_map.remove( id ) ;
	}

	/**
	 * Returns the number of elements in the collector.
	 * @return the number of elements in the collector.
	 */
	static public function size():Number 
	{
		return _map.size() ;	
	}

	/**
	 * Internal HashMap of all IModel in the application.
	 */	
	static private var _map:HashMap = new HashMap() ;
	
}
