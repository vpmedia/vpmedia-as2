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
import asgard.events.ConfigLoaderEvent;
import asgard.events.LoaderEvent;
import asgard.net.EdenLoader;
import asgard.net.URLRequest;

import vegas.errors.Warning;

/**
 * The ConfigEdenLoader class based on the Eden notation.
 * @author eKameleon
 */
class asgard.config.ConfigEdenLoader extends EdenLoader 
{
	
	/**
	 * Creates a new ConfigEdentLoader instance.
	 */
	function ConfigEdenLoader( config ) 
	{
		_oConfig = config || Config.getInstance() ;
	}

	/**
	 * The default config file name.
	 */
	public var default_file_name:String = "config" ;
	
	/**
	 * The default suffix of config file name.
	 */
	public var default_file_suffix:String = ".eden" ;
	
	/**
	 * (read-write) Returns the config file name.
	 * @return the config file name.
	 */
	public function get fileName():String 
	{
		return getFileName() ;	
	}
	
	/**
	 * (read-write) Sets the config file name.
	 */
	public function set fileName(s:String):Void 
	{
		setFileName(s) ;	
	}

	/**
	 * (read-write) Returns the prefix path of the config file name.
	 * @return the prefix path of the config file name.
	 */
	public function get path():String 
	{
		return getPath() ;	
	}

	/**
	 * (read-write) Sets the prefix path of the config file name.
	 */
	public function set path(s:String):Void 
	{
		setPath(s) ;	
	}

	/**
	 * (read-write) Returns the suffix of the config file name.
	 * @return the suffix of the config file name.
	 */
	public function get suffix():String 
	{
		return getSuffix() ;	
	}
	
	/**
	 * (read-write) Sets the suffix of the config file name.
	 */
	public function set suffix(s:String):Void 
	{
		setSuffix(s) ;	
	}

	/**
	 * This method launch the deserialization of the external loaded data in the current Config object. 
	 */
	public function deserializeData():Void 
	{
		super.deserializeData() ;
		var data = getData() ;
		for (var each:String in data) 
		{
			_oConfig[each] = data[each] ;
		}
	}
	
	/**
	 * Returns the Config object reference.
	 * @return the Config object reference.
	 */
	public function getConfig():Config 
	{
		return _oConfig ;	
	}

	/**
	 * Returns the config file name.
	 * @return the config file name.
	 */
	public function getFileName():String 
	{
		return (_fileName == null) ? default_file_name : _fileName ;	
	}

	/**
	 * Returns the prefix path of the config file name.
	 * @return the prefix path of the config file name.
	 */
	public function getPath():String 
	{
		return _path || "" ;

	}

	/**
	 * Returns the suffix of the config file name.
	 * @return the suffix of the config file name.
	 */
	public function getSuffix():String 
	{
		return (_suffix == null) ? default_file_suffix : _suffix ;
	}

	public function initEvent():Void 
	{
		_e = new ConfigLoaderEvent( null, this ) ;
	}
	
	/**
	 * Loads the specified config file.
	 * @param fileName the name of the file to load to create the config object of the application.
	 */
	public function load( fileName:String ):Void 
	{
		if (fileName) 
		{
			setFileName(fileName) ;
		}
		var uri:String = getPath() + getFileName() + getSuffix() ;
		super.load(new URLRequest(uri) ) ;
	}
	
	/**
	 * Invoqued when the loader is initialize.
	 * Overrides this method.
	 */
  	/*override*/ public function onLoadInit(e:LoaderEvent):Void 
  	{
		// 
	}

	/**
	 * Protects a config object with a __resolve method and a Warning exception. 
	 * This protection is important to test if the external properties exist in the external config.
	 */
	static public function protectConfig( oConfig ):Void 
	{
		oConfig.__resolve = function( p:String ):String 
		{
			try
			{
				throw new Warning("Config object : '" + p + "' property is undefined") ;
			}
			catch(e)
			{
					
			}
			return "" ;
		} ;
		_global.ASSetPropFlags(oConfig, "__resolve", 7, 1) ;
	}

	/**
	 * Sets the config file name.
	 */
	public function setFileName(sFileName:String):Void 
	{
		_fileName = sFileName ;	
	}

	/**
	 * Sets the prefix path of the config file name.
	 */
	public function setPath( sPath:String ):Void 
	{
		_path = sPath || "" ;
	}

	/**
	 * Sets the suffix of the config file name.
	 */
	public function setSuffix( sSuffix:String ):Void 
	{
		_suffix = sSuffix || null ;
	}

	private var _fileName:String = null ;

	private var _oConfig:Config ;

	private var _path:String = null ;

	private var _suffix:String = null ;

}