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



import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.ColorComposite;
import flash.display.BitmapData;

/** Effect module merges a {@link com.moviemasher.Media.Media} object onto underlying tracks, with optional paint mode and transformation.
TODO: shearx and sheary (currently undocumented) should be converted to a single plottable property
TODO: bottomright value for align attribute should be supported
*/

class com.moviemasher.Module.Composite extends com.moviemasher.Module.Module
{
	
	function applyEffect(key : String, values : Object, mc : MovieClip, done : Number, size: Object) : Object
	{
		
		var apply_status = {loading: false, changed: false};
		var values_index = 'apply_filter_values_' + config.id;
		var apply_values = {};
		copyValues(apply_values, ['media','blend'], values, config, __defaults);
		var clip_name = 'composite_' + config.id;
		if (apply_values.media.length)
		{
			if (mc[clip_name] == undefined) 
			{
				mc.createEmptyMovieClip(clip_name, mc.getNextHighestDepth());
				mc[clip_name].createEmptyMovieClip(clip_name, mc[clip_name].getNextHighestDepth());
			}
			var med_ob = _global.com.moviemasher.Media.Media.fromMediaID(apply_values.media);
			if (! _global.com.moviemasher.Control.Debug.isFalse(med_ob, "Composite media ID " + apply_values.media + " not found"))
			{
				var media_type = med_ob.getValue('type');
				var media_duration = ((media_type == 'theme') ? values.length : med_ob.getValue('duration'));
				var item_done = done * media_duration;
				var keys = [];
				var other_values = {};
				copyValues(other_values, _global.com.moviemasher.Utility.ObjectUtility.keys(med_ob.clipProperties()), values, config, __defaults);
			
				apply_status = med_ob.applyMedia(clip_name, other_values, mc[clip_name], item_done, size);
				
				if (! apply_status.loading)
				{
					copyValues(apply_values, _global.com.moviemasher.Utility.ObjectUtility.keys(other_values), other_values, config);
					apply_values.frame = 0;
					if ((item_done > 0) && (media_type != 'image'))
					{
						if (item_done >= media_duration) item_done = media_duration;
						apply_values.frame = Math.ceil(item_done * ((media_type == 'theme') ? _global.app.options.video.fps : med_ob.getValue('fps'))) - 1;
					}
				}
			}
		}
		if (! apply_status.loading)
		{
			var default_values = {};
			var keys = ['position', 'scale', 'shearx', 'sheary', 'rotate'];
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
			if (is_variable
				|| (mc[values_index] == undefined) 
				|| (! _global.com.moviemasher.Utility.ObjectUtility.equals(apply_values, mc[values_index]))
			){
				apply_status.changed = true;
				if (! is_variable) mc[values_index] = apply_values;
			
				var matrix = new Matrix();
				var tmp_matrix;
					
				tmp_matrix = new Matrix();
				apply_values.scale = apply_values.scale.split(',');
				tmp_matrix.a = parseFloat(apply_values.scale[0]) / 100;
				tmp_matrix.d = parseFloat(apply_values.scale[1]) / 100;
				matrix.concat(tmp_matrix);
				
				// shear
				tmp_matrix = new Matrix();
				
				tmp_matrix.b = (apply_values.shearx/180) * Math.PI;
				tmp_matrix.c = (apply_values.sheary/180) * Math.PI;
				matrix.concat(tmp_matrix);
		
				// rotation
				tmp_matrix = new Matrix();
	
				tmp_matrix.rotate((apply_values.rotate/180) * Math.PI);
				matrix.concat(tmp_matrix);
				
				// translation
				
				var some_size = (med_ob ? {width: med_ob.width, height: med_ob.height} : _global.app.mash.dimensions);
				var total_size = _global.com.moviemasher.Utility.ObjectUtility.copy(size);
			
				var align = copyValue('align', media.clipDefaults(), config, __defaults);	
				switch (align)
				{
					case 'center':
					{
						total_size.width += some_size.width;
						total_size.height += some_size.height;
						break;	
					}
					case 'topleft': break;
				}
	
				var pt = _global.com.moviemasher.Utility.PlotUtility.plotPoint(apply_values.position, total_size);
				pt.x -= (size.width / 2);
				pt.y -= (size.height / 2);
				switch (align)
				{
					case 'center':
					{
						pt.x -= some_size.width / 2;
						pt.y -= some_size.height / 2;
						break;	
					}
					case 'topleft': break;
				}
				tmp_matrix = new Matrix();
				tmp_matrix.tx = pt.x;
				tmp_matrix.ty = pt.y;
				matrix.concat(tmp_matrix);
				
				if (apply_values.media.length)
				{
					mc[clip_name].blendMode = Math.round(apply_values.blend);
					mc[clip_name].transform.matrix = matrix;
				}
				else mc.applyMatrix[key] = matrix;
			
			}
		}
		return apply_status;
	}
	private static var __defaults : Object = {align: 'center', position: '50,50', media: '', blend: 1, scale: '100,100', shearx: 0, sheary: 0, rotate: 0, intensity: '0,100,100,100'};
 
 
	private function Composite() 
	{
	}
}