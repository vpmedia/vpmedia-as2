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


/** Class handles loading and interactions with effect symbol in external swf file. 
*/

class com.moviemasher.Media.Effect extends com.moviemasher.Media.Media
{
	
	
/** Configure a MovieClip so that an {@link com.moviemasher.Clip.Effect} object can apply effects to it.
Override passes parameters to effect symbol, loading from swf file if needed. 
@param key String index for applyTransform, applyFilter, applyMask and applyMatrix objects.
@param values Object with {@link com.moviemasher.Clip.Effect} specific {@link com.moviemasher.Clip.Clip} values.
@param mc MovieClip that can drawn to (drawing should be centered at origin).
@param done Number from zero to one indicating time relative to clip duration.
@param size Object with 'width' and 'height' keys matching {@link com.moviemasher.Core.Mash} dimensions.
@return Object with 'loading' and 'changed' Boolean keys indicating apply status. 
Loading will be true if swf is still loading, or the symbol is loading additional files.
*/
	function applyEffect(key : String, values : Object, mc : MovieClip, done : Number, size: Object) : Object 
	{
		var apply_status = {loading: false, changed: false};
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
						__swf_mc = false;//com.moviemasher.Core.Callback.factory('__swfDidLoad', this)
						com.moviemasher.Manager.LoadManager.swf(url);
					}
				}
				else __swfDidLoad(swf_mc);
			}
			if (__swf_mc) 
			{
				apply_status = __swf_mc.applyEffect(key, values, mc, done, size);
				if (apply_status == undefined)
				{
					
		
					apply_status = {loading: '__swf_mc ' + typeof(__swf_mc) + ' ' + typeof(__swf_mc.applyEffect), changed: false};
				}
			}
			else apply_status.loading = 'Effect ' + url;
		}
		return apply_status;
	}


// PRIVATE INTERFACE
	
	private function Effect()
	{
	}
	
	
	private function __swfDidLoad(mc)
	{
		//_global.com.moviemasher.Control.Debug.msg('Effect.__swfDidLoad');
		var clip_name = 'media_' + getValue('id');
		if (! mc[clip_name]) mc.attachMovie(getValue('symbol'), clip_name, mc.getNextHighestDepth(), {media: this, config: config});
		if (typeof(mc[clip_name].applyEffect) == 'function') __swf_mc = mc[clip_name];
		else mc[clip_name].removeMovieClip();
	}
	
	private var __swf_mc; // holds my display symbol or false while loading
	



			
}