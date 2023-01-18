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

/** Icon control symbol displays a text label.

*/
class com.moviemasher.Control.Text extends com.moviemasher.Control.ControlIcon
{

	function createChildren() : Void
	{
		super.createChildren();
		
		__btns_mc.createEmptyMovieClip('icon_mc', __btns_mc.getNextHighestDepth(), {_visible: true});
		if (false) __btns_mc.createEmptyMovieClip('overicon_mc', __btns_mc.getNextHighestDepth(), {_visible: false});
		if (false) __btns_mc.createEmptyMovieClip('disovericon_mc', __btns_mc.getNextHighestDepth(), {_visible: false});
	

		var custom_font : Object = _global.com.moviemasher.Manager.FontManager.fontFromID(config.font);
		if (custom_font) 
		{
			if (! custom_font.hasLoaded)
			{
				_global.com.moviemasher.Manager.FontManager.requestFont(config.font, com.moviemasher.Core.Callback.factory('__didLoad', this, 'loadingComplete'))
				__loadingThings++;
			}
			else custom_font = undefined;
		}		
	}
	
	
	function initSize() : Void
	{
		if (config.text.length)
		{
			__drawText(config.text);
			if (! config.width) config.width = __btns_mc._width;
			if (! config.height) config.height = __btns_mc._height;
		}
	}

	
	function propertyChange(event : Object) : Void
	{
		super.propertyChange(event);
		if (__targets[event.property] == event.target)
		{
			__currentValues[event.property] = event.value;
			__drawText(config.text.length ? config.text : (event.value == undefined) ? 'Multiple Values' : (config.pattern.length ? __patternedText(config.pattern) : event.value));
		}
	}

// PRIVATE INSTANCE METHODS

	private var __currentValues : Object;
	
	private function Text()
	{
		__currentValues = {};
		if (config.font == undefined) config.font = 'default';
		if (config.text == undefined) config.text = '';
	}
	private function __drawText(copy : String)
	{
		var bm : BitmapData;
		var orig_width = config.width;
		config.width = 0;
		
		if (bm = com.moviemasher.Manager.FontManager.text2Bitmap(copy, config))
		{
			__btns_mc.icon_mc.attachBitmap(bm, 100);
		}
		config.width = orig_width;
	}
	
	
	function __patternedText(pat)
	{
		var left_brace = pat.indexOf('{');
		var right_brace = 0;
		var s = '';
		var pos = 0;
		var key;
		while (left_brace != -1)
		{
			if (left_brace) s += pat.substr(pos, left_brace - pos);
			right_brace = pat.indexOf('}', left_brace);
			key = pat.substr(left_brace + 1, right_brace - (left_brace + 1));

			s += __currentValues[key];
			pos = right_brace + 1;
			left_brace = pat.indexOf('{', right_brace);
			
		}
		s += pat.substr(pos);
		return s;
	}
	

}