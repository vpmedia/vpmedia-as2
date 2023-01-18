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



import flash.display.BitmapData;
import flash.geom.Matrix;
/** MovieClip symbol manages loading of font files. 
*/

class com.moviemasher.Manager.FontManager extends MovieClip
{


// PUBLIC CLASS METHODS

	
	// called by _global.app as option tags with type = 'font' encountered
	static function addOption(option)
	{
		if (option.id == undefined) option.id = com.meychi.MD5.newID();
		var safe_key = _global.com.moviemasher.Utility.StringUtility.safeKey(option.id);
		if (__instances[safe_key] == undefined) 
		{
			__instances[safe_key] = {waiting: [], hasLoaded: false, hasRequested: false};
			if (__fonts == undefined) __fonts = [];
			__fonts.addItem(__instances[safe_key]);
		}
		com.moviemasher.Utility.ObjectUtility.copy(option, __instances[safe_key]);
		
		if ((__defaultFont == undefined) || (__instances[safe_key].id == 'default'))
		{
			__defaultFont = __instances[safe_key];
		}
	}

	static function fontFromID(font_id) : Object
	{
		var font_ob = undefined;		
		if (font_id == 'default') font_ob = __defaultFont;
		else
		{
			var font_index = com.moviemasher.Utility.ArrayUtility.indexOf(__fonts, font_id, 'id');
			if (! _global.com.moviemasher.Control.Debug.isFalse(font_index != -1,  "Font ID '" + font_id + "' not found"))
			{
				font_ob = __fonts[font_index];
			}
			else font_ob = __defaultFont;
		}
		return font_ob;
	}
	
	static function requestFont(font_id, call_back)
	{
		var font_ob = fontFromID(font_id);
		if (font_ob && (! font_ob.hasLoaded))
		{
			if (call_back) font_ob.waiting.push(call_back);
			if (! font_ob.hasRequested)
			{
				font_ob.hasRequested = true;
				__loadingFonts.push(font_ob);
				if (! (__loadingInterval || __requesting)) __loadingInterval = setInterval(__instance, '__intervalLoad', 250);	
			}
		}
		return font_ob;
	}

	
	
	
	static function text2Bitmap(text : String, config : Object) : BitmapData
	{
		var font_ob : Object = fontFromID(config.font);
		var tf = textFormat(config.font, config);
		
		var clip_name = 'id_';
		
		if (tf.embedFonts) 
		{
			clip_name += font_ob.id;
			tf.font = font_ob.font;
		}
		if (config.textsize) tf.size = config.textsize;
		if (config.textcolor != undefined) tf.color = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.textcolor);
		
		
		var field_mc = __instance.__fields_mc[clip_name];
		if (! field_mc)
		{
			__instance.__fields_mc.createEmptyMovieClip(clip_name, __instance.__fields_mc.getNextHighestDepth());
			field_mc = __instance.__fields_mc[clip_name];
			field_mc.createTextField('field_mc', field_mc.getNextHighestDepth(), -2, -2, 100, 100);
			field_mc.field_mc.autoSize = 'left';
		}
		
		
		var bm : BitmapData = undefined;
		
