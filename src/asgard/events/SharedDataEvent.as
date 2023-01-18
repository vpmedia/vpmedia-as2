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

/**	SharedDataEvent

	AUTHOR

		Name : SharedDataEvent
		Package : asgard.events
		Version : 1.0.0.0
		Date :  2005-05-04
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net
	
	PROPERTY SUMMARY

		- bubbles:Boolean [R/W]
		
		- context [R/W]
		
		- currentTarget [R/W]
		
		- eventPhase:Number [R/W]
		
		- id:String
		
		- target [R/W]
		
		- type:String [R/W]
		
		- value

	METHOD SUMMARY
	
		- cancel():Void
		
		- clone():BasicEvent
		
		- getBubbles():Boolean
		
		- getContext()
		
		- getCurrentTarget()
		
		- getEventPhase():Number
		
		- getTarget()
		
		- getTimeStamp():Number
		
		- getType():String
		
		- isCancelled():Boolean
		
		- isQueued():Boolean
		
		- queueEvent():Void
		
		- setBubbles(b:Boolean):Void
		
		- setContext(context):Void
		
		- setCurrentTarget(target):Void
		
		- setEventPhase(n:Number):Void
		
		- setProperty(p_id:String, p_value):Void
		
		- setTarget(target):Void
		
		- setType(type:String):Void
		
		- stopImmediatePropagation()
		
		- toSource(indent : Number, indentor : String):String
		
		- toString():String

	INHERIT
	
		CoreObject → BasicEvent → DynamicEvent

	IMPLEMENTS 
		
		Event, ICloneable, IFormattable, IHashable, ISerializable

	SEE ALSO
		
		SharedDataEventType

**/

import asgard.events.SharedDataEventType;
import asgard.net.SharedData;

import vegas.events.DynamicEvent;
import vegas.util.serialize.Serializer;

/**
 * @author eKameleon
 * @version 1.0.0.0
 **/	
class asgard.events.SharedDataEvent extends DynamicEvent {

	// ----o Constructor
	
	public function SharedDataEvent ( 
		type:SharedDataEventType, sharedData:SharedData , p_id:String, p_value
		, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number 
	)
		{
		
		super(type, sharedData, context, bubbles, eventPhase, time, stop) ;
 		this.setProperty(p_id, p_value) ;
 		
		}
	
	// ----o Public Properties
	
	public var id:String ;
	public var value ;
	
	// ----o Public Methods

	public function clone() 
		{
			
		return new SharedDataEvent(SharedDataEventType(getType()), getTarget()) ;
		
		}

	public function setProperty(p_id:String, p_value):Void 
		{
			
		id = p_id || null ;
		value = p_value || null ;
		
		}

	// ----o Protected Methods

	/*protected*/ private function _getParams():Array 
		{
		
		var ar:Array = super._getParams() ;
		ar.splice(2, null, Serializer.toSource(id)) ;
		ar.splice(3, null, Serializer.toSource(value)) ;
		return ar ;
		
		}
	
}
