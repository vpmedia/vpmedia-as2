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


import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.BitmapData;
import flash.filters.DropShadowFilter;

/** MovieClip symbol representing a single panel tag in the configuration.
*/

class com.moviemasher.Core.Panel extends MovieClip
{

/** Static Object containing all existing {@link com.moviemasher.Control.Control} 
objects that have an id attribute (which is used as key). 
*/
	static var controls : Object = {};


/** Object representation of panel tag. */
	var config : Object;

	
/** Number of pixels tall. */
	function get height() : Number 
	{ 
		return __height; 
	}
	
/** Number of pixels wide. */
	function get width() : Number 
	{ 
		return __width; 
	}
	

/** Add handler for specified event.
See mx.events.EventDispatcher API for details.
@param event String containing event name.
@param handler Object or movieclip event handler.
*/
	function addEventListener(event:String, handler) : Void {}

	

/** Call a method repeatedly for each control.
@param method String containing the name of the method to call.
@param target Object with method, or undefined to send to each control.

*/	function callControls(method : String, target : Object) : Void
	{
		var y : Number
		var z : Number;
		var call_ob : Object
		var bar : Object;
		var call_param = undefined;
		z = config.bar.length;
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				y = bar.control.length;
				if (y)
				{
					for (var j = 0; j < y; j++)
					{
						call_ob = ((target == undefined) ? bar.control[j].control : target);
						if (target != undefined) call_param = bar.control[j];
						call_ob[method](call_param);
					}
				}
			}
		}
	}

	
/** Trigger a redraw of panel at the next event loop.
*/
	function delayedDraw() : Void // called when visibility of controls changed
	{
		__callLater('size');
	}
	
/** Broadcast event to handlers.
See mx.events.EventDispatcher API for details. 
@param event Object with 'type' key equal to event name.
*/
	function dispatchEvent(event : Object) : Void {}


	
/** Setup property bindings for all controls.
Called with each control by {@link com.moviemasher.Core.App} object during initialization, 
immediately after targetControl() is called. 
@param control Object with 'control' key containing {@link com.moviemasher.Control.Control} object.
*/
	function initBindings(control : Object) : Void
	{
			
		var target_control : Object;
		var listener_control = control.control;
			
		for (var target_id in listener_control.targets)
		{
			target_control = listener_control.targets[target_id];
			
			if (target_control.propertyRedefines(target_id)) 
			{
				target_control.addEventListener('propertyRedefined', listener_control);
				if (listener_control.canDisable) listener_control.enabled = false;
				else control.visible = false; // must wait for target to specifically enable property
			}
			else listener_control.propertyRedefined({target: target_control, property: target_id, defined: true});
			target_control.addEventListener('propertyChange', listener_control);
			listener_control.addEventListener('propertyChanging', target_control);
			listener_control.addEventListener('propertyChanged', target_control);
		
		}
	}
	
	
/** Call createChildren method of each control.
Called with each control by {@link com.moviemasher.Core.App} object during initialization, 
immediately after initBindings() is called. 
If a control requires further loading, panel will listen for loadingComplete event.
@param control Object with 'control' key containing {@link com.moviemasher.Control.Control} object.

*/
	function initControl(control : Object) : Void
	{
		var w : Number, h : Number;
		if (control.control)
		{
			control.control.createChildren();
			
			if (control.control.isLoading())
			{
				__loadingThings ++;
				control.control.addEventListener('loadingComplete', this);
			}
			
		}
	}
	
/** Create {@link com.moviemasher.Control.Control} object for control tag.
Called with each control by {@link com.moviemasher.Core.App} object during initialization, 
 after all control SWFs are loaded. 
@param control Object with 'control' key containing {@link com.moviemasher.Control.Control} object.
*/
	function instanceControl(control : Object)
	{
		var swf_mc : MovieClip;
		var depth : Number;
		var clip_name : String;
		if (control.symbol.length)
		{
			if (control.src.length) swf_mc = com.moviemasher.Manager.LoadManager.swfLoaded(control.src);
			else swf_mc = _global.app;
			
			if (swf_mc != undefined) 
			{
				depth = swf_mc.getNextHighestDepth();
				clip_name = 'symbol_' + control.symbol + '_' + depth + '_mc';
				swf_mc.attachMovie(control.symbol, clip_name, depth, {appinstance: _global.app, _y: -1000, config: control, panel: this});
				control.control = swf_mc[clip_name];
				if (control.id.length) controls[control.id] = control.control;
	}	}	}


	
