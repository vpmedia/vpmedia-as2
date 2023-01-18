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
 * The enumeration of all types of the protocols of your swf application.
 * @author eKameleon
 */
class asgard.system.ApplicationType 
{

	/**
	 * The type of a file application.
	 */
	static public var FILE:String = "file" ;
	
	/**
	 * The type of a FTP application.
	 */
	static public var FTP:String = "ftp" ;
	
	/**
	 * Tge type of a HTTP application.
	 */
	static public var HTTP:String = "http" ;
	
	/**
	 * The type of a HTTPS application.
	 */
	static public var HTTPS:String = "https" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(ApplicationType, null , 7, 7) ;
	
}