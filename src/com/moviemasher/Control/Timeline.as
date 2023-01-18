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

/** Panel control symbol displays an editable view of {@link com.moviemasher.Clip.Clip} objects in a {@link com.moviemasher.Mash.Mash} object.
TODO: drag select in blank areas
*/

class com.moviemasher.Control.Timeline extends com.moviemasher.Control.ControlPanel
{

// PUBLIC INSTANCE PROPERTIES

	function get clipboard() : Array { return __cloneItems(__clipboard); }
	function set clipboard(s : Array) : Void 
	{
		__clipboard = __cloneItems(s);
		dispatchEvent({type: 'changeClipboard'});
	}
		
	function get mash() : Object { return __mash; }
	function set mash(new_mash : Object)
	{
		var events = ['mashLocationChange','mashTrackChange','mashTracksChange','mashLengthChange','mashZoomChange','mashDirtyChange'];
		var z = events.length;
		var i;
		
		if (__mash) 
		{
			for (i = 0; i < z; i++)
			{
				__mash.removeEventListener(events[i], this);
			}
			__deleteClips();
			com.moviemasher.Core.Action.clear();
		}
		__mash = new_mash;
		if (__mash) 
		{
			for (i = 0; i < z; i++)
			{
				__mash.addEventListener(events[i], this);
			}
			if (__watchedProperties.mash) dispatchEvent({type: 'propertyChange', property: 'mash', value: __mash});
			if (__watchedProperties.location) dispatchEvent({type: 'propertyRedefined', property: 'location', defined: true, value: __mash.getValue('location')});
			if (__watchedProperties.duration) dispatchEvent({type: 'propertyRedefined', property: 'duration', defined: true, value: __mash.getValue('duration')});
			if (__watchedProperties.label) dispatchEvent({type: 'propertyRedefined', property: 'label', defined: false});
			if (__watchedProperties.snapon) dispatchEvent({type: 'propertyRedefined', property: 'snapon', defined: ! config.snap});
			if (__watchedProperties.snapoff) dispatchEvent({type: 'propertyRedefined', property: 'snapoff', defined: config.snap});	
			
			mashLocationChange({target: __mash});
			mashTracksChange({target: __mash});
		}
		else __hScrollReset();
		selectedItems = [];
		__needsScrollingTo = true;
	}
	function get mode() : String { return __mode; }
	function set mode(s : String) : Void 
	{
		if (__mode != s)
		{
			__mode = s;
			__deleteClips();
			size();
			if (__watchedProperties.timemode) dispatchEvent({type: 'propertyRedefined', property: 'timemode', defined: (__mode == 'clip')});
			if (__watchedProperties.clipmode) dispatchEvent({type: 'propertyRedefined', property: 'clipmode', defined: (__mode == 'time')});
			if (__watchedProperties.zoom) dispatchEvent({type: 'propertyRedefined', property: 'zoom', defined: true, value: __mash.getValue('zoom')});
			panel.delayedDraw();
			__width = 0;
			__needsScrollingTo = true;
		}
	}
	var previewHeight : Number = 0; 
	var previewWidth : Number = 0; 

	function get selectedItem() { return __selectedItems[__selectedItems.length - 1]; }
	function get selectedItems() { return __selectedItems; }
	function set selectedItems(a : Array) 
	{
	
		var id_name : String;
		var was_selected : Object = {};
		var is_selected : Object = {};
		var z = __selectedItems.length;
		var old_length = z;
		for (var i = 0; i < z; i++)
		{
			id_name = 'id_' + __selectedItems[i].id;
			was_selected[id_name] = __selectedItems[i];
		}
		__selectedItems = a;
		__selectedItems.sort(__mash.sortByTimeTrack);
		z = __selectedItems.length;
		
		var add_selected : Array = [];
		var remove_selected : Array = [];
		for (var i = 0; i < z; i++)
		{
			id_name = 'id_' + __selectedItems[i].id;
			is_selected[id_name] = __selectedItems[i];
			if (was_selected[id_name] == undefined) add_selected.push(is_selected[id_name]);
		}
		for (var k in was_selected)
		{
			if (is_selected[k] == undefined) remove_selected.push(was_selected[k]);
		}
		if (add_selected.length) _global.com.moviemasher.Utility.MashUtility.changeValues(add_selected, 'selected', 1);
		if (remove_selected.length) _global.com.moviemasher.Utility.MashUtility.changeValues(remove_selected, 'selected', 0);
		
		__syncActions();
		__syncProperties();
	}
	
	var viewWidth : Number = 0; 
	function get viewX(): Number { return config.x + config.iconwidth; }
	function get vScroll() : Number { return __vScroll;}
	function set vScroll(n : Number)
	{
		__vScroll = n;
		__icons_mc._y = - __vScroll;
		if (__watchedProperties.vscroll) dispatchEvent({type: 'propertyChange', property: 'vscroll', size: __contentSize.vsize, value: (__vScroll * 100) / __contentSize.height});
	}


// PUBLIC INSTANCE METHODS
	

	function action(event : Object) : Void // some action was taken by the user
	{
		switch (event.target)
		{
			case _global.app:
			{
				__syncActions();
				__syncProperties();
				break;
			}
		}
	}
	
	function createChildren() : Void
	{
		super.createChildren();
		__clips_mc.createEmptyMovieClip('trans_mc', __clips_mc.getNextHighestDepth()); 
		__clips_mc.createEmptyMovieClip('other_mc', __clips_mc.getNextHighestDepth()); 
		
		// INSERT HILITE
		__clips_mc.createEmptyMovieClip('__insert_hi_mc', __clips_mc.getNextHighestDepth()); 
		__insert_hi_mc = __clips_mc.__insert_hi_mc;
		__insert_hi_mc._visible = false;
		
		// DRAG HILITE
		createEmptyMovieClip('__drag_hi_mc', getNextHighestDepth());
		__drag_hi_mc = __drag_hi_mc;
		__drag_hi_mc._visible = false;
	
		if (! config[(config.horizontal ? 'width' : 'height')]) __makeFlexible(config.horizontal);		
		com.moviemasher.Utility.DragUtility.addTarget(this);
		_parent.createEmptyMovieClip('timeline_drag_mc', _parent.getNextHighestDepth());
		
		com.moviemasher.Utility.DragUtility.registerClipParent(_parent.timeline_drag_mc);
		
		createEmptyMovieClip('__icons_mc', getNextHighestDepth());
		createEmptyMovieClip('__icons_mask_mc', getNextHighestDepth());
		__icons_mc.setMask(__icons_mask_mc);
		if (config.iconwidth)
		{
			if (config.clipicon.length) __createIcon(__icons_mc, 'clipicon0_mc', config.clipicon);
			if (config.audioicon.length) __createIcon(__icons_mc, 'audioicon0_mc', config.audioicon);
			if (config.effecticon.length) __createIcon(__icons_mc, 'effecticon0_mc', config.effecticon);
			if (config.videoicon.length) __createIcon(__icons_mc, 'videoicon0_mc', config.videoicon);
		}
		
		var cursors = ['trimleft', 'trimright', 'hover', 'drag'];
		for (var k in cursors)
		{
			__createCursor(cursors[k]);
		}
	}

		
	function dragAccept(root_xmouse, root_ymouse, items, x_offset, y_offset) : Void
	{
		var clip_index;
		var pt = {x: root_xmouse, y: root_ymouse};
		globalToLocal(pt);
		
		if (mode == 'time')
		{
			var not_visual = (! items[0].isVisual());
			
			
			if (not_visual)
			{
				var span = __spanOfItems(items);
				var track = pixels2Track(pt.y + vScroll - y_offset, items[0].type, span.tracks);
				
				var start_time = Math.max(0, pixels2Time(pt.x + hScroll - x_offset));
				start_time = __mash.bestTrackTime(start_time, span.time, (items[0].mash ? items : undefined), track, span.tracks, items[0].type);
					
				com.moviemasher.Utility.MashUtility.insertTracks(__mash, items, track, start_time); 
			}
			else
			{
				var mc = __dragClip(root_xmouse, root_ymouse);
				if (mc) clip_index = mc.item.index;
				else clip_index = -1;
				if (clip_index < 0) clip_index = __mash.tracks.video.length;
				com.moviemasher.Utility.MashUtility.insertItems(__mash, items, clip_index); 
			}
		}
		else // mode == clip
		{
			clip_index = pixels2Index(pt.x + hScroll);
			if (clip_index && (clip_index > __mash.tracks.video.length)) clip_index = __mash.tracks.video.length;
			com.moviemasher.Utility.MashUtility.insertItems(__mash, items, clip_index); 
			
		}
	}
	
		
/** Sets the highlighted state of the view.
Called by {@link com.moviemasher.Utility.DragUtility} during drag operation.
*/
	function dragHilite(tf) : Void
	{
		__drag_hi_mc._visible = tf;
		if (! tf) __insert_hi_mc._visible = tf;
	}

