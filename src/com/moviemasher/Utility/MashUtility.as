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



/** Static class provides mechanisms for editing {@link com.moviemasher.Clip.Clip} and {@link com.moviemasher.Mash.Mash} objects.

*/
class com.moviemasher.Utility.MashUtility
{

	// All 'changing' functions are called repeatedly while controls are being dragged, then the 'change' function is called.
	// We only create an com.moviemasher.Core.Action after the drag is complete, so only the final adjustment is undoable.
	// This action calls the '__do' function. 

	
// CHANGE ATTRIBUTE VALUES FOR MULTIPLE SELECTED ITEMS
	
	static function changeProperties(item : Object, properties : Object)
	{
		if (__originalValue == undefined) changingProperties(item, properties);
		if (__originalValue == undefined) return;
	//_global.com.moviemasher.Control.Debug.msg('changeValues ' + property + ' ' + n);
		
		var undo_action = function() { com.moviemasher.Utility.MashUtility.__propertiesAction(this.item, this.old_values); }
		var do_action = function() { com.moviemasher.Utility.MashUtility.__propertiesAction(this.item, this.new_values); }
		com.moviemasher.Core.Action.factory(do_action, undo_action, {item: item, old_values: __originalValue, new_values: properties}, true);
		__originalValue = undefined;
	}

	static function changingProperties(item : Object, properties : Object)
	{
		if (__originalValue == undefined)
		{
			__originalValue = {};
			for (var k in properties)
			{
				__originalValue[k] = item.getValue(k);
			}
		}
		
		if (__propertiesAction(item, properties)) __originalValue = undefined;
		
		_global.com.moviemasher.Core.Panel.controls.player.drawFrame();
	}
	
	static function changeValues(items : Array, property : String, n)
	{
		if (__originalValue == undefined) changingValues(items, property, n);
		if (__originalValue == undefined) return;
	//_global.com.moviemasher.Control.Debug.msg('changeValues ' + property + ' ' + n);
		var new_values : Array = [];
		var z = items.length;
		for (var i = 0; i < z; i++)
		{
			new_values.push(n);
		}
		var undo_action = function() { com.moviemasher.Utility.MashUtility.__valuesAction(this.items, this.property, this.old_values); }
		var do_action = function() { com.moviemasher.Utility.MashUtility.__valuesAction(this.items, this.property, this.new_values); }
		com.moviemasher.Core.Action.factory(do_action, undo_action, {items: items, old_values: __originalValue, new_values: new_values, property : property}, true);
		__originalValue = undefined;
	}

	static function changingValues(items : Array, property : String, n)
	{
		if (__originalValue == undefined)
		{
			__originalValue = [];
			var z = items.length;
			for (var i = 0; i < z; i++)
			{
				__originalValue.push(items[i].getValue(property));
			}
		}
		var new_values : Array = [];
		var z = items.length;
		for (var i = 0; i < z; i++)
		{
			new_values.push(n);
		}
		if (__valuesAction(items, property, new_values)) __originalValue = undefined;
		
		_global.com.moviemasher.Core.Panel.controls.player.drawFrame();
	}

	static function insertItems(mash, items : Array, index : Number)
	{
		//_global.com.moviemasher.Control.Debug.msg('insertClips ' + index);
		items.sortOn('start', Array.NUMERIC);
		var z : Number = items.length;
		var undo_index : Number;
		var redo_indices = [];
		var undo_indices = [];
		var item;
		
		var redo_index = index;
		for (var i = 0; i < z; i++)
		{
			item = items[i];
			undo_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(mash.tracks.video, item);
			undo_indices.push({item: item, index: undo_index});
			if (undo_index > -1) 
			{
				if (undo_index < redo_index) redo_index--;
				mash.tracks.video.splice(undo_index, 1);
				item.mash = undefined;
			}
			redo_indices.push({item: item, index: redo_index});
			if (redo_index > -1) 
			{
				mash.tracks.video.splice(redo_index, 0, item);
				redo_index++;
				item.mash = mash;
			}
		}
		_global.com.moviemasher.Core.Panel.controls.timeline.selectedItems = ((index == -1) ? [] : items);
		var do_action = function() { com.moviemasher.Utility.MashUtility.__resetClipIndices(this.mash, this.redos); }
		var undo_action = function() { com.moviemasher.Utility.MashUtility.__resetClipIndices(this.mash, this.undos); }
		mash.invalidateLength();
		com.moviemasher.Core.Action.factory(do_action, undo_action, {undos: undo_indices, redos: redo_indices, mash: mash}, true);
	}
	
