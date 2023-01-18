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


/** Edit decision list, made up of clips.

*/

import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.BitmapData;

/** Class representing a single mash tag in the configuration.
*/
 
class com.moviemasher.Mash.Mash
{

/** static function returns Mash object based on attributes.id, creating if needed.
If a Mash object with this id already exists, it is returned.
@param attributes object containing mash properties - if no 'id' key found, a unique 32 charactor hash is generated.
@return Mash object, with no clips.
*/	
	static function factory(attributes : Object) : com.moviemasher.Mash.Mash
	{
		if (attributes.id == undefined)
		{
			if (attributes == undefined) attributes = {};
			attributes.id = com.meychi.MD5.newID();
		}
		var sharedKey = _global.com.moviemasher.Utility.StringUtility.safeKey(attributes.id);
		if (__instances[sharedKey] == undefined) 
		{
			__instances[sharedKey] = new Mash();
			__instances[sharedKey].__fromAttributes(attributes);
			
		}
		return __instances[sharedKey];
	}
	
/** static function returns Mash object for mash tag node, creating if needed.
If a Mash object with node.attributes.id already exists, it is returned.
@param node XMLNode representation of mash tag.
If no 'id' attribute found, a unique 32 charactor hash is generated.
@return Mash object.
Its tracks will be populated with {@link com.moviemasher.Clip.Clip} objects 
for any clip tags encountered in node.childNodes.
*/	
	
	static function fromXML(node: XMLNode) : com.moviemasher.Mash.Mash
	{
		//_global.com.moviemasher.Control.Debug.msg('fromXML in ' + node.attributes.id);
				
		var mash = factory(node.attributes);
		
		var clip_node : XMLNode;
		var clip : com.moviemasher.Clip.Clip;
		var z : Number = node.childNodes.length;
		var item_type : String;
		if (z)
		{	
			for (var i = 0; i < z; i++)
			{
				clip_node = node.childNodes[i];
				if (clip_node.nodeName == 'clip')
				{
					clip = com.moviemasher.Clip.Clip.fromXML(clip_node);
					clip.mash = mash;
					item_type = clip.isVisual() ? 'video' : clip.type;
					if (! _global.com.moviemasher.Control.Debug.isFalse(clip, "Invalid Clip Node: " + clip_node.toString()))
					{
						mash.tracks[item_type].push(clip);
					}
				}
			}
		}
		// recalculate __lengths without dirtying
		mash.invalidateLength('video', true);
		mash.invalidateLength('audio', true);
		mash.invalidateLength('effect', true);

		return mash;
	}
	
	
/** Object with 'width' and 'height' properties as defined in attributes, or mash option tag. */
	function get dimensions() : Object 
	{
		var conf;
		if (values.width) conf = values;
		else conf = _global.app.options.mash;
		return {width: conf.width, height: conf.height}; 
	}
	
/** Object with 'audio' and 'effect' properties containing highest track value for each type. */	
	var highest : Object; // holds highest track created for audio and effects
	
/** Number of seconds in entire mash, including all track types */

	function get length() : Number 
	{
		return __length;	
	}
/** Boolean is true when Mash has unsaved changes */

	var needsSave : Boolean = false;

/** Object with 'audio', 'effect' and 'video' properties each containing an Arrays of {@link com.moviemasher.Clip.Clip} objects. */

	var tracks : Object; // holds arrarys of video, audio and effects Items independently


	var values : Object; // holds attributes found in 'mash' tag
	


	// SERIALIZED
	//var label : String = "Untitled Mash";
	//var bgcolor : String = '000000';
	
	//var width : Number = 320;
	//var height : Number = 240;
	private function Mash()
	{
		if (! __madeEventDispatcher)
		{
			__madeEventDispatcher = true;
			mx.events.EventDispatcher.initialize(com.moviemasher.Mash.Mash.prototype);
		}
		__lengths = {audio: 0, effect: 0, video: 0};
		highest = {audio: 0, effect: 0, video: 0};
		tracks = {audio: [], effect: [], video: []}; // video actually holds ALL visual Items
		
		values = {zoom: .3, location: 0};
		
	}

	
		// Declare mashed-in methods.
/** Add handler for specified event.
See mx.events.EventDispatcher API for details.
@param event string containing event name
@param handler object or movieclip event handler
*/
	function addEventListener(event:String, handler) : Void {}

	

