/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.net.Stream;
import asgard.net.StreamExpert;

import vegas.data.map.HashMap;
import vegas.errors.Warning;

/**
 * This collector use a Map to register all {@code Stream} in the application.
 * @author eKameleon
 */
class asgard.net.StreamCollector 
{

	/**
	 * Removes all {@code Stream} references in the collector.
	 */
	static public function clear():Void 
	{
		_map.clear() ;	
	}
	
	/**
	 * Returns {@code true} if the collector contains the {@code Stream} register with the id passed in argument.
	 * @param id the id of the {@code Stream} register in the collector.
	 * @return {@code true} if the collector contains the {@code Stream} register with the id passed in argument.
	 */
	static public function contains( id ):Boolean 
	{
		return _map.containsKey( id ) ;	
	}
	
	/**
	 * Returns {@code true} if the collector contains the {@code Stream} passed in argument.
	 * @param stream the Stream to search in the collector.
	 * @return {@code true} if the collector contains the {@code Stream} passed in argument.
	 */
	static public function containsStream( stream:Stream ):Boolean
	{
		return _map.containsValue( stream ) ;	
	}
	
	/**
	 * Returns the {@code Stream} reference with the name passed in argument.
	 * @return the {@code Stream} reference with the name passed in argument.
	 * @throws Warning if the the specified id isn't register in the collector.
	 */
	static public function get( id ):Stream 
	{

		if (!contains( id ) ) 
		{
			throw new Warning("[StreamCollector] get(" + id + ") failed. The specified id isn't register in the collector." ) ;
		} ;
		return Stream( _map.get( id ) ) || null ;	
	}
	
	/**
	 * Insert a {@code Stream} in the collector and indexed it with the string name in the first parameter.
	 * @param id the id key of the {@code Stream} in the collector.
	 * @param stream the {@code Stream} reference register in the map of the collector.
	 * @return {@code true} if the specified {@code Stream} is inserted in the collector.
	 * @throws Warning if the specified id is already registered in the collector.
	 */
	static public function insert( id , stream:Stream):Boolean 
	{
		if ( contains(id) ) 
		{
			throw new Warning( "[StreamCollector] insert method failed. A Stream instance is already registered with '" + id + "' id." ) ;
		} ;
		return _map.put(id, stream) == null ;	
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
	 * Removes the {@code Stream} in the collector specified by the argument {@code id}. 
	 * @param id the id of the {@code Stream} to unregister in the collector.
	 */
	static public function remove( id ):Void 
	{
		if (StreamExpert.contains( id ) )
		{
			StreamExpert.release( id ) ;
		}
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
	 * Internal HashMap of all {@code Stream} in the application.
	 */	
	static private var _map:HashMap = new HashMap() ;
	
}
