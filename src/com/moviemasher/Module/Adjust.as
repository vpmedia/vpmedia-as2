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



/** Effect module adjusts hue, brightness, saturation and contrast of pixels in underlying tracks.
*/
class com.moviemasher.Module.Adjust extends com.moviemasher.Module.Module
{

	

	function applyEffect(key : String, values : Object, mc : MovieClip, done : Number, size: Object) : Object
	{
		var apply_status = {loading: false, changed: false};
	
		var apply_values = {};
		var default_values = {};
		var keys = ['brightness', 'contrast', 'hue', '', 'saturation'];
		copyValues(default_values, keys, media.clipDefaults(), config, __defaults);		
		copyValues(apply_values, keys, values, config, __defaults);
		
		var intensity = (values.intensity ? values.intensity : (config.intensity ? config.intensity : ''));
		var is_variable = false;
			
		if (intensity.length) 
		{
			intensity = _global.com.moviemasher.Utility.PlotUtility.string2Plot(intensity);
			var per = _global.com.moviemasher.Utility.PlotUtility.value(intensity, done * 100);
			is_variable = ((intensity.length != 4) || (intensity[1] != intensity[3]));
			if (is_variable)
			{
				_global.com.moviemasher.Utility.PlotUtility.perValues(per, apply_values, default_values, keys);
			}
		}

		var values_index = 'apply_filter_values_' + config.id;

		if (is_variable 
			|| (mc[values_index] == undefined) 
			|| (! _global.com.moviemasher.Utility.ObjectUtility.equals(apply_values, mc[values_index]))
		){
			apply_status.changed = true;
			if (! is_variable) mc[values_index] = apply_values;
	
			var matrix = new com.quasimondo.geom.ColorMatrix();
			matrix.adjustBrightness(apply_values.brightness, apply_values.brightness, apply_values.brightness);
			matrix.adjustContrast(apply_values.contrast, apply_values.contrast, apply_values.contrast);
			matrix.adjustHue(apply_values.hue);
			matrix.adjustSaturation(apply_values.saturation);
				
			mc.applyFilter[key] = matrix.filter;
		}
		return apply_status;
	}
	private static var __defaults : Object = {brightness: 0, contrast: 0, hue: 0, saturation: 1, intensity: '0,100,100,100'};
 	
	private function Adjust()
	{
	}
}

