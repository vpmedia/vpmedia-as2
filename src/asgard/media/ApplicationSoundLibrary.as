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

import asgard.media.SoundLibrary;

/**
 * The Singleton SoundLibrary of the application.
 * @author eKameleon
 */
class asgard.media.ApplicationSoundLibrary extends SoundLibrary 
{
	
	/**
	 * Creates a new ApplicationSoundLibrary singleton.
	 */
	private function ApplicationSoundLibrary() 
	{
		super();
	}
	
	/**
	 * Returns the singleton reference of the ApplicationSoundLibrary class.
	 * @return the singleton reference of the ApplicationSoundLibrary class.
	 */
	static public function getInstance():ApplicationSoundLibrary
	{
		if (_instance == null)
		{
			_instance = new ApplicationSoundLibrary() ;	
		}
		return _instance ;	
	}
	
	/**
	 * The internal singleton of this class.
	 */
	static private var _instance:ApplicationSoundLibrary ;

}