	function attributeValues() : Object
	{
		var ob = {};
		for (var k in _global.app.options.mash.dataFields)
		{
			ob[k] = values[k];
		}
		return ob;
	}
	

	function bestTrackTime(atTime : Number, for_duration : Number, ignore_items : Array, on_track : Number, track_count : Number, item_type : String)
	{		
		if (atTime < 0) return atTime;
		var z : Number;
		var fTracks = timeRangeTrackItems(atTime, for_duration, ignore_items, on_track, track_count, item_type);
		z = fTracks.length;
		
		//_global.com.moviemasher.Control.Debug.msg('z = ' + z + ' on_track = ' + on_track + ' track_count = ' + track_count);
		
		var track;
		var best_time = -1;
		var n : Number;
		if (z)
		{
			for (var i = 0; i < z; i++)
			{
				track = fTracks[i];
				n = track.start + track.length;
				if (track.start < atTime) // try to put it to the right
				{
					fTracks = timeRangeTrackItems(n, for_duration, ignore_items, on_track, track_count, item_type);
					if (! fTracks.length) best_time = n;
					break;
				}
				if (n > (atTime + for_duration))
				{
					n = track.start - for_duration;
					if (n >= 0)
					{
						fTracks = timeRangeTrackItems(n, for_duration, ignore_items, on_track, track_count, item_type);
						if (! fTracks.length) best_time = n;
					}
					break;
				}
			}
		}
		else best_time = atTime;
		return best_time;
	}
		
	
	function clearBuffer()
	{
		var mc = _global.app.mashClip(this);
		mc.removeMovieClip();
	}
	

	function dirtyMash(property : String, value, dont_dirty : Boolean) 
	{
		var was_clean = (__dirty == undefined);
		
		if (was_clean && (! dont_dirty)) 
		{
			__dirty = {};
			needsSave = true;
			dispatchEvent({type: 'mashDirtyChange'});
		}
		if (property.length && (values[property] != value)) 
		{
			if ((! dont_dirty) && (__dirty[property] == undefined)) __dirty[property] = values[property];
			values[property] = value;
			dispatchEvent({type: 'mash' + com.moviemasher.Utility.StringUtility.ucwords(property) + 'Change'});
		}
	}



	
/** Retrieve value of media property from configuration.
@param property String containing property name.
@return String or Number representation of value.
*/
	function getValue(property)
	{
		var value;
		
		switch (property)
		{
			case 'completed': // percent based position
			{
				value = ((values.location * 100) / __length);
				break;	
			}
			case 'duration': property = 'length'; // and fallthrough
			default: value = ((values[property] == undefined) ? this[property] : values[property]);
		}		
		return value;
	}	


	
	function invalidateLength(item_type, dont_dirty)
	{
		if (item_type == undefined) item_type = 'video';
		if (! dont_dirty) dirtyMash();	
		switch (item_type)
		{
			case 'audio':
			case 'effect':
			{
				__recalculateTrackLength(item_type, dont_dirty);
				break;
			}
			default:
			{
				item_type = 'video';
				__recalculateVideoLength(dont_dirty);
				break;
			}
		}
		if (! dont_dirty) dispatchEvent({type: 'mashTrackChange', property: item_type});
	}
	
	function isVisual() : Boolean
	{
		return Boolean(highest.video);//(tracks.video.length > 0);
	}

/** Remove handler for specified event.
See mx.events.EventDispatcher API for details. 
@param event string containing event name
@param handler object or movieclip event handler
*/
	function removeEventListener(event:String, handler) : Void  {}
	
	

