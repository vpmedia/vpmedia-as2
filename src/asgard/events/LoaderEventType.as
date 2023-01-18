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
 * The enumeration of all event type used by default in a ILoader instance.
 * @author eKameleon
 */
class asgard.events.LoaderEventType 
{

	/**
	 * The name of the event when the loader is complete.
	 */
	static public var COMPLETE:String = "onLoadComplete" ;

	/**
	 * The name of the event when the loader notify an IO error.
	 */
	static public var IO_ERROR:String = "onLoadError" ;
	
	/**
	 * The name of the event when the loader is finished.
	 */
	static public var FINISH:String = "onLoadFinished" ;

	/**
	 * The name of the event when the loader is initialized.
	 */
	static public var INIT:String = "onLoadInit" ;
	
	/**
	 * The name of the event when the loader is in progress.
	 */
	static public var PROGRESS:String = "onLoadProgress" ;

	/**
	 * The name of the event when the loader is started.
	 */
	static public var START:String = "onLoadStarted" ;

	/**
	 * The name of the event when the loader is stopped.
	 */
	static public var STOP:String = "onLoadStopped" ;
	
	/**
	 * The name of the event when the loader is out of time.
	 */
	static public var TIMEOUT:String = "onTimeOut" ;

	/**
	 * The name of the event when the loader is release.
	 */
	static public var RELEASE:String = "onRelease" ;

	static private var __ASPF__ = _global.ASSetPropFlags(LoaderEventType, null , 7, 7) ;
	
}
