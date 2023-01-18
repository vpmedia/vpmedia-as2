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
 * The MediaEvent types.
 * @author eKameleon
 */
class asgard.events.MediaEventType 
{

	/**
	 * The name of the MediaEvent when the media is cleared.
	 */
	static public var MEDIA_CLEAR:String = "onMediaClear" ;

	/**
	 * The name of the MediaEvent when the media is finished.
	 */
	static public var MEDIA_FINISH:String = "onMediaFinished" ;

	/**
	 * The name of the MediaEvent when the media progress.
	 */
	static public var MEDIA_PROGRESS:String = "onMediaProgress" ;

	/**
	 * The name of the MediaEvent when the media is resumed.
	 */
	static public var MEDIA_RESUME:String = "onMediaResumed" ;

	/**
	 * The name of the MediaEvent when the media is started.
	 */
	static public var MEDIA_START:String = "onMediaStarted" ;

	/**
	 * The name of the MediaEvent when the media is stopped.
	 */
	static public var MEDIA_STOP:String = "onMediaStopped" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(MediaEventType, null , 7, 7) ;
	
}