	/** Sends data to server.
	* @param configuration object with 'mode' key
	*/
	function save(control : com.moviemasher.Control.Control) : Void
	{
		var mash_xml = toXML();
		var mode = control.getValue('mode');
		switch(mode)
		{
			case 'local':
			{
				
				var lso : SharedObject = SharedObject.getLocal(_global.com.moviemasher.Utility.StringUtility.safeKey(_global.app.options.mash.id));
				lso.data.mash = mash_xml.toString();
				lso.flush();
				__didSave();
				break;	
			}
			case 'burn':
			case 'remote':
			{
				var url = control.getValue('url');
				var idparam = control.getValue('idparam');
				if (! _global.com.moviemasher.Control.Debug.isFalse(url.length, "Save control with no 'url' attribute"))
				{
					if (idparam.length)
					{
						if (url.indexOf('?') == -1)
						{
							url += '?';	
						}
						else url += '&';
						url += idparam + '=' + values.id;
					}
					var xml = new XML();
					xml.contentType = "text/xml";
					var node = xml.createElement('moviemasher');
					if (mode == 'burn') node.attributes.config = _global.root.config;
					xml.appendChild(node);
					node.appendChild(mash_xml);
				
					
					var result_xml = new XML();
					result_xml.contentType = "text/xml";
					result_xml.ignoreWhite = true;
					result_xml.mmOwner = this;
					result_xml.mmSaveControl = control;
					result_xml.onData = function(d) { this.mmOwner.__saveDidLoad(d, this.mmSaveControl); };
					xml.sendAndLoad(url, result_xml);
				}
				break;	
			}
		}
	}



