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
import asgard.events.LoaderEventType;
import asgard.events.LocalizationEvent;
import asgard.net.LoaderListener;
import asgard.system.EdenLocalizationLoader;
import asgard.system.ILocalizationLoader;
import asgard.system.Lang;
import asgard.system.Locale;

import vegas.data.map.HashMap;
import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.Delegate;
import vegas.events.EventListener;

/**
 * The Localization class allows to manage via textual files with JSON or Eden format to charge the textual contents 
 * of an application according to the parameters of languages chosen by the users.
 * <p>It is possible to define several singletons of the Localization class to manage several elements in the application, but for this it's necessary to use the static property getInstance(sName). 
 * Thus all the authorities become of Singletons reusable a little everywhere in the application rather quickly.</p> 
 * @author eKameleon
 * @see Lang
 * @see Locale
 */
class asgard.system.Localization extends AbstractCoreEventDispatcher implements LoaderListener 
{
	
	/**
	 * Creates a new Localization instance.
	 * @param sName the name of the object.
	 */
	public function Localization(sName:String) 
	{

		super();
		
		_sName = sName ;
		
		_map = new HashMap() ;
		
		_eChange = new LocalizationEvent ( Localization.CHANGE ) ;
		
		_complete = new Delegate(this, onLoadComplete) ;
		_error = new Delegate(this, onLoadError) ;
		_init = new Delegate(this, onLoadInit) ;
		_progress = new Delegate(this, onLoadProgress) ;
		_start = new Delegate(this, onLoadStart) ;
		_timeOut = new Delegate(this, onLoadTimeOut) ;
		
		setLoader( new EdenLocalizationLoader() ) ;
		
	}

	/**
	 * The name of the event when the localization is changed.
	 */
	static public var CHANGE:String = "change"  ;
	
	/**
	 * The name of the event invoqued when the localization is completed.
	 */
	static public var COMPLETE:String = "onLoadComplete" ;
	
	/**
	 * The name of the event invoqued when the localization is finished.
	 */
	static public var FINISH:String = "onLoadFinished" ;
	
	/**
	 * The name of the event invoqued when the localization failed with an i/o error.
	 */
	static public var IO_ERROR:String = "onLoadError" ;
	
	/**
	 * The name of the event invoqued when the localization is in progress.
	 */
	static public var PROGRESS:String = "onLoadProgress" ;
	
	/**
	 * The name of the event invoqued when the localization is started.
	 */
	static public var START:String = "onLoadStarted" ;

	/**
	 * The name of the event invoqued when the localization is out of time.
	 */
	static public var TIMEOUT:String = "onTimeOut" ;

	/**
	 * The default singleton name of the Localization singletons.
	 */
	static public var DEFAULT_NAME:String = "" ;
	
	/**
	 * (read-write) Returns the current {@code Lang} object selected in the current localization.
	 * @return the current {@code Lang} object.
	 */
	public function get current():Lang 
	{
		return getCurrent() ;
	}
	
	/**
	 * (read-write) Sets the current {@code Lang} object.
	 */
	public function set current(lang:Lang):Void
	{
		setCurrent(lang) ;
	}	
	
	/**
	 * (read-only) Returns the name of the current localization.
	 */
	public function get name():String 
	{
		return getName() ;	
	}
	
	/**
	 * Removes all singletons in the internal map of this object..
	 */
	public function clear():Void 
	{
		_map.clear() ;
	}

	/**
	 * Returns {@code true} if this Localization contains the specified Lang.
	 * @return {@code true} if this Localization contains the specified Lang.
	 */
	public function contains(lang:Lang):Boolean 
	{	
		return _map.containsKey(lang) ;
	}
	
	/**
	 * Returns the current {@code Locale} object defines with the specified {@code Lang} object in argument.
	 * @return the current {@code Locale} object defines with the specified {@code Lang} object in argument.
	 */
	public function get(lang:Lang):Locale 
	{
		return _map.get(lang) ;
	}
	
	/**
	 * Returns the current {@code Lang} reference of this instance.
	 * @return the current {@code Lang} reference of this instance.
	 */
	public function getCurrent():Lang 
	{
		return _current ;
	} 
	
	/**
	 * Returns a {@code Localization} singleton reference with the specified name passed-in argument.
	 * @return a {@code Localization} singleton reference with the specified name passed-in argument.
	 */
	static public function getInstance( sName:String ):Localization 
	{
		sName = sName || Localization.DEFAULT_NAME  ;
		if (!__mInstances.containsKey(sName)) 
		{
			__mInstances.put(sName, new Localization(sName)) ;
		}
		return Localization(__mInstances.get(sName)) ;
	}	

	public function getName():String 
	{
		return _sName ;	
	}

	/**
	 * Releases the specified {@code Localization} singleton with the specified name in argument.
	 * @return the reference of the removed Localization object.
	 */
	static public function release(sName:String):Localization 
	{
		if (!sName) sName = Localization.DEFAULT_NAME ;
		return Localization.__mInstances.remove(sName) ;
	}

	/**
	 * Returns the ILocalizationLoader reference of this instance (default an EdenLocalizationLoader instance).
	 * @return the ILocalizationLoader reference of this instance.
	 */
	public function getLoader():ILocalizationLoader
	{
		return _loader ;
	}

	/**
	 * Returns the locale object with all this properties.
	 * @param sID (optional) if this key is specified the method return the value of the specified key in the current locale object.  
	 * @return the locale object with all this properties.
	 */
	public function getLocale( sID:String ) 
	{
		if (sID) 
		{
			return this.get(_current)[sID] || null ;
		}
		else 
		{
			return this.get(_current) || null ;
		}
	}

