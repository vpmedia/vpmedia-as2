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
import flash.geom.Matrix;

/** Abstract base class for all media types.
Video, audio, images, effects, themes and transitions are all media types.
Objects of this class are event dispatchers, but only the waveformLoaded event is broadcast.
*/

class com.moviemasher.Media.Media
{

/** Static Number equals total media items of all types. */
	static function get length() : Number { return __length; }

/** Static Boolean is true after first video with audio encountered in configuration. */
	static var multitrackVideo : Boolean = false;
	
	
	
/** Static Function called periodically to flush media buffers.
Called by the {@link com.moviemasher.Core.App} singleton every five seconds.
@param maximum Number of bitmaps that can remain in buffer.
@param ticks Number of ticks that the function is allowed to run.
@return Number of ticks remaining (might be negative)
*/
	static function flush(maximum: Number, ticks : Number) : Number
	{
		if (maximum < __loadedBitmaps) return __doFlush(maximum, ticks);
		return ticks;
	}

/** Static Function retrieves Media object with supplied id.
@param id String containing the id attribute of Media object.
@return Media object or undefined if no Media object with id exists.
*/
	static function fromMediaID(id : String) : com.moviemasher.Media.Media
	{
		return __instances['id_' + id];
	}
	
/** Static Function returns Media object for media tag node, creating if needed.
If a Media object with node.attributes.id already exists, it is returned.
@param node XMLNode representation of mash tag.
If no 'id' attribute found, a unique 32 charactor hash is generated.
@return Media object.
*/	
	static function fromXML(node : XMLNode) : com.moviemasher.Media.Media
	{
		return __factory(node.attributes);
	
	}

/** Static Function retrieves nth media item
See dataProvider API for more information.
@param index Number is zero based index.
@return Media object or undefined if index is negative or not less than length.
*/
	static function getItemAt(index : Number) : com.moviemasher.Media.Media { return __allMedia[index]; }
	

/** Static Function searches loaded media
Only media tags already encoutered are searched.
@param parameters Object with one or more key value pairs.
@return Array object of com.moviemasher.Media.Media objects.
*/
	static function localSearch(parameters : Object) : Array 
	{ 
		var results : Array = [];
		var z : Number = __allMedia.length;
		var item;
		var k;
		for (var i = 0; i < z; i++)
		{
			item = __allMedia[i];
			for (k in parameters)
			{
				if (item.getValue(k) == parameters[k]) results.push(item);
			}
			if (! k.length) results.push(item);
		}
		return results;
	}
	

/** Object representation of attributes in media tag.
Use getValue() to access values by key.
*/
	var config : Object;
	
	
/** Number of pixels tall - media's natural size. 
This property is zero until at least one frame loads.
*/
	var height : Number = 0;
	
/** BitmapData object contains graphic representation of wave file. 
This property is undefined until the file loads.
*/	
	function get waveformBitmap() : BitmapData
	{
		if (__waveformBitmap == undefined)
		{
			var wave = getValue('wave');
			if (wave.length)
			{
				__waveformBitmap = false;
				com.moviemasher.Manager.LoadManager.loadBitmap(wave, com.moviemasher.Core.Callback.factory('__bitmapLoaded', this, 'waveform'));
			}
		}
		return __waveformBitmap;
	}
	
/** Number of pixels wide - media's natural size.
This property is zero until at least one frame loads.
*/
	var width : Number = 0;
	
	
		
/* Add handler for specified event.
See mx.events.EventDispatcher API for details.
@param event String containing event name
@param handler Object or movieclip event handler
	function addEventListener(event:String, handler) : Void {}
*/


/** Configure a MovieClip so that an {@link com.moviemasher.Clip.Effect} object can apply effects to it.
The default implementation does nothing - it's overridden by {@link com.moviemasher.Media.Effect} objects.
@param key String index for applyTransform, applyFilter, applyMask and applyMatrix objects.
@param values Object with {@link com.moviemasher.Clip.Effect} specific {@link com.moviemasher.Clip.Clip} values.
@param mc MovieClip that can drawn to (drawing should be centered at origin).
@param done Number from zero to one indicating time relative to clip duration.
@param size Object with 'width' and 'height' keys matching {@link com.moviemasher.Core.Mash} dimensions.
@return Object with 'loading' and 'changed' Boolean keys indicating apply status.
*/
	function applyEffect(key : String, values : Object, mc : MovieClip, done : Number, size: Object) : Object { return undefined; } 

/** Draw content to a MovieClip for a {@link com.moviemasher.Clip.Video}, {@link com.moviemasher.Clip.Image} or {@link com.moviemasher.Clip.Theme} object.
The default implementation is used for {@link com.moviemasher.Media.Video} and {@link com.moviemasher.Media.Image} media
and attaches a BitmapData object to mc. It's overridden by {@link com.moviemasher.Media.Theme} objects to draw directly to mc.
@param key String index for applyTransform, applyFilter, applyMask and applyMatrix objects.
@param values Object with {@link com.moviemasher.Clip.Clip} specific values.
@param mc MovieClip that can drawn to (drawing should be centered at origin).
@param time Number of seconds of current time relative to clip duration.
@param size Object with 'width' and 'height' keys matching {@link com.moviemasher.Core.Mash} dimensions.
@return Object with 'loading' and 'changed' Boolean keys indicating apply status.
*/
	function applyMedia(key : String, values: Object, mc : MovieClip, time : Number, size: Object) : Object
	{
		//_global.com.moviemasher.Control.Debug.msg('applyMedia ' + key);
		
		var apply_status = {loading: false, changed: false};
		var frame = __time2Frame(time, values);
		var bm : BitmapData = __loadFrame(frame);
		if (bm)
		{
			var clip_name = 'media_' + getValue('id');
			
			var fill = getValue('fill');
			var w = width;
			var h = height;
			
			switch (fill)
			{
				case 'stretch':
				{
					w = size.width;
					h = size.height;
					break;	
				}
				case 'scale':
				case 'crop':
				{
					var multiplier = Math[(fill == 'scale') ? 'min' : 'max'](size.width / w, size.height / h);
					w = w * multiplier;
					h = h * multiplier;
					
					break;	
				}
				
			}
			
			if (! mc[clip_name])
			{		
				mc.createEmptyMovieClip(clip_name, mc.getNextHighestDepth());
				mc[clip_name]._x = - Math.round(w / 2);
				mc[clip_name]._y = - Math.round(h / 2);
			}
			if (mc[clip_name].lastAttached != frame)
			{
				mc[clip_name]._xscale = mc[clip_name]._yscale = 100;
				mc[clip_name].lastAttached = frame;
				mc[clip_name].attachBitmap(bm, 1);
				mc[clip_name]._width = w;
				mc[clip_name]._height = h;
				apply_status.changed = true;
			}
		}
		else apply_status.loading = true;
		return apply_status;
	}

/** Draw content to a MovieClip for a {@link com.moviemasher.Clip.Video}, {@link com.moviemasher.Clip.Image} or {@link com.moviemasher.Clip.Theme} object.
The default implementation does nothing - it's overridden by {@link com.moviemasher.Media.Transition} media.
@param key String index for applyTransform, applyFilter, applyMask and applyMatrix objects.
@param values Object with {@link com.moviemasher.Clip.Clip} specific values.
@param leftclip {@link com.moviemasher.Clip.Clip} that precedes transition.
@param rightclip {@link com.moviemasher.Clip.Clip} that follows transition.
@param mc MovieClip that can drawn to (drawing should be centered at origin).
@param done Number from zero to one indicating time relative to clip duration.
@param size Object with 'width' and 'height' keys matching {@link com.moviemasher.Core.Mash} dimensions.
@return Object with 'loading' and 'changed' Boolean keys indicating apply status.
*/
	function applyTransition(key : String, values: Object, leftclip : com.moviemasher.Clip.Clip, rightclip : com.moviemasher.Clip.Clip, mc : MovieClip, done : Number, size: Object) : Object  { return undefined; } 

	
/** Returns background color for themes.
The default implementation returns undefined - it's overridden by {@link com.moviemasher.Media.Theme} media.
@return String with six character hex color value, or undefined.
*/
	function backColor() : String { return undefined; }


/** Returns default values drawn from 'attributes' and 'values' attributes.
Both the media tag and type specific option tag are used to generate defaults.
@return Object with media related default key/value pairs.
*/
	function clipDefaults() : Object
	{
		return __dataValues;
	}
	
/** Returns default properties drawn from 'attributes' attribute.
Both the media tag and type specific option tag are used to generate properties.
@return Object with media related keys, values are true.
*/
	function clipProperties() : Object
	{
		return __dataFields;
	}
	
/* Broadcast event to handlers.
See mx.events.EventDispatcher API for details. 
@param event object with 'type' key equal to event name

	function dispatchEvent(event : Object) : Void {}
*/

	
/** Retrieve value of media property from configuration.
@param property String containing property name.
@return String or Number representation of value.
*/
	function getValue(property : String) { return config[property]; }

/** Indicates whether Media object is dynamic or file based.
@return Boolean true if Media object is not of type audio, video or image.
*/
	function isModular() : Boolean
	{
		switch (getValue('type'))
		{
			case 'audio':
			case 'image':
			case 'video': return false;	
		}
		return true;
	}

/** Retrieve bitmap frame for poster image.
@param w Number of pixels wide - icon size.
@param h Number of pixels tall - icon size.
@return BitmapData object or undefined if frame is loading
*/
	function posterBitmap(w : Number, h: Number) : BitmapData
	{
		var bm = undefined;
		var wave = getValue('icon');
		if (! wave.length) wave = _global.app.options[getValue('type')].icon;
		
		if (wave.length)
		{
			bm = com.moviemasher.Manager.LoadManager.cachedBitmap(wave, w, h);
			if (! bm) com.moviemasher.Manager.LoadManager.cacheBitmap(wave); 
		}
		else bm = false;//__loadFrame(getValue('poster'));
		/*
		if (bm)
		{
			var scaled_bm = new BitmapData(w, h, true, 0x00FFFFFF);//com.moviemasher.Utility.DrawUtility.hexColor(_global.app.options[getValue('type')].color, 'FF'));
			var nMatrix = new Matrix();
		
			var bm_scale = Math.max(w / bm.width, h / bm.height);
	
			nMatrix.tx = Math.round((w - (bm_scale * bm.width))  / 2);
			nMatrix.ty = Math.round((h - (bm_scale * bm.height))  / 2);
			nMatrix.a = nMatrix.d = bm_scale;
			
			scaled_bm.draw(bm, nMatrix);
			bm = scaled_bm;
		}
		*/
		return bm;
	}

/* Remove handler for specified event.
See mx.events.EventDispatcher API for details. 
@param event string containing event name
@param handler object or movieclip event handler

	function removeEventListener(event:String, handler) : Void  {}
*/	
	
/** Set value of media property in configuration.
@param property String containing property name.
@param value String or Number containing property value.

*/
	function setValue(property : String, value) { config[property] = value; }

	
	
	
// PRIVATE INTERFACE

