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
 * This static class contains all default static properties to defined colors and specific SOS message in the {@code SOSTarget} class.
 * @author eKameleon
 */
class vegas.logging.targets.SOSType 
{
	
	/**
	 * Provides the color in the SOS console to display all levels. 
	 */
	static public var ALL_COLOR:Number = 0xD7EEFD ;
	
	/**
	 * Provides the message to send in the SOS console to clear the console. 
	 */
	static public var CLEAR:String = "!SOS<clear/>\n" ;
	
	/**
	 * Provides the 'debug' color in the SOS console. 
	 */
	static public var DEBUG_COLOR:Number = 0xDEECFE ;

	/**
	 * Provides the 'default' color in the SOS console. 
	 */
	static public var DEFAULT_COLOR:Number = 0xFFFFFF ;
	
	/**
	 * Provides the value if you want 'disabled' the levels colors in the SOS Console.
	 */
	static public var DISABLE:Number = 0 ;

	/**
	 * Provides the value if you want 'enabled' the levels colors in the SOS Console.
	 */
	static public var ENABLE:Number = 1 ;

	/**
	 * Provides the 'error' color in the SOS console. 
	 */
	static public var ERROR_COLOR:Number = 0xEDCC81 ;

	/**
	 * Provides the message to send in the SOS console to exit the console. 
	 */
	static public var EXIT:String = "!SOS<exit/>" ;
	
	/**
	 * Provides the 'fatal' color in the SOS console. 
	 */
	static public var FATAL_COLOR:Number = 0xFDD1B5 ;
	
	/**
	 * Provides the default host in the SOS console to connect the internal XMLSocket. 
	 */
	static public var HOST:String = "localhost" ;
	
	/**
	 * Provides the message to send in the SOS console to receive infos about the console. 
	 */
	static public var IDENTIFY:String = "!SOS<identify/>" ;
	
	/**
	 * Provides the 'info' color in the SOS console. 
	 */
	static public var INFO_COLOR:Number = 0xD2FAB8 ;

	/**
	 * Provides the default port in the SOS console to connect the internal XMLSocket. 
	 */
	static public var PORT:Number = 4444 ;
	
	/**
	 * Provides the 'warn' color in the SOS console. 
	 */
	static public var WARN_COLOR:Number = 0xFDFDB5 ;
	
}