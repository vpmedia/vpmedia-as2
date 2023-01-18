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

/** Class handles loading and interactions with transition symbol in external swf file. 
*/

class com.moviemasher.Media.Transition extends com.moviemasher.Media.Media
{
	
	
/** Draw content to a MovieClip for a {@link com.moviemasher.Clip.Video}, {@link com.moviemasher.Clip.Image} or {@link com.moviemasher.Clip.Theme} object.
Override passes parameters to transition symbol, loading from swf file if needed. 
@param key String index for applyTransform, applyFilter, applyMask and applyMatrix objects.
@param values Object with {@link com.moviemasher.Clip.Clip} specific values.
@param leftclip {@link com.moviemasher.Clip.Clip} that precedes transition.
@param rightclip {@link com.moviemasher.Clip.Clip} that follows transition.
@param mc MovieClip that can drawn to (drawing should be centered at origin).
@param done Number from zero to one indicating time relative to clip duration.
@param size Object with 'width' and 'height' keys matching {@link com.moviemasher.Core.Mash} dimensions.
@return Object with 'loading' and 'changed' Boolean keys indicating apply status.
Loading will be true if swf is still loading, or the symbol is loading additional files.
*/
	function applyTransition(key : String, values: Object, leftclip : com.moviemasher.Clip.Clip, rightclip : com.moviemasher.Clip.Clip, mc : MovieClip, done : Number, size: Object) : Object  
	{
		var apply_status = {loading: false, changed: false};
		width = size.width;
		height = size.height;
		var mc : MovieClip;
		var url = getValue('url');
		if (url.length) 
		{
			if (! __swf_mc)
			{
				mc = com.moviemasher.Manager.LoadManager.swfLoaded(url);
				if (mc == undefined)
				{
					if (__swf_mc == undefined)
					{
						__swf_mc = false;
						com.moviemasher.Manager.LoadManager.swf(url);
					}
				}
				else __swfDidLoad(mc);
			}
			if (__swf_mc) apply_status = __swf_mc.applyTransition(key, values, leftclip, rightclip, mc, done, size);
			else apply_status.loading = true;
		}
		return apply_status;
	}


// PRIVATE INSTANCE PROPERTIES

	private var __swf_mc; 
	
	
// PRIVATE INSTANCE METHODS
	
	private function Transition()
	{
	}
	
	private function __swfDidLoad(mc : MovieClip)
	{
		//_global.com.moviemasher.Control.Debug.msg('Transition.__swfDidLoad');
		var clip_name = 'media_' + getValue('id');
		if (! mc[clip_name]) mc.attachMovie(getValue('symbol'), clip_name, mc.getNextHighestDepth(), {media: this, config: config});
		if (typeof(mc[clip_name].applyTransition) == 'function') __swf_mc = mc[clip_name];
		else mc[clip_name].removeMovieClip();
	}
	
	
}
