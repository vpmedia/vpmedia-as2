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

/**	ConfigLoaderEvent

	AUTHOR

		Name : ConfigLoaderEvent
		Package : asgard.events
		Version : 1.0.0.0
		Date :  2006-03-25
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net
		
	CONSTRUCTOR
	
		new ConfigLoaderEvent(type : String, loader:ConfigLoader ) ;

	METHOD SUMMARY
	
		- clone()
	
		- getBytesLoaded():Number
	
		- getBytesTotal():Number

		- getData()

		- getLoader():ILoader

		- getName():String
	
		- getPercent():Number
		
		- getTarget():Object
		
		- getType():String
		
		- setTarget(target:Object):Void
		
		- setType(type:String):Void
		
		- toSource(indent : Number, indentor : String):String
		
		- toString():String

	INHERIT
	
		CoreObject → BasicEvent → DynamicEvent → LoaderEvent → ConfigLoaderEvent
		
	IMPLEMENTS 
		
		Event, ICloneable, IFormattable, IHashable, ISerializable

**/

import asgard.events.LoaderEvent;
import asgard.net.ParserLoader;

import pegas.events.UIEventType;

/**
 * @author eKameleon
 * @version 1.0.0.0
 */
 
class asgard.events.ConfigLoaderEvent extends LoaderEvent {

	// ----o Constructor
		
	public function ConfigLoaderEvent( type : String, loader:ParserLoader, p_code:Number, p_error:String, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number ) {
		super(type, loader, p_code, p_error, context, bubbles, eventPhase, time, stop);
	}
	
	// ----o Constant
	
	static public var CHANGE:String = UIEventType.CHANGE ;

	static private var __ASPF__ = _global.ASSetPropFlags(ConfigLoaderEvent, ["CHANGE"] , 7, 7) ;
	
	// ----o Public Methods
	
	public function clone() {
		return new ConfigLoaderEvent( getType(), ParserLoader(getLoader())) ;
	}
	
	public function getConfig() {
		return getTarget()["getConfig"]() ;	
	}
	
}