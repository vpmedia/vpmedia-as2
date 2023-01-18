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


import asgard.config.Config;
import asgard.config.ConfigLoader;

import vegas.core.IRunnable;

/**
 * This interface defines a tool to invoqued the configuration of your application.
 * @author eKameleon
 */
interface asgard.config.ISetup extends IRunnable 
{
	
	function getConfig():Config ;

	function getConfigLoader():ConfigLoader ;
	
	function getRunning():Boolean ;

	function notifyChange():Void ;

	function release():Void ;
	
	function setLoader(sFileName:String, sPath:String, sSuffix:String):Void ;

	function update():Void ;

}