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

/** Effect module displays text with custom font, color, size and alignment.
*/
class com.moviemasher.Module.Title extends com.moviemasher.Module.Module
{

	function applyMedia(key : String, values : Object, mc: MovieClip, done : Number, size: Object) : Object
	{
		var bm_width : Number = size.width;
		var bm_height : Number = size.height;
		var apply_status = {loading: false, changed: false};
		var apply_values = {};
		
		copyValues(apply_values, ['font','textsize','forecolor','text','align'], values, config, __defaults);


		var font_ob : Object = _global.com.moviemasher.Manager.FontManager.fontFromID(apply_values.font);
		if (font_ob) 
		{
			if (! font_ob.hasLoaded)
			{
				_global.com.moviemasher.Manager.FontManager.requestFont(apply_values.font);
				apply_status.loading = true;
			}
		}		
		
		//_global.com.moviemasher.Control.Debug.msg('Title.applyMedia ' + font_ob.id + ' ' + apply_status.loading);
		if (! apply_status.loading)
		{		
			var values_index = 'title_values_'  + config.id;
			if ( (mc[values_index] == undefined) || (! _global.com.moviemasher.Utility.ObjectUtility.equals(apply_values, mc[values_index])))
			{
				apply_status.changed = true;
				mc[values_index] = apply_values;
				
				var clip_name = 'title_media_' + config.id;
				
				if (! mc[clip_name]) __createClips(mc, clip_name, bm_width, bm_height, apply_values.text, font_ob.id, apply_values.forecolor);
			 	

				var tf = _global.com.moviemasher.Manager.FontManager.textFormat(font_ob.id, {textalign: apply_values.align, textcolor: apply_values.forecolor, textsize: apply_values.textsize}, size);
				mc[clip_name].field_container_mc.field_mc.embedFonts = Boolean(tf.embedFonts);

				mc[clip_name].field_container_mc.field_mc.setNewTextFormat(tf);
				mc[clip_name].field_container_mc.field_mc.text = apply_values.text;
						
				var pt = {x: 0, y: 0};
				
				switch (apply_values.align)
				{
					case 'center':
					{
						pt.x -= mc[clip_name].field_container_mc._width / 2;
						pt.y -= mc[clip_name].field_container_mc._height / 2;
						break;	
					}
					case 'right':
					{
						pt.x -= mc[clip_name].field_container_mc._width;
						pt.y -= mc[clip_name].field_container_mc._height;
						break;	
					}
					case 'left':
					{
						break;
					}
				}
				mc[clip_name].field_container_mc._x = pt.x;
				mc[clip_name].field_container_mc._y = pt.y;
			}
			
		}
		return apply_status;
	}
	
	
	function backColor(values : Object) : String
	{
		return copyValue('backcolor', values, config, __defaults);
	}
	
	private static var __defaults : Object;
 	
	private function Title()
	{		
		if (__defaults == undefined) __defaults = {align: 'center', textsize: 48, forecolor: 'FFFFFF', backcolor: '333333', text: config.label, font: 'default'};
	}	
		
	private function __createClips(mc: MovieClip, clip_name : String, bm_width : Number, bm_height : Number) : Void
	{
		mc.createEmptyMovieClip(clip_name, mc.getNextHighestDepth());
		
		mc[clip_name].createEmptyMovieClip('field_container_mc', mc[clip_name].getNextHighestDepth());
		mc[clip_name].field_container_mc.createTextField('field_mc', mc[clip_name].field_container_mc.getNextHighestDepth(), 0, 0, bm_width, bm_height);
		mc[clip_name].field_container_mc.field_mc.autoSize = 'left';
				
	}
	
}