	function dragOver(root_xmouse, root_ymouse, items, x_offset, y_offset, hasnt_moved) : Boolean // GLOBAL x,y! return true if valid drop point
	{
		var ok = false;
		
		if (__click_mc.hitTest(root_xmouse, root_ymouse))
		{
			var pt = {x: root_xmouse, y: root_ymouse};
			globalToLocal(pt);
			var not_visual = (! items[0].isVisual());
			if (not_visual && (__mode == 'clip')) mode = 'time';
			if (hasnt_moved)
			{
				if (pt.x < config.autoscroll) __doScroll(-1, true); 
				else if (pt.x > (config.width - config.autoscroll)) __doScroll(1, true);
			}
			if (__mode == 'time')
			{
				if (hasnt_moved)
				{
					if (pt.y < config.autoscroll) __doScroll(-1, false); 
					else if (not_visual && (pt.y > (config.height - config.autoscroll))) __doScroll(1, false);
				}
				ok = true;
				if (! not_visual) // is visual selection
				{
					var mc = __dragClip(root_xmouse, root_ymouse);
					
					if (mc && (! __isDropTarget(mc.item.index, items))) 
					{
						ok = false;
						mc = undefined;
					}
					
					if (__insert_hi_mc._visible = Boolean(mc))
					{
						__insert_hi_mc._height = mc.height;
						__insert_hi_mc._width = mc.width;
						__insert_hi_mc._y = mc._y;
						__insert_hi_mc._x = mc._x;
					}
				}
				else // not_visual
				{
					var span = __spanOfItems(items);
					var track = pixels2Track(pt.y + vScroll - y_offset, items[0].type, span.tracks);
					var start_time = Math.max(0, pixels2Time(pt.x + hScroll - x_offset));
					start_time = __mash.bestTrackTime(start_time, span.time, (items[0].mash ? items : undefined), track, span.tracks, items[0].type);
					if (__insert_hi_mc._visible = (start_time >= 0))
					{
						__insert_hi_mc._x = time2Pixels(start_time) - hScroll;
						__insert_hi_mc._height = (typeHeight(items[0].type) * span.tracks) + (span.tracks - 1);
						__insert_hi_mc._width = time2Pixels(span.time);
						__insert_hi_mc._y = track2Pixels(track, items[0].type) - vScroll;
						
					}
					else ok = false;
				}
			}
			else // mode == clip
			{
				ok = true;
				var clip_index = pixels2Index(pt.x + hScroll);
				if (clip_index < __mash.tracks.video.length)
				{
					ok = __isDropTarget(clip_index, items);
				}
				if (__insert_hi_mc._visible = ok)
				{
					__insert_hi_mc._x = __index2Pixels(clip_index) - hScroll;
					__insert_hi_mc._height = previewHeight;
					__insert_hi_mc._width = previewWidth;
					__insert_hi_mc._y = track2Pixels(track, items[0].type) - vScroll;
				}
			}
		}
		return ok;
	}
	

	function initSize(dont_use_icon : Boolean) : Void
	{
		super.initSize();		

		var cursors = ['trimleft', 'trimright', 'hover', 'drag'];
		for (var k in cursors)
		{
			__configCursor(cursors[k]);
		}

		if (! config.iconwidth) return;
		
		var keys : Array = ['clip', 'effect', 'video', 'audio'];
		var clip_name : String;
		var k : String;
		var z = keys.length;
		for (var kk = 0; kk < z; kk++)
		{
			k = keys[kk];
			if (config[k + 'icon'].length)
			{
				clip_name = k + 'icon0_mc';
				if (! __icons_mc[clip_name]) __icons_mc.createEmptyMovieClip(clip_name, __icons_mc.getNextHighestDepth());
				__clipBitmap(__icons_mc[clip_name], config[k + 'icon'], config.iconwidth, 0);
				
				__heights[k] = __icons_mc[clip_name]._height;
				__icons_mc[clip_name].removeMovieClip();
			}
		}
	}	
	
	
	function mashDirtyChange(event : Object) : Void
	{
		switch (event.target)
		{
			case __mash:
			{
				if (__watchedProperties.save) dispatchEvent({type: 'propertyRedefined', property: 'save', defined: __mash.needsSave});
				break;
			}
		}
	}
	
	function mashLengthChange(event : Object) : Void
	{
		switch (event.target)
		{
			case __mash:
			{
				__hScrollReset();
				__drawClips();
				if (__watchedProperties.duration) dispatchEvent({type: 'propertyChange', property: 'duration', value: __mash.getValue('duration')});
				break;
			}
		}
	}
	
	function mashLocationChange(event : Object) : Void
	{
		switch(event.target)
		{
			case __mash:
			{
				if (__watchedProperties.location) dispatchEvent({type: 'propertyChange', property: 'location', value: __mash.getValue('location')});
				if (__watchedProperties.completed) dispatchEvent({type: 'propertyChange', property: 'completed', value: __mash.getValue('completed')});
				break;
			}
		}
	}
	
	function mashTrackChange(event : Object) : Void
	{
		switch (event.target)
		{
			case __mash:
			{
				__drawClips();
				break;
			}
		}
	}

	function mashTracksChange(event : Object) : Void // the number of tracks changed
	{
		switch (event.target)
		{
			case __mash:
			{
				__resetTracks();
				__vScrollReset();
				break;
			}
		}
	}
	
	function mashZoomChange(event : Object) : Void
	{
		switch (event.target)
		{
			case __mash:
			{
				//_global.com.moviemasher.Control.Debug.msg('mashZoomChange');
				if (__mode == 'clip') 
				{
					
					__resetSizes();
				}
				__hScrollReset();
				__scrollToPosition();
				break;
			}	
		}
	}

	
	function pixels2Index(x_pixels) : Number // only called when mode == clip
	{
		var clip_index;
		clip_index = Math.floor(x_pixels / previewWidth);
		clip_index = Math.max(0, Math.min(clip_index, __mash.tracks.video.length));
		return clip_index;
	}
	
	
	function pixels2Time(pixels : Number) : Number
	{
		var time = 0;
		var clip_length;
		var clip_start;
		var through;
		var clip;
		if (mode == 'clip')
		{
			var index = pixels2Index(pixels);
			if (index < __mash.tracks.video.length) 
			{
				clip = __mash.tracks.video[index];
				var timeline_start = clip.timelineStart();
				clip_length = clip.length;
				clip_length -= timeline_start;
				clip_length -= clip.timelineEnd();
				clip_start = clip.start;
				clip_start += timeline_start;
				through = (pixels  % previewWidth) / previewWidth;
				time = clip_start + (through * clip_length);
			}
			else time = __mash.length;
		}
		else time = pixels / _global.app.options.video.fps / __mash.getValue('zoom');
		return Math.round(time * _global.app.options.video.fps) / _global.app.options.video.fps;
	}
	
