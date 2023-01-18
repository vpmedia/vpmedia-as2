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



/** Abstract base class for all slider based controls.
*/
class com.moviemasher.Control.ControlSlider extends com.moviemasher.Control.ControlIcon
{

// PUBLIC INSTANCE METHODS
	
	function createChildren() : Void
	{
		createEmptyMovieClip('__btns_mc', getNextHighestDepth());
		if (config.back.length) __createIcon(__btns_mc, 'back_mc', config.back);
		if (config.reveal.length) 
		{
			__createIcon(__btns_mc, 'reveal_mc', config.reveal);
			__btns_mc.createEmptyMovieClip('reveal_mask_mc', __btns_mc.getNextHighestDepth());
			__btns_mc.reveal_mc.setMask(__btns_mc.reveal_mask_mc);
		}
		super.createChildren();
	}
	
	function initSize() : Void
	{
		super.initSize(true); // true indicates icon not involved in sizing
		if (config.back.length) 
		{
			var dim_name = __dimName('', 'width');
			__clipBitmap(__btns_mc.back_mc, config.back);
			if (! config[dim_name]) config[dim_name] = __btns_mc.back_mc[__dimName('_', 'width')];
		}
	}

	function size() : Void
	{
		var w_prop = __dimName('', 'width');
		var h_prop = __dimName('', 'height');
		
		var slide_width = (__slideSize ? Math.max(config[h_prop], Math.round((config[w_prop] * __slideSize) / 100)) : 0);
		__iconSize[w_prop] = slide_width;
		
		super.size();
		
		var _w_prop = __dimName('_', 'width');
		__iconSize[w_prop] = config[w_prop];
	
		if (config.back.length) __clipBitmap(__btns_mc.back_mc, config.back);
		if (config.reveal.length) __clipBitmap(__btns_mc.reveal_mc, config.reveal);
		
		
		__iconSize[w_prop] = slide_width;
		if (! isNaN(config[w_prop]))
		{
			__slideWidth = config[w_prop];
			if (( ! __centerIcon) && __btns_mc.icon_mc[_w_prop]) __slideWidth -= __btns_mc.icon_mc[_w_prop];
			__setSlide(__slidePercent, __slideSize);
		}
		
	}

	
	// one of my targets has changed a property
	function propertyChange(event : Object) : Void
	{
		
		if (__targets[event.property] == event.target)
		{
			switch(event.property)
			{
				case 'mask':
				{
					if (! __dontReveal) __dontReveal = true;
					
					if (__btns_mc.reveal_mask_mc)
					{
						var z : Number = event.value.length;
						var loaded_time : Object;
						var total_size = event.total;
						var x : Number, y : Number, w : Number, h : Number;
					
						var x_pos : Number;
						var w_pos : Number;
						var total_pixels = config[__dimName('', 'width')];
						__btns_mc.reveal_mask_mc.clear();
						_global.com.moviemasher.Utility.DrawUtility.setFill(__btns_mc.reveal_mask_mc, 0);
						for (var i = 0; i < z; i++)
						{
							loaded_time = event.value[i];
							x_pos = ((total_pixels * loaded_time.start) / total_size);
							w_pos = ((total_pixels * loaded_time.duration) / total_size);
							
							
							x = (config.horizontal ? x_pos : 0);
							y = (config.horizontal ? 0 : x_pos);
							w = (config.horizontal ? w_pos : config.width);
							h = (config.horizontal ? config.height : w_pos);
							_global.com.moviemasher.Utility.DrawUtility.drawFill(__btns_mc.reveal_mask_mc, _global.com.moviemasher.Utility.DrawUtility.points(x, y, w, h), true);
						}
					}
					break;
				}
				default: __setSlide(__value2Percent(event.value), event.size);
			}
		}
	}
	
	

// PRIVATE INSTANCE PROPERTIES

	private var __centerIcon : Boolean = false;
	private var __dontReveal : Boolean = false;
	private var __pressClip : MovieClip;
	private var __pressOffset : Number;
	private var __revealPercent : Number = -1;
	private var __slidePercent : Number = -1;
	private var __slideSize : Number = 0;
	private var __slideWidth : Number = 0;


// PRIVATE INSTANCE METHODS
		
