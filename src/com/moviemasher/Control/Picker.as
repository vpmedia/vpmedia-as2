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

/** Control symbol allows a color to be chosen from a supplied graphic.
*/
class com.moviemasher.Control.Picker extends com.moviemasher.Control.Control
{

	function createChildren() : Void
	{	
		__createBitmapClip();
		createEmptyMovieClip('__chip_mc', getNextHighestDepth());
		__chip_mc.owner = this;
		createEmptyMovieClip('__bm_bevel_mc', getNextHighestDepth());
		if (! config[(config.horizontal ? 'width' : 'height')]) __makeFlexible(config.horizontal);		
	}

	
	function propertyChange(event : Object) : Void
	{
		if (__targets[event.property] == event.target)
		{
			if (! (__indeterminateValue = (event.value == undefined))) __value = event.value;
			__updateInterface();
		}
	}
	
	function size() : Void
	{
		if (! (width && height)) return;
		var icon_size = height;	
		__chipSize = height - 2;	
		__colorWidth = width - (icon_size + 2 + config.spacing);
		__bm_bevel_mc._x = icon_size + config.spacing;
		__bevelClip(__bm_bevel_mc, 0, 0, width - (icon_size + config.spacing), icon_size);
		__drawColors();
		__bm_mc._x = __bm_bevel_mc._x + 1;
		__bm_mc._y = __bm_bevel_mc._y + 1;
		__chip_mc.clear();
		__updateInterface();		
	}
	

// PRIVATE INSTANCE PROPERTIES

	private var __bm : BitmapData;
	private var __bm_bevel_mc : MovieClip;
	private var __bm_mc : MovieClip;
	private var __chip_mc : MovieClip;
	private var __chipSize : Number;
	private var __colorWidth : Number;
	private var __indeterminateValue : Boolean = false;
	private var __requestedBitmap : Boolean = false;
	private var __value : String;
	
// PRIVATE INSTANCE METHODS

	
	private function Picker()
	{
	
		if (config.spacing == undefined) config.spacing = 0;
		if (config.value == undefined) config.value = '000000';
		__value = config.value;
		
	}
	
	private function __bevelClip(clip, x, y, w, h, concave, depth) : Void
	{
		if (depth == undefined) depth = 1;
		var up_color = (concave ? 0x000000 : 0xFFFFFF);
		var down_color =  (concave ? 0xFFFFFF : 0x000000);
		
		_global.com.moviemasher.Utility.DrawUtility.plot(clip, x, y, w, depth, up_color, 50);
		_global.com.moviemasher.Utility.DrawUtility.plot(clip, x, y + depth, depth, h - depth, up_color, 50);
	
		_global.com.moviemasher.Utility.DrawUtility.plot(clip, x + w - depth, y + depth, depth, h - depth, down_color, 50);
		_global.com.moviemasher.Utility.DrawUtility.plot(clip, x + depth, y + h - depth, w - (depth * 2), depth, down_color, 50);
	
	}
	
	
	private function __createBitmapClip()
	{
		createEmptyMovieClip('__bm_mc', getNextHighestDepth());
		__bm_mc.owner = this;
		__bm_mc.onPress = function() { this.owner.__press(); };
		__bm_mc.onReleaseOutside = __bm_mc.onRelease = function() { this.owner.__release(); };
		__bm_mc.useHandCursor = false;
	}
	
	private function __drawColors() : Void
	{
		__bm = _global.com.moviemasher.Manager.LoadManager.cachedBitmap(config.back, __colorWidth, __chipSize);
		if ((! __bm) && (! __requestedBitmap))
		{
			__requestedBitmap = true;
			_global.com.moviemasher.Manager.LoadManager.cacheBitmap(config.back, _global.com.moviemasher.Core.Callback.factory('__drawColors', this));
		}
		if (__bm) __bm_mc.attachBitmap(__bm, 100);
	}
	
	private function __mouseMove()
	{
		var new_value = '';
		var val;
		if (__bm_mc.hitTest(_root._xmouse, _root._ymouse))
		{
			if (__bm)
			{
				new_value = __bm.getPixel(__bm_mc._xmouse, __bm_mc._ymouse);
				new_value = _global.com.moviemasher.Utility.DrawUtility.hex2RGB(new_value);
				new_value = _global.com.moviemasher.Utility.DrawUtility.getHexStr(new_value.r, new_value.g, new_value.b);
			}
		}
		if (new_value.length) 
		{
			__value = new_value;
			dispatchEvent({type: 'propertyChanging', property: __property, value: __value});
			__updateInterface();
		}
	}
	private function __press() : Void
	{
		__bm_mc.onMouseMove = function() { this.owner.__mouseMove(); };
		__mouseMove();
	}
	
	private function __release() : Void
	{
		dispatchEvent({type: 'propertyChanged', property: __property, value: __value});
		__bm_mc.onMouseMove = undefined;
	}
	
	private function __updateInterface() : Void
	{
		if (__chip_mc._visible = (! __indeterminateValue))
		{
			__chip_mc.clear();
			_global.com.moviemasher.Utility.DrawUtility.plot(__chip_mc, 1, 1, __chipSize, __chipSize, _global.com.moviemasher.Utility.DrawUtility.hexColor(__value));
			var icon_size = height;	
			__bevelClip(__chip_mc, 0, 0, icon_size, icon_size, true);
		}
	}
	
}