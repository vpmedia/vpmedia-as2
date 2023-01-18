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


import flash.filters.DisplacementMapFilter;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.BitmapData;

/** Effect module maps pixels of underlying video and effect tracks, based on the pixels of another visual {@link com.moviemasher.Media.Media} object.
*/
class com.moviemasher.Module.Displace extends com.moviemasher.Module.Module
{

	function applyEffect(key : String, values : Object, mc : MovieClip, done : Number, size: Object) : Object
	{
		var bm_width : Number = size.width;
		var bm_height : Number = size.height;
		
		var apply_status = {loading: false, changed: false};
		var bm;
		var apply_values = {};
		
		copyValues(apply_values, ['map'], values, config, __defaults);
		
		
	
		if (apply_values.map.length)
		{
			var media_clip_name = 'media_id_' + apply_values.map;
			if (! __media_mc[media_clip_name])
			{
				__media_mc.createEmptyMovieClip(media_clip_name, __media_mc.getNextHighestDepth());
				__media_mc[media_clip_name].createEmptyMovieClip('mc', __media_mc[media_clip_name].getNextHighestDepth());		
			}
			var med_ob = _global.com.moviemasher.Media.Media.fromMediaID(apply_values.map);
			var media_type = med_ob.getValue('type');
			var media_duration = ((media_type == 'theme') ? values.length : med_ob.getValue('duration'));
			var item_done = done * media_duration;
				
				
			apply_status = med_ob.applyMedia(key, values, __media_mc[media_clip_name].mc, item_done, size);
			if (! apply_status.loading)
			{
				
				bm = new BitmapData(bm_width, bm_height, true, 0x00000000);
				var m = new Matrix();
				m.translate(bm_width / 2, bm_height / 2);
				bm.draw(__media_mc[media_clip_name].mc, m);
				apply_values.frame = 0;
				if ((item_done > 0) && (media_type != 'image'))
				{
					if (item_done >= media_duration) item_done = media_duration;
					apply_values.frame = Math.ceil(item_done * ((media_type == 'theme') ? _global.app.options.video.fps : med_ob.getValue('fps'))) - 1;
				}
			}
		}
		if (! apply_status.loading)
		{
			var intensity = (values.intensity ? values.intensity : (config.intensity ? config.intensity : ''));
			var is_variable = false;
			var per = 1;
			if (intensity.length) 
			{
				intensity = _global.com.moviemasher.Utility.PlotUtility.string2Plot(intensity);
				per = _global.com.moviemasher.Utility.PlotUtility.value(intensity, done * 100);
				is_variable = ((intensity.length != 4) || (intensity[1] != intensity[3]));
			}
			var values_index = 'apply_filter_displace_values_' + config.id;
			//_global.com.moviemasher.Control.Debug.msg(values_index);
			if (is_variable
				|| (mc[values_index] == undefined) 
				|| (! _global.com.moviemasher.Utility.ObjectUtility.equals(apply_values, mc[values_index]))
			){
				apply_status.changed = true;
				if (! is_variable) mc[values_index] = apply_values;
				mc.applyFilter[key] = new DisplacementMapFilter(bm, undefined, 8, 8, per, per, 'clamp');
				
			}
			
		}
		return apply_status;
		
	}
	
	private static var __defaults : Object = {map: '', intensity: '0,100,100,100'};
 	
	private var __media_mc : MovieClip;
	
	private function Displace()
	{
		createEmptyMovieClip('__media_mc', getNextHighestDepth());	
		__media_mc._visible = false;
	}
	
	
}