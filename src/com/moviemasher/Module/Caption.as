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

/** Effect module displays multiline text with custom font, color, and size over a semi transparent background color.

*/
class com.moviemasher.Module.Caption extends com.moviemasher.Module.Module
{

	var className = 'Caption';
	
	function applyEffect(key : String, values : Object, mc: MovieClip, done : Number, size: Object) : Object
	{
		var bm_width : Number = size.width;
		var bm_height : Number = size.height;
	
		var apply_status = {loading: false, changed: true};
		var apply_values = {};
		copyValues(apply_values, ['padding','font','textsize','forecolor','backcolor','story'], values, config, __defaults);


		var font_ob : Object = _global.com.moviemasher.Manager.FontManager.fontFromID(apply_values.font);
		if (font_ob) 
		{
			if (! font_ob.hasLoaded)
			{
				_global.com.moviemasher.Manager.FontManager.requestFont(apply_values.font);
				apply_status.loading = 'Font ' + apply_values.font;
			}
		}		
			
		if (! apply_status.loading)
		{		
			var clip_name = 'caption_media_' + config.id;
			
			if (! mc[clip_name]) __createClips(mc, clip_name, bm_width, bm_height);
			var tf = _global.com.moviemasher.Manager.FontManager.textFormat(font_ob.id, {textcolor: apply_values.forecolor, textsize: apply_values.textsize}, size);

			
			var t_w = size.width - (apply_values.padding * 2);
			mc[clip_name].field_container_mc.field_mc._width = t_w;
			
			mc[clip_name].field_container_mc.field_mc.setNewTextFormat(tf);
			mc[clip_name].field_container_mc.field_mc.embedFonts = Boolean(tf.embedFonts);
			mc[clip_name].field_container_mc.field_mc.text = apply_values.story;
		
			var b_h = mc[clip_name].field_container_mc.field_mc.textHeight +  apply_values.padding;
			
			
			
			mc[clip_name].back_mc.clear();
			
			_global.com.moviemasher.Utility.DrawUtility.fill(mc[clip_name].back_mc, size.width, b_h, _global.com.moviemasher.Utility.DrawUtility.hexColor(apply_values.backcolor), 50);
		
			
			mc[clip_name]._x = - Math.round(bm_width / 2);
			mc[clip_name]._y = Math.round(bm_height / 2) - b_h;
			//mc[clip_name].field_container_mc._y = 
			mc[clip_name].field_container_mc._x = apply_values.padding;
		
		}
		return apply_status;
	}
	
	private static var __defaults : Object;
 	
	
	private function Caption()
	{		
		if (__defaults == undefined) __defaults = {padding: 10, textsize: 20, forecolor: 'FFFFFF', backcolor: '000000', story: config.label, font: 'default'};
	}	
		
	private function __createClips(mc: MovieClip, clip_name : String, bm_width : Number, bm_height : Number)
	{
		mc.createEmptyMovieClip(clip_name, mc.getNextHighestDepth());
		mc[clip_name].createEmptyMovieClip('back_mc', mc[clip_name].getNextHighestDepth());
		mc[clip_name].createEmptyMovieClip('field_container_mc', mc[clip_name].getNextHighestDepth());
		mc[clip_name].field_container_mc.createTextField('field_mc', mc[clip_name].field_container_mc.getNextHighestDepth(), 0, 0, bm_width, bm_height);
		mc[clip_name].field_container_mc.field_mc.autoSize = 'left';
		mc[clip_name].field_container_mc.field_mc.embedFonts = true;
		mc[clip_name].field_container_mc.field_mc.wordWrap = true;
		mc[clip_name].field_container_mc.field_mc.multiline = true;
		
	
	}
}

