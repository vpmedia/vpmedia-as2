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

/** ILocalizationLoader (interface)

	AUTHOR

		Name : LocalizationLoader
		Package : asgard.system
		Version : 1.0.0.0
		Date :  2006-08-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

*/	

import asgard.system.Lang;
import asgard.system.Locale;

/**
 * @author eKameleon
 */
interface asgard.system.ILocalizationLoader {

	function getDefault():Lang ;
	
	function getLocalization(lang:Lang):Locale ; 

	function getPath():String ;
	
	function getPrefix():String ; 

	function getSuffix():String ; 

	function initEvent():Void ; 
	
	function load( lang:Lang ):Void ; 

	function setDefault( lang:String ):Void ; 

	function setPath( sPath:String ):Void ; 

	function setPrefix( sPrefix:String ):Void ; 

	function setSuffix( sSuffix:String ):Void ; 

}