	function setValue(property, value) : Boolean
	{
		var do_dirty : Boolean = false;
		switch (property)
		{
			case 'completed': // percent based position
			{
				property = 'location';
				value = ((value * __length) / 100);
				// intentional fallthrough to location
			}
			case 'location':
			{
				value = Math.max(0, Math.min(__length - _global.app.options.frametime, _global.app.fpsTime(value)));
				//_global.com.moviemasher.Control.Debug.msg('location: ' + value);
				break;	
			}
			case 'zoom':
			{
				
				break;	
			}
			default: do_dirty = true;
		}
		if (values[property] != value) dirtyMash(property, value, ! do_dirty);
		do_dirty = (do_dirty ? false : undefined);
		return do_dirty;
	}
	
	
	function sortByTimeTrack(a, b)
	{
		if (a.start < b.start) return -1;
		if (a.start > b.start) return 1;
		return sortByTrack(a, b);
		
	}
	function sortByTrack(a, b)
	{
		var a_track = a.track;
		var b_track = b.track;
		if (a_track < b_track) return -1;
		if (a_track > b_track) return 1;
		return 0;
	}
	
	
	function time2Bitmap(project_time : Number, bm_width : Number, bm_height : Number, effect_track: Number, extended : Boolean)
	{
		
		project_time = _global.app.fpsTime(project_time);
		var info = {};
				//timeRangeClips(project_time, 0);//
		var v_clips = __visualClipsAtTime(project_time);
		var z = v_clips.length;
		var dims = dimensions;
		//_global.com.moviemasher.Control.Debug.msg('dims ' + dims.width + 'x' + dims.height);
		if (extended) info.clip_total = z;
		
		var needs_load = false;
		var bm : BitmapData = undefined;
		switch(z)
		{
			case 0: 
			case 1: 
			{
				if ((! z) || (v_clips[0].type == 'transition')) 
				{
					if (extended) info.blank = 1;
					bm = __opaqueBitmap();
				}
				else if (v_clips[0].needsLoad(project_time, dims)) 
				{
					if (extended) info.clip_0_loading = 1;
					needs_load = true;
				}
				break;
			}
			case 2:
			{
				if (v_clips[0].type == 'transition') 
				{
					if (extended) info.transitionfirst = 1;
					v_clips.unshift(0);
				}
				else
				{
					if (extended) info.transitionlast = 1;
					v_clips.push(0);
				}
				// intentional fallthrough to 3
			}
			case 3:
			{
				if (v_clips[1].type == 'transition') //_global.com.moviemasher.Control.Debug.isFalse((v_clips[1].type == 'transition'), "Mash.time2Bitmap with v_clips[1].type != 'transition'"))
				{
					if (v_clips[0] && __prepareTransitionedClip(v_clips[0], project_time, dims, true)) 
					{
						//_global.app.msg('needs load 0 ' + v_clips[0].type);
						if (extended) info.clip_0_loading = v_clips[0].media.getValue('id');
						needs_load = true;
					}
					if (v_clips[2] && __prepareTransitionedClip(v_clips[2], project_time, dims, false))
					{
						//_global.app.msg('needs load 2 ' + v_clips[2].type);
						if (extended) info.clip_2_loading = v_clips[2].media.getValue('id');
						 needs_load = true;
					}
					if (v_clips[1].needsLoad(project_time, dims, v_clips[0], v_clips[2])) 
					{
						//_global.app.msg('needs load ' + v_clips[1].type);
						if (extended) info.clip_1_loading = v_clips[1].media.getValue('id');
						needs_load = true;
					}
					z = 3;
				}
				else
				{
					info.transitiontype = v_clips[1].type;
					info.project_time = project_time;
					info.clip_0 = v_clips[0].media.getValue('id');
					info.clip_0_start = v_clips[0].start;
					info.clip_1_start = v_clips[1].start;
					info.clip_0_length = v_clips[0].length;
					info.clip_1_length = v_clips[1].length;
					if (v_clips[0].padStart) info.clip_0_padStart = v_clips[0].padStart;
					if (v_clips[1].padStart) info.clip_1_padStart = v_clips[1].padStart;
					if (v_clips[0].padEnd) info.clip_0_padEnd = v_clips[0].padEnd;
					if (v_clips[1].padEnd) info.clip_1_padEnd = v_clips[1].padEnd;
					
					//info.trans_index = tracks.video[v_clips[1].index - 1].index;
					//info.trans_padend = tracks.video[v_clips[1].index - 1].padEnd;
					//info.trans_padstart = tracks.video[v_clips[1].index - 1].padStart;
					info.clip_1 = v_clips[1].media.getValue('id');
					info.trans = tracks.video[v_clips[1].index - 1].type + ' ' + tracks.video[v_clips[1].index - 1].start + ' ' + tracks.video[v_clips[1].index - 1].length; 
					needs_load = true; // what else to do???
				}
			}
		}
		
		var effects : Array;
		var effects_count : Number = 0;
		var reason;
		if (effect_track) 
		{
			effects = timeRangeClips(project_time, 0, 'effect');	
			effects_count = effects.length;	
			if (extended) info.effects_total = effects_count;
			for (var i = 0; i < effects_count; i++)
			{
				if (effects[i].getValue('track') > effect_track) continue;
				if (reason = effects[i].needsLoad(project_time, dims)) 
				{
					//_global.app.msg('needs load e ' + effects[i].media.getValue('id'));
					info['effect_' + i + '_loading'] = effects[i].media.getValue('id');
					info['effect_' + i + '_reason'] = reason;
					needs_load = true;
				}
			}
		}
		//_global.com.moviemasher.Control.Debug.msg('dims ' + dims.width + 'x' + dims.height);
			
		// take a picture
		if (! needs_load)
		{
			//_global.com.moviemasher.Control.Debug.msg('Mash.Loaded ' + v_clips.length);
			var mash_clip = _global.app.mashClip(this);
			var needs_clear : Boolean = (mash_clip.track_0.filterClips == undefined)
			if (needs_clear) __clearTrackClip(mash_clip.track_0);
			
			var back_color = undefined;
			
			if (! bm)
			{
				if (v_clips[0]) 
				{
					if (extended) info.clip_0 = v_clips[0].media.getValue('id');
					v_clips[0].bitmapping(false);
					back_color = v_clips[0].backColor();
				}
				if (v_clips[2]) 
				{
					
					if (extended) info.clip_2 = v_clips[2].media.getValue('id');
				
					
					v_clips[2].bitmapping(false);
					if (back_color == undefined) back_color = v_clips[2].backColor();
				}
				if (back_color == undefined) back_color = getValue('bgcolor');
				if (v_clips[1]) 
				{
					v_clips[1].bitmapping(false, v_clips[0], v_clips[2]);
					if (extended) info.clip_1 = v_clips[1].media.getValue('id');
				}
				
			}
		//	else _global.app.msg('BM! ' + effects_count);
			// check to make sure at least one clip populated main visual track clips
			if (! mash_clip.track_0.filterClips.length) mash_clip.track_0.filterClips.push(mash_clip.track_0);
			for (var i = 0; i < effects_count; i++)
			{
				if (effects[i].track > effect_track) continue;
				track_name = 'track_' + effects[i].track;
				if (needs_clear) __clearTrackClip(mash_clip[track_name]);
				effects[i].bitmapping(false);
				info['effect_' + i] = effects[i].media.getValue('id');
			}
			
			var matrix = new Matrix();
			//if (v_clips.length) back_color = 'FFFF00';
			matrix.translate(Math.round(dims.width / 2), Math.round(dims.height / 2));
			var temp_bm = new BitmapData(dims.width, dims.height, true, com.moviemasher.Utility.DrawUtility.hexColor(back_color, 'FF'));
			temp_bm.draw(mash_clip, matrix);
			if ( ! ((dims.width == bm_width) && (dims.height == bm_height)))
			{
				matrix = new Matrix();
				matrix.scale(bm_width / dims.width, bm_height / dims.height);
				bm = new BitmapData(bm_width, bm_height);
				bm.draw(temp_bm, matrix);
				temp_bm.dispose();
			}
			else bm = temp_bm;
			if (v_clips[0]) v_clips[0].bitmapping(true);
			if (v_clips[2]) v_clips[2].bitmapping(true);
			if (v_clips[1]) v_clips[1].bitmapping(true, v_clips[0], v_clips[2]);
			var track_name : String;
			
			for (var i = 0; i <= effects_count; i++)
			{
				if (i)
				{
					effects[i - 1].bitmapping(true);
					if (effects[i - 1].track > effect_track) continue;
				}
				track_name = 'track_' + (i ? effects[i - 1].track : 0);
				__clearTrackClip(mash_clip[track_name]);
			}
		}
		
		if (needs_load) bm = undefined;
		if (extended)
		{
			info.bitmap = bm;
			
			return info;
		}
		return bm;
	}
	
	
	