	private static var __length : Number = 0; // class itself is dataProvider
	
	private static var __madeEventDispatcher : Boolean = false;
	private static var __instances : Object = {}; // avoids duplicate objects for same IDs
	private static var __allMedia : Array = []; // avoids duplicate objects for same IDs
	private static var __activeBitmaps : Array = []; // instances that have loaded bitmaps
	private static var __loadedBitmaps : Number = 0;

	
	private static function __doFlush(max_bitmaps: Number, available_ticks : Number) : Number
	{
		
		var d = new Date();
		var start_time : Number = d.getTime();
		var time : Number = start_time;
		var item;
		var z : Number;
		var i : Number;
		var k : String;
		z = __activeBitmaps.length;
		for (i = 0; i < z; i++)
		{
			item = __activeBitmaps[i].item;
			k = __activeBitmaps[i].frame;
			if (__activeBitmaps[i].firstDisplayTime == item.__frameDisplayTimes[k])
			{
				//_global.com.moviemasher.Control.Debug.msg('Media.__doFlush ' + max_bitmaps + ' ' + available_ticks);
		
				item.__frameDisplayTimes[k] = undefined;
				item.__frameBitmaps[k].dispose();
				item.__frameBitmaps[k] = undefined;
				__loadedBitmaps --;
				if (__loadedBitmaps <= max_bitmaps) 
				{
					i++;
					break;
				}
			}
			d = new Date();
			time = d.getTime();
			if ((time - start_time) >= available_ticks) 
			{
				i++;
				break; 
			}
		}
		if (i) __activeBitmaps.splice(0, i - 1);
		return available_ticks - (time - start_time);
	}
/** Static Function returns Media object based on attributes.id, creating if needed.
If a Media object with this id already exists, it is returned.
@param attributes Object containing media properties - if no 'id' key found, a unique 32 charactor hash is generated.
@return Media object.
*/	
	
