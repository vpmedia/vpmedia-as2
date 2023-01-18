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



/** Control symbol edits a matrix of percentages, like the volume of {@link com.moviemasher.Clip.Audio}/{@link com.moviemasher.Clip.Video} clips.


*/

class com.moviemasher.Control.Plotter extends com.moviemasher.Control.Control
{

	function createChildren() : Void
	{
		createEmptyMovieClip('__back_mc', getNextHighestDepth());
		createEmptyMovieClip('__lines_mc', getNextHighestDepth());
		createEmptyMovieClip('__ovals_mc', getNextHighestDepth());
		if (! config[(config.horizontal ? 'width' : 'height')]) __makeFlexible(config.horizontal);		
	}
	
	function onPress()
	{
		if ((_xmouse > config.padding) && (_xmouse < (width - config.padding)) && (_ymouse > config.padding) && (_ymouse < (height - config.padding)))
		{
			__origValue = _global.com.moviemasher.Utility.ArrayUtility.copy(__value);
			if (! config.multiple) __dragIndex = 0;
			else if (__ovals_mc.hitTest(_root._xmouse, _root._ymouse))
			{
				var z = __value.length;
				var oval_name;
				for (var i = 0; i < z; i += 2)
				{
					oval_name = 'oval_' + i;
					if (__ovals_mc[oval_name].hitTest(_root._xmouse, _root._ymouse))
					{
						__dragIndex = i;
						break;
					}
				}
			}
			onMouseMove = __doDrag;
			__doDrag();
		}
	}
	
	function onRelease()
	{
		__dragIndex = -1;
		onMouseMove = undefined;
		if (__didDrag) dispatchEvent({type: 'propertyChanged', property: __property, value: String(__value)});
		__didDrag = false;
		
	}
	
	function onReleaseOutside() : Void
	{
		onRelease();
	}
	
	
	function propertyChange(event : Object) : Void
	{
		if (targets[event.property] == event.target)
		{
			if (event.value != undefined) __value = _global.com.moviemasher.Utility.PlotUtility.string2Plot(event.value);
			else __value = event.value;
			__plotValue();
		}
	}

	function size() : Void
	{
		super.size();
		if (! (width && height)) return;
		__back_mc.clear();
		
		var c = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.color);
		if (config.grad)
		{
			c = _global.com.moviemasher.Utility.DrawUtility.buffedFill(width, height, c, config.grad, config.angle);
		}
		_global.com.moviemasher.Utility.DrawUtility.plot(__back_mc, 0, 0, width, height, c, 100, config.curve);

		__plotWidth = width - ((2 * config.padding) + config.controlsize);
		__plotHeight = height - ((2 * config.padding) + config.controlsize);
		__ovals_mc._x = __ovals_mc._y = __lines_mc._x = __lines_mc._y = config.padding + (config.controlsize / 2);
		
		__plotValue();
	}
	
	
	
// PRIVATE INSTANCE PROPERTIES

	private var __back_mc : MovieClip;
	private var __didDrag : Boolean = false;
	private var __dragIndex : Number = -1;
	private var __highest : Number = 0;
	private var __lines_mc : MovieClip
	private var __origValue : Array;
	private var __ovals_mc : MovieClip
	private var __plotWidth : Number;
	private var __plotHeight : Number;
	private var __value : Array;

