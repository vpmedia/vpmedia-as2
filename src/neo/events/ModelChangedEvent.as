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

/* ------- 	ModelChangedEvent

	AUTHOR

		Name : ModelChangedEvent
		Package : neo.events
		Version : 1.0.0.0
		Date :  2005-11-18
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net


	CONSTRUCTOR



		ModelChangedEvent(name:String, target:Object)



	PROPERTY SUMMARY

	

		- data
		
		- eventName:String
		
		- fieldName:String
		
		- firstItem:Number
		
		- index:Number
		
		- lastItem:Number
		
		- removedIDs:Array
		
		- removedItems:Array


	METHOD SUMMARY

	

		- getTarget():Object

		

		- getType():String

		

		- setTarget(target:Object):Void

		

		- setType(type:String):Void

		

		- toString():String


	EVENTS SUMMARY



		- ADD_ITEMS:ModelChangedType

		

		- CLEAR_ITEMS:ModelChangedType

		

		- MODEL_CHANGED:ModelChangedType

		

		- REMOVE_ITEMS:ModelChangedType

		

		- SORT:ModelChangedType

		

		- UPDATE_ALL:ModelChangedType

		

		- UPDATE_FIELD:ModelChangedType

		

		- UPDATE_ITEMS:ModelChangedType

	

	INHERIT
	
		Object > BasicEvent > ModelChangedEvent

	IMPLEMENTS
	
		IEvent

		

	SEE ALSO

	

		ModelChangedEventType

----------  */


import com.bourre.core.HashCodeFactory;
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

import neo.events.ModelChangedEventType;

class neo.events.ModelChangedEvent extends BasicEvent {

	// ----o Constructor
	
	public function ModelChangedEvent(e:EventType, target) {
		super(ModelChangedEventType.MODEL_CHANGED , target) ;
		eventName = e || ModelChangedEventType.MODEL_CHANGED ;
	}


	// ----o Public Properties
	
	public var data ;
	public var eventName:String = null ;
	public var fieldName:String = null ;
	public var firstItem:Number = null ;
	public var index:Number = null ;
	public var lastItem:Number = null ;
	public var removedIDs:Array = null ;
	public var removedItems:Array = null ;

	// ----o Public Methods

	public function toString() : String {

		return '[ModelChangedEvent' + HashCodeFactory.getKey( this ) + ' : ' + getType() + ']';

	}

}