	function time2FreeTrack(project_time, track_duration, item_type, tracks)
	{
		if (tracks == undefined) tracks = 1;
		var a_clips = timeRangeClips(project_time, track_duration, item_type);
		a_clips.sort(sortByTrack);
		var z = a_clips.length;
		var defined_tracks : Object = {};
		for (var i = 0; i < z; i++)
		{
			defined_tracks['t' + a_clips[i].track] = true;
		}
		var track = 0;
		var track_ok : Boolean = false;
		while (! track_ok)
		{
			track_ok = true;
			track ++;
			z = track + tracks
			for (var i = track; i < z; i++)
			{
				if (defined_tracks['t' + i]) 
				{
					track_ok = false;
					break;
				}
			}
		}
		return track;
	}

	function timeRangeClips(atTime : Number, for_duration : Number, item_type : String, collapse_transitions : Boolean, first_track : Number, last_track : Number)
	{
		if (item_type == undefined) item_type = 'video';
		var time_clips = [];
		var clip;
		var end_time = atTime + for_duration;
		var av_clips = tracks[item_type];
		var clip_start : Number;
		var clip_end : Number;
		var z = av_clips.length;
		for (var i = 0; i < z; i++)
		{
			clip = av_clips[i];
			clip_start = clip.start - clip.padStart;
			if (collapse_transitions) clip_start += clip.timelineStart();
			if (clip_start > end_time) break;
			clip_end = clip.start + clip.length + clip.padEnd;
			if (collapse_transitions) clip_end -= clip.timelineEnd();
			
			if (clip_end > atTime) 
			{
				if (item_type != 'video') // see if track is valid
				{
					if ((clip.track < first_track) || (clip.track > last_track)) continue;
				}
				time_clips.push(clip);
			}
		}
		time_clips.sort(sortByTrack);
		return time_clips;
	}
	
		
	function timeRangeTrackItems(atTime, for_duration, ignore_items, on_track, track_count : Number, item_type : String)
	{
		var z : Number;
		var ignore_ids = {};
		if (ignore_items)
		{
			z = ignore_items.length;
			for (var i = 0; i < z; i++)
			{
				ignore_ids['id_' + ignore_items[i].id] = true;
			}
		}		
		var items = [];
		var clip;
		var end_time = atTime + for_duration;
		z = tracks[item_type].length;
		var start_range = ((item_type == 'effect') ? (on_track - track_count) + 1 : (on_track))
		var end_range = ((item_type == 'effect') ? on_track : (on_track + track_count - 1));
		
		var clip_track;
		for (var i = 0; i < z; i++)
		{
			clip = tracks[item_type][i];
			clip_track = clip.track
			if (ignore_ids['id_' + clip.id] != undefined) continue;
			if ((clip_track < start_range) || (clip_track > end_range)) continue;
			if (clip.start >= end_time) break;
			if ((clip.start + clip.length) > atTime) items.push(clip);
		}
		return items;
	}


