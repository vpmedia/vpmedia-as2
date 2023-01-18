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

import asgard.events.LoaderEvent;

/**
 * Enumeration of all event type of the FlashPaperLoaderEvent class.
 * @author eKameleon
 */
class asgard.events.FlashPaperLoaderEventType 
{

	static public var COMPLETE:String = LoaderEvent.COMPLETE ;
	
	static public var ENABLE_SCROLL:String = "onEnableScrolling" ;
	
	static public var FINISH:String = LoaderEvent.FINISH ;
	
	static public var INIT:String = LoaderEvent.INIT ;
	
	static public var IO_ERROR:String = "onLoadError" ;
	
	static public var PROGRESS:String = LoaderEvent.PROGRESS ;
		
	static public var RELEASE:String = LoaderEvent.RELEASE ;

	static public var PAGE_CHANGE:String = "onPageChanged" ;

	static public var START:String = LoaderEvent.START ;
	
	static public var STOP:String = LoaderEvent.STOP ;
	
	static public var TIMEOUT:String = LoaderEvent.TIMEOUT ;

	static public var TOOL_CHANGE:String = "onToolChanged" ;

	static public var ZOOM_CHANGE:String = "onZoomChanged" ;

	static public var VISIBLE_AREA_CHANGE:String = "onVisibleAreaChanged" ;
	
}
