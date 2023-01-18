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



/** Control symbol provides simple debug message functionality.

*/
class com.moviemasher.Control.Debug extends com.moviemasher.Control.Control
{
	
// PUBLIC CLASS METHODS

/** Reverse assertion function displays debug message if condition is false.
Call this function as _global.com.moviemasher.Control.Debug.isFalse so this class
isn't compiled into your SWF. 
@param condition Boolean expression that should evaluate to false.
@param error String containing failure message.
@return Boolean true if supplied condition expression is false.
*/
	static function isFalse(condition : Boolean, error : String) : Boolean
	{
		if (! condition) msg('Failure: ' + error);
		return ! condition;
	}
	
/** Display a debug message.
@param error String containing message.
*/
	static function msg(debug_message : String) : Void
	{
		__instance.__field_mc.text = debug_message + newline + __instance.__field_mc.text;
		
		//if (__debugMsgs.addItemAt) __debugMsgs.addItemAt(0, {label: debug_message});
	//	else __debugMsgs.unshift({label: debug_message});
	}

// PUBLIC INSTANCE METHODS

	function createChildren() : Void
	{
		createTextField('__field_mc', getNextHighestDepth(), 0, 0, 100, 100);
		__field_mc.multiline=true;
		
		//attachMovie('List', '__field_mc', getNextHighestDepth());
		//__field_mc.dataProvider = __debugMsgs;	
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

	
	function size() : Void
	{
		super.size();
		//_global.com.moviemasher.Control.Debug.msg(className + '.size ' + __width + 'x' + __height);
		__field_mc._width = __width;
		__field_mc._height = __height;
		
		//__field_mc.setSize(__width, __height);
	
	}
	private function __fontDidLoad(font_ob)
	{
		var tf = _global.com.moviemasher.Manager.FontManager.textFormat(font_ob.id, config);
		__field_mc.embedFonts = Boolean(tf.embedFonts);
		
		__field_mc.setNewTextFormat(tf);
		__field_mc.text = 'Ready!';
		if (font_ob != undefined) __didLoad(undefined, 'loadingComplete');
	}
	
	
// PRIVATE INSTANCE PROPERTIES

	private static var __instance : Debug;
	private static var __debugMsgs : Array = [];

	private var __field_mc : TextField;
	
// PRIVATE INSTANCE METHODS

	private function Debug()
	{
		__instance = this;
		if (config.font == undefined) config.font = 'default';
		else config.font = String(config.font);
		if (config.textcolor == undefined) config.textcolor = '333333';
		if (config.textsize == undefined) config.textsize = 12;
		if (config.textbackcolor == undefined) config.textbackcolor = 'FFFFFF';
		if (config.textalign == undefined) config.textalign = 'left';
	}
}