/** Indicates whether or not controls are loading.
@return boolean true if any control is loading SWF files or skin graphics.
*/
	function isLoading() : Boolean 
	{
		return Boolean(__loadingThings);
	}
	

/** Request SWF for control tag, if needed.
Called with each control by {@link com.moviemasher.Core.App} object during initialization, 
immediately after Panel is instanced. 
@param control Object with 'control' key containing {@link com.moviemasher.Control.Control} object.
*/

	function loadControlSource(control : Object)
	{
		var swf_mc : MovieClip;
		if (control.symbol.length)
		{
			if (control.src.length)
			{
				swf_mc = com.moviemasher.Manager.LoadManager.swfLoaded(control.src);
				if (swf_mc == undefined)
				{
					com.moviemasher.Manager.LoadManager.swf(control.src, com.moviemasher.Core.Callback.factory('__didLoad', this, 'swfComplete'), true);
					__loadingThings++;
				}
			}
		}
	}
	
	
/** Sent as each control finishes loading.
If all controls have loaded, dispatch controlsComplete event 
(to {@link com.moviemasher.Core.App} object).
@param event Object with standard event keys.
*/
	function loadingComplete(event : Object) : Void
	{
		__loadingThings --;
		if (! __loadingThings) 
		{
			dispatchEvent({type: 'controlsComplete'});
		}
		event.target.removeEventListener('loadingComplete', this);
	}	
	
/** Remove handler for specified event.
See mx.events.EventDispatcher API for details. 
@param event String containing event name.
@param handler Object or movieclip event handler.
*/
	function removeEventListener(event:String, handler) : Void  {}
	
/** Redraws the panel and initializes control selections.
Called by {@link com.moviemasher.Core.App} at the very end of initializing,
immediately after {@link com.moviemasher.Control.Control}.initSize() and
sizeControls() are called, but 
just before moviemasher.mash is set.
*/
	function selectControls() : Void
	{
		__swfLoaded = true;
		//_global.com.moviemasher.Control.Debug.msg('Panel.selectControls');
		size();
		callControls('makeConnections');
		var z : Number = config.bar.length;
		var y : Number;
		var swf_mc : MovieClip;
		var control : Object;
		var bar : Object;
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				y = bar.control.length;
				for (var j = 0; j < y; j++)
				{
					control = bar.control[j];
					if (control.control && control.visible && control.selected) control.control.select();
				}
			}
		}
	}

	
/** Change the size of panel and redraw immediately. 
@param w Number of pixels wide.
@param h Number of pixels tall.
*/
	function setSize(w : Number, h : Number) : Void
	{
		__width = w;
		__height = h;
		size();
	}

/** Redraw the entire panel, hidding and showing controls as needed. */
	function size() : Void
	{
		if ( ! ( __width && __height ) ) return;
		__setContentSize();
		sizeControls();
		

		__showBars();
		__padding_mc.clear();
		var c : Number;
	
		if (config.color != undefined)
		{
			c = com.moviemasher.Utility.DrawUtility.hexColor(config.color);
			if (config.grad)
			{
				c = com.moviemasher.Utility.DrawUtility.buffedFill(__width, __height, c, config.grad, config.angle);
			}
			com.moviemasher.Utility.DrawUtility.plot(__padding_mc, 0, 0, __width, __height, c);
			
		}
	
		// WINDOW SHADOW
		if (config.shadow || config.shadowcolor || config.border) 
		{
			__window_shadow_mc.clear();
			com.moviemasher.Utility.DrawUtility.setFill(__window_shadow_mc, com.moviemasher.Utility.DrawUtility.hexColor(config.bordercolor));
			com.moviemasher.Utility.DrawUtility.drawFill(__window_shadow_mc, com.moviemasher.Utility.DrawUtility.points(- config.border, - config.border, __width + (2 * config.border), __height + (2 * config.border), config.curve));
		}
		
		// MASK
		__window_mask_mc.clear();
		com.moviemasher.Utility.DrawUtility.setFill(__window_mask_mc, 0x000000);
		com.moviemasher.Utility.DrawUtility.drawFill(__window_mask_mc, com.moviemasher.Utility.DrawUtility.points(0, 0, __width, __height, config.curve));

	
		
		var z = config.bar.length;
	
		var bar_w : Number;
		var bar_h : Number;
		var bar_x : Number;
		var bar_y : Number;
		var bar : Object;
		var has_visible_bar : Boolean = false;
		
		if (z)
		{
			__window_mc.clear();
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				if (bar.visible)
				{
					has_visible_bar = true;
					if (bar.color != undefined)
					{
						c = com.moviemasher.Utility.DrawUtility.hexColor(bar.color);
						if (bar.grad) c = com.moviemasher.Utility.DrawUtility.buffedFill(bar.width, bar.height, c, bar.grad, bar.angle);
						com.moviemasher.Utility.DrawUtility.plot(__window_mc, bar.x, bar.y, bar.width, bar.height, c);
					}
				}
			}
			__maskClip(__window_mc);
		}
		_visible = has_visible_bar;
	}
	
	
	