		if ((font_ob == undefined) || font_ob.hasLoaded)
		{
			var back_color;
			if (config.backcolor != undefined) back_color = com.moviemasher.Utility.DrawUtility.hexColor(config.backcolor, 'FF')
			else back_color = 0x00000000;
			
			field_mc.field_mc.embedFonts = tf.embedFonts;
			
			
			var ob = tf.getTextExtent(text);
			//_global.com.moviemasher.Control.Debug.msg(ob.textFieldHeight + ' ?= ' + ob.height + ' ?= '+ ob.ascent + ' + ' + ob.descent);
			field_mc.field_mc.setNewTextFormat(tf);
			
			field_mc.field_mc.text = text;
			var bm_w = field_mc._width;//field_mc.textWidth;
			var bm_h = field_mc._height;//field_mc.textHeight;
			
			if (config.width)
			{
				bm_w = config.width;
			//	_global.com.moviemasher.Control.Debug.msg('width ' + field_mc._width + ' ?= ' + config.width + ' ' + text);
				field_mc.field_mc._xscale = 100 * (config.width / field_mc._width);
				if (! config.height)
				{
					field_mc.field_mc._yscale = field_mc.field_mc._xscale;
				}
			}
			if (config.height && (! config.textsize))
			{
				bm_h = config.height;
			//	_global.com.moviemasher.Control.Debug.msg('height ' + field_mc._height + ' ?= ' + config.height + ' ' + text);
				field_mc.field_mc._yscale = 100 * (config.height / ob.height);
				field_mc._height = config.height;
				if (! config.width) 
				{
					field_mc.field_mc._xscale = field_mc.field_mc._yscale;
					bm_w = field_mc._width;
				}
				
			}
			bm = new BitmapData(bm_w, bm_h, true, back_color);
			bm.draw(field_mc);
			field_mc.field_mc._xscale = field_mc.field_mc._yscale = 100;
		}
		return bm;
	}
	
	
	static function textFormat(font_id : String, config : Object, size : Object) : TextFormat
	{
		var font_ob : Object = undefined;
		var tf = new TextFormat();
		
		var clip_name = 'id_';
		
		tf.embedFonts = Boolean(font_id.length && (font_ob = __preloadedFont(font_id)));
		if (tf.embedFonts) tf.font = font_ob.font;
		
		if ((size != undefined) && config.textsize) 
		{
			var ts = config.textsize;
			if (size != undefined)
			{
				ts = (size.height * ts) / 240;
			}
			tf.size = ts;
		}
		if (config.textcolor != undefined) tf.color = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.textcolor);
		if (config.textalign != undefined) tf.align = config.textalign;
		
		return tf;
	}

// PUBLIC INSTANCE METHODS	

// called from font swfs
	function fontLoaded(font_ob) : Void
	{
		
		font_ob.hasLoaded = true;
		var z = font_ob.waiting.length;
		for (var i = 0; i < z; i++)
		{
			font_ob.waiting[i].back(font_ob);
		}
		font_ob.waiting = undefined;
		__startLoad();
	
	}


// PRIVATE CLASS PROPERTIES

	private static var __fonts : Array;
	private static var __instance : FontManager;
	private static var __instances : Object = {}; // avoids duplicate objects for same IDs
	private static var __loadingFonts = [];
	private static var __loadingInterval = 0;
	private static var __requesting : Boolean = false;




// PRIVATE CLASS METHODS

	private static function __preloadedFont(font_id) // will return font object if loaded, call requestFont to actually load
	{
		var font_ob = fontFromID(font_id);
		if (font_ob && (! font_ob.hasLoaded))
		{
			font_ob = undefined;
		}
		return font_ob;
	}
	

// PRIVATE INSTANCE PROPERTIES

	private var __fields_mc : TextField;
	private static var __defaultFont : Object;
	
// PRIVATE INSTANCE METHODS

	private function FontManager()
	{
		__instance = this;
		_visible = false;
		createEmptyMovieClip('__fields_mc', getNextHighestDepth());
	}
	
	private function __intervalLoad()
	{
		if (__loadingInterval)
		{
			clearInterval(__loadingInterval);
			__loadingInterval = 0;
		}
		__startLoad();
	}
	
	private function __startLoad()
	{
		__requesting = Boolean(__loadingFonts.length);		
		if (__requesting)
		{
			var font_ob = __loadingFonts.shift();
			var clip_name = font_ob.id + '_mc';
			createEmptyMovieClip(clip_name, getNextHighestDepth());
			this[clip_name].mmFont = font_ob;
			this[clip_name].createEmptyMovieClip('mc', 1);
			var url = _global.app.basedURL(font_ob.url);
			
			//_global.app.msg('font = ' + url + ' ' + font_ob.url);
			System.security.allowDomain(url);
					
			this[clip_name].mc.loadMovie(url, 0);
		}
	}

}