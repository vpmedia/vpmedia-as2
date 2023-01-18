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
import asgard.config.ISetup;
import asgard.events.LoaderEvent;
import asgard.net.LoaderListener;

import pegas.events.UIEvent;
import pegas.events.UIEventType;

import vegas.events.Delegate;
import vegas.events.EventDispatcher;

/**
 * This class provides a skeletal implementation of the {@code ISetup} interface, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class asgard.config.AbstractSetup extends EventDispatcher implements ISetup, LoaderListener  
{

	/**
	 * Creates a new AbstractSetup instance.
	 * @param sFileName the name of the file to load.
	 * @param sPath (optional) the path of the file to load.
	 * @param sSuffix (optional) the suffix of the file to load
	 */
	private function AbstractSetup( sFileName:String, sPath:String, sSuffix:String ) 
	{

		_eChange = new UIEvent( UIEventType.CHANGE ) ;
	
		_loader = new ConfigLoader() ;
		_loader.addEventListener(LoaderEvent.COMPLETE, new Delegate(this, onLoadComplete)) ;
		_loader.addEventListener(LoaderEvent.INIT, new Delegate(this, onLoadInit)) ;
		_loader.addEventListener(LoaderEvent.PROGRESS, new Delegate(this, onLoadProgress)) ;
		_loader.addEventListener(LoaderEvent.START, new Delegate(this, onLoadStart)) ;
		_loader.addEventListener(LoaderEvent.IO_ERROR, new Delegate(this, onLoadError)) ;
		_loader.addEventListener(LoaderEvent.TIMEOUT, new Delegate(this, onLoadTimeOut)) ;

		setLoader(sFileName, sPath, sSuffix) ;

	}

	/**
	 * The name of this object.
	 */
	public var name:String = null ;
	
	/**
	 * The namespace of this object.
	 */
	public var namespace:String = null  ;
	
	/**
	 * (read-write) Returns {@code true} if the object is running.
	 * @return {@code true} if the object is running.
	 */
	public function get running():Boolean 
	{
		return getRunning() ;	
	}
	
	/**
	 * The version of this object.
	 */
	public var version:String = null  ;
	
	/**
	 * Returns the reference of the Config singleton.
	 * @return the reference of the Config singleton.
	 */
	public function getConfig():Config 
	{
		return Config.getInstance() ;
	}
	
	/**
	 * Returns the reference of the ConfigLoader use by this object to load the configuration of the application.
	 * @return the reference of the ConfigLoader use by this object to load the configuration of the application
	 */
	public function getConfigLoader():ConfigLoader 
	{
		return _loader ;
	}
	
	/**
	 * Returns {@code true} if the object is running.
	 * @return {@code true} if the object is running.
	 */
	public function getRunning():Boolean 
	{
		return _loader.running ;
	}

	/**
	 * Notify an UIEvent with the event type {@code UIEventType.CHANGE}.
	 */
	public function notifyChange():Void 
	{
		dispatchEvent( _eChange ) ;
	}

	public function onLoadError(e:LoaderEvent):Void 
	{
		// override
	}

	public function onLoadComplete(e:LoaderEvent):Void 
	{

	}

	public function onLoadInit( e:LoaderEvent ) : Void 
	{
		update() ;
		notifyChange() ;
	}

	public function onLoadProgress( e:LoaderEvent ):Void 
	{
		// override
	}

	public function onLoadStart( e:LoaderEvent ):Void 
	{
		// override
	}

	public function onLoadTimeOut( e:LoaderEvent ):Void 
	{
		// override
	}
	
	/**
	 * Calls this method to release the object.
	 */
	public function release():Void 
	{
		name = null ;
		namespace = null  ;
		version = null  ;
	}
	
	/**
	 * Runs the command.
	 */
	public function run():Void 
	{
		if (!getRunning()) {
			release() ;
			_loader.load() ;
		}
	}
	
	/**
	 * Sets the loader of this object.
	 */
	public function setLoader(sFileName:String, sPath:String, sSuffix:String):Void 
	{
		if (sFileName) _loader.setFileName(sFileName) ;
		if (sPath) _loader.setPath(sPath) ;
		if (sSuffix) _loader.setSuffix(sSuffix) ;	
	}

	/**
	 * Update the object.
	 */
	public function update():Void 
	{
		// override this method in you setup class.
	}

	private var _eChange : UIEvent ;

	private var _loader:ConfigLoader ; 
	
}