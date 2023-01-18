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

import asgard.events.LocalizationLoaderEvent;
import asgard.net.JSONLoader;
import asgard.net.URLRequest;
import asgard.system.ILocalizationLoader;
import asgard.system.Lang;
import asgard.system.Locale;
import asgard.system.Localization;

import vegas.errors.IllegalArgumentError;

/**
 * The ILocalizationLoader based on a external JSON string document.
 * @author eKameleon
 */
class asgard.system.JSONLocalizationLoader extends JSONLoader implements ILocalizationLoader
{
	
	/**
	 * Creates a new LocalizationLoader instance.
	 */
	function JSONLocalizationLoader() 
	{
		super() ;
	}

	static public var DEFAULT_PREFIX:String = "localize_" ;

	static public var DEFAULT_SUFFIX:String = ".json" ;


	public function get path():String 
	{
		return getPath() ;	
	}
	
	public function set path(s:String):Void 
	{
		setPath(s) ;	
	}

	public function get prefix():String 
	{
		return getPrefix() ;	
	}
	
	public function set prefix(s:String):Void 
	{
		setPrefix(s) ;	
	}

	public function get suffix():String 
	{
		return getSuffix() ;	
	}
	
	public function set suffix(s:String):Void 
	{
		setSuffix(s) ;	
	}

	public function getDefault():Lang 
	{
		return Lang(_default) || null ;
	}

	public function getLocalization(lang:Lang):Locale 
	{
		return Localization.getInstance().get(lang) ;
	}

	public function getPath():String 
	{
		return _path || "" ;

	}
	
	public function getPrefix():String 
	{
		return (_prefix == null) ? DEFAULT_PREFIX : _prefix ;
	}

	public function getSuffix():String 
	{
		return (_suffix == null) ? DEFAULT_SUFFIX : _suffix ;
	}

	public function initEvent():Void 
	{
		_e = new LocalizationLoaderEvent( null, this );
	}
	
	public function load( lang:Lang ):Void 
	{
		if (Lang.validate(lang)) 
		{
			var uri:String = getPath() + getPrefix() + lang + getSuffix() ;
			var request:URLRequest = new URLRequest(uri) ;
			super.load( request ) ;
		}
		else 
		{
			throw new IllegalArgumentError(this + ".load(" + lang + ") argument must be a valid Lang") ;	
		}
	}

	public function setDefault( lang:String ):Void 
	{
		_default = (Lang.validate(lang)) ? lang : null ;
	}

	public function setPath( sPath:String ):Void 
	{
		_path = sPath || "" ;
	}

	public function setPrefix( sPrefix:String ):Void 
	{
		_prefix = sPrefix || null ;
	}

	public function setSuffix( sSuffix:String ):Void 
	{
		_suffix = sSuffix || null ;
	}
	
	private var _default:String = null ;

	private var _path:String = null ;

	private var _prefix:String = null ;

	private var _suffix:String = null ;

}