/** Makes sure that control at index is visible.
Used by the {@link com.moviemasher.Control.Scroller} control, two instances
of which must be in the same bar.
@param bar Object representation of control's bar tag (config.bar, to the control).
@param index Number index of scroller set in bar (config.scrolls_index, to the control).
@param direction Number -1 or 1 depending on whether control is first (config.first, to the control).
*/
	function scrollToBarIndex(bar : Object, index : Number, direction : Number) : Void
	{
		var scrolls = bar.scrolls[index];
		var scrolls_position = scrolls.position + direction;
		if (scrolls_position < 0) scrolls_position += scrolls.controls.length;
		else if (scrolls_position > (scrolls.controls.length - 1)) scrolls_position -= scrolls.controls.length;
		__scrollToBarControl(bar, scrolls.controls[scrolls_position]);
	}
	
/** Redraws controls, but not bars - best to call size() instead.
Called by {@link com.moviemasher.Core.App} when first initializing.
*/

	function sizeControls() : Void
	{
		var z = config.bar.length;
		var y;
		
		var x_pos;
		var y_pos;
		var bar : Object;
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				if (bar.visible && bar.control.length)
				{
					__scrollBar(bar);
				}
			}	
		}
	}
	
	
/** Populate targets property of each control based on ids in its attributes attribute.
Called with each control by {@link com.moviemasher.Core.App} object during initialization, 
immediately after instanceControl() is called. 
@param control Object with 'control' key containing {@link com.moviemasher.Control.Control} object.
*/
	function targetControl(control : Object) : Void
	{
		
		if (control.control)
		{
			var targets_string : String = control.attributes;
			var targets : Array;
			var z;
			var bits : Array;
			var target_control : com.moviemasher.Control.Control;
			var is_always_defined : Boolean;
			var property;
			var target;
			
			if (targets_string.length)
			{
				targets = targets_string.split(',');
				z = targets.length;
				if (! _global.com.moviemasher.Control.Debug.isFalse(z, 'Invalid targets attribute: ' + control.xmlNode.toString()))
				{
					for (var i = 0; i < z; i++)
					{
						bits = targets[i].split('.');
						if (! _global.com.moviemasher.Control.Debug.isFalse(bits.length == 2, 'Invalid target ' + target + '.' + property + ': ' + control.xmlNode.toString()))
						{
							target = bits.shift();
						 	target_control = controls[target];
							if (! _global.com.moviemasher.Control.Debug.isFalse(target_control, 'No id for target ' + target + ': ' + control.xmlNode.toString()))
							{
								property = bits.shift();
								control.control.targetProperty(property, target_control);
								target_control.watchProperty(property);
							}
						}
					}
				}
			}
		}
	}