	function toXML() : XMLNode
	{
		
		var node : XMLNode = new XMLNode(1, "mash");
		__toAttributes(node.attributes);
		var z : Number;
		for (var k in tracks)
		{
			z = tracks[k].length;
			for (var i = 0; i < z; i++)
			{
				node.appendChild(tracks[k][i].toXML());
			}
		}
		return node;

	}
	function transitionClips() : Array
	{
		var transition_clips : Array = [];
		
		var location = getValue('location');
		//timeRangeClips(location, 0);//
		var clips = __visualClipsAtTime(location);
		var z = clips.length;
		if (z == 3) 
		{
			transition_clips.push(clips[0]);
			transition_clips.push(clips[2]);
		}
		else
		{
			var clip;
			for (var i = 0; i < z; i++)
			{
				clip = clips[i];
				if (clip.type != 'transition')
				{
					break;	
				}
			}
			
			if (clip && (clip.type != 'transition')) // found a non transition clip
			{
				transition_clips.push(clip);
				var dir : Number = -1;
				
				z = tracks.video.length;
				var index = com.moviemasher.Utility.ArrayUtility.indexOf(tracks.video, clip);
				if ((index < (z - 1)) && (location > (clip.start + (clip.length / 2)))) 
				{
					
					dir = 1;
				}
				index += dir;
				for (var i = index; ((i > -1) && (i < z)); i += dir)
				{
					clip = tracks.video[i];
					if (clip.type != 'transition')
					{
						if (clip.start > transition_clips[0].start) transition_clips.push(clip);
						else transition_clips.unshift(clip);
						break;
					}
				}	
			}
		}
		return transition_clips;
		
	}
	
	function transRun(index, direction) // returns index = last trans, longest = greatest run length
	{
		if (direction == undefined) direction = 1;
		
		var return_ob = {freezestart: false, freezeend: false, index: index - direction, longest: 0, transitions: []};
		var z = tracks.video.length;
		var clip;
		for (var i = index; ((direction == 1) ? i < z : i > -1); i += direction)
		{
			clip = tracks.video[i];
			switch (clip.type)
			{
				case 'transition':
				{
					return_ob.longest = Math.max(clip.length, return_ob.longest);
					if (clip.getValue('freezestart')) return_ob.freezestart = true;
					if (clip.getValue('freezeend')) return_ob.freezeend = true;
					return_ob.transitions.push(clip);
					return_ob.index += direction;
					break;
				}
				default:
				{
					return_ob.clip = clip;
					return return_ob;
				}
			}
		}
		return return_ob;
	}
	
	
	

// PRIVATE INTERFACE

	// make class into an EventDispatcher
	private static var __instances : Object = {}; // avoids duplicate objects for same IDs
	private static var __madeEventDispatcher : Boolean = false;
	
