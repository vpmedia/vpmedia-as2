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


import flash.filters.ConvolutionFilter;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Matrix;
import flash.geom.ColorTransform;

/** Abstract class representing an instance of a {@link com.moviemasher.Media.Media} object in a {@link com.moviemasher.Mash.Mash}
object.
The {@link com.moviemasher.Control.TimelinePreview} object is a graphical representation of a
clip visible, within the {@link com.moviemasher.Control.Timeline} control.
*/
class com.moviemasher.Clip.Clip
{

// PUBLIC CLASS METHODS

/** Static Function called periodically to flush clip buffers.
Called by the {@link com.moviemasher.Core.App} singleton every five seconds.
@param time Number of seconds since clip last displayed.
@param ticks Number of ticks that the function is allowed to run.
*/
	static function flush(time: Number, ticks : Number) : Void
	{
		var d = new Date();
		var start_time : Number = d.getTime();
		var k : String;
		var did_flush : Boolean = false;
		var outa_time : Boolean = false;
		var active_instances : Object = {};
		for (k in __activeInstances)
		{
			if ((! outa_time) && (__activeInstances[k].__lastDisplayTime < time))
			{
				if (__activeInstances[k].__clearMovieEffects(time))
				{
					if (! did_flush) did_flush = true;
				}
			}
			if (outa_time || (__activeInstances[k].__lastDisplayTime >= time)) active_instances[k] = __activeInstances[k];
			if (! outa_time)
			{
				d = new Date();
				
				if ((d.getTime() - start_time) >= ticks) 
				{
					if (did_flush) outa_time = true;
					else break; 
				}
			}

		}
		if (did_flush) __activeInstances = active_instances;
	}	
	
/** Creates new Clip subclass object, based on type of {@link com.moviemasher.Media.Media} object referenced by supplied id.
@param media_id String containing id attribute from media tag.
@return Clip object (always newly created), or undefined if media not found.
*/
	static function fromMediaID(media_id : String) : com.moviemasher.Clip.Clip
	{
		var item_ob : com.moviemasher.Clip.Clip = undefined;
		var media : com.moviemasher.Media.Media;
		
		if (! _global.com.moviemasher.Control.Debug.isFalse(media_id.length, "Clip's media ID not defined"))
		{
			media = com.moviemasher.Media.Media.fromMediaID(media_id);
			
			if (! _global.com.moviemasher.Control.Debug.isFalse(media, 'Media with ID ' + media_id + ' not found'))
			{
				var media_type = media.getValue('type');
				item_ob = new _global.com.moviemasher.Clip[_global.com.moviemasher.Utility.StringUtility.ucwords(media_type)]();
				if (! _global.com.moviemasher.Control.Debug.isFalse(item_ob, "Couldn't create " + media_type + ' item'))
				{
					item_ob.media = media;
					item_ob.type = media_type;
					item_ob.__mediaValues();
					item_ob.__initValues();
				}
			}
		}
		return item_ob;
	}
	
/** Static Function returns new Clip subclass object for clip tag node.
@param node XMLNode representation of mash tag.
Media object id must be in 'id' key of attributes.
@return Clip object (always newly created), or undefined if media not found.
*/	
	static function fromXML(node: XMLNode) : com.moviemasher.Clip.Clip
	{
		var media_id = node.attributes.id;
		var item : com.moviemasher.Clip.Clip = fromMediaID(media_id);
		
		// pull basic media specific properties
		item.__fromAttributes(node.attributes);

		return item;
	}


// PUBLIC INSTANCE PROPERTIES


/** String containing unique clip identifier (unrelated to id attribute of clip tag).
The identifier is a 32 character MD5 generated sequence of letters and numbers. 
*/	
	var id : String = ''; 

/** Number containing zero based index of visual clips within {@link com.moviemasher.Mash.Mash} video track. */

	var index : Number = -1;
	
/** String containing label property of corresponding {@link com.moviemasher.Media.Media} object. */
	function get label() : String
	{
		return media.getValue('label');
	}
	

/** Number of seconds in duration, taking into consideration all properties.
This default implementation is used for {@link com.moviemasher.Clip.Effect}
and {@link com.moviemasher.Clip.Theme} objects, so only length property is used.
*/
	function get length() : Number { return __values.length; } 

/** The mash that contains this clip. 
This property is set in {@link com.moviemasher.Utility.MashUtility} as clip is 
added and removed from mash.
*/
	function get mash() : com.moviemasher.Mash.Mash { return __mash; }
	function set mash(new_mash : com.moviemasher.Mash.Mash)
	{
		__mash = new_mash;
	}

/** Media object that this clip is an instance of*/
	var media : com.moviemasher.Media.Media; // the media object that I am an instance of


/** Number of seconds added to the end of this clip to accommodate a transition after it.
This property is set by the containing {@link com.moviemasher.Mash.Mash} object.
*/
	var padEnd : Number = 0; // padding needed to fill transitions that follow item

/** Number of seconds added to the start of this clip to accommodate a transition before it.
This property is set by the containing {@link com.moviemasher.Mash.Mash} object.
*/
			
