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


import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.BitmapData;

/** Slider control symbol displays playhead position, relative to {@link com.moviemasher.Control.Timeline} control.

*/

class com.moviemasher.Control.Ruler extends com.moviemasher.Control.ControlSlider
{

	
	function createChildren() : Void
	{
		super.createChildren();
		if (config.ruleicon.length) __createIcon(__btns_mc, 'ruleicon_mc', config.ruleicon);
		if (config.ruleovericon.length) __createIcon(__btns_mc, 'ruleovericon_mc', config.ruleovericon, true);
		
	}
	function initSize() : Void
	{
		if (! config[(config.horizontal ? 'width' : 'height')]) config[(config.horizontal ? 'width' : 'height')] = '*';		
		super.initSize();
	}
		
	
	function propertyChange(event : Object) : Void
	{
		if (event.target == __targets.location)
		{
			switch (event.property)
			{
				case 'hscroll':
				case 'zoom':
				{
					event = {target: event.target, property: 'location', value: __targets.location.mash.getValue('location')};
					break;
				}
			}
		}
		super.propertyChange(event);
	}
	

	function propertyRedefined(event)
	{
		if (event.target == __targets.location)
		{
			switch (event.property)
			{
				case 'clipmode':
				case 'timemode':
				{
					__slidePercent = __value2Percent(__targets.location.mash.getValue('location'));
					__height = 0;
					panel.delayedDraw();
					break;
				}
			}
		}
		super.propertyRedefined(event);
	}

	function size() : Void
	{
		__resizing = true;
		super.size();
		__resizing = false;
		var h = __targets.location.config.height;
		h += __targets.location.config.y - config.y;
		if (config.ruleicon.length) 
		{
			__clipBitmap(__btns_mc.ruleicon_mc, config.ruleicon, 0, 0);
			__clipBitmap(__btns_mc.ruleicon_mc, config.ruleicon, __btns_mc.ruleicon_mc._width, h);
		}
		if (config.ruleovericon.length) 
		{
			__clipBitmap(__btns_mc.ruleovericon_mc, config.ruleovericon, 0, 0);
			__clipBitmap(__btns_mc.ruleovericon_mc, config.ruleovericon, __btns_mc.ruleovericon_mc._width, h);
		}
	}

// PRIVATE INSTANCE PROPERTIES

	private var __resizing : Boolean = false;

// PRIVATE INSTANCE METHODS

	private function Ruler()
	{			
		if (config.attributes == undefined) config.attributes = 'timeline.location';
		__centerIcon = true;
		__canDisable = true; // so i don't get hidden but do get propertyRedefined events
	}
	private function __percent2Value(percent)
	{
		var value = ((config.width * percent) / 100);
		value += __targets.location.hScroll;
		value += (config.x - __targets.location.viewX);
		value = __targets.location.pixels2Time(value);
		
		return Math.min(__targets.location.mash.length - _global.app.options.frametime, value);
	}
	

	private function __roll(tf : Boolean, prefix : String) //: Boolean
	{
		super.__roll(tf, prefix);
		if (prefix == undefined) super.__roll(tf, 'rule');
		
	}
	
	private function __setSlide(percent : Number)
	{
		if (_global.com.moviemasher.Control.Debug.isFalse(! isNaN(percent), '__setSlide percent = ' + percent)) return;
		
		var per = __value2Percent(__percent2Value(percent));
		if (__resizing || (per != __slidePercent))
		{
			super.__setSlide(per); 
			__syncRuler();
		}
	}

	
	private function __syncRuler()
	{
		if (config.ruleicon.length) 
		{
			if (__btns_mc.ruleicon_mc._visible = __btns_mc.icon_mc._visible)
			{
				__btns_mc.ruleicon_mc._x = __btns_mc.icon_mc._x + Math.floor((__btns_mc.icon_mc._width - __btns_mc.ruleicon_mc._width) / 2);
			}
		}
		if (config.ruleovericon.length) 
		{
			__btns_mc.ruleovericon_mc._visible = __btns_mc.overicon_mc._visible;
			__btns_mc.ruleovericon_mc._x = __btns_mc.overicon_mc._x + Math.floor((__btns_mc.overicon_mc._width - __btns_mc.ruleovericon_mc._width) / 2);
		}
	}
	
	private function __update(prefix : String)
	{
		super.__update(prefix);
		__syncRuler();
		
	}
	
	private function __value2Percent(location)
	{
				
		var percent = __targets.location.time2Pixels(location);
		percent -= __targets.location.hScroll;
		percent -= (config.x - __targets.location.viewX);
		percent = (percent / config.width) * 100;
		
		return percent;
	}
	
		
	
}



