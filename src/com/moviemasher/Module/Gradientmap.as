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
/** Theme module displays a greyscale gradient useful to the {@link com.moviemasher.Module.Displace} effect module.
TODO: allow more than simple droplet shape.
TODO: scalex and scaley (currently undocumented) should be converted to a single plottable property.
*/

class com.moviemasher.Module.Gradientmap extends com.moviemasher.Module.Module
{

	

	function applyMedia(key : String, values : Object, mc: MovieClip, done : Number, size: Object) : Object
	{
		var bm_width : Number = size.width;
		var bm_height : Number = size.height;
		
		var apply_status = {loading: false, changed: true};
		var apply_values = {};
		
		copyValues(apply_values, ['scalex','scaley'], values, config, __defaults);
	
		var clip_index = 'gradientmap_' + config.id;
		if (! mc[clip_index]) mc.createEmptyMovieClip(clip_index, mc.getNextHighestDepth());
		else mc[clip_index].clear();

		
		var base_colors = [0, 0, 0, 0, 0];
		var base_alphas = [50, 0, 50, 100, 50];
		var colors = [];
		var alphas = [];
		var scaled = 10 * apply_values.scalex * apply_values.scaley;
		var z = scaled - Math.floor(scaled * done);
		for (var i = 0; i < z; i++)
		{
			colors = colors.concat(base_colors);
			alphas = alphas.concat(base_alphas);
		}
		var half_done = 1 - Math.abs(done - .5);
		var c = {spread: 'pad', x: - bm_width * half_done / 2, y: - bm_height * half_done / 2, width: bm_width * half_done, height: bm_height * half_done, type: 'radial', colors: colors, alphas: alphas};//
		_global.com.moviemasher.Utility.DrawUtility.plot(mc[clip_index], - bm_width / 2, - bm_height / 2, bm_width, bm_height, c);
		
		return apply_status;
	}
	private static var __defaults : Object;
 	
	
	private function Gradientmap()
	{		
		if (__defaults == undefined) __defaults = {scaley:  1, scalex: 1};
	}	

}