	var padStart : Number = 0; // padding needed to fill transitions that proceed item

/** Number of seconds indicating clip start time relative to the containing {@link com.moviemasher.Mash.Mash} object.
For effect and audio clip objects, this property is tied to the start attribute. 
For others it's set by the containing {@link com.moviemasher.Mash.Mash} object.
*/
	var start : Number = 0; // my start time in project

/** Number indicating track position of clip.
For effect and audio clip objects, this property is tied to the track attribute. 
For others it's always equal to zero.
*/
	var track : Number = 0;
	
/** MovieClip being used for temporary bitmap generation.
If there was no clip before this method is called, one is created and returned.
*/
	function get trackClip() : MovieClip
	{
		if (! __trackClip)
		{
			
			var mash_clip = _global.app.mashClip(__mash);
			var track_name : String = 'track_' + track;
			var scratch_clip : MovieClip = mash_clip[track_name];
			if (! scratch_clip) 
			{
				mash_clip.createEmptyMovieClip(track_name, 100 + track);
				scratch_clip = mash_clip[track_name];
			}
			var item_clip;
			var scratch_depth = scratch_clip.getNextHighestDepth();
			var clip_name = 'clip_' + id;
			scratch_clip.createEmptyMovieClip(clip_name, scratch_depth);
			item_clip = scratch_clip[clip_name];
			
			item_clip.createEmptyMovieClip('item_clip', item_clip.getNextHighestDepth());
			__trackClip = item_clip.item_clip;
			__trackClip.clip = this;
			__trackClip.depth = scratch_depth;
			
			__initMovieEffects(__trackClip);
			__trackClip._visible = false;
		}
		return __trackClip;
	}
	
/** String containing the type attribute of the corresponding {@link com.moviemasher.Media.Media} object. */
	var type : String;

/** Boolean indicating whether or not volume is faded out. */
	function get volumeEnabled() : Boolean
	{
		return (__values.volume != '0,0,0,100');
	}	


	
// PUBLIC INSTANCE METHODS

	
/** Add handler for specified event.
See mx.events.EventDispatcher API for details.
@param event string containing event name
@param handler object or movieclip event handler
*/
	function addEventListener(event:String, handler) : Void {}


/** Retrieves Object with a key for each bindable clip property. 
Called by {@link com.moviemasher.Control.Timeline} control when clip is selected.
@return Object with values for all bindable clip properties. 
*/
	function attributeValues() : Object
	{
		var ob = {};
		com.moviemasher.Utility.ObjectUtility.copy(media.clipProperties(), ob);
		com.moviemasher.Utility.ObjectUtility.copy(_global.app.options[type].dataFields, ob);
		com.moviemasher.Utility.ObjectUtility.copy(_global.app.options.clip.dataFields, ob);
		for (var k in ob)
		{
			ob[k] = getValue(k);
		}
		return ob;
	}

/** Returns background color for themes.
The default implementation returns undefined - it's overridden by {@link com.moviemasher.Clip.Theme} clips.
@return String with six character hex color value, or undefined.
*/
	function backColor() : String { return undefined; }
	

/** Alerts clip that a bitmap generation session is starting or ending.
Called during execution of the {@link com.moviemasher.Mash.Mash#time2Bitmap} method.
@param done Boolean is true if session is ending.
*/
	function bitmapping(done : Boolean) : Void
	{
		if (__trackClip._visible = ! done)
		{
			__trackClip._parent._parent.filterClips.push(__trackClip);
		}
	}
	
	
/** Creates a duplicate of the receiver, by calling toXML and fromXML.
@return Clip subclass object that is a deep copy of receiver.
*/
	function clone() : com.moviemasher.Clip.Clip { return fromXML(toXML()); }


	
/** Broadcast event to handlers.
See mx.events.EventDispatcher API for details. 
@param event object with 'type' key equal to event name
*/
	function dispatchEvent(event : Object) : Void {}


/** Retrieve value of clip property from configuration.
@param property String containing property name.
@return String or Number representation of value.
*/

