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
 * Static class containing constants for use in the level  property.
 * @author eKameleon
 */
class vegas.logging.LogEventLevel
{
	
	/**
	 * Intended to force a target to process all messages (0).
	 */
	static public var ALL:Number = 0 ;

	/**
	 * Designates informational level messages that are fine grained and most helpful when debugging an application (2).
	 */
	static public var DEBUG:Number = 2 ;

	/**
	 * Designates error events that might still allow the application to continue running (8).
	 */	
	static public var ERROR:Number = 8 ;
	
	/**
	 * Designates events that are very harmful and will eventually lead to application failure (1000).
	 */
	static public var FATAL:Number = 1000 ;

	/**
	 * Designates informational messages that highlight the progress of the application at coarse-grained level (4).
	 */
	static public var INFO:Number =  4 ;	

	/**
	 * Designates events that could be harmful to the application operation (6).
	 */	
	static public var WARN:Number = 6 ;
	
	/**
	 * Returns true if the number level passed in argument is valid.
	 */
	static public function isValidLevel(level:Number):Boolean 
	{
		var levels:Array = [ALL, DEBUG, ERROR, FATAL, INFO, WARN] ;
		var l:Number = levels.length ;
		while (--l > -1) 
		{
			if (level.valueOf() == levels[l].valueOf())
			{
				return true ;
			}
		}
		return false ;
	}

}