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

import vegas.logging.ILogger;

/**
 * All logger target implementations within the logging framework must implement this interface.
 * @author eKameleon
 */
interface vegas.logging.ITarget
{

	/**
	 * In addition to the level setting, filters are used to provide a pseudo hierarchical mapping for processing only those events for a given category.
	 */
	// var filters:Array ;
	
	/**
	 * Provides access to the level this target is currently set at.
	 */
	// var level:Number ;
	
	/**
	 * Sets up this target with the specified logger.
	 * Note : this method is called by the framework and should not be called by the developer.
	 */
	function addLogger(logger:ILogger):Void ;
	
	/**
	 * Stops this target from receiving events from the specified logger.
	 * Note : this method is called by the framework and should not be called by the developer.
	 */
	function removeLogger(logger:ILogger):Void ;
	
}