	function getValue(property : String) 
	{ 
		if (__values[property] != undefined) return __values[property];
		return this[property]; 
	}
	
/** Indicates the existence of an audio track that isn't faded out.
Will return false for a video clip if its speed is not normal (1). 
@return Boolean true if clip has audio, and it should play.
*/	
	function hasA() : Boolean { return false; }
	
/** Indicates the existence of a visual track. 
@return Boolean true for all but {@link com.moviemasher.Clip.Audio} clips.
*/
	// default for all but audio
	function hasV() : Boolean { return true; }
	


/** Indicates whether or not clip belongs on the visual track.
@return Boolean true for all but {@link com.moviemasher.Clip.Audio} and {@link com.moviemasher.Clip.Effect} clips.
*/
	function isVisual() : Boolean
	{
		return ( ! ((type == 'audio') || (type == 'effect')));
	}
	
/** Converts mash time to media time, taking into account trim, loop and other properties.
This default implementation returns zero and is only used by {@link com.moviemasher.Clip.Image} clips. 
Overridden by {@link com.moviemasher.Clip.Audio} and {@link com.moviemasher.Clip.Video} clips to deal with
trimming and looping.  
Never called for {@link com.moviemasher.Clip.Effect} or {@link com.moviemasher.Clip.Theme} clips.

*/
	function mediaTime(time : Number) : Number { return time; }
	
		
/** Attempts to load visuals of clip into trackClip, loading media if needed.
Called by {@link com.moviemasher.Mash.Mash#time2Bitmap} method.
Overridden by {@link com.moviemasher.Clip.Effect} and {@link com.moviemasher.Clip.Theme} clips.
@param time Number of seconds into mash.
@param size Object with 'width' and 'height' keys matching bitmap.
@return Boolean false if all clip media for time is loaded and visible in trackClip.
*/
	function needsLoad(time : Number, size : Object) : Boolean
	{
		var item_time = time - start;
		var media_time = mediaTime(item_time);
		
		var apply_status : Object = media.applyMedia(__clipKey(), __values, trackClip, media_time, size);
		if (apply_status == undefined) apply_status = {loading: 1};
		if (! apply_status.loading)
		{
			var d = new Date();
			__lastDisplayTime = d.getTime();
			__activeInstances['id_' + id] = this;
		}
		//else _global.com.moviemasher.Control.Debug.msg('Clip.needsLoad ' + type + ' ' + media.getValue('id') + ' ' + apply_status.loading);

		return apply_status.loading;
	}	

/** Adds start property to supplied time.
@param time Number of seconds relative to clip start time.
@return Number of seconds relative to mash start time.
*/	
	function projectTime(time : Number) : Number
	{
		return time + start;
	}
	


/** Remove handler for specified event.
See mx.events.EventDispatcher API for details. 
@param event string containing event name
@param handler object or movieclip event handler
*/
	function removeEventListener(event:String, handler) : Void  {}
	
	
/** Change a property of a clip. 
Some properties might adjust value before setting property, for instance 'start' will 
round the time to the nearest frame time. 
This method will also call {@link com.moviemasher.Mash.Mash#dirtyMash} for the containing mash object.
@param property String containing attribute name.
@param value Number or String containing new value
@return Boolean true if change in property has changed clip length
*/
	function setValue(property : String, value, dont_send : Boolean) : Boolean
	{
		var length_changed : Boolean;
		switch (property)
		{
			case 'selected': break;
			case 'length':
			{
				value = Math.max(_global.app.options.frametime, value);
				// intentional fallthrough to 'start'
			}
			case 'start':
			{
				var orig = value;
				value = _global.app.fpsTime(value);
				//if (value != orig) _global.app.msg('setValue ' + property + ' ' + value + ' != ' + orig);
				// intentional fallthrough to 'trim'
			}
			case 'trim':
			case 'speed':
			case 'loops':
			{
				length_changed = true;
				break;
			}
			case 'track':
			{
				__clearClipBuffer(); 
				// intentional fallthrough to default
			}
			default: length_changed = false;
		}
		__dirtySelf(property, value, (length_changed == undefined), dont_send);
		return length_changed;
	}
	
/** Volume level for clip at a certain time, relative to mash.
@param time Number indicating current mash time.
@return Number from zero to 100.
*/
	function time2Volume(time : Number) : Number
	{
		var volume = com.moviemasher.Utility.PlotUtility.string2Plot(__values.volume);
		return com.moviemasher.Utility.PlotUtility.value(volume, ((time - start) * 100) / length);
	}	
	
	
/** The last moment of clip that should be visible in timeline.
Will not include portion of clip that may be transitioned.
@return Number of seconds into clip before following transition starts.
*/
	function timelineEnd() : Number // returns time eaten up at end by transitions and padding
	{
		var trans_time = 0;
		if (__mash)
		{
			if ((index != -1) && (index < (__mash.tracks.video.length - 2)))
			{
				if (__mash.tracks.video[index + 1].type == 'transition')
				{
					trans_time += __mash.tracks.video[index + 1].length;
				
				//var run = __mash.transRun(index + 1);
				//trans_time += run.longest;
					trans_time -= padEnd;
				}
			}
		}
		return trans_time;
	
	}
	
/** The first moment of clip that should be visible in timeline.
Will not include portion of clip that may be transitioned.
@return Number of seconds into clip before preceding transition ends.
*/
	function timelineStart() : Number // returns time eaten up at start by transitions and padding
	{
		var trans_time = 0;
		if (__mash)
		{
			if (index > 0)
			{
				if (__mash.tracks.video[index - 1].type == 'transition')
				{
					trans_time += __mash.tracks.video[index - 1].length;
				
				//var run = __mash.transRun(index - 1, -1);
				//trans_time += run.longest;
					trans_time -= padStart;
				}
			}
		}
		return trans_time;
	}
	
/** Convert the receiver to XML format.
@return XMLNode representation of clip.
*/
	function toXML() : XMLNode 
	{ 
		var node : XMLNode = new XMLNode(1, "clip");
		node.attributes.id = media.getValue('id');
		
		// populate basic media specific properties
		__toAttributes(node.attributes);
		
		return node;
	}
	
	
	

// PRIVATE INTERFACE

