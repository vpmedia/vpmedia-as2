/*
* The contents of this file are subject to the Mozilla Public
* License Version 1.1 (the "License"); you may not use this
* file except in compliance with the License. You may obtain a
* copy of the License at http://www.mozilla.org/MPL/
* 
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
* or implied. See the License for the specific language
* governing rights and limitations under the License.
* 
* The Original Code is 'Movie Masher'. The Initial Developer
* of the Original Code is Doug Anarino. Portions created by
* Doug Anarino are Copyright (C) 2007 Syntropo.com, Inc. All
* Rights Reserved.
*/



/** Abstract base class for all control types.
Each control is a symbol, descended from MovieClip, that's meant to 
display and edit a property value of another object.
*/

class com.moviemasher.Control.Control extends MovieClip
{
		

/** Boolean indicating whether control should disable or hide itself when its property is undefined. */
	function get canDisable() : Boolean { return __canDisable; }

/** Object representation of control tag attributes. */
	var config : Object;
	
	
/** Number of pixels tall. */
	function get height() : Number { return __height; }

/** {@link com.moviemasher.Core.Panel} object that contains receiver. */
	var panel : MovieClip;
	//var target : Object;
	
/** Object with property keys and Control object values (bound targets). */
	function get targets() : Object { return __targets; }
	
/** Number of pixels wide. */
	function get width() : Number { return __width; }
	
	// Make me into an event dispatcher
/** Add handler for specified event.
See mx.events.EventDispatcher API for details.
@param event string containing event name
@param handler object or movieclip event handler
*/
	function addEventListener(event:String, handler) : Void {}


/** Notice that receiver has just been instanced and needs to create interface.
Will load graphics if needed.
Called by {@link com.moviemasher.Core.Panel} object just after all controls 
in all panels are instanced.
*/	
	function createChildren() : Void
	{
	}

	

/** Retrieve value of media property from configuration.
@param property String containing property name.
@return String or Number representation of value.
*/
	
	function getValue(property: String)
	{
		return config[property];
	}
	
	// called after all the graphics for all the controls have loaded, set width and height in config!
	
	function initSize() : Void
	{
		if (isNaN(config.width)) 
		{
			config.width = 0;
			__makeFlexible(true);
		}
		if (isNaN(config.height)) 
		{
			config.height = 0;
			__makeFlexible(false);
		}
	}
	
	
/** Indicates whether or not control is loading.
@return boolean true if loading skin graphics.
*/
	
	function isLoading() : Boolean 
	{
		return Boolean(__loadingThings);
	}


/** Final notice that controls are about to be displayed for the first time.
Called by {@link com.moviemasher.Core.Panel} object after all controls are loaded
and targetProperty and watchProperty have been called.
*/
	function makeConnections() : Void 
	{
	}
	
	
	

/** Event notification that the property the receiver is bound to
has changed.
@param event Object with standard event keys, plus 'property' and 'value'.
*/
	function propertyChange(event : Object) : Void
	{
	
	}
	
		
/** Event notification that one of receiver's properties has changed.
@param event Object with standard event keys, plus 'property' and 'value'.
*/
	function propertyChanged(event : Object) : Void
	{
		_global.app.dragging = false;
		__changeProperty(true, event.property, event.value, event.target);	
	}
	
/** Event notification that one of receiver's properties is being changed.
@param event Object with standard event keys, plus 'property' and 'value'.
*/
	function propertyChanging(event : Object) : Void
	{
		_global.app.dragging = true;
		__changeProperty(false, event.property, event.value, event.target);
	}

/** Event notification that the property the receiver is bound to
is being defined or undefined.
@param event Object with standard event keys, plus 'property' and 'defined'.
*/
	// one of my targets has defined or undefined a property
	function propertyRedefined(event : Object) : Void
	{
		
		if (__targets[event.property] == event.target)
		{
			var should_be_visible = ((event.defined || __canDisable) ? (! config.disable) : Boolean(config.disable));
			//var call_redefined : Boolean;
			
			if (config.visible != should_be_visible)
			{
				config.visible = should_be_visible;
				panel.delayedDraw();
			}
			if (config.visible && event.defined)
			{
				//if (property == undefined) call_redefined = true;
				__property = event.property;
				if (event.value) 
				{
					propertyChange(event);
				}
				if (__canDisable) enabled = true;
			}
			else 
			{
				__property = undefined;
				if (config.visible) enabled = false;
			}
		}
	}

/** Indicates whether or not the property supplied becomes undefined.
@param property String containing property name.
@return Boolean false if property remains defined at all times.
*/
	function propertyRedefines(property : String) : Boolean
	{
		return false;
	}

/** Remove handler for specified event.
See mx.events.EventDispatcher API for details. 
@param event string containing event name
@param handler object or movieclip event handler
*/
	function removeEventListener(event:String, handler) : Void  {}


/** Change the size of control and redraw immediately. 
@param w Number of pixels wide.
@param h Number of pixels tall.
*/
	
	function setSize(w : Number, h : Number) : Void
	{
		__width = w;
		__height = h;
		size();
	}
	
/** Redraw the control. */
	function size() : Void
	{
	}

/** Notice that target wants to listen for propertyChanging and propertyChanged 
events from receiver. 
@param property String containing property name.
@param target Control object that has the property to be changed.
*/
	function targetProperty(property : String, target: com.moviemasher.Control.Control) : Void
	{
		__targets[property] = target;
	}

/** Notice that another control wants to listen to propertyChange events from receiver,
and propertyRedefined events if applicable.
@param property String containing property name.
*/
	function watchProperty(property : String) : Void
	{
		__watchedProperties[property] = true;
	}

// PRIVATE INTERFACE

	private static var __dimNames = {w: 'h', h: 'w', x: 'y', y: 'x', width: 'height', height: 'width'};
	private static var __madeEventDispatcher : Boolean = false;
	
	private var __canDisable : Boolean = false;
	private var __height = 0;
	private var __loadingThings : Number = 0;
	private var __property : String;
	private var __targets : Object;
	private var __watchedProperties : Object;
	private var __width = 0;
	
	private function Control()
	{
		_global.app.msg('control!');
		if (! __madeEventDispatcher)
		{
			__madeEventDispatcher = true;
			mx.events.EventDispatcher.initialize(com.moviemasher.Control.Control.prototype);
		}
		__targets = {};
		__watchedProperties = {};
	}
	
	private function __changeProperty(finished : Boolean, property : String, value)
	{
	
	}

	private function __didLoad(result, event_type)
	{
		__loadingThings--;
		if (! __loadingThings) 
		{
			//_global.com.moviemasher.Control.Debug.msg('dispatching ' + event_type);
			dispatchEvent({type: event_type});
		}
	}
	
	private function __dimName(pre : String, name : String, post : String)
	{
		var dim_name = '';
		if (pre.length) dim_name += pre;
		
		if (config.horizontal) dim_name += name;
		else dim_name += __dimNames[name];
		
		if (post.length) dim_name += post;
		return dim_name;
	}

/** Broadcast event to handlers.
See mx.events.EventDispatcher API for details. 
@param event object with 'type' key equal to event name
*/
	private function dispatchEvent(event : Object) : Void {}


	private function __setUndefinedConfig(property : String, value)
	{
		if (config[property] == undefined) config[property] = value;
	}
	
	private function __makeFlexible(horizontal)
	{
		config[(horizontal ? 'width' : 'height') + 'Flex'] = true;
		
	}



}