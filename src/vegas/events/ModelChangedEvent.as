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

import vegas.events.BasicEvent;
import vegas.util.serialize.Serializer;

/**
 * This event is used with some models.
 * @author eKameleon
 */
class vegas.events.ModelChangedEvent extends BasicEvent 
{

	/**
	 * Creates a ModelChanged event.
	 * @param type the string type of the instance. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 * @param data the date of the event
	 * @param fieldName the fieldName in the model of changed item.
	 * @param firstItem the firstItem who changed.
	 * @param index the index position of the item who changed in the model.
	 * @param lastItem the last position of the items who changed in the model.
	 * @param removedIDs the array of the ids of the items who changed in the model.
	 * @param removeItems the array of all items who changed in the model.
	 */
	public function ModelChangedEvent
	( 
		name:String , target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number 
		, data, fieldName:String, firstItem:Number, index:Number, lastItem:Number, removedIDs:Array, removedItems:Array
	)
	{
		
		super(name || MODEL_CHANGED, target, context, bubbles, eventPhase, time, stop) ;
		
		this.data = data || null ;
		this.fieldName = fieldName || null ;
		this.firstItem = isNaN(firstItem) ? null : firstItem ;
		this.index = isNaN(index) ? null : index ;
		this.lastItem = isNaN(lastItem) ? null : lastItem ;
		this.removedIDs = removedIDs || null ;
		this.removedItems = removedItems || null ;
		
	}

	/**
	 * The type of a ModelChangedEvent when an item is added in this model.
	 */
	static public var ADD_ITEMS:String = "addItems" ; 

	/**
	 * The type of a ModelChangedEvent when clear all items in the model.
	 */
	static public var CLEAR_ITEMS:String = "clear" ;

	/**
	 * The type of a ModelChangedEvent when the model is changed.
	 */
	static public var MODEL_CHANGED:String = "modelChanged" ;

	/**
	 * The type of a ModelChangedEvent when an item is removed in this model.
	 */
	static public var REMOVE_ITEMS:String = "removeItems" ;

	/**
	 * The type of a ModelChangedEvent when the model is sorted.
	 */
	static public var SORT_ITEMS:String = "sortItems" ;

	/**
	 * The type of a ModelChangedEvent when all is update in the model.
	 */
	static public var UPDATE_ALL:String = "updateAll" ;

	/**
	 * The type of a ModelChangedEvent when a field in the model is updated.
	 */
	static public var UPDATE_FIELD:String = "updateField" ;

	/**
	 * The type of a ModelChangedEvent when an item in the model changed.
	 */
	static public var UPDATE_ITEMS:String = "updateItems" ;

	/**
	 * The data of this event.
	 */
	public var data = null ;
	
	/**
	 * The name of the field that was updated, or null. 
	 */
	public var fieldName:String = null ;
	
	/**
	 * The index of the first item that was added, changed, or removed. 
	 */
	public var firstItem:Number = null ;
	
	/**
	 * The index of the item of this event.
	 */
	public var index:Number = null ;

	/**
	 * The lastItem value of this event.
	 */	
	public var lastItem:Number = null ;
	
	/**
	 * An array containing the IDs of the items that were removed, or null. 
	 */
	public var removedIDs:Array = null ;
	
	/**
	 * An array containing the items that were removed from the data provider, or null. 
	 */
	public var removedItems:Array = null ;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone() 
	{
		return new ModelChangedEvent
		(
			getType(), getTarget(), getContext(), getBubbles(), getEventPhase(), getTimeStamp(), stop,
			data, fieldName, firstItem, index, lastItem, removedIDs, removedItems
		) ;
	}

	/*protected*/ private function _getParams():Array 
	{
		var ar:Array = super._getParams() ;
		ar = ar.concat
		( 
			[
			Serializer.toSource(data) ,
			Serializer.toSource(fieldName) ,
			Serializer.toSource(firstItem) ,
			Serializer.toSource(index) ,
			Serializer.toSource(lastItem) ,
			Serializer.toSource(removedIDs) ,
			Serializer.toSource(removedItems) 
			]
		) ;
		return ar ;
	}

}

