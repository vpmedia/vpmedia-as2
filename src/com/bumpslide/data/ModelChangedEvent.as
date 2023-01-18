import com.bumpslide.data.Model;

/**
 * This event gets dispatched by ObservableMap every time a 
 * group of changes is made.
 * 
 * The dispatched is delayed a couple milliseconds so that
 * multiple sequential changes will only result in one 
 * modelChangedEvent
 *
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 */
 
class com.bumpslide.data.ModelChangedEvent extends com.bumpslide.events.Event
{
	var type:String;	
	var previous:Object;
	var current:Object;
	var changedKeys:Array;
	var modelName:String;
	
	function ModelChangedEvent(src:Model, prev:Object, curr:Object, changed:Array) 
	{
		target = src;
		type=Model.MODEL_CHANGED_EVENT;
		modelName = src.name;
		previous = prev;
		current  = curr;
		changedKeys = changed;
	}
}
