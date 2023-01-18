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


/** Static class provides utility functions for matrices of percentages.
*/
class com.moviemasher.Utility.PlotUtility
{
	static function perPlot(per : Number, value : String, default_value: String) : String
	{
		var values = string2Plot(value);
		var defaults = string2Plot(default_value);
		var z = values.length;
		for (var i = 0; i < z; i++)
		{
			values[i] = perValue(per, values[i], defaults[i]);
		}
		return String(values);
	}
	
	static function perValue(per : Number, value : Number, default_value: Number) : Number
	{
		return default_value + (((value - default_value) * per) / 100);
	}
	
	static function perValues(per : Number, values : Object, defaults: Object, keys : Array, update : Object) : Object
	{
		if (update == undefined) update = values;
		if (keys == undefined) keys = _global.com.moviemasher.utils.Object.keys(defaults);
		var z = keys.length;
		var k;
		for (var i = 0; i < z; i++)
		{	
			k = keys[i];
			if (typeof(values[k]) == 'string')
			{
				update[k] = perPlot(per, values[k], defaults[k]);
			}
			else update[k] = perValue(per, values[k], defaults[k]);
		}
		return update;
	}
	
	static function plotPoint(s : String, total_size : Object, offset_size : Object) : Object
	{
		if (offset_size == undefined) offset_size = {width: 0, height: 0};
		var plot : Array = string2Plot(s);
		
		var pt = {x: total_size.width - offset_size.width, y: total_size.height - offset_size.height};
		pt.x = pt.x * (plot[0] / 100);
		pt.y = pt.y * ((100 - plot[1]) / 100);
		return pt;
	}
	
	static function string2Plot(s : String) : Array
	{
		var plot : Array;
		if (! s.length) plot = [0, 100, 100, 100];
		else 
		{
			plot = s.split(',');
			var z = plot.length;
			for (var i = 0; i < z; i++)
			{
				plot[i] = parseFloat(plot[i]);
			}
		}
		return plot;
	}

	static function tweenValue(left_plot : Array, right_plot : Array, percent : Number) : Number
	{
		var percent_total = right_plot[0] - left_plot[0];
		var value_total = (right_plot[1] - left_plot[1]);
		var percent_change = percent - left_plot[0];
		var value_change = (percent_change * value_total) / percent_total;
		return left_plot[1] + value_change;
	}
	
	static function value(plot, percent : Number) : Number
	{
		if (typeof(plot) == 'String') plot = string2Plot(plot);
		percent = Math.round(percent);
		var left_plot;
		var right_plot;
		var z = plot.length;
		for (var i = 0; i < z; i += 2)
		{
			if (plot[i] == percent)
			{
				left_plot = [plot[i], plot[i + 1]];
				break;
			}
			if (plot[i] > percent)
			{
				left_plot = [plot[i - 2], plot[i - 1]];
				right_plot = [plot[i], plot[i + 1]];
				break;
			}
		}
		if (! left_plot) left_plot = [plot[z - 2], plot[z - 1]];
		if (! right_plot) return left_plot[1];
		return tweenValue(left_plot, right_plot, percent);
	}
		
}