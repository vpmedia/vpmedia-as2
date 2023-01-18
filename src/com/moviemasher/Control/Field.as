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



/** Control symbol allows editing of textual {@link com.moviemasher.Clip.Clip} properties. 
*/
class com.moviemasher.Control.Field extends com.moviemasher.Control.Control
{

	function createChildren() : Void
	{
		createTextField('__field_mc', getNextHighestDepth(), 0, 0, 100, 100);
		__field_mc.addListener(this);
		__field_mc.type = 'input';
		__field_mc.restrict = config.restrict;
		__field_mc.background = true;
		__field_mc.backgroundColor = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.textbackcolor);
		var custom_font : Object = _global.com.moviemasher.Manager.FontManager.fontFromID(config.font);
		if (custom_font) 
		{
			if (! custom_font.hasLoaded)
			{
				_global.com.moviemasher.Manager.FontManager.requestFont(config.font, _global.com.moviemasher.Core.Callback.factory('__fontDidLoad', this))
				__loadingThings++;
			}
			else custom_font = undefined;
		}
		if (! custom_font) __fontDidLoad(); // sending undefined so __didLoad not called
		if (! config[(config.horizontal ? 'width' : 'height')]) __makeFlexible(config.horizontal);		
	}
	
	function onChanged() : Void
	{
		dispatchEvent({type: 'propertyChanged', property: __property, value: __field_mc.text});	
	}

	function propertyChange(event : Object) : Void
	{
		if (__targets[event.property] == event.target)
		{
			__field_mc.text = ((event.value == undefined) ? '' : event.value);
		}
	}
	
	function size() : Void
	{
		__field_mc._width = __width;
		__field_mc._height = __height;
	}


// PRIVATE INSTANCE PROPERTIES

	private var __field_mc : MovieClip;

// PRIVATE INSTANCE METHODS


	private function Field()
	{
		if (config.attributes == undefined) config.attributes = 'timeline.text';
		if (config.font == undefined) config.font = 'default';
		else config.font = String(config.font);
		if (config.textcolor == undefined) config.textcolor = '333333';
		if (config.textsize == undefined) config.textsize = 12;
		if (config.textbackcolor == undefined) config.textbackcolor = 'FFFFFF';
		if (config.textalign == undefined) config.textalign = 'left';
		if (config.multiline == undefined) config.multiline = 0;
		//if (config.restrict == undefined) config.restrict = '';
	}
	
	private function __fontDidLoad(font_ob)
	{
		var tf = _global.com.moviemasher.Manager.FontManager.textFormat(font_ob.id, config);
		__field_mc.embedFonts = Boolean(tf.embedFonts);
		__field_mc.multiline = config.multiline;
		__field_mc.wordWrap = config.multiline;
		__field_mc.editable = true;
		
		__field_mc.setNewTextFormat(tf);
		if (font_ob != undefined) __didLoad(undefined, 'loadingComplete');
	}
}