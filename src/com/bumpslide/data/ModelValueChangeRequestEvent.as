import com.bumpslide.data.Model;

/**
 * This event gets dispatched by Model every time a 
 * a value change is requested, but before it it processed.
 * 
 * This gives a main application controller a chance to intercept 
 * specific state changes.
 * 
 * 
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 */

class com.bumpslide.data.ModelValueChangeRequestEvent
{
	var type:String;	
	var oldValue;
	var newValue;
	var key;
	var modelName;
	
	function ModelValueChangeRequestEvent(model,o,n,k) 
	{
		modelName=model.getName();
		type = Model.CHANGE_REQUEST_EVENT;
		oldValue=o;
		newValue=n;
		key=k;		
	}
}