	function pixels2Track(y_pixels, type, lowest_track) : Number 
	{
		if (lowest_track < 1) lowest_track = 1;
		var highest_track = __tracks[type];
		var track = 0;
		if (__tracks[type]) 
		{
			switch (type)
			{
				case 'effect':
				{
					track = __tracks.effect - Math.round(y_pixels / typeHeight('effect'));
					break;	
				}
				case 'audio':
				{
					y_pixels -= __tracks.effect * typeHeight('effect');
					y_pixels -= __tracks.video * typeHeight('video');
					if (__tracks.video && _global.com.moviemasher.Media.Media.multitrackVideo) y_pixels -= typeHeight('audio');
					
					track = Math.round(y_pixels / typeHeight('audio')) + 1;
					
					break;
				}
			}
		}
		// don't let user create new tracks if config specified a set number of them
		track = Math.min(__tracks[type] + (config[type + 'tracks'] ? 0 : 1), track);
		if (track < lowest_track) track = lowest_track;
		return track;
	}
	
	function pressedClip(item : Object, pressed_clip : MovieClip, on_handle : Number) : Void
	{
		
		var new_sel = _global.com.moviemasher.Utility.ArrayUtility.copy(selectedItems);
		var sel_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(new_sel, item);
		var shift_down = Key.isDown(Key.SHIFT);
		
		var do_press = true;
		if (sel_index > -1) // it was selected
		{
			if (shift_down) // deselected it, disable drag
			{
				new_sel.splice(sel_index, 1);
				do_press = false;
			}
		}
		else // it wasn't selected
		{
			if (shift_down) 
			{
				if (mode == 'time') // make sure selection is valid
				{
					// make sure selection is all audio OR effects OR visual items
					if (
						new_sel.length && (
							(item.isVisual() != new_sel[0].isVisual()) 
							|| ((! item.isVisual()) && (item.type != new_sel[0].type))
						)
					) shift_down = false;
				}
				if (shift_down) new_sel.push(item);
			}
			if (! shift_down) new_sel = [item];
		}
		selectedItems = new_sel;
		
		if (do_press) do_press = __canRemove(__selectedItems);
		if (do_press && on_handle && (new_sel.length == 1))
		{		
			__trimStart(on_handle, new_sel[0]);
			do_press = false;
		}

		if (do_press) 
		{
			var pt = {x: 0, y: 0};
			localToGlobal(pt);
			var offset = {};
			if (new_sel[0].type == 'effect') new_sel.sortOn('track', Array.DESCENDING | Array.NUMERIC);
			else new_sel.sortOn('track', Array.NUMERIC);
			offset.y = (vScroll + _ymouse) - track2Pixels(new_sel[0].track, new_sel[0].type);
			new_sel.sortOn('start', Array.NUMERIC);
			offset.x = (hScroll + _xmouse) - time2Pixels(new_sel[0].start);
			_global.app.setCursor();
			com.moviemasher.Utility.DragUtility.begin(selectedItems, {itemOffset: offset, bitmapOrigin: pt, bitmap: __itemsBitmap(__selectedItems), _x: _root._xmouse, _y: _root._ymouse});
			if (__cursors.drag.bm) _global.app.setCursor(__cursors.drag.bm, __cursors.drag.x, __cursors.drag.y);
		}
	}
	
	// one of my targets has changed a property
	function propertyChange(event : Object) : Void
	{
		if (__targets[event.property] == event.target)
		{
			switch(event.property)
			{
				case 'mash':
				{
					mash = event.value;
					mode = config.mode;
					break;
				}
			}
		}
	}

	
	
	function propertyRedefines(property : String) : Boolean
	{
		var property_redefines : Boolean = true;
		if (__enabledControls[property] == undefined) //property_redefines = true;
		{
			switch(property)
			{
				case 'mash':
				{
					property_redefines = false;
					break;
				}
			}
		}
		return property_redefines;
	}
	
	function setCursor(cursor : Number) // called from timline previews
	{
		var cursor_ob : Object; // undefined
		
		if (cursor != undefined)
		{
			var cursors = ['trimleft', 'hover', 'trimright'];
			cursor_ob = __cursors[cursors[1 + cursor]];
		}
		_global.app.setCursor(cursor_ob.bm, cursor_ob.x, cursor_ob.y);

	}
	function size() : Void
	{
		if (! __mash) return;
		super.size();

	
		__resetSizes();
		
		var c = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.hicolor);
		__drag_hi_mc.clear();
		_global.com.moviemasher.Utility.DrawUtility.plot(__drag_hi_mc, 0, 0, width, 2, c, config.hialpha);
		_global.com.moviemasher.Utility.DrawUtility.plot(__drag_hi_mc, 0, height - 2, width, 2, c, config.hialpha);
		__click_mc.clear();
		_global.com.moviemasher.Utility.DrawUtility.fill(__click_mc, width, height, 0, 0);

		__icons_mask_mc.clear();
		_global.com.moviemasher.Utility.DrawUtility.fill(__icons_mask_mc, width, height, 0, 0);
	
		__insert_hi_mc.clear();
		_global.com.moviemasher.Utility.DrawUtility.fill(__insert_hi_mc, 2, height, c, config.hialpha);
		
		__hScrollReset();
		__vScrollReset();
		
	}

	function time2Pixels(seconds : Number, rounding : String) : Number
	{
		
		if (! seconds) return 0;
		if (! rounding) rounding = 'ceil';
		var pixels = 0;
		if (mode == 'clip')
		{
			
			// grab clip(s) at time
			var clips = __mash.timeRangeClips(seconds, 0, 'video');
			
			// if there are none, use the last clip
			if ((! clips.length) && __mash.tracks.video.length) clips.push(__mash.tracks.video[__mash.tracks.video.length - 1]);
			
			
			var clip_length;
			var clip_start;
			var through;
			var z = clips.length;
			if (z) // true if there are video clips
			{
			 	if (z > 1) // there's a transition going on, make it the first clip in clips
			 	{
			 		for (var i = 0; i < z; i++)
			 		{
			 			if (clips[i].type == 'transition')
			 			{
			 				clips[0] = clips[i];
			 				break;
			 			}
			 		}
			 	}
			 	// clip is single clip, or the transition if one's going on
				var clip = clips[0];
				var index = clip.index;
				if (index != -1) // it should be
				{
					var timeline_start = clip.timelineStart();
				
					clip_length = clip.length;
					clip_length -= timeline_start;
					clip_length -= clip.timelineEnd();
				 	clip_start = clip.start;
				 	clip_start += timeline_start;
				 	
				 	through = (seconds - clip_start) /  clip_length
				 	pixels = ((index * previewWidth) ) + (through * previewWidth);
				 }
			}		 
 		}
		else pixels = Math[rounding](seconds * _global.app.options.video.fps * __mash.getValue('zoom'));
	 	return pixels;
	}
	
	function track2Pixels(track, type) : Number
	{
		var pixels = 0;
		switch (type)
		{
			case 'effect':
			{
				pixels += (__tracks.effect - track) * typeHeight('effect');
				break;	
			}
			case 'audio':
			{
				if (__tracks.video) pixels += typeHeight('video');
				
				pixels += (track + ((__tracks.video && _global.com.moviemasher.Media.Media.multitrackVideo) ? 0 : -1) ) * typeHeight('audio');
				// intentional fallthrough to default
			}
			default:
			{
				pixels += __tracks.effect * typeHeight('effect');
			}
			
		}
		return pixels;
	}
	
	function typeHeight(type : String, subtract_line : Boolean)
	{
		if ( ! ((type == 'audio') || (type == 'effect') || (type == 'clip'))) type = 'video';
		return __heights[type] - (subtract_line ? config.line : 0);
	}

