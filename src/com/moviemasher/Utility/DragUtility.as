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


/** Static class provides drag management.
*/

class com.moviemasher.Utility.DragUtility
{

// PUBLIC CLASS METHODS

	static function addTarget(mc : MovieClip)
	{
		var target_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(__dragTargets, mc);
		if (target_index == -1) __dragTargets.push(mc);
	}
	static function begin(items, data)
	{
	
		if (! _global.app.dragging)
		{
			_global.app.dragging = true;
			__dragData = data;
			__dragData.clickTime = new Date();
			__dragData.dragItems = items;
			__dragData.onMouseMove = function() { com.moviemasher.Utility.DragUtility.__move(); };
			__dragData.onMouseUp = function() { com.moviemasher.Utility.DragUtility.__release(); };
			Mouse.addListener(__dragData);
		}
	}
	static function registerClipParent(mc : MovieClip)
	{
		__clipParent = mc;
	}
	

	static function removeTarget(mc : MovieClip)
	{
		var target_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(__dragTargets, mc);
		if (target_index != -1) __dragTargets.splice(target_index, 1);
	}


// PRIVATE CLASS PROPERTIES

	private static var __clipParent : MovieClip;
	private static var __dragData : Object; // data about the drag (_x, _y are offset)
	private static var __dragTargets : Array = [];


// PRIVATE CLASS METHODS
	private static function __createDrag()
	{
		var z = Math.min(4, __dragData.dragItems.length);
		var clip_name : String;
		var offset = 0;
		
		__clipParent.createEmptyMovieClip('__drag_manager_temp_clip_mc', __clipParent.getNextHighestDepth());
		
		__dragData.drag_mc = __clipParent.__drag_manager_temp_clip_mc;
		if (__dragData.bitmap) 
		{
			__dragData.drag_mc.attachBitmap(__dragData.bitmap, 100);
		}
	}
	

	private static function __dragTarget(x_pos, y_pos) // global location
	{
		var target = undefined;
		
		var z = __dragTargets.length;
		for (var i = 0; i < z; i++)
		{
			if (__dragTargets[i].hitTest(x_pos, y_pos, false)) 
			{
				target = __dragTargets[i];
				break;
			}
		}
		if (target)
		{
			__dragData.hasnt_moved = ((x_pos == __dragData.dragPoint.x) && (y_pos == __dragData.dragPoint.y));
			
			if (! target.dragOver(x_pos, y_pos, __dragData.dragItems, __dragData.itemOffset.x, __dragData.itemOffset.y, __dragData.hasnt_moved)) target = undefined;
			else __dragData.dragPoint = {x: x_pos, y: y_pos};
			
		}
		return target;
	}
	


	private static function __move()
	{
		var mouse_target = __clipParent;
		var cur_target = __dragTarget(mouse_target._xmouse, mouse_target._ymouse);
		if (__dragData.target != cur_target)
		{
			if (__dragData.target) __dragData.target.dragHilite(false);
			__dragData.target = cur_target;
			if (__dragData.target) __dragData.target.dragHilite(true);
		}
		if (! __dragData.drag_mc)
		{
			__createDrag();
		}
		var pt = {x: _root._xmouse, y: _root._ymouse};
		pt.x += __dragData.bitmapOrigin.x;
		pt.y += __dragData.bitmapOrigin.y;
		pt.x -= __dragData._x;
		pt.y -= __dragData._y;
		
		
		//__clipParent.globalToLocal(pt);
		__dragData.drag_mc._x = pt.x;
		__dragData.drag_mc._y = pt.y;
	
	}
	
	
	private static function __release()
	{
		_global.app.dragging = false;
		if (__dragData.drag_mc)
		{	
			var d = new Date();
			if (__dragData.target) 
			{
				if (d.getTime() > (__dragData.clickTime.getTime() + 250))
				{
					__dragData.target.dragAccept(__dragData.dragPoint.x, __dragData.dragPoint.y, __dragData.dragItems, __dragData.itemOffset.x, __dragData.itemOffset.y);
				}
				__dragData.target.dragHilite(false);
			}
			__dragData.drag_mc.createEmptyMovieClip('kill_bitmap', 100);
			__dragData.drag_mc.removeMovieClip();
		}
		__dragData.onMouseMove = undefined;
		__dragData.onMouseUp = undefined;
	
		Mouse.removeListener(__dragData);
		__dragData = undefined;
	}

}