	static function insertTracks(mash, items : Array, track : Number, start_time : Number)
	{
	//_global.com.moviemasher.Control.Debug.msg('insertTracks track = ' + track + ' start_time = ' + start_time);
		var redos = [];
		var undos = [];
		var start_offset : Number;
		var track_offset : Number;
		var z = items.length;
		var ob;
		var item_track : Number;
		
		if (track != -1)
		{
			item_track = items[0].track;
			var minORmax : String = ((items[0].type == 'effect') ? 'max' : 'min');
			var select_start : Number = items[0].start;
			var select_track : Number = item_track;
			for (var i = 1; i < z; i++)
			{
				item_track = items[i].getValue('track');
				select_start = Math.min(select_start, items[i].start);
				select_track = Math[minORmax](select_track, item_track);
			}
			start_offset = start_time - select_start;
			track_offset = track - select_track;
		//	_global.com.moviemasher.Control.Debug.msg('track_offset = ' + track_offset);
		}
		
		for (var i = 0; i < z; i++)
		{
			ob = {};
			item_track = items[i].track;
				
			if (track != -1)
			{
				ob.track = item_track + track_offset;
				ob.time = items[i].start + start_offset;
			}
			else ob.track = -1;
		
			redos.push(ob);
			undos.push({track: (items[i].mash ? item_track : -1), time: items[i].start});
		}
		var do_action = function() { com.moviemasher.Utility.MashUtility.__resetTracks(this.mash, this.items, this.redos); }
		var undo_action = function() { com.moviemasher.Utility.MashUtility.__resetTracks(this.mash, this.items, this.undos); }
		com.moviemasher.Core.Action.factory(do_action, undo_action, {items: items, redos: redos, undos: undos, mash: mash});
	}
	

// PRIVATE CLASS PROPERTIES 
	private static var __originalValue = undefined;

// PRIVATE CLASS METHODS
 
	private static function __resetClipIndices(mash, indices : Array)
	{
		var z : Number = indices.length;
		var mash_index : Number;
		var ob;
		var items = [];
		for (var i = z - 1; i > -1; i--)
		{
			ob = indices[i];
			mash_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(mash.tracks.video, ob.item);
			if (mash_index > -1) 
			{
				mash.tracks.video.splice(mash_index, 1);
				ob.item.mash = undefined;
			}
			if (ob.index > -1) 
			{
				mash.tracks.video.splice(ob.index, 0, ob.item);
				items.push(ob.item);
				ob.item.mash = mash;
			}
		}
		mash.invalidateLength();
		_global.com.moviemasher.Core.Panel.controls.timeline.selectedItems = items;
	}
	
	private static function __resetTracks(mash, items : Array, positions : Array)
	{
		var item;
		var z = items.length;
		var track_index : Number;
		var start_time : Number;
		var track : Number;
		var type : String;
		var container : Array;
		for (var i = 0; i < z; i++)
		{
			item = items[i];
			type = item.type;
			container = mash.tracks[type];
			track = positions[i].track;
			start_time = positions[i].time;
			if (track != -1) item.setValue('track', track);
			if (start_time != undefined) item.setValue('start', start_time);	
			track_index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(container, item);
			if (track_index == -1)
			{
				if (track > -1)
				{
					container.push(item);
					item.mash = mash;
				}
			}
			else if (track == -1) 
			{
				item.mash = undefined;
				container.splice(track_index, 1);
			}
		}
		_global.com.moviemasher.Core.Panel.controls.timeline.selectedItems = ((track > -1) ? items : []);
		mash.invalidateLength(type);
	}
	
	private static function __valuesAction(items : Array, property : String, values : Array) : Boolean
	{
		var z = items.length;
		var item;
		var response : Boolean;
		var no_action : Boolean = false;
		var invalidated_length : Boolean = false;
		for (var i = 0; i < z; i++)
		{
			item = items[i];
			response = item.setValue(property, values[i]);
			if (response) invalidated_length = true;
			else if (response == undefined) no_action = true;
		}
		if (invalidated_length) item.mash.invalidateLength(item.type);
		
		return no_action;
	}
	private static function __propertiesAction(item : Object, properties : Object) : Boolean
	{
		var response : Boolean;
		var no_action : Boolean = false;
		var invalidated_length : Boolean = false;
		for (var property in properties)
		{
			response = item.setValue(property, properties[property], true);
			//if (item.getValue(property) != properties[property]) _global.app.msg('__propertiesAction length ' + item.getValue(property) + ' != ' + properties[property]);
			if (response) invalidated_length = true;
			else if (response == undefined) no_action = true;
		}
		if (invalidated_length) item.mash.invalidateLength(item.type);
		
		return no_action;
	}
}