// PRIVATE INSTANCE PROPERTIES

	private var __clipboard : Array = [];
	private var __contentHeight : Number = 0;
	
	private var __drag_hi_mc : MovieClip; // drag focus rect
	private var __enabledControls : Object;
	private var __enabledProperties : Object;
	private var __heights : Object;
	private var __icons_mc : MovieClip; // holds track icons
	private var __icons_mask_mc : MovieClip; // matte
	private var __insert_hi_mc : MovieClip; // drag insert line
	private var __lastWidth : Number;
	private var __mash;
	private var __maxScrolls : Object;
	private var __mode : String = '';
	private var __needsScrollingTo : Boolean = false;
	private var __selectedItems : Array;
	private var __tracks : Object;
	private var __trimInfo : Object;
	private var __vScroll : Number = 0;
	
	private var __cursors : Object;
	
// PRIVATE INSTANCE METHODS

	private function Timeline()
	{
		__enabledControls = {save: false, undo: false, redo: false, cut: false, copy: false, paste: false, remove: false, timemode: false, clipmode: false};
		__selectedItems = [];
		__cursors = {};
		__enabledProperties = {};
		__maxScrolls = {};
		__contentSize = {width: 0, height: 0};
		__heights = {clip: 150, audio: 60, video: 90, effect: 60};
		
		if (config.iconwidth == undefined) config.iconwidth = 0;
		if (config.handlewidth == undefined) config.handlewidth = 5;
		
		if (config.line == undefined) config.line = 0;
		if (config.snapto == undefined) config.snapto = 20;
		if (config.previewoffset == undefined) config.previewoffset = 50;
		
		config.videotracks = (config.videotracks ? 1 : 0);
		config.cliptracks = (config.cliptracks ? 1 : 0);
		if (config.audiotracks == undefined) config.audiotracks = 0;
		if (config.effecttracks == undefined) config.effecttracks = 0;
		
		__tracks = {clip: config.cliptracks, audio: config.audiotracks, video: config.videotracks, effect: config.effecttracks};
		
		var defaults = {hialpha: 50, id: 'timeline', autoscroll: 20, curvetime: 6, curveclip: 6, previewmode: 'normal', previewcurveclip: 4, previewcurvetime: 4, previewinsettime: 2, previewinsetclip: 2};
		for (var k in defaults)
		{
			__setUndefinedConfig(k, defaults[k]);
		}
		/*
		if (config.autoscroll == undefined) config.autoscroll = 20;
		if (config.curvetime == undefined) config.curvetime = 6;
		if (config.curveclip == undefined) config.curveclip = 6;
		if (config.previewmode == undefined) config.previewmode = 'normal';
		if (config.previewcurveclip == undefined) config.previewcurveclip = ;
		if (config.previewcurvetime == undefined) config.previewcurvetime = 4;
		if (config.previewinsettime == undefined) config.previewinsettime = 2;
		if (config.previewinsetclip == undefined) config.previewinsetclip = 2;
	*/
	
		
	//	if (config.id == undefined) config.id = 'timeline';
		config.mode = ((config.mode == 'time') ? 'time' : 'clip');
	//	if (config.snap == undefined) config.snap = 1;
		config.snap = Boolean(config.snap);
		
		//if (config.hialpha == undefined) config.hialpha = 50;
		
		
		_global.app.addEventListener('action', this);
		
		
		// all track heights to be overridden by cliptrack, videotrack, etc.		
		var keys : Array = ['clip', 'effect', 'video', 'audio'];
		var k : String;
		for (var kk = 0; kk < 4; kk++)
		{
			k = keys[kk];
			if (config[k + 'track']) __heights[k] = config[k + 'track']	
		}
	}

	private function __Timeline()
	{
	
	}
	
	
	private function __arrowSize(horizontal) : Number
	{
		return (horizontal ? 50 : 20);
	}
	
	private function __calculateContentHeight() : Void
	{
		__contentHeight = 0;
		if (__mode == 'clip')
		{
			if (__tracks.clip) __contentHeight += typeHeight('clip');
		}
		else
		{
			if (__tracks.video) 
			{
				__contentHeight += typeHeight('video');
				if (_global.com.moviemasher.Media.Media.multitrackVideo) __contentHeight += typeHeight('audio');
			}
			if (__tracks.audio) __contentHeight += __tracks.audio * typeHeight('audio');
			if (__tracks.effect) __contentHeight += __tracks.effect * typeHeight('effect');
		}
	}
	
	private function __canRemove(items) : Boolean
	{
		var z = items.length;
		var not_visual = (! items[0].isVisual());
		if (not_visual) return true;
		var can_remove : Boolean = true;
		var item_mash;
		var item;
		var index : Number;
		var is_selected : Object = {};
		var left_index;
		var right_index;
		
		for (var i = 0; i < z; i++)
		{
			item = items[i];
			is_selected['id_' + item.id] = item;
		}
		for (var i = 0; i < z; i++)
		{
			item = items[i];
			item_mash = item.mash;
			index = item.index;
			
			left_index = index - 1;
			while (left_index > -1)
			{
				item = item_mash.tracks.video[left_index];
				if (! is_selected['id_' + item.id]) break;
				left_index --;
			}
			if (left_index > -1) 
			{
				right_index = index + 1;
				while (right_index < item_mash.tracks.video.length)
				{
					item = item_mash.tracks.video[right_index];
					if (! is_selected['id_' + item.id]) break;
					right_index ++;
				}
			
				if (right_index < item_mash.tracks.video.length)
				{
					
					if ((item_mash.tracks.video[left_index].type == 'transition') && (item_mash.tracks.video[right_index].type == 'transition'))
					{
						can_remove = false;
						break;
					}
				}
			}
		}
		return can_remove;
	}
	
	private function __changeProperty(finished : Boolean, property : String, value, control: com.moviemasher.Control.Control) : Void
	{
		var change_target = __selectedItems;
		if (__enabledControls[property] != undefined) __doAction(property, control);
		else
		{
			switch(property)
			{
				case 'snapoff':
				case 'snapon':
				{
					config.snap = (property == 'snapon');
					if (__watchedProperties.snapon) dispatchEvent({type: 'propertyRedefined', property: 'snapon', defined: ! config.snap});
					if (__watchedProperties.snapoff) dispatchEvent({type: 'propertyRedefined', property: 'snapoff', defined: config.snap});	
					break;
				}
				case 'vscroll':
				{
					//if (! _global.com.moviemasher.Control.Debug.isFalse(! isNaN(__contentSize.height), className + '.__changeProperty with bad __contentSize.height ' + value))
			
					__scrollTo(false, Math.round((value * __contentSize.height) / 100), true);
					break;
				}
				case 'hscroll':
				{
					__scrollTo(true, Math.round((value * __contentSize.width) / 100), true);
					break;
				}
				case 'completed':
				case 'location':
				case 'zoom':
				{
					change_target = [__mash];
					// intentional fallthrough to default
				}
				
				
				default:
				{
					com.moviemasher.Utility.MashUtility['chang' + (finished ? 'e' : 'ing') + 'Values'](change_target, property, value);
				}
			}
		}
	}

	private function __cloneItems(a : Array) : Array
	{
		var items : Array = [];
		var z = a.length;
		var item;
		for (var i = 0; i < z; i++)
		{
			item = a[i].clone();
			item.mash = undefined;
			items.push(item);
		}
		return items;
	}
	

	private function __createClip(clip, clip_name : String) : MovieClip
	{
		var container_name = ((clip.type == 'transition') ? 'trans' : 'other') + '_mc';
		var mc : MovieClip;
		__clips_mc[container_name].attachMovie('TimelinePreview', clip_name, __clips_mc[container_name].getNextHighestDepth(), {target: this});
		mc = __clips_mc[container_name][clip_name];
		mc.item = clip;
		return mc;
	}
	

	
	private function __configCursor(cursor_name : String)
	{
		if (config[cursor_name + 'icon'].length)
		{
			var c = config[cursor_name + 'icon'].split(';');
			__cursors[cursor_name] = {};
			__cursors[cursor_name].bm = _global.com.moviemasher.Manager.LoadManager.cachedBitmap(c[0]);
			if (c.length > 1) __cursors[cursor_name].x = c[1];
			if (c.length > 2) __cursors[cursor_name].y = c[2];
		}
	}
	
	private function __createCursor(cursor_name : String)
	{
		if (config[cursor_name + 'icon'].length)
		{
			var c = config[cursor_name + 'icon'].split(';');
			if (! _global.com.moviemasher.Manager.LoadManager.cachedBitmap(c[0]))
			{
				__loadingThings ++;
				_global.com.moviemasher.Manager.LoadManager.cacheBitmap(c[0], _global.com.moviemasher.Core.Callback.factory('__cacheDidLoad', this));
			}
		}
	}
	
	
	
	private function __deleteClips() : Void
	{
		for (var k in __createdClips)
		{
			if (__createdClips[k]) 
			{
				__createdClips[k].item = undefined;
				__createdClips[k].removeMovieClip();
			}
		}
		__createdClips = {};
		
	}

	
	private function __doAction(action : String, control : com.moviemasher.Control.Control) : Void
	{
		var z = __selectedItems.length;
		var not_visual : Boolean;
		
		switch (action)
		{
			case 'cut':
			{
				clipboard = __selectedItems;
				__doDelete();				
				break;
			}
			case 'copy':
			{
				clipboard = __selectedItems;
				break;
			}
			case 'timemode':
			{
				mode = 'time';
				break;
			}			
			case 'clipmode':
			{
				mode = 'clip';
				break;
			}			
			case 'remove': 
			{
				__doDelete();
				break;
			}
			case 'paste': 
			{
				var items = clipboard;
				var not_visual = (! items[0].isVisual());
				if (not_visual) 
				{
					var span = __spanOfItems(items);
					var start = mash.getValue('location');
					var track = mash.time2FreeTrack(start, span.time, items[0].type, span.tracks);
					
					com.moviemasher.Utility.MashUtility.insertTracks(mash, items, track, start);
							
				}
				else com.moviemasher.Utility.MashUtility.insertItems(mash, items, __insertIndex());
				break;
			}
			
			case 'save': 
			{	
				__mash.save(control);
				break;
			}
			case 'redo':
			case 'undo': 
			{		
				com.moviemasher.Core.Action[action]();
				break;
			}
		}
		selectedItems = __selectedItems;
	}	
	

	private function __doDelete() : Void
	{
		if (__selectedItems.length)
		{
			var not_visual = (! __selectedItems[0].isVisual());
			if (not_visual) com.moviemasher.Utility.MashUtility.insertTracks(__mash, __selectedItems, -1);
			else com.moviemasher.Utility.MashUtility.insertItems(__mash, __selectedItems, -1);
		}
	}

	private function __doScroll(dir, horizontal) : Number
	{
		var hORv = (horizontal ? 'h' : 'v');
		if (__maxScrolls[hORv])
		{
			var cur_pos = this[hORv + 'Scroll'];
			var new_pos = cur_pos + (dir * __arrowSize(horizontal));
			if (new_pos > __maxScrolls[hORv]) new_pos = __maxScrolls[hORv];
			else if (new_pos < 0) new_pos = 0;
			if (new_pos != cur_pos) return __scrollTo(horizontal, new_pos);
		}
		return 0;
	}


	private function __dragClip(root_xmouse, root_ymouse) : MovieClip
	{
		var mc : com.moviemasher.Control.TimelinePreview = undefined;
		for (var k in __createdClips)
		{
			if (__createdClips[k].__back_mc.hitTest(root_xmouse, root_ymouse))
			{
				mc = __createdClips[k];
				break;
			}
		}
		return mc;
	}
	private function __drawClip(clip, metrics) : Void
	{	
		if (! metrics) metrics = __drawMetrics();
		var clip_name = 'clip_' + clip.id;
		if (__createdClips[clip_name]) 
		{
			var clip_mode = (__mode == 'clip');
		
			metrics.x = (clip_mode ? previewWidth * clip.index : time2Pixels(clip.start, 'round')) - __hScroll;
			metrics.y = track2Pixels(clip.getValue('track'), clip.type) - vScroll;
			metrics.width = (clip_mode ? previewWidth : Math.max(1, time2Pixels(clip.length, 'ceil')));
			
			metrics.height = (clip_mode ? previewHeight : typeHeight(clip.type, true));
			metrics.starttrans = ((clip_mode || (clip.index < 0)) ? 0 : time2Pixels(clip.timelineStart(), 'floor'));
			metrics.endtrans = ((clip_mode || (clip.index < 0)) ? 0 : time2Pixels(clip.timelineEnd(), 'floor'));
			
			metrics.leftcrop = ((metrics.x < 0) ? -metrics.x : 0);
			metrics.rightcrop = ((metrics.xcrop < (metrics.x + metrics.width)) ? metrics.xcrop - (metrics.x + metrics.width) : 0);
			metrics.widthcrop = metrics.width - (metrics.leftcrop + metrics.rightcrop);
			__createdClips[clip_name].draw(metrics);
		}
	}
	
	private function __drawClips(force : Boolean) : Void
	{	
		if (__trimInfo.not_visual && (! force)) return;
		var name;
		var clip;
		var newClips = {};
		var clip_name;
		var viewable_clips : Array = __viewableClips();
		var z : Number = viewable_clips.length;
		var metrics = __drawMetrics();
		for (var i = 0; i < z; i++)
		{
			clip = viewable_clips[i];
			clip_name = 'clip_' + clip.id;
			if (__createdClips[clip_name] == undefined) 
			{
				newClips[clip_name] = __createClip(clip, clip_name);
				__createdClips[clip_name] = newClips[clip_name];
			}
			else newClips[clip_name] = __createdClips[clip_name];
			__drawClip(clip, metrics);
			__createdClips[clip_name] = false;
		}
		__deleteClips();
		__createdClips = newClips;
		__startDrawing();
	}
	
	private function __drawMetrics()
	{
		var metrics = {};
		metrics.curve = config['curve' + __mode];
		metrics.previewcurve = config['previewcurve' + __mode];
		metrics.previewinset = config['previewinset' + __mode];
		metrics.mode = __mode;
		metrics.xcrop = viewWidth;
		return metrics;	
	}
	
	private function __enableAction(action : String) : Boolean
	{
		
		var enabled : Boolean = true;
		var z = __selectedItems.length;
		var not_visual : Boolean;
		switch (action)
		{
			case 'cut':
			case 'copy':
			case 'remove': if (! z) enabled = false;
		}
		if (enabled)
		{
			not_visual = (! __selectedItems[0].isVisual());
			switch (action)
			{
				case 'cut':
				case 'remove': 
				{
					enabled = __canRemove(__selectedItems);
					break;
				}
				case 'paste': 
				{
					enabled = Boolean(clipboard.length);
					if (enabled && clipboard[0].isVisual())
					{
						 var insert_index = __insertIndex();
						 enabled = __isDropTarget(insert_index, clipboard);
					}
					break;
				}
				case 'save': 
				{
					enabled = __mash.needsSave
					break;
				}
				case 'undo': 
				{
					enabled = (com.moviemasher.Core.Action.currentDo > -1);
					break;
				}
				case 'redo':
				{
					enabled = (com.moviemasher.Core.Action.currentDo < (com.moviemasher.Core.Action.doStack.length - 1));
					break;
				}
			}
		}
		return enabled;
	}

	private function __hScrollReset() : Void
	{
		var new_w = 0;
		
		if (__mash)
		{
			if (mode == 'clip') new_w += (previewWidth * (1 + __mash.tracks.video.length));
			else new_w += Math.round((viewWidth / 2) + time2Pixels(__mash.length));
		}
	
		if (__lastWidth != new_w)
		{
			__lastWidth = new_w;
			var max_scroll = new_w - viewWidth;
			var scrolls_needed : Boolean = false;
			var new_scroll = __hScroll;
			if (new_w > viewWidth)
			{
				__contentSize.width = max_scroll;
				__contentSize.hsize = (viewWidth * 100) / new_w;
				scrolls_needed = true;
				if (hScroll > (max_scroll)) new_scroll = max_scroll;
				__maxScrolls.h = max_scroll;
			}
			else 
			{
				__maxScrolls.h = 0;
				new_scroll = 0;
			}
			if (__scrollsNeeded.h != scrolls_needed)
			{
				__scrollsNeeded.h = scrolls_needed;
				if (__watchedProperties.hscroll) dispatchEvent({type: 'propertyRedefined', property: 'hscroll', defined: __scrollsNeeded.h});
			}
			hScroll = new_scroll;
		}
		if (__needsScrollingTo) 
		{
			__scrollToPosition();
			__needsScrollingTo = false;
		}
	}
	
	private function __index2Pixels(index) : Number // only called when mode == clip
	{
		var pixels = 0;
		if (index) pixels = (index * previewWidth);
		return pixels;
	}
	
	private function __insertIndex() : Number // only called when mode == clip
	{
		var i = 0;
		if (selectedItem != undefined)
		{
			i = selectedItem.index + 1;
		}
		else i = pixels2Index(time2Pixels(__mash.getValue('location')));
		return i;
	}
	
	private function __isDropTarget(index : Number, items : Array) : Boolean
	{
		var item = __mash.tracks.video[index];
		var ok = true;
		// see if transition is first or last in selection 
		var first_is = (items[0].type == 'transition');
		var last_is = (items[items.length - 1].type == 'transition');
		if (first_is || last_is)
		{
			// see if we're dropping on or next to a transition
			if (
				(last_is && (item.type == 'transition'))
				|| (first_is && index && (__mash.tracks.video[index - 1].type == 'transition'))
			)
			{
				ok = false;
			}
		}
		return ok;
	}

	private function __resetSizes() : Void
	{
		__resetTracks();
	
		if (mode == 'clip') 
		{
			var dims = __mash.dimensions;
			previewHeight = typeHeight('clip', true);
			previewWidth = __mash.getValue('zoom') * Math.round((previewHeight * dims.width) / dims.height);
		}
		viewWidth = config.width - config.iconwidth;
		__clips_mc._x = config.iconwidth;
	}
	
	private function __resetTracks() : Void
	{
		var clip_mode = (__mode == 'clip');
		__tracks.clip = (clip_mode ? (config.cliptracks ? 1 : __mash.highest.video) : 0);
		__tracks.video = (clip_mode ? 0 : (config.videotracks ? 1 : __mash.highest.video));
		__tracks.audio = (clip_mode ? 0 : (config.audiotracks ? config.audiotracks : __mash.highest.audio));
		__tracks.effect = (clip_mode ? 0 : (config.effecttracks ? config.effecttracks : __mash.highest.effect));
					
		var keys : Array = ['clip', 'effect', 'video', 'audio'];
		var i : Number;
		var z : Number;
		var clip_name : String;
		var y_pos : Number = 0;
		var k : String;
		__icons_mc.clear();
		var c;
		if (config.line)
		{
			c = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.linecolor);
			if (config.linegrad) c = _global.com.moviemasher.Utility.DrawUtility.buffedFill(config.width, config.line, c, config.linegrad, config.lineangle);
		}
		for (var kk = 0; kk < 4; kk++)
		{
			k = keys[kk];
			i = 0;
			z =  __tracks[k];
			if ((k == 'audio') && _global.com.moviemasher.Media.Media.multitrackVideo && __tracks.video) z++;
			for (; i < z; i++)
			{
				if (config[k + 'icon'].length)
				{
					clip_name = k + 'icon' + i + '_mc';
					if (! __icons_mc[clip_name]) __icons_mc.createEmptyMovieClip(clip_name, __icons_mc.getNextHighestDepth());
					__clipBitmap(__icons_mc[clip_name], config[k + 'icon'], config.iconwidth, 0);
					__icons_mc[clip_name]._y = y_pos;
				}
				y_pos += __heights[k];
				if (config.line) _global.com.moviemasher.Utility.DrawUtility.plot(__icons_mc, 0, y_pos - config.line, config.width, config.line, c);
			}
			if (config[k + 'icon'].length)
			{
				clip_name = k + 'icon' + i + '_mc';		
				while (__icons_mc[clip_name])
				{
					__icons_mc[clip_name].removeMovieClip();
					i++;
					clip_name = k + 'icon' + i + '_mc';		
				}
			}
		}
		__calculateContentHeight();
	}
	
	
	private function __scrollTo(horizontal : Boolean, position : Number) : Number
	{
		var scrolled = 0;
		if (! isNaN(position))
		{
			scrolled = position - this[(horizontal ? 'h' : 'v') + 'Scroll'];
			this[(horizontal ? 'h' : 'v') + 'Scroll'] = position;
			__drawClips();
		}
		return scrolled;
	}

	private function __scrollToPosition()  : Void
	{
		var new_pos = 0;
		if (__mash)
		{
			new_pos = time2Pixels(__mash.getValue('location')) - Math.round(viewWidth / 2);
		}
		if (new_pos > __maxScrolls.h) new_pos = __maxScrolls.h;
		else if (new_pos < 0) new_pos = 0;
		__scrollTo(true, new_pos);
	}
	
	private function __selectionProperties() : Object
	{
		var z : Number = __selectedItems.length;
		var enabled_properties = {};
		var attribute_values;
		var found = {};
		for (var i = 0; i < z; i++)
		{
			attribute_values = __selectedItems[i].attributeValues();
			for (var property in attribute_values)
			{
				if (! __watchedProperties[property]) continue; // no one's listening for changes in this property
				if (! found[property])
				{
					found[property] = true;
					enabled_properties[property] = {value: attribute_values[property]};
				}
				else if (enabled_properties[property] != attribute_values[property])
				{
					enabled_properties[property] = {value: undefined};
				}
			}	
		}
		return enabled_properties;
	}
	
	private function __spanOfItems(items : Array) : Object
	{
		var select_start : Number = items[0].start;
		var select_end : Number = select_start + items[0].length;
		var track_start : Number = items[0].getValue('track');
		var track_end : Number = track_start;
		var z = items.length;
		var item_track : Number;
		for (var i = 1; i < z; i++)
		{
			item_track = items[i].getValue('track');
			track_start = Math.min(track_start, item_track);
			track_end = Math.max(track_end, item_track);
			select_start = Math.min(select_start, items[i].start);
			select_end = Math.max(select_end, items[i].start + items[i].length);
		}
		return {time: select_end - select_start, tracks: 1 + (track_end - track_start)};
	}

	
	private function __syncActions() : Void
	{
		
		for (var property in __enabledControls)
		{
			if (! __watchedProperties[property]) continue; // no one's listening for changes in this property
			if (__enabledControls[property] != __enableAction(property))
			{
				__enabledControls[property] = ! __enabledControls[property];
				dispatchEvent({type: 'propertyRedefined', property: property, defined: __enabledControls[property]});
			}
		}
	}
	
	private function __syncProperties() : Void
	{
		var enabled_properties = __selectionProperties(); // each key will be in __watchedProperties
				
		var is_defined = {};
		for (var property in enabled_properties)
		{
			is_defined[property] = true;
		}
		for (var property in __enabledProperties)
		{
			if (! is_defined[property])
			{
				dispatchEvent({type: 'propertyRedefined', property: property, defined: false});
			}
		}
		var event = {};
		for (var property in enabled_properties)
		{
			if (! __enabledProperties[property]) 
			{
				dispatchEvent({type: 'propertyRedefined', property: property, defined: true});		
			}
			event = {type: 'propertyChange', property: property};
			for (var k in enabled_properties[property])
			{
				event[k] = enabled_properties[property][k];
			}
			dispatchEvent(event);
		}
		__enabledProperties = is_defined;
	}

	private function __trimStart(direction : Number, clip : com.moviemasher.Clip.Clip) : Void
	{
		var i;
		var items;
		_global.app.dragging = true;
		__trimInfo = {};
		__trimInfo.direction = direction;
		__trimInfo.clip = clip;
		__trimInfo.xmouse = _xmouse - config.iconwidth;
		__trimInfo.orig_data = {};
		__trimInfo.orig_data.start = clip.start;
		__trimInfo.orig_data.length = clip.length;
		__trimInfo.not_visual = false;
		if (clip.type == 'effect')
		{
			__trimInfo.not_visual = true;
			if (direction < 0) 
			{
				__trimInfo.end_time = _global.app.fpsTime(__trimInfo.orig_data.start + clip.length);
				__trimInfo.max_start = _global.app.fpsTime(__trimInfo.end_time - _global.app.options.frametime);
				items = clip.mash.timeRangeTrackItems(0, __trimInfo.orig_data.start, [clip], clip.track, 1, clip.type);
				__trimInfo.min_start = 0;
				for (i = 0; i < items.length; i++)
				{
					__trimInfo.min_start = Math.max(__trimInfo.min_start, _global.app.fpsTime(items[i].start + items[i].length));
				}
			}
			else
			{
				__trimInfo.max_start = 0;
				items = __trimInfo.clip.mash.timeRangeTrackItems(__trimInfo.orig_data.start, __mash.__lengths.effect, [__trimInfo.clip], __trimInfo.clip.track, 1, __trimInfo.clip.type);
				if (items.length) 
				{
					__trimInfo.max_start = items[0].start;
					for (var i = 1; i < items.length; i++)
					{
						__trimInfo.max_start = Math.min(__trimInfo.max_start, items[i].start);
					}
				}
			}
		}
		else if ((clip.type == 'audio') || (clip.type == 'video')) __trimStartAV();
		onMouseMove = __trimMove;
		onMouseUp = __trimUp;
	}
	
	private function __trimStartAV()
	{
		
		__trimInfo.trim = __trimInfo.clip.getValue('trim').split(',');
		__trimInfo.trim[0] = parseFloat(__trimInfo.trim[0]);
		__trimInfo.trim[1] = parseFloat(__trimInfo.trim[1]);
		__trimInfo.media_duration = ((__trimInfo.clip.type == 'video') ? __trimInfo.clip.getValue('speed') : 1) * __trimInfo.clip.media.getValue('duration');
	
		if (__trimInfo.clip.type == 'audio')
		{
			__trimInfo.not_visual = true;
			__trimInfo.end_time = (__trimInfo.orig_data.start + __trimInfo.orig_data.length);
			if (__trimInfo.direction < 0) 
			{
				items = __trimInfo.clip.mash.timeRangeTrackItems(0, __trimInfo.orig_data.start, [__trimInfo.clip], __trimInfo.clip.track, 1, __trimInfo.clip.type);
				__trimInfo.min_start = 0;
				if (items.length) 
				{
					items = items.pop();
					__trimInfo.min_start = items.start + items.length;
				}
			}
			__trimInfo.max_start = 0;
			var items = __trimInfo.clip.mash.timeRangeTrackItems(__trimInfo.orig_data.start, __trimInfo.media_duration, [__trimInfo.clip], __trimInfo.clip.track, 1, __trimInfo.clip.type);
			if (items.length) 
			{
				__trimInfo.max_start = items[0].start;
				for (var i = 1; i < items.length; i++)
				{
					__trimInfo.max_start = Math.min(__trimInfo.max_start, items[i].start);
				}
			}
		}
	}
	
	private function __trimvideo(dif_time : Number) : Object
	{
		var first : Number = __trimInfo.trim[0];
		var last : Number = __trimInfo.trim[1];
		var n
		if (__trimInfo.direction < 0) // decrease start while increasing length
		{
			if (__trimInfo.time != undefined)
			{
				n = (((__trimInfo.time - __trimInfo.orig_data.start) * 100) / __trimInfo.media_duration);
			}
			else n = (__trimInfo.trim[0] + ((dif_time * 100) / __trimInfo.media_duration));
			first = Math.round(100 * (Math.min(100 - (__trimInfo.trim[1] + Math.min(1, ((_global.app.options.frametime * 100) / __trimInfo.media_duration))), Math.max(0, n)))) / 100;
		}
		else
		{
			if (__trimInfo.time != undefined)
			{
				n = ((((__trimInfo.media_duration + __trimInfo.orig_data.start - (__trimInfo.clip.timelineEnd() + ((first * __trimInfo.media_duration) / 100))) - __trimInfo.time) * 100) / __trimInfo.media_duration);
			}
			else n = (__trimInfo.trim[1] - ((dif_time * 100) / __trimInfo.media_duration));
			
			last = Math.round(100 * (Math.min(100 - (__trimInfo.trim[0] + Math.min(1, ((_global.app.options.frametime * 100) / __trimInfo.media_duration))), Math.max(0, n)))) / 100;
		}
		return {trim: first + ',' + last};
	}
	
	private function __trimaudio(dif_time : Number) : Object
	{	
		var data = {};
		if (__trimInfo.direction < 0) // decrease start while increasing length
		{
			var dt = (Math.max(__trimInfo.min_start, __trimInfo.orig_data.start + dif_time) - __trimInfo.orig_data.start);
			if (dif_time != dt) dif_time = dt;
			data = __trimvideo(dif_time);
			var trim = data.trim.split(',');
			var new_duration = _global.app.fpsTime(__trimInfo.media_duration - (((__trimInfo.media_duration * parseFloat(trim[0])) / 100) + ((__trimInfo.media_duration * parseFloat(trim[1])) / 100)));
			data.start = (__trimInfo.end_time - new_duration);
		}
		else
		{
			if (__trimInfo.max_start) 
			{
				var dt = (Math.min(__trimInfo.max_start, __trimInfo.end_time + dif_time) - __trimInfo.end_time);
				if (dif_time != dt) dif_time = dt;
			}
			data = __trimvideo(dif_time);
		}
		return data;
	}
	
	private function __trimeffect(dif_time : Number) : Object
	{
		var data = {};
		
		if (__trimInfo.direction < 0) // decrease start while increasing length
		{
			var data_start = ((__trimInfo.time != undefined) ? __trimInfo.time : __trimInfo.orig_data.start + dif_time);
			data_start = _global.app.fpsTime(Math.max(__trimInfo.min_start, Math.min(__trimInfo.max_start, data_start)));
			data.length = _global.app.fpsTime(__trimInfo.end_time - data_start);
			data.start = data_start;
		}
		else 
		{
			data.length = ((__trimInfo.time != undefined) ? __trimInfo.time - __trimInfo.orig_data.start : __trimInfo.orig_data.length + dif_time);
			if (__trimInfo.max_start) data.length = Math.min(__trimInfo.max_start - __trimInfo.orig_data.start, data.length)
			data.length = Math.max(_global.app.options.frametime, data.length);
		}
		return data;
	}

	private function __trimimage(dif_time : Number) : Object
	{
		var data = {};
		data.length = _global.app.fpsTime(((__trimInfo.time != undefined) ? __trimInfo.time - __trimInfo.orig_data.start : __trimInfo.orig_data.length + dif_time));
		return data;
	}
	
	private var __trimtransition : Function = __trimimage;
	private var __trimtheme : Function = __trimimage;
	
	private function __snapMouse(x_pos : Number) : Object
	{
		var matches = [];
		var x : Number;
		var d : Number;
		for (var k in __createdClips)
		{
			if (__trimInfo.clip == __createdClips[k].item) continue;
			if ((! __trimInfo.not_visual) && __createdClips[k].item.isVisual()) continue; 
			x = (__createdClips[k]._x + __createdClips[k].__back_mc._x);
			d = Math.abs(x_pos - x);
			if (config.snapto > d) matches.push({d: d, x: x, time: __createdClips[k].item.start + __createdClips[k].item.timelineStart()});
			x += __createdClips[k].__back_mc._width;
			d = Math.abs(x_pos - x);	
			if (config.snapto > d) matches.push({d: d, x: x, t: __createdClips[k].item.start + __createdClips[k].item.length - __createdClips[k].item.timelineEnd()});
		}
		if (matches.length) 
		{
			matches.sortOn('d', Array.NUMERIC);
			__trimInfo.time = matches[0].t;
			x_pos = matches[0].x;
		}
		return x_pos;
	}
	
	private function __trimMove()
	{
		var x_mouse = Math.min(viewWidth, Math.max(0, Math.round(_xmouse - config.iconwidth)));
		var scrolling = 0;
		__trimInfo.time = undefined;
		if (x_mouse < config.autoscroll) scrolling = -1;
		else if (x_mouse > (viewWidth - config.autoscroll)) scrolling = 1
		if (scrolling) __trimInfo.xmouse -= __doScroll(scrolling, true);
		if (__mode == 'time')
		{
			var do_snap = config.snap;
			if (Key.isDown(Key.SHIFT)) do_snap = ! do_snap;
			if (do_snap
				&& (__trimInfo.clip.type != 'transition')
				&& (__trimInfo.not_visual || (__trimInfo.direction > 0))
			) x_mouse = __snapMouse(x_mouse);
		}
		var dif = x_mouse - __trimInfo.xmouse;
		var dif_time = pixels2Time(dif);
		__trimInfo.data = this['__trim' + __trimInfo.clip.type](dif_time);
		com.moviemasher.Utility.MashUtility.changingProperties(__trimInfo.clip, __trimInfo.data);
		if (scrolling) __drawClips(true);
		else 
		{
			__drawClip(__trimInfo.clip);
		//	__startDrawing();
		}
			__createdClips['clip_' + __trimInfo.clip.id].drawPreview();
	}

	function __trimUp()
	{
		_global.app.dragging = false;
		com.moviemasher.Utility.MashUtility.changeProperties(__trimInfo.clip, __trimInfo.data);
		onMouseMove = undefined;
		onMouseUp = undefined;
		__trimInfo = undefined;
	}	
	
	private function __viewableClips() : Array
	{
		var first : Number;
		var last : Number;
		var viewable_clips = [];
		if (__mash)
		{
			if (mode == 'clip')
			{
				if (__mash.tracks.video.length)
				{
					first = Math.floor(hScroll / previewWidth);
					last = Math.ceil(viewWidth / previewWidth) + 1;
					last =  Math.min(__mash.tracks.video.length, first + last);
					viewable_clips = __mash.tracks.video.slice(first, last);
				}
			}
			else 
			{
				first = pixels2Time(hScroll);
				last = pixels2Time(viewWidth);
				
				var highs = {effect: 0, audio: 0, video: 0};
				var lows = {effect: 0, audio: 0, video: 0};
				
				var invisible_space = __vScroll;
				
				var visible_space = config.height;
				var type : String;
				var type_height : Number;
				var displayed : Boolean;
				var i : Number;
				var inc : Number;
				
				var types : Array = ['effect', 'video', 'audio'];
				for (var j = 0; j < 3; j++)
				{
					displayed = false;
					type = types[j];
					type_height = typeHeight(type);
					if ((type == types[1]) && _global.com.moviemasher.Media.Media.multitrackVideo) type_height += typeHeight('audio');
					
					i = ((type == types[0]) ? __tracks[type] - 1 : 0);
					inc = ((type == types[0]) ? -1 : 1);
					
					for (; ((i > -1) && (i < __tracks[type])); i += inc)
					{
						if (invisible_space > 0)
						{
							invisible_space -= type_height;
							if (invisible_space <= 0) visible_space += type_height + invisible_space;
						}
						if (invisible_space <= 0)
						{
							if (visible_space >= 0)
							{
								visible_space -= type_height;
								if (i < __mash.highest[type])
								{
									displayed = true;
									highs[type] = Math.max(highs[type], i + 1);
									lows[type] = Math.min((lows[type] ? lows[type] : i + 1), i + 1);
								}
							}
						}
					}
					if (displayed) viewable_clips = viewable_clips.concat(__mash.timeRangeClips(first, last, type, (type == 'video'), lows[type], highs[type])); // make sure they are all really viewable
				}
			}
		}
		return viewable_clips;
	}
	
	private function __vScrollReset() : Void
	{
		if (__mash)
		{
			var scrolls_needed : Boolean = false;
			var video_tracks = (_global.com.moviemasher.Media.Media.multitrackVideo ? 2 : 1);
			var new_scroll = __vScroll;
			var new_h = __contentHeight - config.height;
			if (new_h > 0)
			{
				__contentSize.height = new_h;
				__contentSize.vsize = (config.height * 100) / (__contentSize.height + config.height);
				scrolls_needed = true;
				if (vScroll > new_h) new_scroll = new_h;
				__maxScrolls.v = new_h;
			}
			else 
			{
				__maxScrolls.v = 0;
				new_scroll = 0;
			}
			if (__scrollsNeeded.v != scrolls_needed)
			{
				__scrollsNeeded.v = scrolls_needed;
				if (__watchedProperties.vscroll) dispatchEvent({type: 'propertyRedefined', property: 'vscroll', defined: __scrollsNeeded.v});
			}
			vScroll = new_scroll;
		}
	}
}