	private function ControlSlider()
	{
		if (config.min == undefined) config.min = 0;
		if (config.max == undefined) config.max = 100;
		
		// is this actually used anywhere ????
		if (config.value == undefined) config.value = 50; 
				
	}
	private function __dragSlide(prefix : String)
	{
		if (prefix == undefined) prefix = '';
		
		var percent = Math.max(0, Math.min(100, ((__pressOffset + __btns_mc[__dimName('_', 'x', 'mouse')]) * 100) /  __slideWidth));
		if (percent != __slidePercent)
		{
			__setSlide(percent, __slideSize);
			__update(prefix);
			dispatchEvent({type: 'propertyChanging', property: __property, value: __percent2Value(__slidePercent)});
		}
	}

	private function __percent2Value(percent)
	{
		var value = config.min + ((percent * (config.max - config.min)) / 100);
		if (isNaN(value)) value = 0;
		return value;
	}
	

	private function __press(mc : MovieClip)
	{
		if (! __enabled) return;
		
		if (config.back.length)
		{
			__pressClip = ((mc == __btns_mc) ? __btns_mc.icon_mc : mc);
			var press_width = __pressClip[__dimName('_', 'width')] / 2;
			
			__pressOffset = 0;
			if (! __centerIcon) __pressOffset -= press_width;
			if (__pressClip.hitTest(_root._xmouse, _root._ymouse, true))
			{
				__pressOffset += press_width - __pressClip[__dimName('_', 'x', 'mouse')];
			}
			onMouseMove = __dragSlide;
			__dragSlide();
		}
	}
	
	private function __release(mc : MovieClip)
	{
		if (! __enabled) return;
		//super.__release(mc);
		onMouseMove = undefined;
		__pressClip = undefined;
		
		dispatchEvent({type: 'propertyChanged', property: __property, value: __percent2Value(__slidePercent)});
	}
	
	private function __releaseOutside(mc : MovieClip)
	{
		if (! __enabled) return;
		super.__releaseOutside(mc)
		onMouseMove = undefined;
		__pressClip = undefined;
		dispatchEvent({type: 'propertyChanged', property: __property, value: __percent2Value(__slidePercent)});
	}	

	private function __setReveal(percent)
	{
		if (percent == undefined) percent = 0;
		__revealPercent = percent;
		
		if (__width && (__width != '*'))
		{
		
			var x_pos = ((__slideWidth * percent) / 100) + ((__centerIcon ? 0 : __btns_mc.icon_mc[__dimName('_', 'width')]) / 2);
			x_pos = Math.round(x_pos);
			__btns_mc.reveal_mask_mc.clear();
			var w = (config.horizontal ? x_pos : width);
			var h = (config.horizontal ? height : x_pos);
			
			_global.com.moviemasher.Utility.DrawUtility.fill(__btns_mc.reveal_mask_mc, w, h, 0x000000);
		}
	
	}
	private function __setSlide(percent : Number, btn_size : Number, mc : MovieClip, over_mc : MovieClip)
	{
		
		if (btn_size == undefined) btn_size = 0;
		if (__slideSize != btn_size)
		{
			__slideSize = btn_size;
			size();
		}
		if (mc == undefined) mc = __btns_mc.icon_mc;
		if ((over_mc == undefined) && (config.overicon.length)) over_mc = __btns_mc.overicon_mc;
		if (percent == undefined)
		{
			if (over_mc) over_mc._visible = false;
			mc._visible = false;
		}
		else
		{
			if ((percent >= 0) && (percent <= 100))
			{
				var x_prop = __dimName('_', 'x');
				var w_prop = __dimName('_', 'width');
				if (__slideWidth)
				{
					var x_pos = ((__slideWidth * percent) / 100);
					if (__centerIcon && mc[w_prop]) x_pos -= mc[w_prop] / 2;
					x_pos = Math.ceil(x_pos);
					//_global.com.moviemasher.Control.Debug.msg(x_pos);
					if (over_mc) over_mc[x_prop] = x_pos;
					mc[x_prop] = x_pos;
					if (over_mc) over_mc._visible = (__selected || over_mc.hitTest(_root._xmouse, _root._ymouse));
					mc._visible = true;
				}
			}
			else
			{
				if (over_mc) over_mc._visible = false;
				mc._visible = false;
				percent = Math.min(100, Math.max(0, percent));
			}
		}
		__slidePercent = percent;
		if (config.reveal.length && (! __dontReveal)) __setReveal(percent);
		
	
	}

	private function __value2Percent(value : Number) 
	{
		
		var percent : Number;
		if (value != undefined) 
		{
			percent = ((value - config.min) * 100) / (config.max - config.min);
		}
		if (isNaN(percent)) percent = 0;
		return percent;
	}

}