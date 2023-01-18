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

import asgard.display.DisplayObject;

import vegas.data.map.HashMap;
import vegas.errors.Warning;

/**
 * This collector use a Map to register all Displays in the application.
 * @author eKameleon
 */
class asgard.display.DisplayObjectCollector 
{

	/**
	 * Removes all DisplayObject reference in the collector.
	 */
	static public function clear():Void 
	{
		_map.clear() ;	
	}
	
	/**
	 * Returns {@code true} if the collector contains the DisplayObject register with the name passed in argument.
	 * @return {@code true} if the collector contains the DisplayObject register with the name passed in argument.
	 */
	static public function contains( sName:String ):Boolean 
	{
		return _map.containsKey( sName ) ;	
	}
	
	/**
	 * Returns {@code true} if the collector contains the DisplayObject passed in argument.
	 * @return {@code true} if the collector contains the DisplayObject passed in argument.
	 */
	static public function containsDisplay( display:DisplayObject ):Boolean
	{
		return _map.containsValue( display ) ;	
	}
	
	/**
	 * Returns the DisplayObject reference with the name passed in argument.
	 * @return the DisplayObject reference with the name passed in argument.
	 */
	static public function get(sName:String):DisplayObject 
	{
		try 
		{
			if (!contains(sName) ) 
			{
				throw new Warning("[DisplayObjectCollector].get(\"" + sName + "\"). Can't find DisplayObject instance." ) ;
			} ;
		}
		catch (e:Warning) 
		{
			e.toString() ;
		}
		
		return DisplayObject(_map.get(sName)) ;	
	}
	
	/**
	 * Insert a DisplayObject in the collector and indexed it with the string name in the first parameter.
	 * @param sName the name of the display to register it.
	 * @param dObject the DisplayObject reference. 
	 */
	static public function insert(sName:String, dObject:DisplayObject):Boolean 
	{
		try 
		{
			if ( contains(sName) ) 
			{
				throw new Warning("[DisplayObjectCollector].insert(). A DisplayObject instance is already registered with '" + sName + "' name." ) ;
			} ;
		}
		catch (e:Warning) 
		{
			e.toString() ;
		}
		return Boolean(_map.put(sName, dObject))   ;	
		
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
	 * Removes the DisplayObject in the collector specified by the argument {@code sName}.
	 */
	static public function remove(sName:String):Void 
	{
		_map.remove(sName) ;
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
	 * Internal HashMap of all DisplayObject in the application.
	 */	
	static private var _map:HashMap = new HashMap() ;
	
}