	private static function __factory(attributes : Object) : com.moviemasher.Media.Media
	{
		var sharedKey = _global.com.moviemasher.Utility.StringUtility.safeKey(attributes.id);
		if (__instances[sharedKey] == undefined) 
		{
			__length ++;
			__instances[sharedKey] = new _global.com.moviemasher.Media[_global.com.moviemasher.Utility.StringUtility.ucwords(attributes.type)]();
			__allMedia.addItemAt(__allMedia.length - 1, __instances[sharedKey]);
			__instances[sharedKey].__initWithObject(attributes);
			if ((attributes.type == 'video') && attributes.audio.length) multitrackVideo = true;
		}
		
		return __instances[sharedKey];
	}
	
	
	private var __dataFields : Object;
	private var __dataValues : Object;
	private var __frameBitmaps : Object; // bitmap objects for each frame
	private var __frameDisplayTimes : Object; // last displayed time of each frame
	private var __highestFrame = -1;
	private var __lastDisplayTime : Number = 0;
	private var __waveformBitmap;// : BitmapData;
	

	
	private function Media()
	{
	/*	if (! __madeEventDispatcher)
		{
			__madeEventDispatcher = true;
			mx.events.EventDispatcher.initialize(com.moviemasher.Media.Media.prototype);
		}
	*/
		__frameBitmaps = {};
		__frameDisplayTimes = {};
		config = {};
		__initConfig();
	}
	