	private var __dirty : Object;
	private var __lengths : Object; // holds duration of video, audio and effects tracks independently
	private var __opaqueFrame : BitmapData;
	private var __length = 0;
		
	
	private function __clearTrackClip(track_mc)
	{
		var y : Number = track_mc.filterClips.length;
		var filter_clip : MovieClip;
		for (var j = 0; j < y; j++)
		{
			filter_clip = track_mc.filterClips[j];
			filter_clip.transform.matrix = new Matrix();
			filter_clip.filters = [];
			filter_clip.transform.colorTransform = new ColorTransform();
		}
		track_mc.filterApplied = false;
		track_mc.matrixApplied = false;
		track_mc.filterClips = [];
	}
	private function __didSave()
	{
		__dirty = undefined;
		needsSave = false;
		dispatchEvent({type: 'mashDirtyChange'});
	}

	
/** Broadcast event to handlers.
See mx.events.EventDispatcher API for details. 
@param event object with 'type' key equal to event name
*/
	private function dispatchEvent(event : Object) : Void {}

	
	
	
		
	private function __fromAttributes(ob : Object)
	{
		for (var k in ob) 
		{
			//_global.com.moviemasher.Control.Debug.msg('Mash.' + k + ' = ' + 	ob[k]);
			values[k] = com.moviemasher.Utility.XMLUtility.flashValue(ob[k]);
		}
	}	
	
	private function __opaqueBitmap() : BitmapData
	{
		//_global.com.moviemasher.Control.Debug.msg('__opaqueBitmap');
		if (! __opaqueFrame) 
		{
			var dims = dimensions;
			var back_color = com.moviemasher.Utility.DrawUtility.hexColor(getValue('bgcolor'));
			__opaqueFrame = new BitmapData(dims.width, dims.height, false, back_color);
		}
		return __opaqueFrame;
	}
	
	private function __prepareTransitionedClip(clip : com.moviemasher.Clip.Clip, project_time : Number, dims : Object, is_first : Boolean) : Boolean
	{
		var trans_time = project_time;
		if (is_first)
		{
			trans_time = (clip.start + clip.length) - _global.app.options.frametime;
			if (project_time < trans_time) 
			{
				//_global.com.moviemasher.Control.Debug.msg('Resetting left ' + is_first + ' ' + project_time + ' to ' + trans_time);
				trans_time = project_time;
			}
		}
		else
		{
			trans_time = clip.start;
			if (project_time > trans_time) trans_time = project_time;
		}
		return clip.needsLoad(trans_time, dims);
	}

	private function __recalculateTrackLength(item_type, dont_dirty : Boolean)
	{
		
		var a = tracks[item_type];
		
		a.sort(sortByTimeTrack);
		var cur_time : Number = 0;
		var z = a.length;
		var highest_track = 0;
		
		for (var i = 0; i < z; i++)
		{
			cur_time = Math.max(cur_time, a[i].length + a[i].start);
			highest_track = Math.max(highest_track, a[i].track);
		}
		if (__lengths[item_type] != cur_time)
		{
			__lengths[item_type] = cur_time;
			cur_time = Math.max(__lengths.effect, Math.max(__lengths.audio, __lengths.video));
			if (__length != cur_time)
			{
				__length = cur_time;
				if (! dont_dirty) dispatchEvent({type: 'mashLengthChange'});
			}
		}
		if (highest[item_type] != highest_track)
		{
			highest[item_type] = highest_track;
			if (! dont_dirty) dispatchEvent({type: 'mashTracksChange', type: item_type});
		}
		
	}
	
