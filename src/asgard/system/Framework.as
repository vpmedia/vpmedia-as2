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

import asgard.system.Version;

/**
 * This singleton can be used to defined the copyright of your applications or frameworks.
 * @author eKameleon
 */
class asgard.system.Framework 
{
	
	/**
	 * This Object contains all the copyrights and properties of the application or the framework. 
	 */
	static public var COPYRIGHT = {} ;
	
	/**
	 * Returns the author of this project.
	 * @return the author of this project.
	 */
	static public function getAuthor():String 
	{
		return COPYRIGHT.author ;
	}
	
	/**
	 * Returns the licence of this application or framework.
	 * @return the licence of this application or framework.
	 */
	static public function getLicence():String 
	{
		return COPYRIGHT.licence ;
	}
	
	/**
	 * Returns the link of the project.
	 * @return the link of the project.
	 */
	static public function getLink():String 
	{
		return COPYRIGHT.link ;
	}
	
	/**
	 * Returns the mail of this project.
	 * @return the mail of this project.
	 */
	static public function getMail():String 
	{
		return COPYRIGHT.mail ;
	}
	
	/**
	 * Returns the name of the author (if it's different).
	 * @return the name of the author (if it's different).
	 */
	static public function getName():String 
	{
		return COPYRIGHT.name ;
	}
	
	/**
	 * Returns the version of this project.
	 * @return the version of this project.
	 */
	static public function getVersion():Version 
	{
		return COPYRIGHT.version ;
	}

	/**
	 * Sets the author of this project.
	 */
	static public function setAuthor(s:String):Void 
	{
		COPYRIGHT.author = s ;
	}

	/**
	 * Sets the licence of this application or framework.
	 */
	static public function setLicence(s:String):Void 
	{
		COPYRIGHT.licence = s ;
	}

	/**
	 * Sets the link of the project.
	 */
	static public function setLink(s:String):Void 
	{
		COPYRIGHT.link = s ;
	}
	
	/**
	 * Sets the mail of this project.
	 */
	static public function setMail (s:String):Void 
	{
		COPYRIGHT.mail = s ;
	}

	/**
	 * Sets the name of the author (if it's different).
	 */
	static public function setName(s:String):Void 
	{
		COPYRIGHT.name = s ;
	}

	/**
	 * Sets the version of this project.
	 */
	static public function setVersion(v:Version):Void 
	{
		COPYRIGHT.version = v ;
	}
	
	/**
	 * Returns the string representation of this singleton.
	 * @return the string representation of this singleton.
	 */
	static public function toString():String 
	{
		var txt:String = "<" ;
		for (var prop in COPYRIGHT) 
		{
			txt += "\r\t" + prop + " : " + (COPYRIGHT[prop].toString() || "empty") ;
		}
		txt += "\r>" ;
		return txt ;
	}

}