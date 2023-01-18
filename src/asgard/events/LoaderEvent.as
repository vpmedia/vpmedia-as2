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

import asgard.net.ILoader;

import vegas.events.BasicEvent;
import vegas.util.serialize.Serializer;

/**
 * The ILoader Event.
 * @author eKameleon
 */
class asgard.events.LoaderEvent extends BasicEvent 
{

	/**
	 * Creates a new LoaderEvent instance.
	 */
	public function LoaderEvent(type : String, loader:ILoader, p_code:Number, p_error:String, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number ) 
	{
		super(type, loader, context, bubbles, eventPhase, time, stop);
		_oLoader = loader ;
		code = isNaN(p_code) ? null : p_code ;
		error = p_error || null ;
	}
	
	/**
	 * The name of the event when the loader is complete.
	 */
	static public var COMPLETE:String = "onLoadComplete" ;

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
	 * The code if an error is invoqued.
	 */
	public var code:Number = null ;
	
	/**
	 * The error string representation if an error is invoqued.
	 */
	public var error:String = null ;
	
	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		return new LoaderEvent( getType(), getLoader()) ;
	}

	/**
	 * Returns the current bytes value of the external data to load during the loading.
	 * @return the current bytes value of the external data to load during the loading.
	 */
	public function getBytesLoaded():Number 
	{
		return getLoader().getBytesLoaded() ;
	}
	
	/**
	 * Returns the total bytes value of the external data to load.
	 * @return the total bytes value of the external data to load.
	 */
	public function getBytesTotal():Number 
	{
		return getLoader().getBytesTotal() ;
	}

	/**
	 * Returns the data of the loader.
	 * @return the data of the loader.
	 */
	public function getData() 
	{
		return getLoader().getData() ;	
	}

	/**
	 * Returns the loader reference.
	 * @return the loader reference.
	 */
	public function getLoader():ILoader 
	{
		return _oLoader ;
	}

	/**
	 * Returns the name of the loader.
	 * @return the name of the loader.
	 */
	public function getName():String 
	{
		return getLoader().getName() ;	
	}
	
	/**
	 * Returns the percent value of the loader when is in progress.
	 * @return the percent value of the loader when is in progress.
	 */
	public function getPercent():Number 
	{
		return getLoader().getPercent() ;
	}
	
	/**
	 * The internal loader reference.
	 */
	private var _oLoader:ILoader ;

	/**
	 * This method is used by the toSource method.
	 */
	/*protected*/ private function _getParams():Array 
	{
		var ar:Array = super._getParams() ;
		ar.splice(2, null, Serializer.toSource(code)) ;
		ar.splice(3, null, Serializer.toSource(error)) ;
		return ar ;
	}

}