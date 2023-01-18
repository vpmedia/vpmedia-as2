/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ------ Localization

	AUTHOR

		Name : Localization
		Package : neo.system
		Version : 1.0.0.0
		Date :  2006-02-19
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	DESCRIPTION
	
		Singleton

	PROPERTY SUMMARY
	
		- current:Lang [Read Only]

	METHOD SUMMARY
	
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- addListener (oL, f:Function):Void 
		
		- broadcastEvent(e:IEvent):Void 
		
		- clear():Void 
		
		- contains(lang:Lang):Boolean
		
		- dispatchEvent(o:Object):Void 
		
		- get(lang:Lang):Locale
		
		- getCurrent():Lang
		
		- static getInstance():Locale
		

		- getLoader():LocalizationLoader 

		

		- getLocale( sID:String )

		

			- Renvoi l'objet 'Locale' courrant si sID n'est pas défini. 

			

			- Renvoi la propriété de l'objet 'Locale' courant définie par le paramètre 'sID'.

		
		- isEmpty():Boolean
		
		- put(lang:Lang, oL:Locale)
		
		- removeEventListener(e:EventType, oL):Void
		
		- removeListener(oL):Void
		
		- setCurrent(lang:Lang):Void
		
		- toString():String
	
	EVENT SUMMARY
	
		- UIEvent

	EVENT TYPE SUMMARY

		- CHANGE:UIEventType
	
	INHERIT
	
		CoreObject
			|
			Locale
	
	IMPLEMENTS
	
		IFormattable, IEventTarget
	

	TODO : voir quoi afficher sur le onLoadProgress et le onTimeOut

	TODO : voir si je dois ajouter une variable inProgress par exemple pour éviter de charger 2 xml en même temps.


----------  */	

import com.bourre.data.collections.Map;
import com.bourre.data.libs.ILibListener;
import com.bourre.data.libs.LibEvent;
import com.bourre.data.libs.XMLToObject;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;

import neo.core.CoreObject;
import neo.core.IEventTarget;
import neo.events.UIEvent;
import neo.events.UIEventType;
import neo.system.Lang;
import neo.system.Locale;
import neo.system.LocalizationLoader;
import neo.util.factory.PropertyFactory;

class neo.system.Localization extends CoreObject implements IEventTarget, ILibListener {

	// ----o Constructor
	
	private function Localization() {

		_oEB = new EventBroadcaster(this) ;
		_map = new Map() ;

		_loader = new LocalizationLoader() ;

		_loader.addListener(this) ;
	}

	// ----o Public Properties
	
	public var current:Lang ; // [Read Only]

	static public var CHANGE:UIEventType = UIEventType.CHANGE ;

	// ----o Public Methods

	public function addEventListener(e:EventType, oL, f:Function):Void {
		_oEB.addEventListener.apply(_oEB, arguments);
	}
	
	public function addListener (oL, f:Function):Void {
		_oEB.addListener.apply(_oEB, arguments);
	}
	
	public function broadcastEvent(e:IEvent):Void {	
		_oEB.broadcastEvent(e) ;
	}

	public function clear():Void {
		_map.clear() ;
	}

	public function contains(lang:Lang):Boolean {	
		return _map.containsKey(lang) ;
	}
	
	public function dispatchEvent(o:Object):Void {
		_oEB.dispatchEvent(o) ;
	}
	
	public function get(lang:Lang):Locale {
		return _map.get(lang) ;

	}
	
	public function getCurrent():Lang {
		return _current ;

	} 
	
	static public function getInstance():Localization {
		if (!__instance) __instance = new Localization() ;
		return __instance ;

	}	

	public function getLoader():LocalizationLoader {
		return _loader ;
	}

	public function getLocale( sID:String ) {
		if (sID) {
			return this.get(_current)[sID] || null ;
		} else {
			return this.get(_current) || null ;
		}
	}

	public function isEmpty():Boolean {
		return _map.isEmpty() ;

	}

	public function notifyChange():Void {
		broadcastEvent( new UIEvent (UIEventType.CHANGE) ) ;
	}
	
	public function onLoadInit( e:LibEvent ) : Void {
		var oLocale:Locale = XMLToObject(e.getLib()).getObject() ;
		put (_current, oLocale ) ;
		notifyChange() ;
	}

	public function onLoadProgress( e:LibEvent ):Void {
		// ici possibilité d'afficher la progression du chargement du fichier XML.
	}

	public function onTimeOut( e:LibEvent ):Void {
		// ici notifier une erreur ??
	}

	public function put(lang:Lang, oL:Locale) {
		return _map.put(lang, oL) ;
	}
	
	public function remove(lang:Lang):Void {
		if (Lang.validate(lang)) {
			_map.remove(lang) ;
		}
	}
	
	public function removeEventListener(e:EventType, oL):Void {
		_oEB.removeEventListener(e, oL);
	}
	
	public function removeListener(oL):Void {
		_oEB.removeListener(oL) ;
	}
	
	public function setCurrent(lang:Lang):Void {
		if (Lang.validate(lang)) {
			_current = lang ;
			if ( contains(lang) ) {
				notifyChange() ;	
			} else {
				_loader.setObject ( new Locale() ) ;
				_loader.load(lang) ;
			}
		}
	}
	
	// ----o Virtual Properties
	
	static private var __CURRENT__:Boolean = PropertyFactory.create(Localization, "current", true, true) ;
	
	// ----o Private Properties

	private var _current ;
	static private var __instance:Localization ;

	private var _loader:LocalizationLoader ;
	private var _map:Map ;
	private var _oEB:EventBroadcaster ;
	
}