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
/** Abstract base class for all panel based controls.
*/
class com.moviemasher.Control.ControlPanel extends com.moviemasher.Control.ControlIcon
{
	

	function get hScroll() : Number { return __hScroll;}
	function set hScroll(n : Number)
	{
		__hScroll = n;
		if (__watchedProperties.hscroll) dispatchEvent({type: 'propertyChange', property: 'hscroll', size: __contentSize.hsize, value: (__hScroll * 100) / __contentSize.width});
	}
	
	
	function createChildren() : Void
	{
		// BACK (for deselection)
		createEmptyMovieClip('__click_mc', getNextHighestDepth()); 
		__click_mc.onPress = function() 
		{
			_parent.selectedItems = [];
		}
		__click_mc.useHandCursor = false;
		
		// CLIPS CONTAINER
		createEmptyMovieClip('__items_mc', getNextHighestDepth());
		__items_mc.createEmptyMovieClip('__clips_mc', __items_mc.getNextHighestDepth());
		__items_mc.createEmptyMovieClip('mask_mc', __items_mc.getNextHighestDepth());
		__clips_mc = __items_mc.__clips_mc;
		__clips_mc.setMask(__items_mc.mask_mc);
	}
	
	function size() : Void
	{
		//_global.com.moviemasher.Control.Debug.msg(className + '.size ' + width + ' x ' + height);
		super.size();
		__items_mc.mask_mc.clear();
		_global.com.moviemasher.Utility.DrawUtility.fill(__items_mc.mask_mc, config.width, config.height, 0, 0);
		
	}
	

// PRIVATE INSTANCE PROPERTIES

	private var __clips_mc : MovieClip;
	private var __click_mc : MovieClip;
	private var __contentSize : Object;
	private var __createdClips : Object;
 	private var __drawContinuously : Boolean = false;
	private var __drawIndex : Number;
	private var __drawInterval : Number = 0;
	private var __hScroll : Number = 0;
	private var __intervalDrawing : Boolean = false;
	private var __items_mc : MovieClip;
	private var __scrollsNeeded : Object;
	

	private function ControlPanel() 
	{ 
		__scrollsNeeded = {};
		__createdClips = {};
	}
	
// PRIVATE INSTANCE METHODS

	private function __intervalDraw() : Void
	{
		//_global.app.msg('__intervalDraw ' + _name);
		if (__intervalDrawing) return;
		__intervalDrawing = true;
		var couldnt_draw : Boolean = false;
		if (__shouldDraw())
		{
			var d = new Date();
			var stop_time = d.getTime() + _global.app.options.frameticks;
			var total_visible = _global.com.moviemasher.Utility.ObjectUtility.keys(__createdClips).length;
			var counter = total_visible;
			for (var k in __createdClips)
			{
				counter --;
				if (counter >= __drawIndex) continue;
				
				if (__createdClips[k].drawPreview()) couldnt_draw = true;
				if (! couldnt_draw) __drawIndex --;
			//	if (couldnt_draw) break;
				
				d = new Date();
				//if (couldnt_draw) _global.app.msg(d.getTime() + " Couldn't draw " + __createdClips[k]._name);
				if (d.getTime() > stop_time) 
				{
					couldnt_draw = true;
					break;
				}
			}
			if (! __drawIndex) __drawIndex = total_visible;
			
			if (! (couldnt_draw || __drawContinuously)) 
			{
			//	_global.app.msg('__stopDrawing ' + _name);
				__stopDrawing();
			}
		}
		__intervalDrawing = false;
		
	}
	
	private function __itemsBitmap(items : Array) : BitmapData
	{
		var bm = new BitmapData(config.width, config.height, true, 0x00000000);
		for (var k in __createdClips)
		{
			if (__createdClips[k]._visible = (_global.com.moviemasher.Utility.ArrayUtility.indexOf(items, __createdClips[k].item) > -1))
			{
				__createdClips[k]._alpha = 50;
			}
		}
		bm.draw(__items_mc);
		for (var k in __createdClips)
		{
			if (! __createdClips[k]._visible)
			{
				__createdClips[k]._visible = true;
				
			}
			else __createdClips[k]._alpha = 100;
		}
		return bm;
	}
	

	private function __shouldDraw() : Boolean
	{
		return true;
	}

	private function __startDrawing(ticks : Number)
	{
		if (__drawIndex = _global.com.moviemasher.Utility.ObjectUtility.keys(__createdClips).length)
		{
			if (ticks == undefined) ticks = _global.app.options.frameticks;
		//	_global.com.moviemasher.Control.Debug.msg('__startDrawing ' +  + config.id + ' ' + ticks);
			if (! __drawInterval) __drawInterval = setInterval(this, '__intervalDraw', ticks);
		}
	}
	
	private function __stopDrawing()
	{
		if (__drawInterval)
		{
			//_global.com.moviemasher.Control.Debug.msg('__stopDrawing ' + config.id);
			clearInterval(__drawInterval);
			__drawInterval = 0;	
		}
	}
}