	/**
	 * Returns {@code true} if the Localization model is empty.
	 * @return {@code true} if the Localization model is empty.
	 */
	public function isEmpty():Boolean 
	{
		return _map.isEmpty() ;
	}

	/**
	 * Notify when the Localization change.
	 */
	public function notifyChange():Void 
	{
		dispatchEvent( _eChange ) ;
	}
	
	/**
	 * Invoqued if the Localization loader notify an error.
	 * Overrides this method.
	 */
	public function onLoadError(e:LoaderEvent):Void 
	{
		// override
	}

	/**
	 * Invoqued if the Localization loader notify is complete.
	 * Overrides this method.
	 */
	public function onLoadComplete(e:LoaderEvent):Void 
	{
		// override
	}

	/**
	 * Invoqued if the Localization loader notify is init.
	 */
	public function onLoadInit( e:LoaderEvent ) : Void 
	{
		var oLocale:Locale = new Locale() ;
		var jsonData = e.getData() ;
		for (var each:String in jsonData) 
		{
			oLocale[each] = jsonData[each] ;	
		}
		put (_current, oLocale ) ;
		notifyChange() ;
	}

	/**
	 * Invoqued when the localization loading is in progress. Overrides this method.
	 */
	public function onLoadProgress( e:LoaderEvent ):Void 
	{
		// override
	}

	/**
	 * Invoqued when the localization loading is started. Overrides this method.
	 */
	public function onLoadStart( e:LoaderEvent ):Void 
	{
		// override
	}
	
	/**
	 * Invoqued when the localization loading is out of time. Overrides this method.
	 */
	public function onLoadTimeOut( e:LoaderEvent ):Void 
	{
		// override
	}

	/**
	 * Put the specified Lang in the Localization model.
	 */
	public function put(lang:Lang, oL:Locale) 
	{
		return _map.put(lang, oL) ;
	}

	/**
	 * Remove the specified Lang in the Localization model.
	 * @param lang a valid Lang object. This argument is valid if the {@link Lang.validate} method return {@code true}.
	 */
	public function remove(lang:Lang):Void 
	{
		if ( Lang.validate(lang) ) 
		{
			_map.remove(lang) ;
		}
	}

	/**
	 * Sets the current localization with the specified Lang.
	 */
	public function setCurrent(lang:Lang):Void 
	{
		if (Lang.validate(lang)) 
		{
			_current = lang ;
			if ( contains(lang) ) 
			{
				notifyChange() ;
			}
			else 
			{
				ILocalizationLoader(_loader).load(_current) ;
			}
		}
	}
	
	/**
	 * Sets the current loader of this Localization (default an EdenLocalizationLoader instance).
	 */
	public function setLoader( loader:ILocalizationLoader ):Void
	{
		
		if (_loader != null)
		{
			AbstractCoreEventDispatcher(_loader).setParent( null ) ; // use bubbling
		
			AbstractCoreEventDispatcher(_loader).removeEventListener(LoaderEventType.COMPLETE, _complete) ;
			AbstractCoreEventDispatcher(_loader).removeEventListener(LoaderEventType.INIT, _init) ;
			AbstractCoreEventDispatcher(_loader).removeEventListener(LoaderEventType.PROGRESS, _progress) ;
			AbstractCoreEventDispatcher(_loader).removeEventListener(LoaderEventType.START, _start) ;
			AbstractCoreEventDispatcher(_loader).removeEventListener(LoaderEventType.IO_ERROR, _error) ;
			AbstractCoreEventDispatcher(_loader).removeEventListener(LoaderEventType.TIMEOUT, _timeOut) ;
			
		}
		
		if (loader == null)
		{
			loader = new EdenLocalizationLoader() ;
		}
		
		_loader = loader ;
		
		if (_loader != null)
		{
		
			AbstractCoreEventDispatcher(_loader).setParent( getEventDispatcher() ) ; // use bubbling
			
			AbstractCoreEventDispatcher(_loader).addEventListener(LoaderEventType.COMPLETE, _complete) ;
			AbstractCoreEventDispatcher(_loader).addEventListener(LoaderEventType.INIT, _init) ;
			AbstractCoreEventDispatcher(_loader).addEventListener(LoaderEventType.PROGRESS, _progress) ;
			AbstractCoreEventDispatcher(_loader).addEventListener(LoaderEventType.START, _start) ;
			AbstractCoreEventDispatcher(_loader).addEventListener(LoaderEventType.IO_ERROR, _error) ;
			AbstractCoreEventDispatcher(_loader).addEventListener(LoaderEventType.TIMEOUT, _timeOut) ;
		}
	}

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String 
	{
		var txt:String = "[Localization" ; 
		 if (_sName.length > 0) txt += "." + _sName ;
		 txt += "]" ;
		 return txt ;	
	}

	private var _map:HashMap = null ;
	
	private var _complete:EventListener ;

	private var _current:Lang = null ;

	private var _eChange:LocalizationEvent = null ;

	private var _error:EventListener ;

	private var _init:EventListener ;

	private var _loader:ILocalizationLoader = null ;

	static private var __mInstances:HashMap = new HashMap () ;

	private var _progress:EventListener ;

	private var _sName:String = null ;
	
	private var _start:EventListener ;

	private var _timeOut:EventListener ;


}