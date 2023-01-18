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
 * Defines how to publish A {@code Stream}. 
 * Valid values are "record", "append", and "live". The default value is "live".
 * @author eKameleon
 */
class asgard.net.StreamPublishType 
{
	
	/**
	 * Flash Player publishes and records live data, appending the recorded data to an FLV file with a name that matches the value passed to the name parameter, stored on the server in a subdirectory within the directory that contains the server application. 
	 * If no file with a matching name the name parameter is found, it is created.
	 */
	static public var APPEND:String = "append" ;
	
	/**
	 * The default type value of the Stream publish method. 
	 * Flash Player publishes live data without recording it. 
	 * If a file with a name that matches the value passed to the name parameter exists, it is deleted.
	 */
	static public var LIVE:String = "live" ;
	
	/**
	 * If you pass "record", Flash Player publishes and records live data, saving the recorded data to a new FLV file with a name matching the value passed to the name parameter of the publish method of the Stream reference. 
	 * The file is stored on the server in a subdirectory within the directory that contains the server application. 
	 * If the file already exists, it is overwritten.
	 */
	static public var RECORD:String = "record" ;
	
	
}