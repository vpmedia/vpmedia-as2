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


import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.BitmapData;

/** Theme module provides a fade between two colors over time.


*/
class com.moviemasher.Module.Colorfade extends com.moviemasher.Module.Module
{


	/** Draws appropriate tween color
	* @param key String containing ID of clip
	* @param values Object containing clip properties
	* @param mc MovieClip to draw into
	* @param done Number between 0 and 1 representing current time
	* @param bm_width Number specifying frame width
	* @param bm_height Number specifying frame height
	
	*/
	function applyMedia(key : String, values : Object, mc: MovieClip, done : Number, size: Object) : Object
	{
		var bm_width : Number = size.width;
		var bm_height : Number = size.height;
		var apply_status = {loading: false, changed: false};
	
		var values_index = 'apply_filter_values_' + config.id;
		var apply_values = {};
		
		var clip_name = 'Colorfade_' + config.id;
		if (mc[clip_name] == undefined) 
		{
			mc.createEmptyMovieClip(clip_name, mc.getNextHighestDepth());
			mc[clip_name].createEmptyMovieClip(clip_name, mc[clip_name].getNextHighestDepth());
			apply_status.changed = true;
		}
		var forecolor = _global.com.moviemasher.Utility.DrawUtility.hexColor(copyValue('forecolor', values, config, __defaults));
		var backcolor = _global.com.moviemasher.Utility.DrawUtility.hexColor(copyValue('backcolor', values, config, __defaults));
		var intensity = copyValue('intensity', values, config, __defaults);
		intensity = _global.com.moviemasher.Utility.PlotUtility.string2Plot(intensity);
		var per = _global.com.moviemasher.Utility.PlotUtility.value(intensity, done * 100);
		
		apply_values.color = _global.com.moviemasher.Utility.DrawUtility.blendColor(per / 100, forecolor, backcolor);
		//_global.com.moviemasher.Control.Debug.msg('Colorfade ' + done + ' % ' + forecolor + ' -> ' + backcolor);
		
		if ((mc[values_index] == undefined) 
			|| (! _global.com.moviemasher.Utility.ObjectUtility.equals(apply_values, mc[values_index]))
		){
			apply_status.changed = true;
			mc[values_index] = apply_values;
			
		}
		_global.com.moviemasher.Utility.DrawUtility.plot(mc[clip_name], - bm_width / 2, - bm_height / 2, bm_width, bm_height, apply_values.color);
	
		return apply_status;
		
	}
	private static var __defaults : Object = {forecolor: '333333', backcolor: 'CCCCCC', intensity: '0,0,100,100'};
	
	private function Colorfade() 
	{
	}	
}

