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

import asgard.display.FlashPaperLoader;
import asgard.events.DisplayLoaderEvent;

import vegas.util.serialize.Serializer;

/**
 * The FlashPaperLoaderEvent event.
 * @author eKameleon
 * @version 1.0.0.0
 */
class asgard.events.FlashPaperLoaderEvent extends DisplayLoaderEvent 
{

	/**
	 * Creates a new FlashPaperLoaderEvent instance.
	 */
	public function FlashPaperLoaderEvent
	(
		type : String, fpLoader:FlashPaperLoader
		, p_currentZoom:Number, p_isEnabledScrolling:Boolean, p_newPageNumber:Number, p_newVisibleArea 
		, p_code:Number, p_error:String, context
		, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number
	) 
	{
		super(type, fpLoader, p_code, p_error, context, bubbles, eventPhase, time, stop);
		currentZoom = isNaN(p_currentZoom) ? null : p_currentZoom ;
		isEnabledScrolling = p_isEnabledScrolling || null ;
		newPageNumber = isNaN(p_newPageNumber) ? null : p_newPageNumber ;
		newVisibleArea = p_newVisibleArea || null ;
	}

	/**
	 * The name of the event when the loader is complete.
	 */
	static public var COMPLETE:String = "onLoadComplete" ;
	
	/**
	 * The name of the event when the value of the enable scroll change.
	 */
	static public var ENABLE_SCROLL:String = "onEnableScrolling" ;
	
	/**
	 * The name of the event when the loader is finished.
	 */
	static public var FINISH:String = "onLoadFinished" ;
	
	/**
	 * The name of the event when the loader is initialized.
	 */
	static public var INIT:String = "onLoadInit" ;
	
	/**
	 * The name of the event when the loader notify an IO error.
	 */
	static public var IO_ERROR:String = "onLoadError" ;
	
	/**
	 * The name of the event when the loader is in progress.
	 */
	static public var PROGRESS:String = "onLoadProgress" ;
	
	/**
	 * The name of the event when the loader is release.
	 */
	static public var RELEASE:String = "onRelease" ;

	/**
	 * The name of the event when the value of the current page change.
	 */
	static public var PAGE_CHANGE:String = "onPageChanged" ;

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
	 * The name of the event when the value of the current tool change.
	 */
	static public var TOOL_CHANGE:String = "onToolChanged" ;

	/**
	 * The name of the event when the value of the current zoom change.
	 */
	static public var ZOOM_CHANGE:String = "onZoomChanged" ;

	/**
	 * The name of the event when the visible area change.
	 */
	static public var VISIBLE_AREA_CHANGE:String = "onVisibleAreaChanged" ;

	/**
	 * The current zoom of the loader.
	 */	
	public var currentZoom:Number ;
	
	/**
	 * The scrolling enabled value of the loader.
	 */
	public var isEnabledScrolling:Boolean ;
	
	/**
	 * The new page number in the loader.
	 */
	public var newPageNumber:Number ;
	
	/**
	 * The new visible area to display in the loader.
	 */
	public var newVisibleArea ; 

	/**
	 * Returns a shallow copy of the event.
	 */
	public function clone() 
	{
		return new FlashPaperLoaderEvent( getType(), getLoader()) ;
	}

	/**
	 * Returns the FlashPaperLoader reference of this event.
	 */
	public function getLoader():FlashPaperLoader 
	{
		return FlashPaperLoader(_oLoader) ;
	}

	/**
	 * This protected method is used by the toSource method.
	 */
	/*protected*/ private function _getParams():Array 
	{
		var ar:Array = super._getParams() ;
		ar.splice(2, null, Serializer.toSource(currentZoom)) ;
		ar.splice(3, null, Serializer.toSource(isEnabledScrolling)) ;
		ar.splice(4, null, Serializer.toSource(newPageNumber)) ;
		ar.splice(5, null, Serializer.toSource(newVisibleArea)) ;
		return ar ;
	}

}