// PRIVATE INSTANCE METHODS
	
	private function Plotter()
	{
		if (config.angle == undefined) config.angle = 270;
		if (config.attributes == undefined) config.attributes = 'timeline.volume';
		if (config.color == undefined) config.color = 666666;
		if (config.controlangle == undefined) config.controlangle = 90;
		if (config.controlcolor == undefined) config.controlcolor = 'CCCCCC';
		if (config.controlgrad == undefined) config.controlgrad = 40;
		if (config.controlsize == undefined) config.controlsize = 6;
		if (config.curve == undefined) config.curve = 4;
		if (config.grad == undefined) config.grad = 40;
		if (config.padding == undefined) config.padding = 2;
		if (config.multiple == undefined) config.multiple = true;
		else config.multiple = Boolean(config.multiple);
	}
	

	private function __doDrag()
	{
		__didDrag = true;
		var	val = _global.com.moviemasher.Utility.ArrayUtility.copy(__origValue);
		var is_outer : Boolean = false;
		var did_exist : Boolean = (__dragIndex > -1);
		
		if (did_exist) is_outer = ( (__dragIndex == 0) || (__dragIndex == (__origValue.length - 2)));
		var mouse_inside : Boolean = ((_xmouse > 0) && (_xmouse < width) && (_ymouse > 0) && (_ymouse < height));
		if ((! is_outer) && (! mouse_inside))
		{
			if (did_exist) val.splice(__dragIndex, 2);
		}
		else
		{
			var new_percents = __pixels2Percents([__ovals_mc._xmouse, __ovals_mc._ymouse]);
			if (did_exist)
			{
				if (is_outer && config.multiple) new_percents[0] = __origValue[__dragIndex];
				val.splice(__dragIndex, 2);
			}
			var z = val.length;
			var insert_index = __dragIndex;
			
			for (var i = 0; i < z; i += 2)
			{
				if (val[i] > new_percents[0])
				{
					insert_index = i;
					break;
				}
			}
			val.splice(insert_index, 0, new_percents[1]);
			val.splice(insert_index, 0, new_percents[0]);
		}	
		__value = val;
		__plotValue();
		dispatchEvent({type: 'propertyChanging', property: __property, value: String(__value)});
	}
	
	
	private function __percents2Pixels(a : Array)
	{
		return [Math.round((a[0] * __plotWidth) / 100), Math.round(((100 - a[1]) * __plotHeight) / 100)];
	}
	
	private function __pixels2Percents(a : Array)
	{
		return [Math.max(0, Math.min(100, Math.round((a[0] * 100) / __plotWidth))), Math.max(0, Math.min(100, Math.round(((__plotHeight - a[1]) * 100) / __plotHeight)))];
	}
	
	private function __plotValue()
	{
		var z : Number;
		var i : Number = 0;
		var line_name : String;
		var oval_name : String;
		if (__value != undefined)
		{
			z = __value.length;
			var half_oval = config.controlsize / 2;
			var val;
			var line_params;
			var control_fill = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.controlcolor);
			var line_hi = 0;
			var line_low = control_fill;
			if (config.controlgrad)
			{
				control_fill = _global.com.moviemasher.Utility.DrawUtility.buffedFill(config.controlsize, config.controlsize, control_fill, config.controlgrad, config.controlangle);
				line_hi = control_fill.colors[0];
				line_low = control_fill.colors[control_fill.colors.length - 1];
			}
			
			for (; i < z; i += 2)
			{
				val = __percents2Pixels([__value[i], __value[i + 1]]);
				
				oval_name = 'oval_' + i;
				if (! __ovals_mc[oval_name]) 
				{
					__ovals_mc.createEmptyMovieClip(oval_name, __ovals_mc.getNextHighestDepth());
					_global.com.moviemasher.Utility.DrawUtility.setFill(__ovals_mc[oval_name], control_fill);
					_global.com.moviemasher.Utility.DrawUtility.drawFill(__ovals_mc[oval_name], _global.com.moviemasher.Utility.DrawUtility.points(- half_oval, -half_oval, config.controlsize, config.controlsize, half_oval));
				}
				__ovals_mc[oval_name]._x = val[0];
				__ovals_mc[oval_name]._y = val[1];
				if (i)
				{
					line_name = 'line_' + i;
					if (! __lines_mc[line_name]) __lines_mc.createEmptyMovieClip(line_name, __lines_mc.getNextHighestDepth());
					__lines_mc[line_name].clear();
					line_params = [{x: __ovals_mc['oval_' + (i - 2)]._x, y: __ovals_mc['oval_' + (i - 2)]._y}, {x: val[0], y: val[1]}];
					_global.com.moviemasher.Utility.DrawUtility.setLine(__lines_mc[line_name], 3, line_low);
					_global.com.moviemasher.Utility.DrawUtility.drawFill(__lines_mc[line_name], line_params, false);
					if (line_hi)
					{
						_global.com.moviemasher.Utility.DrawUtility.setLine(__lines_mc[line_name], 1, line_hi);
						_global.com.moviemasher.Utility.DrawUtility.drawFill(__lines_mc[line_name], line_params, false);
					}
				}
			}
		}
		z = __highest;
		__highest = i;
		for (; i < z; i++)
		{
			line_name = 'line_' + i;
			oval_name = 'oval_' + i;
			__ovals_mc[oval_name].removeMovieClip();
			__lines_mc[line_name].removeMovieClip();
		}
	}
		
}