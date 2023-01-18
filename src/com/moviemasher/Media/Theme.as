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

/** Class handles loading and interactions with theme symbol in external swf file. 
*/


class com.moviemasher.Media.Theme extends com.moviemasher.Media.Media
{


/** Draw content to a MovieClip for a {@link com.moviemasher.Clip.Theme} object.
Override passes parameters to theme symbol, loading from swf file if needed. 
The time parameter is converted to a percentage relative to duration.
@param key String index for applyTransform, applyFilter, applyMask and applyMatrix objects.
@param values Object with {@link com.moviemasher.Clip.Clip} specific values.
@param mc MovieClip that can drawn to (drawing should be centered at origin).
@param time Number of seconds of current time relative to clip duration.
@param size Object with 'width' and 'height' keys matching {@link com.moviemasher.Core.Mash} dimensions.
@return Object with 'loading' and 'changed' Boolean keys indicating apply status.
Loading will be true if swf is still loading, or the symbol is loading additional files.
*/

	function applyMedia(key : String, values : Object, mc : MovieClip, time : Number, size: Object) : Object
	{
		var apply_status = {loading: false, changed: false};
		var done : Number = time / values.length;
		
		var url = getValue('url');
		if (url.length) 
		{
			var swf_mc : MovieClip;
			if (! __swf_mc)
			{
				swf_mc = com.moviemasher.Manager.LoadManager.swfLoaded(url);
				if (swf_mc == undefined)
				{
					if (__swf_mc == undefined)
					{
						__swf_mc = false;
						com.moviemasher.Manager.LoadManager.swf(url);
					}
					//_global.com.moviemasher.Control.Debug.msg('Theme.applyMedia');
				}
				else __swfDidLoad(swf_mc, true);
			}
		
			if (__swf_mc) 
			{
			
				apply_status = __swf_mc.applyMedia(key, values, mc, done, size);
				if (! apply_status.loading) 
				{
					width = mc._width;
					height = mc._height;
				}
			}
			else apply_status.loading = true;
		}
		return apply_status;
	}
	
/** Returns background color.
The {@link com.moviemasher.Media.Theme} override passes paramter to external symbol.
@return String with six character hex color value, or undefined.
*/

	function backColor(values : Object) : String
	{
		return __swf_mc.backColor(values);
	}

	private var __swf_mc; // holds my display symbol or false while loading
	
	
	private function Theme()
	{
	}
	
	
	private function __time2Frame(atTime : Number, values : Object)
	{
		if (atTime <= 0) return 0;
		var my_length = values.length;
		var my_fps = _global.app.options.video.fps;
		if (atTime >= my_length) atTime = my_length;
		return Math.ceil(atTime * my_fps) - 1;
	}
	private function __swfDidLoad(mc : MovieClip)
	{
		//_global.com.moviemasher.Control.Debug.msg('Theme.__swfDidLoad');
		var clip_name = 'media_' + getValue('id');
		if (! mc[clip_name]) mc.attachMovie(getValue('symbol'), clip_name, mc.getNextHighestDepth(), {media: this, config: config});
		if (typeof(mc[clip_name].applyMedia) == 'function') __swf_mc = mc[clip_name];
		else mc[clip_name].removeMovieClip();

	}
}