// PRIVATE INTERFACE

	private static var __madeEventDispatcher : Boolean = false;
	private static var symbolName : String = 'Panel';
	private static var symbolOwner : Object = com.moviemasher.Core.Panel;
	
	private var __contentH : Number;
	private var __contentW : Number;
	private var __contentX : Number;
	private var __contentY : Number;
	private var __height : Number = 0;
	private var __laterInterval : Number = 0; 
	private var __laterQueue : Object;
	private var __loadingThings : Number = 0;
	private var __padding_mc : MovieClip; // duplicate mask for active contents

	
	private var __swfLoaded : Boolean = false;
	
	private var __width : Number = 0;
	private var __window_mask_mc : MovieClip; // mask for above
	private var __window_mc : MovieClip; // window and bar backgrounds
	private var __window_shadow_mc : MovieClip; // shadow duplicate shape for shadow using DropShadowFilter
	


	private function Panel()
	{
		if (! __madeEventDispatcher)
		{
			__madeEventDispatcher = true;
			mx.events.EventDispatcher.initialize(com.moviemasher.Core.Panel.prototype);
		}
		
		__initConfig(); // makes config valid
		
		_x = config.x;
		_y = config.y;
		__createWindow(); // creates background, padding, shadow and matte
		__width = config.width;
		__height = config.height;
		__setContentSize();
		
	}

	private function __calculateBarSizes()
	{
		var bar : Object;
		var z : Number = config.bar.length;
		var wORh : String;
		var flex : Object = {w: 0, h:0};
		var hard : Object = {w: 0, h:0};
		
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				
				if (bar.visible)
				{
					wORh = (bar.horzAlign ? 'h' : 'w');
					if (bar.flexible)
					{
						flex[wORh] += bar.flexible;
					}
					else hard[wORh] += bar.size;
				}
			}
			if (flex.w || flex.h)
			{
				if (flex.w) flex.w = ((__width - (2 * config.padding)) - hard.w) / flex.w;
				if (flex.h) flex.h = ((__height - (2 * config.padding)) - hard.h) / flex.h;
				for (var i = 0; i < z; i++)
				{
					bar = config.bar[i];
					if (bar.visible && bar.flexible)
					{
						wORh = (bar.horzAlign ? 'h' : 'w');
						bar.size = bar.flexible * flex[wORh];
						
					}
				}
			}
		}
	}
	
	private function __calculateBarPositions()
	{
		var new_values : Object;
		var bar : Object;
		var left_x : Number = config.padding;
		var right_x : Number  = __width - (config.padding);
		var top_y : Number  = config.padding;
		var bottom_y : Number = __height - (config.padding);
		var z : Number = config.bar.length;
		var last_bar;
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				new_values = {x: config.padding, y: config.padding};
				bar = config.bar[i];
				if (bar.visible)
				{
					switch(bar.align)
					{
						case 'bottom':
						{
							bottom_y -= bar.size;
							new_values.y = bottom_y;
							// fallthrough to top
						}
						case 'top':
						{
							if (bar.align == 'top')
							{
								new_values.y = top_y;
								top_y += bar.size;
							}
							if (bar.dynamicWidth) new_values.width = __width - (2 * config.padding);
							if (bar.dynamicHeight) new_values.height = bar.size;
							break;
						}
						case 'right':
						{
							right_x -= bar.size;
							new_values.x = right_x;
							// fallthrough to left
						}
						case 'left':
						{
							if (bar.align == 'left')
							{
								new_values.x = left_x;
								left_x += bar.size;
							}
							if (bar.dynamicWidth) new_values.width = bar.size;
							if (bar.dynamicHeight) new_values.height = __contentH;
							new_values.y = __contentY;
							break;
						}
						case 'float':
						{
							new_values.x = last_bar.x;
							new_values.y = last_bar.y + last_bar.height;
							if (bar.dynamicWidth) new_values.width = last_bar.width;
							
							break;	
						}	
					
					}
					com.moviemasher.Utility.ObjectUtility.copy(new_values, bar);
					last_bar = bar;
				}
			}
		}
	
	}

	private function __calculateControlSizes()
	{
		var z : Number = config.bar.length;
		var bar : Object;
		var y : Number;
		var control : Object;
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				y = bar.control.length;
				if (y)
				{
					for (var j = 0; j < y; j++)
					{
						control = bar.control[j];
						//control.horizontal = bar.horizontal;
						if (control.width_editable || (! control.width)) control.width = (control.horizontal ? control.width : bar.width - (bar.padding * 2));
						if (control.height_editable || (! control.height)) control.height = (control.horizontal ? bar.height - (bar.padding * 2) : control.height)
					}
				}
			}	
		}
	}

	private function __callInterval()
	{
		var queue = __laterQueue;
		__laterQueue = undefined;
		clearInterval(__laterInterval);
		__laterInterval = 0;
		
		for (var k in queue)
		{
			this[queue[k].method](queue[k].param);
		}
	}
	
	private function __callLater(method : String, param : String)
	{
		if (param == undefined) param = '';
		if (__laterQueue == undefined) __laterQueue = {};
		__laterQueue[method + param] = {method: method, param: param};
		if (! __laterInterval) __laterInterval = setInterval(this, '__callInterval', 1);
	}
	
	private function __createWindow()
	{
		if (config.shadow || config.shadowcolor || config.border) 
		{
			createEmptyMovieClip('__window_shadow_mc', getNextHighestDepth());
			if (config.shadow || config.shadowcolor ) __window_shadow_mc.filters = [new DropShadowFilter(config.shadow, 45, com.moviemasher.Utility.DrawUtility.hexColor(config.shadowcolor), 1, config.shadowblur, config.shadowblur, config.shadowstrength, 3)];
		}
		createEmptyMovieClip('__padding_mc', getNextHighestDepth());
		createEmptyMovieClip('__window_mc', getNextHighestDepth());
		createEmptyMovieClip('__window_mask_mc', getNextHighestDepth());
		__padding_mc.setMask(__window_mask_mc);
		
	}
	
	private function __didLoad(result, event_type)
	{
		__loadingThings--;
		if (! __loadingThings) dispatchEvent({type: event_type});
	}

	private function __initBarConfig(bar)
	{
		
		var z : Number = bar.control.length;
		var control : Object;
		var in_scroll : Boolean = false;
		
		for (var i = 0; i < z; i++)
		{
			control = bar.control[i];
			control.bar = bar;
			control.visible = true;	
			control.width_editable = true;
			control.height_editable = true;
			
			if (control.width == undefined) control.width = 0;
			else control.width_editable = false;
			
			if (control.height == undefined) control.height = 0;
			else control.height_editable = false;
			
			if (control.horizontal == undefined) control.horizontal = bar.horizontal;
			else control.horizontal = Boolean(control.horizontal);
			
			if (control.symbol == 'Scroller')
			{
				in_scroll = ! in_scroll;
				if (in_scroll)
				{
					if (bar.scrolls == undefined) bar.scrolls = [];
					control.first = true;
					bar.scrolls.push({position: 0, controls: []});
				}
			}
			else if (in_scroll)
			{
				bar.scrolls[bar.scrolls.length - 1].controls.push(control);
			}
			if (bar.scrolls.length) control.scrolls_index = bar.scrolls.length - 1;
		}
	}

	private function __initConfig()
	{
		
		if (config.angle == undefined) config.angle = 90;
		if (config.border == undefined) config.border = 0;
		if (config.bordercolor == undefined) config.bordercolor = 0;
		if (config.padding == undefined) config.padding = 0;
		if (config.curve == undefined) config.curve = 4;
		if (config.grad == undefined) config.grad = 0;
		if (config.shadow == undefined) config.shadow = 0;
		if (config.shadowblur == undefined) config.shadowblur = 16;
		if (config.shadowcolor == undefined) config.shadowcolor = 0;
		if (config.shadowstrength == undefined) config.shadowstrength = 3;
		if (config.x == undefined) config.x = 0;
		if (config.y == undefined) config.y = 0;
		
		var z : Number = config.bar.length;
		var bar : Object;
		var y : Number;
		
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				bar.visible = true;
				if (bar.align == undefined) bar.align = 'top';
				//if (bar.color == undefined) bar.color = '333333';
				if (bar.grad == undefined) bar.grad = 0;
				if (bar.angle == undefined) bar.angle = 90;
				if (bar.padding == undefined) bar.padding = 0;
				if (bar.spacing == undefined) bar.spacing = 0;
				if (bar.size == undefined) bar.size = 0;
				
				bar.dynamicWidth = (bar.width == undefined);
				bar.dynamicHeight = (bar.height == undefined);
				
				bar.flexible = (isNaN(bar.size) ? bar.size.length : 0);
				bar.horzAlign =  ( ! ((bar.align == 'left') || (bar.align == 'right')));
				if (bar.horizontal == undefined) bar.horizontal = bar.horzAlign;
				//if (bar.horizontal == undefined) bar.horizontal = ((bar.align == 'top') || (bar.align == 'bottom'));
				//else bar.horizontal = Boolean(bar.horizontal);
				if (bar.control.length)
				{
					__initBarConfig(bar);
				}
			}	
		}
	}
	
	private function __maskClip(mc : MovieClip)
	{
		var depth = mc._parent.getNextHighestDepth();
		var clip_name = mc._name + '_mask';
		if (! mc._parent[clip_name]) 
		{
			mc._parent.createEmptyMovieClip(clip_name, depth);
			mc._parent[clip_name]._x =  config.padding + ((mc._parent == this) ? 0 : _x);
			mc._parent[clip_name]._y = config.padding + ((mc._parent == this) ? 0 : _y);
			mc.setMask(mc._parent[clip_name]);
		}
		mc._parent[clip_name].clear();
		com.moviemasher.Utility.DrawUtility.plot(mc._parent[clip_name], 0,0, __width - (2 * config.padding), __height - (2 * config.padding), 0x000000, 100, config.curve);
	}

	private function __scrollBar(bar)
	{
		var control : Object;
		var in_scroll : Boolean = false;
		var z : Number = bar.control.length;
		var wORh = (bar.horizontal ? 'width' : 'height') 
		var yORx = (bar.horizontal ? 'y' : 'x') 
		var hORw = (bar.horizontal ? 'height' : 'width') 
		var control_size : Number;
		var pos : Object = {};
		pos.width = bar.x + bar.padding;
		pos.height = bar.y + bar.padding;
		if (z)
		{
			var visible_controls = 0;
			var hard_space = 0;
			var flex_controls = 0;
			for (var i = 0; i < z; i++)
			{
				control = bar.control[i];
				
				if (! in_scroll)
				{
					if (control.visible)
					{
						
						visible_controls++;
						if (control.symbol == 'Scroller')
						{
							visible_controls++;
							in_scroll = true;
							hard_space += control[wORh];
							flex_controls++;
						}
						else
						{
							if (control[wORh + 'Flex']) flex_controls++;
							else hard_space += control[wORh];
						}
					}
				}
				else if (control.symbol == 'Scroller')
				{
					in_scroll = false;
					hard_space += control[wORh];
					visible_controls++;
						
				}
				
			}
			if (! visible_controls) return;
		
			if (flex_controls) flex_controls = (((bar[wORh] - ((2 * bar.padding) + ((visible_controls - 1) * bar.spacing))) - hard_space) / flex_controls);
			in_scroll = false;
			var scroll_index = 0;
			for (var i = 0; i < z; i++)
			{
				control = bar.control[i];
				if (control.control)
				{
					if (! in_scroll)
					{
						
						if (control.visible)
						{
							if (control[wORh + 'Flex'])
							{
								control_size = flex_controls;
								control[wORh] = flex_controls;
							}
							else  control_size = control[wORh];
							

							control.x = _x + pos.width;
							control.y = _y + pos.height;
						
							switch (control.align)
							{
								case 'top':
								case 'left':
								{
									break;
								}
								case 'bottom':
								case 'right':
								{
									control[yORx] += Math.round(((bar[hORw] - (2 * bar.padding)) - control[hORw]));
									break;
								}
								default:
								{
									control[yORx] += Math.round(((bar[hORw] - (2 * bar.padding)) - control[hORw]) / 2);
								}
								
							}
							pos[wORh] += control_size + bar.spacing;
							if (control.symbol == 'Scroller')
							{
								bar.scrolls[scroll_index].x = _x + pos.width;
								bar.scrolls[scroll_index].y = _y + pos.height;
								bar.scrolls[scroll_index].flex = flex_controls;
								pos[wORh] += flex_controls;
								in_scroll = true;
							}
						}
					}
					else if (control.symbol == 'Scroller') 
					{
						in_scroll = false;
						bar.scrolls[scroll_index].right = control;
						scroll_index++;
						control.control._x = _x + pos.width;
						control.control._y = _y + pos.height;
						pos[wORh] += control[wORh] + bar.spacing;
					}
					
				}
			}
			z = bar.scrolls.length;
			if (z) 
			{
				for (var i = 0; i < z; i++)
				{
					__scrollBarControl(bar, i);
				}
				__showBars();
			}
		}
	}
	
	
	private function __scrollBarControl(bar, scrolls_index)
	{
		var wORh = (bar.horizontal ? 'width' : 'height') 
		var hORw = (bar.horizontal ? 'height' : 'width') 
		var scrolls = bar.scrolls[scrolls_index];
		var z = scrolls.controls.length;
		var control : Object;
		var available_space = scrolls.flex;
		
		var control_size : Number;
		var pos : Object = {};
		pos.width = scrolls.x;
		pos.height = scrolls.y;
		var i;
		for (i = scrolls.position; i < z; i++)
		{
			control = scrolls.controls[i];
			available_space -= control[wORh] + bar.spacing;
			control.visible = (available_space >= 0);
			
			if (control.visible)
			{
				control.x = pos.width;
				control.y = pos.height;
				pos[wORh] += control[wORh] + bar.spacing;	
			}
			else break;
		}
		for (; i < z; i++) // hide the rest
		{
			control = scrolls.controls[i];
			control.visible = false;
		}
		z = scrolls.position;
		for (i = 0; i < z; i++)
		{
			control = scrolls.controls[i];
			available_space -= control[wORh] + bar.spacing;
			control.visible = (available_space >= 0);
			
			if (control.visible)
			{
				control.x = pos.width;
				control.y = pos.height;
				pos[wORh] += control[wORh] + bar.spacing;	
			}			
		}
		scrolls.right.mc._x = pos.width;
		scrolls.right.mc._y = pos.height;
				
	}
	
	private function __scrollToBarControl(bar, to_control)
	{
		var control : Object;
		var scrolls_index : Number =  to_control.scrolls_index;
		var scrolls = bar.scrolls[scrolls_index];
		var z = scrolls.controls.length;
		
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				control = scrolls.controls[i];
				
				if (control == to_control)
				{
					scrolls.position = i;
					break;
				}
			}	
		}
		__visibleBar(bar);
		__scrollBar(bar);
	}
	// runs through config setting default sizes for bars and controls
	private function __setContentSize()
	{
		__contentW = __width;
		__contentH = __height;
		__contentX = 0;
		__contentY = 0;
		if (config.padding)
		{
			__contentX += config.padding;
			__contentY += config.padding;
			__contentW -= (2 * config.padding);
			__contentH -= (2 * config.padding);
		}
		var bar : Object;
		var z = config.bar.length;
		if (z)
		{
			
			if (__swfLoaded) 
			{
				for (var i = 0; i < z; i++)
				{
					bar = config.bar[i];
					__visibleBar(bar);
				}
			}
			
			__calculateBarSizes();
			for (var i = 0; i < z; i++)
			{
				bar = config.bar[i];
				if (bar.visible && (! bar.flexible))
				{
					switch(bar.align)
					{
						case 'top':
						{
							__contentY += bar.size;
							// fallthrough to 'bottom'
						}
						case 'bottom':
						{
							__contentH -= bar.size;
							break;
						}
						case 'left':
						{
							__contentX += bar.size;
							// fallthrough to 'right'
						}
						case 'right':
						{
							__contentW -= bar.size;
							break;
						}
					}
				}
			}	
			__calculateBarPositions();
			__calculateControlSizes();
		}
	}
	
	private function __showBars()
	{
		callControls('__showControl', this);
	}
	
	private function __showControl(control)
	{
		if (control.control._visible != control.visible) 
		{
			control.control._visible = control.visible;
		}
		if (control.visible)
		{
			if (! ((control.control._x == control.x) && (control.control._y == control.y)))
			{
				control.control._x = control.x;
				control.control._y = control.y;
			}
			if (! ((control.control.width == control.width) && (control.control.height == control.height)))
			{
				
				control.control.setSize(control.width, control.height);
				if (control.mask) __maskClip(control.control);
			}
		}
	}
	
	private function __visibleBar(bar)
	{
		var visible_controls : Number;
		var y : Number;
		var control : Object;
		var mc_found : Boolean = false;
		visible_controls = 0;
		var scroll_controls : Array = [];
		var in_scroll : Boolean = false;
		var should_be_visible : Boolean = true;
		y = bar.control.length;
		if (y)
		{
			for (var j = 0; j < y; j++)
			{
				control = bar.control[j];
			
				mc_found = true;
				if (! in_scroll) 
				{
					should_be_visible = control.visible;
					if (should_be_visible) 
					{
						visible_controls++;
						if (control.symbol == 'Scroller') in_scroll = true;
					}
				}
				else if (control.symbol == 'Scroller') 
				{
					should_be_visible = control.visible;
					if (should_be_visible) in_scroll = false;
				}
			
			}
		}
		bar.visible = ((! mc_found) || Boolean(visible_controls));
	}
	

}