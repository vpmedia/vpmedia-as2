import com.bumpslide.data.Model;

/**
 * This event gets dispatched by Model every time a 
 * a value is changed.
 * 
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 */

class com.bumpslide.data.ModelValueChangedEvent
{
	var type:String;	
	var oldValue;
	var newValue;
	var key;
	var modelName;
	
	function ModelValueChangedEvent(model,o,n,k) 
	{
		modelName=model.getName();
		type = Model.VALUE_CHANGED_EVENT;
		oldValue=o;
		newValue=n;
		key=k;		
	}
}