	private static var __madeEventDispatcher : Boolean = false;
	private static var __activeInstances : Object = {}; // references to instances that have been loaded visually

	private var __dirty : Object;
	private var __lastDisplayTime : Number; // the last time I've been loaded visually
	private var __mash : com.moviemasher.Mash.Mash;
	private var __trackClip : MovieClip;

	private var __values : Object; // holds attributes from 'clip' node


	private function Clip()
	{
		if (! __madeEventDispatcher)
		{
			__madeEventDispatcher = true;
			mx.events.EventDispatcher.initialize(com.moviemasher.Clip.Clip.prototype);
		}
		__values = {selected: 0, track: 0};
		id = com.meychi.MD5.newID();
	}

	private function __clearClipBuffer()
	{
		if (__trackClip) 
		{
	
			__trackClip._parent.removeMovieClip();
			__trackClip = undefined;
		}
	}
	
	private function __clearMovieEffects(time : Number) : Boolean
	{
		var did_flush : Boolean = true;
		// clear audio?
		//com.moviemasher.Core.Panel.controls.player.destroyAudioClip(this);
		
		
		// clear visual 
		__clearClipBuffer();
		
		if (did_flush) __activeInstances['id_' + id] = undefined;
		return did_flush;
	}

	
	private function __clipKey() : String
	{
		return 'id_' + media.getValue('type') + '_' + media.getValue('id') + '_' + id;
	}

	private function __clipLength(does_loop, vals)
	{
		var media_duration = media.getValue('duration');
		if (does_loop) return _global.app.fpsTime(media_duration * vals.loops);
	/*	var trim = vals.trim.split(',');
		trim[0] = parseFloat(trim[0]);
		trim[1] = parseFloat(trim[1]);
		if (isNaN(trim[0])) _global.app.msg('trim[0] NaN ' + vals.trim.toString());
		if (isNaN(trim[1])) _global.app.msg('trim[1] NaN ' + vals.trim.toString());
	*/
		return _global.app.fpsTime(media_duration - (__trimTime(true) + __trimTime(false)));
	}

	private function __dirtySelf(property : String, value, dont_dirty : Boolean, dont_send : Boolean) 
	{
		var was_clean = (__dirty == undefined);
		
		if (! dont_dirty) __mash.dirtyMash();
		
		if (property.length)
		{
			if ((! dont_dirty) && (__dirty[property] == undefined)) __dirty[property] = __values[property];
		
			__values[property] = value;
		//	if (__values[property] != value) _global.app.msg('__dirtySelf ' + property + ' ' + __values[property] + ' != ' + value);
			if (! dont_send)
			{
				dispatchEvent({type: 'change', property: property});
				dispatchEvent({type: property + 'Change'});	
			}
		}
	}


	private function __fromAttributes(ob : Object)
	{
		for (var k in ob) 
		{
			if (ob[k] != undefined) __values[k] = com.moviemasher.Utility.XMLUtility.flashValue(ob[k]);
		}
	}	
	
	private function __initMovieEffects(mc : MovieClip)
	{
		mc.applyTransform = {};
		mc.applyFilter = {};
		mc.applyMask = {};
		mc.applyMatrix = {};
	}

	private function __initValues() : Void {}
	
	private function __mediaValues() 
	{
		com.moviemasher.Utility.ObjectUtility.copy(media.clipDefaults(), __values);
	}


	private function __toAttributes(ob : Object)
	{
		for (var k in __values) ob[k] = String(__values[k]);
	}
	private function __trimTime(trim_end : Boolean) : Number
	{
	
		var index = (trim_end ? 1 : 0);
		var n = (media.getValue('duration') * parseFloat(__values.trim.split(',')[index])) / 100;
	
		return n;
	}	
	

}