	private function __initConfig() : Void
	{
	
	}
	
	private function __bitmapLoaded(result, loadedFrame) : Void
	{
		var ob = result.bitmap;
		var w = result.width;
		var h = result.height;
		switch (loadedFrame)
		{
			case 'waveform':
			{
				if (getValue('type') == 'audio') 
				{
					width = w;
					height = h; 
				}
				__waveformBitmap = ob;
				//dispatchEvent({type: 'waveformLoaded'});
				break;
			}
			
			default: // frame number
			{
				width = w;
				height = h;
				__highestFrame = Math.max(__highestFrame, loadedFrame);
				__loadedBitmaps ++;
				__frameBitmaps['f' + loadedFrame] = ob;
			}
		}		
	}
	
	private function __frame2Bitmap(n) : BitmapData // returns closest frame for time
	{
		var frame = __frameBitmaps['f' + n];
		var z : Number;
		var d : Date;
		var displayed_frame = n;
		
		if (frame)
		{
			d = new Date();
			__lastDisplayTime = d.getTime();
			
			__activeBitmaps.push({item: this, frame: 'f' + displayed_frame, firstDisplayTime: __lastDisplayTime});
			__frameDisplayTimes['f' + displayed_frame] = __lastDisplayTime;
		}
		else frame = undefined;
		return frame;
	}

	private function __frame2URL(frame : Number) : String { return undefined; }
	

	private function __initWithObject(media_data)
	{
		for (var k in media_data)
		{
			config[k] = com.moviemasher.Utility.XMLUtility.flashValue(media_data[k]);
			//if (k != 'config') this[k] = config[k];
		}
		config.id = String(config.id); // numeric ids shouldn't be actual numbers
		__dataFields = {};
		__dataValues = {};
		
	
		var fields = config.attributes.split(',');
		var field_values = ((config.values == undefined) ? [] : String(config.values).split(';'));
		var z = fields.length;
		var y = field_values.length;
		
		for (var i = 0; i < z; i++)
		{
			__dataFields[fields[i]] = true;
			if (i < y) __dataValues[fields[i]] = com.moviemasher.Utility.XMLUtility.flashValue(field_values[i]);
		}
		
		__setAttributes();
	}
	
	private function __loadFrame(frame_number) : BitmapData
	{
		//_global.com.moviemasher.Control.Debug.msg('__loadFrame ' + frame_number);
		
		var frame = 'f' + frame_number;
		if (__frameBitmaps[frame] == undefined)
		{
			__frameBitmaps[frame] = false; // so we only load once
			com.moviemasher.Manager.LoadManager.loadBitmap(__frame2URL(frame_number), com.moviemasher.Core.Callback.factory('__bitmapLoaded', this, frame_number));
		}
		return __frame2Bitmap(frame_number);
	}
	private function __setAttributes() {}


	private function __time2Frame(time : Number, values : Object)
	{
		if (time <= 0) return 0;
		var my_length = getValue('duration');
		var my_fps = getValue('fps');
		if (time >= my_length) time = my_length;
		return Math.ceil(time * my_fps) - 1;
	}

}