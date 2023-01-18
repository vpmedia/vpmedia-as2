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


/** Slider control symbol with two buttons for editing the trim of {@link com.moviemasher.Clip.Audio}/{@link com.moviemasher.Clip.Video} clips.

*/
class com.moviemasher.Control.Trimmer extends com.moviemasher.Control.ControlSlider
{

	function createChildren() : Void
	{
		// increment so __graphicsDidLoad isn't called
		__loadingThings ++;
		__bindBtn = false; // don't bind
		super.createChildren(); 
		if (config.trimicon.length) __createIcon(__btns_mc, 'trimicon_mc', config.trimicon);
		if (config.trimovericon.length) __createIcon(__btns_mc, 'trimovericon_mc', config.trimovericon, true);
		
		__bindClip(__btns_mc.icon_mc);
		__bindClip(__btns_mc.trimicon_mc);
		
		// decrement and see if __graphicsDidLoad needs calling
		__loadingThings --;
		if (! __loadingThings) __graphicsDidLoad();

	}	
	
	function propertyChange(event : Object) : Void
	{
		if (__targets[event.property] == event.target)
		{
			if (! (__indeterminateValue = (event.value == undefined)))
			{
				__values = event.value.split(',');
				super.__setSlide(100 - __values[1], 0, __btns_mc.trimicon_mc, __btns_mc.trimovericon_mc);
				super.__setSlide(__values[0]);
			}
			else
			{
				super.__setSlide(undefined, 0, __btns_mc.trimicon_mc, __btns_mc.trimovericon_mc);
				super.__setSlide(undefined);
			}
		}
	}

	function size() : Void
	{
		//_global.com.moviemasher.Control.Debug.msg(className + '.size ' );
				
		super.size();
		if (config.trimicon.length) __clipBitmap(__btns_mc.trimicon_mc, config.trimicon);
		if (config.trimovericon.length) __clipBitmap(__btns_mc.trimovericon_mc, config.trimovericon);
		__rollOut(__btns_mc.trimicon_mc);
		if (__property) propertyChange({property: __property, target: __targets[__property], value: String(__values)});
	}
	

// PRIVATE INSTANCE PROPERTIES
	
	private var __indeterminateValue : Boolean = false;
	private var __values : Array;
	
// PRIVATE INSTANCE METHODS
		
	private function Trimmer() 
	{
		if (config.trimicon == undefined) config.trimicon = config.icon;
		if (config.trimovericon == undefined) config.trimovericon = config.overicon;
		if (config.value == undefined) config.value = '0,0';
		__values = config.value.split(',');
		
	}
	
	private function __dragSlide()
	{
		var is_end = (__pressClip == __btns_mc.trimicon_mc);
		var prefix = is_end ? 'trim' : ''
		var percent = Math.max(0, Math.min(100, ((__pressOffset + __btns_mc[__dimName('_', 'x', 'mouse')]) * 100) /  __slideWidth));
	
		if (is_end) percent = Math.max(percent, __values[0] + 1);
		else percent =  Math.min(percent, (100 - __values[1]) - 1);
	
		if (percent != __slidePercent)
		{
			__setSlide(percent);
			__update(prefix);
		}		
		__values[is_end ? 1 : 0] = __percent2Value(__slidePercent, is_end);
		//_global.com.moviemasher.Control.Debug.msg('Trimmer ' + String(__values));
		dispatchEvent({type: 'propertyChanging', property: __property, value: String(__values)});
	}
	
	private function __percent2Value(percent, is_end)
	{
		if (is_end) percent = 100 - percent;
		return percent;
	}
	
	private function __release(mc : MovieClip)
	{
		var is_end = (__pressClip == __btns_mc.trimicon_mc);
		onMouseMove = undefined;
		__pressClip = undefined;
		__values[is_end ? 1 : 0] = __percent2Value(__slidePercent, is_end);
		dispatchEvent({type: 'propertyChanged', property: __property, value: String(__values)});
	}
	
	private function __releaseOutside(mc : MovieClip)
	{
		var is_end = (__pressClip == __btns_mc.trimicon_mc);
		onMouseMove = undefined;
		__pressClip = undefined;
		__values[is_end ? 1 : 0] = __percent2Value(__slidePercent, is_end);
		dispatchEvent({type: 'propertyChanged', property: __property, value: String(__values)});
	}
	private function __rollOut(mc : MovieClip)
	{
		var prefix = '';
		if (mc == __btns_mc.trimicon_mc) prefix = 'trim';
		__roll(selected, prefix);
	}
	
	private function __rollOver(mc : MovieClip)
	{
		if (_global.app.dragging) return;
		var prefix = '';
		var not_prefix = '';
		if (mc == __btns_mc.trimicon_mc) prefix = 'trim';
		else not_prefix = 'trim';
		__roll(! selected, prefix);
		__roll(selected, not_prefix);
	}
	

	private function __setSlide(percent, btn_size, mc, over_mc)
	{
		//_global.com.moviemasher.Control.Debug.msg('Trimmer.__setSlide ' + percent + ' ' + mc);
		
		if ((mc == undefined) && __pressClip) 
		{
			mc = __pressClip;
			over_mc = ((mc == __btns_mc.trimicon_mc) ? __btns_mc.trimovericon_mc : __btns_mc.overicon_mc);
		}
		super.__setSlide(percent, btn_size, mc, over_mc);
	}

	private function __value2Percent(value : Number, is_end) 
	{
		if (is_end) value = 100 - value;
		return value;
	}
	
}