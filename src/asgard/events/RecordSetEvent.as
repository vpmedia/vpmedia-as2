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

/**	RecordSetEvent

	AUTHOR

		Name : RecordSetEvent
		Package : asgard.events
		Version : 1.0.0.0
		Date :  2006-05-25
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	CONSTRUCTOR

		var ev:Event = new RecordSetEvent(type:String, rs:RecordSet) ;

	PROPERTY SUMMARY
	
		- data
		
		- fieldName:String
			The name of the field that was updated, or null. 
		
		- firstItem:Number
			The index of the first item that was added, changed, or removed. 
		
		- index:Number
		
		- lastItem:Number
		
		- removedIDs:Array
			An array containing the IDs of the items that were removed, or null. 
		
		- removedItems:Array
			An array containing the items that were removed from the data provider, or null. 

	METHOD SUMMARY
	
		- cancel():Void
		
		- clone():BasicEvent
		
		- getBubbles():Boolean
		
		- getContext():Object
		
		- getCurrentTarget():Object
		
		- getEventPhase():Number
		
		- getTarget():Object
		
		- getTime():Number
		
		- getType():String
		
		- isCancelled():Boolean
		
		- isQueued():Boolean
		
		- queueEvent():Void
		
		- setBubbles(b:Boolean):Void
		
		- setContext(context:Object):Void
		
		- setCurrentTarget(target):Void
		
		- setEventPhase(n:Number):Void
		
		- setTarget(target:Object):Void
		
		- setType(type:String):Void
		
		- stopImmediatePropagation()
		
		- toSource(indent : Number, indentor : String):String
		
		- toString():String

	EVENTS SUMMARY

		- ADD_ITEMS:String = "addItems"
		
		- MODEL_CHANGED:String = "modelChanged"
		
		- REMOVE_ITEMS:String = "removeItems"
		
		- SORT:String = "sort"
		
		- UPDATE_ALL:String = "updateAll"
		
		- UPDATE_FIELD:String = "updateField"
		
		- UPDATE_ITEMS:String = "updateItems"

		- UPDATE_ROWS:String = "updateRows"

	INHERIT
	
		CoreObject → BasicEvent → ModelChangedEvent → RecordSetEvent

	IMPLEMENTS
	
		Event, IFormattable, IHashable, ISerializable

**/

import asgard.data.remoting.RecordSet;

import vegas.events.ModelChangedEvent;

class asgard.events.RecordSetEvent extends ModelChangedEvent {

	// ----o Constructor
	
	public function RecordSetEvent(
		type:String, rs:RecordSet
		, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number 
		, data, fieldName:String, firstItem:Number, index:Number, lastItem:Number, removedIDs:Array, removedItems:Array)
	{
		super( 
			type || RecordSetEvent.MODEL_CHANGED, 
			rs, 
			context, 
			bubbles, 
			eventPhase, 
			time, 
			stop,
			data, 
			fieldName, 
			firstItem, 
			index, 
			lastItem, 
			removedIDs, 
			removedItems
		) ;
	}

	// ----o Constants

	static public var ADD_ITEMS:String = "addItems" ; 
	static public var CLEAR_ITEMS:String = "clear" ;
	static public var MODEL_CHANGED:String = "modelChanged" ;
	static public var REMOVE_ITEMS:String = "removeItems" ;
	static public var SORT_ITEMS:String = "sortItems" ;
	static public var UPDATE_ALL:String = "updateAll" ;
	static public var UPDATE_FIELD:String = "updateField" ;
	static public var UPDATE_ITEMS:String = "updateItems" ;
	static public var UPDATE_ROWS:String = "updateRows" ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(RecordSetEvent, null , 7, 7) ;
	
	// ----o Public Methods

	public function clone() {
		return new RecordSetEvent(getType(), getTarget()) ;
	}

}