	private function __recalculateVideoLength(dont_dirty : Boolean)
	{
		var z : Number = tracks.video.length;
		
		var cur_time : Number = 0;
		var clip;
		var left_clip;
		var right_clip;
		var transitions : Array = [];
		var run : Object;
		var last_type : String = '';
		var type : String;
		//var longest : Number = 0;
		var left_padding : Number = 0;
		var right_padding : Number = 0;
		var trans_offset : Number = 0;
		var left_offset : Number = 0;
		var right_offset : Number = 0;
		//var freezestart : Boolean = false;
		//var freezeend : Boolean = false;
		var last_transition : Object;
		
		var y : Number;
		for (var i = 0; i < z; i++)
		{
			clip = tracks.video[i];
			clip.index = i;
			type = clip.type;
			switch (type)
			{
				case 'transition':
				{
				//	longest = clip.length;
				//	if (clip.freezestart) freezestart = true;
				//	if (clip.freezeend) freezeend = true;
					last_transition = clip;
					break; // this is the first transition
				}
				default: // non transition clip
				{
					clip.padStart = clip.padEnd = 0;
					if (last_transition) // preceeded by one or more transitions, cur_time = the end time of last non trans clip
					{
						if (left_clip) left_padding = left_clip.padEnd = __transitionBuffer(left_clip.length, last_transition.length, last_transition.freezestart);
						else left_padding = last_transition.length;
						right_clip = clip;
						right_padding = right_clip.padStart = __transitionBuffer(right_clip.length, last_transition.length, last_transition.freezeend);
						
						//y = cur_time;
						
						cur_time -= last_transition.length;
						
						cur_time += left_padding;
						
						last_transition.start = _global.app.fpsTime(cur_time);
						//last_transition.setValue('length', (y - right_padding) - cur_time, true);
						
						last_transition = undefined;
						cur_time += right_padding;
						
					}
					clip.start = _global.app.fpsTime(cur_time);
					cur_time += clip.length;
				
					//freezestart = freezeend = false;
					
					left_clip = clip;
				}
			}
			last_type = type;
		}
		if (last_transition) // mash ends with transitions
		{
			if (left_clip) left_padding = left_clip.padEnd = __transitionBuffer(left_clip.length, last_transition.length, last_transition.freezestart);
			else left_padding = last_transition.length;
			cur_time += left_padding;
			last_transition.start = _global.app.fpsTime(cur_time - last_transition.length);
		}	
		if (__lengths.video != cur_time)
		{
			__lengths.video = cur_time;
			cur_time = Math.max(__lengths.effect, Math.max(__lengths.audio, __lengths.video));
			if (__length != cur_time)
			{
				__length = cur_time;
				dispatchEvent({type: 'mashLengthChange'});
				
			}
		}
		if (Boolean(highest.video) != Boolean(z))
		{
			highest.video = (z ? 1 : 0);
			if (! dont_dirty) dispatchEvent({type: 'mashTracksChange', type: 'video'});

		}
	}
	

	private function __saveDidLoad(response : String, control : com.moviemasher.Control.Control)
	{
		__didSave();
	}
	

	private function __toAttributes(ob : Object)
	{
		for (var k in values) ob[k] = String(values[k]);
	}
	private function __transitionBuffer(clip_time : Number, trans_time : Number, is_stopped : Boolean) : Number
	{
		if (is_stopped) return trans_time;
		var target_time = trans_time + (clip_time / 2);
		target_time -= clip_time;
		
		
		target_time = _global.app.fpsTime(target_time);
		//Math.ceil(target_time * _global.app.options.video.fps) / _global.app.options.video.fps;
		return Math.max(target_time, 0);
	}
	
	private function __visualClipsAtTime(atTime : Number)
	{
		var time_clips = [];
		var clip;
		var z = tracks.video.length;
		var end_time : Number;
		for (var i = 0; i < z; i++)
		{
			clip = tracks.video[i];
			
			if (time_clips.length)
			{
				if (clip.type == 'transition')
				{
					time_clips.push(clip);
					if ((i + 1) < z) time_clips.push(tracks.video[i + 1]);
				}
				break;
			}
			if (clip.type == 'transition')
			{
			//	i++; // skip the next one too
				continue;
			}
			if (_global.app.fpsTime(clip.start - clip.padStart) > atTime) break;
			end_time = (clip.start + clip.length + clip.padEnd);
			if ((_global.app.fpsTime(end_time) > atTime) && ((! i) || (clip.type != 'transition'))) time_clips.push(clip);
			
		}
		//_global.app.msg('clips = ' + time_clips.length);
		return time_clips;
	}

		
	

}