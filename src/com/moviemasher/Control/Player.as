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
import flash.geom.Point;
import flash.geom.Matrix;
import mx.video.VideoPlayer;

/** Panel control symbol displays a preview of a {@link com.moviemasher.Mash.Mash} object.
*/

class com.moviemasher.Control.Player extends com.moviemasher.Control.Control
{
	
// PUBLIC INSTANCE PROPERTIES


	function get bitmap() : BitmapData { return __bitmap; }
	function get mash() : Object { return __mash; }
	function set mash(new_mash : Object)
	{
		var was_defined : Boolean = Boolean(__mash);
		
		if (was_defined) 
		{
			if (__hasDimensions()) __clips_mc.removeMovieClip();
			__mash.removeEventListener('mashLocationChange', this);
			paused = true;
			__clearBitmapBuffer();
		}
		__mash = new_mash;
		__mashDidChange();
		
		var is_defined : Boolean = Boolean(__mash);
		
		if (is_defined != was_defined)
		{
			if (__watchedProperties.play) dispatchEvent({type: 'propertyRedefined', property: 'play', defined: is_defined});// });
		}
		if (is_defined) 
		{
			__mash.addEventListener('mashLocationChange', this);
			if (__hasDimensions()) createEmptyMovieClip('__clips_mc', getNextHighestDepth());
			if (__watchedProperties.mash) dispatchEvent({type: 'propertyChange', property: 'mash', value: __mash});
			mashLocationChange({target: __mash});
		}
	}
	
	function get volume() : Number { return __volume; }
	function set volume(n : Number) : Void
	{
		__volume = Math.max(0, Math.min(100, Math.round(n)));
		dispatchEvent({type: 'propertyChange', property: 'volume', value: __volume});
	
	}

// PUBLIC INSTANCE METHODS
	


	function action(event : Object) : Void // some action was taken by the user
	{
		switch (event.target)
		{
			case appinstance:
			{
				if (event.action.item.type != 'audio') __clearBitmapBuffer()
				if (! paused) __resetPlayback();
				drawFrame();
				break;
			}
		}
	}
	

	function cancelPlay() : Void
	{
		__paused = true;
		__stopPlaying()
	}
		
	function createChildren() : Void
	{
		appinstance.createEmptyMovieClip('__audio_mc', appinstance.getNextHighestDepth());
		__audio_mc = appinstance.__audio_mc;
		appinstance.addEventListener('action', this);
	}
	
	
	function drawFrame()
	{
		if (! (__mash && __hasDimensions())) return;
		var bm : BitmapData = __mash.time2Bitmap(__mash.getValue('location'), config.width, config.height, __mash.highest.effect);
		if (bm) 
		{
			if (__bmInterval) 
			{
				clearInterval(__bmInterval);
				__bmInterval = 0;
			}
			__bitmap = bm;
			__clips_mc.attachBitmap(bm, 1);
		}
		else 
		{
		//	_global.com.moviemasher.Control.Debug.msg('drawFrame() no bm ' + __mash);
			if ((! __bmInterval) && (! __playing)) __bmInterval = setInterval(this, 'drawFrame', __drawFrameTime);
		}
	}

	function initSize() : Void
	{
		if (! config[(config.horizontal ? 'width' : 'height')]) __makeFlexible(config.horizontal);		
		super.initSize();
	}
	
	function makeConnections() : Void
	{
		super.makeConnections();
		if (__watchedProperties.volume) dispatchEvent({type: 'propertyChange', property: 'volume', value: __volume});
	}

	function mashLocationChange(event : Object) : Void
	{
		switch(event.target)
		{
			case __mash:
			{
				if (! __iChangedLocation)
				{					
					__realLocation = __mash.getValue('location');

					if (__intervals.__videoPreload) __videoPreloadMonitor();
					if (__intervals.__audioPreload) 
					{
						__stopAudio();
						__audioPreloadMonitor();
						if (__waiting.audio) playing = false;
					}
				}
				if (playing && __intervals.__videoPreload) __drawBuffer();
				else drawFrame();
				if (__watchedProperties.location) dispatchEvent({type: 'propertyChange', property: 'location', value: __mash.getValue('location')});
				if (__watchedProperties.completed) dispatchEvent({type: 'propertyChange', property: 'completed', value: __mash.getValue('completed')});
				break;
			}
		}
	}

	function get playing() : Boolean { return __playing; }
	function set playing(tf : Boolean)
	{
		__playing = tf;
		if (__playing)
		{
			var d = new Date();
			__lastTimed = d.getTime();
			__realLocation = __mash.getValue('location');
			__startMonitor('__play', appinstance.options.upticks);
		}
		else
		{
			__stopMonitor('__play');
			__stopAudio();
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
					break;
				}
			}
		}
	}
	function propertyRedefines(property : String) : Boolean
	{
		var property_redefines : Boolean = false;
		switch(property)
		{
			case 'play':
			case 'pause':
			{
				property_redefines = true;
				break;
			}
		}
		return property_redefines;
	}
	
	function get paused() : Boolean { return __paused; };
	function set paused(tf : Boolean)	
	{
		if (__paused != tf)
		{
			__paused = tf;
			if (__paused) appinstance.stopPlaying();
			else 
			{
				appinstance.startPlaying(this);
				__startPlaying();
			}
		}
	}
	
	
	
	function size() : Void
	{
		drawFrame();
	}
	
	
	
	
	

	
// PRIVATE INSTANCE PROPERTIES

	private var __allAudioClips : Array;
	private var __audio_mc : MovieClip; // holds VideoPlayer components (one for each audible and preloading clip)
	private var __audibleClips : Object;
	private var __bitmap : BitmapData; // the bitmap currently being displayed in the player
	private var __bitmapBuffer : Object;
	private var __bmInterval : Number = 0;
	private var __clips_mc : MovieClip;
	private var __drawFrameTime : Number = 2000;
	private var __iChangedLocation : Boolean = false;
	private var __intervals : Object; // holds keyed __intervals of active monitors
	private var __lastTimed : Number = 0; // the last time we checked the time during playback
	private var __loadedTimes : Array;
	private var __mash;
	private var __paused : Boolean = true;
	private var __playing : Boolean = false;
	private var __realLocation : Number;	
	private var __volume : Number;
	private var __waiting : Object;
	private var appinstance;

	
		

// PRIVATE INSTANCE METHODS
	
	private function Player()
	{
		if (! appinstance) appinstance = _global.app;
		if (config.buffertime == undefined) config.buffertime = 10;
		if (config.id == undefined) config.id = 'player';
		if (config.minbuffertime == undefined) config.minbuffertime = 1;
		if (config.unbuffertime == undefined) config.unbuffertime = 20;
		if (config.volume == undefined) config.volume = 75;
		
		__adjustBufferTimes();		
		__volume = config.volume;
		__intervals = {};
		__loadedTimes = [];
		__audibleClips = {};
		__waiting = {};
		__bitmapBuffer = {};
	}
	
	private function __adjustBufferTimes()
	{
		config.unbufferticks = config.unbuffertime * 1000;
		config.unbufferframes = __time2ClipFrame(config.unbuffertime);
		config.bufferframes = __time2ClipFrame(config.buffertime);
		config.minbufferframes = __time2ClipFrame(config.minbuffertime);
	
	}
	
	private function __audioPreloadMonitor() // keeps audio preloading
	{
		var audio_player;
		var mash_location = __mash.getValue('location');
		
		var clips = __timeRange2AudioClips(mash_location, mash_location + (config.buffertime)); 
		var z = clips.length;
		var clip : com.moviemasher.Clip.Clip;
		var clip_name : String;
		var queued_time : Number;
		__waiting.audio = false;
		for (var i = 0; i < z; i++)
		{
			clip = clips[i];
			clip_name = 'id_' + clip.id;
			if (__audibleClips[clip_name] != undefined) continue;
			audio_player = __playerForClip(clip);
			if (audio_player == undefined) audio_player = __createAudioClip(clip);
			if (__clipReady(clip)) 
			{
				queued_time = clip.mediaTime(Math.max(0, mash_location - clip.start));
				if (audio_player.lastSeekedTo != queued_time)
				{
					if (__clipBufferTime(clip) >= queued_time)
					{
						audio_player.lastSeekedTo = queued_time;
						audio_player.lastSeekedFrom = __clipPosition(clip);
						if (audio_player.ext == 'flv') audio_player.seek(queued_time);
						
					}
					if (clip.start <= mash_location) __waiting.audio = true;
				}
			}
			else if (clip.start <= mash_location) __waiting.audio = true;
		}
		if ((! __waiting.audio) && (! __waiting.video) && (! __playing)) playing = true;
	}
	
	
	private function __changeProperty(finished : Boolean, property : String, value)
	{
		switch(property)
		{
			case 'volume':
			{
				__volume = value;
				break;
			}
			case 'play':
			{
				paused = false;
				break;
			}
			case 'pause':
			{
				paused = true;
				break;
			}
			default:
			{
				__mash.setValue(property, value);
			
				//com.moviemasher.Utility.MashUtility['chang' + (finished ? 'd' : 'ing') + 'Values']([__mash], property, value);
			}
		}
	
	}

	
	private function __clearBitmapBuffer()
	{
		if (__loadedTimes.length) // remove existing buffer
		{
			__loadedTimes = [];
			__bitmapBuffer = {};
			__drawLoadState();					
		}
	}
	

	private function __clipBufferTime(clip)
	{
		var audio_player = __playerForClip(clip);
		var n = 0;
		var media_duration = clip.media.getValue('duration');
		if (audio_player.ext == 'flv') n = media_duration * (audio_player.bytesLoaded / audio_player.bytesTotal);
		else 
		{
			n = media_duration * (audio_player.snd.getBytesLoaded() / audio_player.snd.getBytesTotal());
		
			if (clip.media.getValue('loop') && (n == media_duration))
			{
				n = clip.length;
			}
		}
		return n;
	}
	
	private function __clipPosition(clip) : Number
	{
		var audio_player = __playerForClip(clip);
		var n = 0;
		if (audio_player.ext == 'flv')
		{
			n += audio_player.playheadTime;
		}
		else n += audio_player.snd.position / 1000;
		return n;
		
		
	}


	private function __clipReady(clip_ob) : Boolean
	{
		var audio_player = __playerForClip(clip_ob);
			
		var ready = false;
		if (audio_player != undefined)
		{
			if (audio_player.ext == 'flv')
			{
				switch(audio_player.state)
				{
					case VideoPlayer.PLAYING:
					case VideoPlayer.PAUSED:
					case VideoPlayer.STOPPED:
					{
						ready = audio_player.stateResponsive;
						break;	
					}
				}
			}
			else ready = (__clipBufferTime(clip_ob) >= clip_ob.lastSeeked);
		}
		return ready;
	}

	private function __createAudioClip(clip_ob : com.moviemasher.Clip.Clip) : MovieClip
	{
		var clip_name = 'id_' + clip_ob.id;
		
		var path = appinstance.basedURL(clip_ob.media.getValue('audio'));
		var ext = path.substr(-3);
		if (ext == 'flv')
		{
			__audio_mc.attachMovie('VideoPlayer', clip_name, __audio_mc.getNextHighestDepth());
			__audio_mc[clip_name].autoRewind = false;
			__audio_mc[clip_name].load(path);
		}
		else if (ext == 'mp3')
		{
			__audio_mc.createEmptyMovieClip(clip_name, __audio_mc.getNextHighestDepth());
			__audio_mc[clip_name].snd = new Sound(__audio_mc[clip_name]);
			__audio_mc[clip_name].snd.loadSound(path);//, (clip_ob.media.getValue('duration') > 20)
		}
		__audio_mc[clip_name].ext = ext;
		return __audio_mc[clip_name];
	}
	
	private function __destroyAudioClip(clip_ob)
	{
		var audio_player = __playerForClip(clip_ob);
		if (audio_player)
		{
			if (audio_player.ext == 'flv') audio_player.stop();
			else audio_player.snd.stop();
			audio_player.removeMovieClip();
		}
	}
	
	private function __drawBuffer() : Boolean
	{
		var frame = __time2ClipFrame(__mash.getValue('location'));
		var bm : BitmapData = __bitmapBuffer['f_' + frame];
		if (bm) 
		{
			__bitmap = bm;
			__clips_mc.attachBitmap(bm, 1);
		}
		return Boolean(bm);
	}
	

	
	private function __drawLoadState() : Void
	{
		if (__watchedProperties.mask) dispatchEvent({type: 'propertyChange', property: 'mask', value: __loadedTimes, total: Math.floor((__mash.length - appinstance.options.frametime) * appinstance.options.video.fps)});
	}

	
	private function __findNextUnloadedFrame(project_time)
	{
		var z = __loadedTimes.length;
		if (! z) return project_time;
		var loaded_time = project_time;
		
		var found = false;
		for (var i = 0; i < z; i++)
		{
			if (__loadedTimes[i].start > project_time) break;
			loaded_time = Math.max(loaded_time, __loadedTimes[i].start + __loadedTimes[i].duration);	
		}
		if (loaded_time >= (__time2ClipFrame(__mash.length)))
		{
			loaded_time = -1;
		}
		return loaded_time;
	}

	private function __frame2Time(frame_number)
	{
		return appinstance.fpsTime(frame_number / appinstance.options.video.fps);
	}
	
		
	private function __hasDimensions()
	{
	 	return ((config.height > 0) && (config.width > 0));
	}
	
	private function __loadedFrame(loaded_frame)
	{
		// do maintenaince of __loadedTimes array
		var z = __loadedTimes.length;
		var found = false;
		var i = 0;
		for (; i < z; i++)
		{
			if ((__loadedTimes[i].start + __loadedTimes[i].duration) == loaded_frame)
			{
				found = true;
				__loadedTimes[i].duration ++;
				if (((i + 1) < z) && (__loadedTimes[i + 1].start == (loaded_frame + 1)))
				{
					__loadedTimes[i].duration += __loadedTimes[i + 1].duration;
					__loadedTimes.splice(i + 1, 1);
				}
				break;
			}
			if (__loadedTimes[i].start == (loaded_frame + 1))
			{
				found = true;
				__loadedTimes[i].start --;
				__loadedTimes[i].duration ++;
				break;
			}
			if (__loadedTimes[i].start > (loaded_frame + 1)) break;
		}
		if (! found)
		{
			__loadedTimes.push({start: loaded_frame, duration: 1});
			__loadedTimes.sortOn('start', Array.NUMERIC);
		}
	}	

	
	private function __loop2Location()
	{
		
		var a_clips = __time2AudioClips(__mash.getValue('location'));
		var z = a_clips.length;
		var clip;
		for (var i = 0; i < z; i++)
		{
			clip = a_clips[i];
			if (clip.media.getValue('loop') && (clip.getValue('loops') > 1))
			{
				var mash_location = __mash.getValue('location');

				var over = (mash_location - clip.start) % clip.media.getValue('duration');
				over = (mash_location - over);
				over = appinstance.fpsTime(over);
				if (mash_location != over)
				{
					__mash.setValue('location', over);
					return true;
				}
			}
		}
		return false;
		
	}
	
	private function __mashDidChange()
	{
	
	}
		
	private function __playAudio(now_pos : Number) : Number
	{
		var clip_name : String;
		var playing_clips : Object = {};
		var clip : com.moviemasher.Clip.Clip;
		var a_clips : Array = __time2AudioClips(now_pos);
		//_global.com.moviemasher.Control.Debug.msg('__playAudio ' + now_pos + ' clips = ' + a_clips.toString());
		var z : Number = a_clips.length;
		var am_ready = true;
		for (var i = 0; i < z; i++)
		{
			clip = a_clips[i];
			if (! __clipReady(clip)) return -1;
			clip_name = 'id_' + clip.id;
			playing_clips['id_' + clip.id] = clip;
		}
		var audio_player;
		for (var k in __audibleClips) // stop clips no longer on timeline
		{
			clip = __audibleClips[k];
			if (playing_clips[k] == undefined) 
			{
				__destroyAudioClip(clip);
			}
		}
		var clip_volume : Number;
		for (var k in playing_clips) 
		{
			clip = playing_clips[k];
			audio_player = __playerForClip(clip);
				
			if (__audibleClips[k] == undefined) // clip new to timeline
			{
				if (audio_player.lastSeekedTo != undefined) 
				{
					var wait_secs = clip.projectTime(audio_player.lastSeekedTo) - now_pos;
					if (wait_secs > 0)
					{
						var d = new Date();
						var wait_time = d.getTime() + (wait_secs * 1000);
						while (d.getTime() < wait_time) {d = new Date();}
						
					}
				}
				now_pos = clip.projectTime(audio_player.lastSeekedTo);
			
				if (audio_player.ext == 'flv') audio_player.play();
				else 
				{
					if (clip.media.getValue('loop'))
					{
						audio_player.lastSeekedTo = audio_player.lastSeekedTo % clip.media.getValue('duration');
					}
					audio_player.snd.start(audio_player.lastSeekedTo, clip.getValue('loops'));
				}
				audio_player.lastSeekedTo = undefined;
			}
			else 
			{
				var clip_position = __clipPosition(clip); 
				if (! clip_position) clip_position = 0;
				if (audio_player.lastSeekedFrom != clip_position) // the playhead has moved since we last seeked
				{
					if (! clip.media.getValue('loop')) now_pos = clip.projectTime(clip_position);
					
					if (audio_player.lastSeekedFrom != undefined) audio_player.lastSeekedFrom = undefined;
				}
			}
			clip_volume = clip.time2Volume(now_pos) / 100;
			
			clip_volume = Math.round(__volume * clip_volume);
		//	_global.com.moviemasher.Control.Debug.msg('volume = ' + clip_volume);
			var sound_transform = {};
			sound_transform.ll = clip_volume;
			sound_transform.rr = clip_volume;
			sound_transform.lr = 0;
			sound_transform.rl = 0;
			
			if (audio_player.ext == 'flv') audio_player.transform = sound_transform;
			else audio_player.snd.setTransform(sound_transform);
		}
		__audibleClips = playing_clips;
		if (! am_ready) now_pos = -1;
		return now_pos;
	}
	
	private function __playFinished() : Void
	{
		if (config.dontloop) paused = true;
		else __mash.setValue('location', 0);
	}
	
	private function __playerForClip(clip_ob : com.moviemasher.Clip.Clip)
	{
		var clip_name = 'id_' + clip_ob.id;
		return __audio_mc[clip_name];
	}
	
	private function __playMonitor() // keep time for video manually
	{
		var reposition : Boolean = false;
		
		var play_time = __playTime();
		if (play_time > __mash.length) return __playFinished();
		if (__waiting.audio) __audioPreloadMonitor();
		if (__playing)
		{
			if (__intervals.__audioPreload)
			{
				play_time = __playAudio(play_time);
				if (play_time < 0) playing = false;
				else reposition = true;
			}
			else reposition = true;
		}
		
		if (reposition && (__mash.getValue('location') != play_time))
		{
			__iChangedLocation = true;
			__mash.setValue('location', play_time);
			__iChangedLocation = false;
			
		}
		//_global.com.moviemasher.Control.Debug.msg(play_time);
	}
	
	
	private function __playTime()
	{
		var now = new Date();
		now = now.getTime();
		if (playing) __realLocation += (now - __lastTimed) / 1000;
		__lastTimed = now;
		return __realLocation;
	}
	
	private function __rebuildAudioClips()
	{	
		__allAudioClips = [];
		var z = __mash.tracks.video.length;
		var clip;
		var start_time : Number = 0;
		for (var i = 0; i < z; i++)
		{
			clip = __mash.tracks.video[i];
			if (clip.hasA()) __allAudioClips.push(clip);
		}
		z = __mash.tracks.audio.length;
		for (var i = 0; i < z; i++)
		{
			__allAudioClips.push(__mash.tracks.audio[i]);
		}
		__allAudioClips.sort(__sortByStart);
	
	}
	private function __resetPlayback()
	{
		__rebuildAudioClips();
		//__stopAudio();
		//_global.com.moviemasher.Control.Debug.msg('__allAudioClips = ' + __allAudioClips.toString());
		if (__allAudioClips.length)
		{
			__audioPreloadMonitor();		
			__startMonitor('__audioPreload', 2000); // effectively the time it takes to restart playback
		}
		else 
		{
			__stopMonitor('__audioPreload');
			__waiting.audio = false;
		}
		if (__mash.tracks.video.length && __hasDimensions()) // there is at least one visual clip
		{
			__waiting.video = true;
			__videoPreloadMonitor();
			__startMonitor('__videoPreload', appinstance.options.upticks);
			__startMonitor('__videoUnload', 2000);
		}
		else
		{
			__waiting.video = false;
			__stopMonitor('__videoPreload');
			__stopMonitor('__videoUnload');
		}
		if (__waiting.audio || __waiting.video) __stopAudio();
		//if (start_time < __mash.length) loadedTimeRange('audio', __time2ClipFrame(start_time), __time2ClipFrame(__mash.length));
	}

	private function __sortByStart(a, b)
	{
		if (a.start == b.start) return 0;
		return (a.start > b.start ? 1 : -1);
	}

	

	private function __startMonitor(monitor_name : String, milliseconds : Number)
	{
		if (! __intervals[monitor_name]) 
		{
			__intervals[monitor_name] = setInterval(this, monitor_name + 'Monitor', milliseconds);
		}
	}
	
	private function __startPlaying()
	{
		//_global.com.moviemasher.Control.Debug.msg('__startPlaying ' + __mash.getValue('location'));
		__waiting = {video: false, audio: false};
		__resetPlayback();
		
		if (__watchedProperties.pause) dispatchEvent({type: 'propertyRedefined', property: 'pause', defined: true});
		if (__watchedProperties.play) dispatchEvent({type: 'propertyRedefined', property: 'play', defined: false});
			
			
	}
		
	private function __stopAudio()
	{
		for (var k in __audibleClips)
		{
			__destroyAudioClip(__audibleClips[k]);
		}
		__audibleClips = {};
		__loop2Location();
	}
	
	private function __stopMonitor(monitor_name : String)
	{
		if (__intervals[monitor_name])
		{
			clearInterval(__intervals[monitor_name]);
			__intervals[monitor_name] = undefined;
		}
	}

	
	private function __stopPlaying()
	{
		__stopMonitor('__videoPreload');
		__stopMonitor('__videoUnload');
		__stopMonitor('__audioPreload');
		playing = false;
		if (__watchedProperties.pause) dispatchEvent({type: 'propertyRedefined', property: 'pause', defined: false});
		if (__watchedProperties.play) dispatchEvent({type: 'propertyRedefined', property: 'play', defined: true});
		
	}
	
		
	private function __time2AudioClips(project_time) // returns array of audio clips that should be playing at time
	{
		var audio_clips : Array = [];
		if (__volume)
		{
			var z = __allAudioClips.length;
			var clip : com.moviemasher.Clip.Clip;
			
			for (var i = 0; i < z; i++)
			{
				clip = __allAudioClips[i];
				if ((clip.start - appinstance.options.frametime) > project_time) break;//
				if ((clip.start + clip.length) > project_time) audio_clips.push(clip);
			}
		}
		return audio_clips;
	}
	
	private function __time2ClipFrame(project_time)
	{
		return Math.floor(project_time * appinstance.options.video.fps);
	}
	
	private function __timeRange2AudioClips(first_time, last_time) // returns array of audio clips that should be playing at time
	{
		var audio_clips : Array = [];
		if (__volume)
		{
			var z = __allAudioClips.length;
			var clip : com.moviemasher.Clip.Clip;
			
			for (var i = 0; i < z; i++)
			{
				clip = __allAudioClips[i];
				if ((clip.start) > last_time) break;
				if ((clip.start + clip.length) > first_time) audio_clips.push(clip);
			}
		}
		return audio_clips;
	}
		
	
	private function __videoPreloadMonitor() // keeps video preloading
	{
		var d = new Date();
		var start_time = d.getTime();
		
		var available_ticks = appinstance.options.upticks;
		var draw_state : Boolean = false;
		
		
		var frame_location = __time2ClipFrame(__mash.getValue('location'));
		var frame_length = __time2ClipFrame(__mash.length);
		var frame_buffer = config.bufferframes;
		var next_unloaded = __findNextUnloadedFrame(frame_location);
		var buffer_full = ((next_unloaded == -1) || ((next_unloaded - frame_location) >= frame_buffer));
		var last_loaded_frame : Number;
		if (! buffer_full)
		{
			last_loaded_frame = __videoPreloadRange(next_unloaded, Math.min(frame_location + frame_buffer, frame_length), available_ticks);
			
			
			
			if (last_loaded_frame != -1) // something was loaded during __videoPreloadRange
			{
				next_unloaded = __findNextUnloadedFrame(frame_location);
				buffer_full = ((next_unloaded == -1) ||((next_unloaded - frame_location) >= frame_buffer));
				draw_state = true;
			}
			available_ticks -= (d.getTime() - start_time);
		}
		
		
		if (buffer_full)
		{
			if ((available_ticks > 0) && (next_unloaded == -1))
			{
				frame_buffer = Math.max(0, frame_buffer - (frame_length - frame_location));
				if (frame_buffer) // see if we need to load anything at the start
				{
					next_unloaded = __findNextUnloadedFrame(0);
					if ((next_unloaded != -1) && (next_unloaded <= frame_buffer))
					{
						last_loaded_frame = __videoPreloadRange(next_unloaded, Math.min(frame_buffer, frame_length, available_ticks));
						if (last_loaded_frame != -1) 
						{
							draw_state = true;
						}
					}
				}
			}
			__waiting.video = false;
			if ((! __waiting.audio) && (! playing)) playing = true;
		}
		else if (next_unloaded <= Math.min(frame_length, (frame_location + __time2ClipFrame(config.minbuffertime))))
		{
			__waiting.video = true;
			if (playing) playing = false;
		}
		if (draw_state) __drawLoadState();
	}
	
	private function __videoPreloadRange(start_frame, ideal_frame, available_ticks)
	{
		var now_date : Date = new Date();
		var stop_time : Number;
		if (playing) stop_time = now_date.getTime() + available_ticks;
		else stop_time = now_date.getTime() + 250;
		
		var bm : BitmapData;
		var last_loaded : Number = -1;
		var found_all = true;
		for (var i = start_frame; i <= ideal_frame; i++)
		{
			if (! __bitmapBuffer['f_' + i])
			{
				bm = __mash.time2Bitmap(__frame2Time(i), config.width, config.height, __mash.highest.effect);
				if (bm) 
				{
					if (found_all) last_loaded = Math.max(last_loaded, i);
					__bitmapBuffer['f_' + i] = bm;
					__loadedFrame(i);
				}
				else if (found_all) found_all = false;
				now_date = new Date();
				if (stop_time < now_date.getTime()) ideal_frame = i; // will break
			}
			if (found_all) last_loaded = Math.max(last_loaded, i);
		}
		return last_loaded;
	}
	private function __videoUnloadMonitor() // removes cache of played frames
	{
		var frame_location = __time2ClipFrame(__mash.getValue('location'));
		var frame_length = __time2ClipFrame(__mash.length);
		var unload_frame = (frame_location - config.unbufferframes);
		
		var start_frame = Math.max(0, config.bufferframes - (frame_length - frame_location));

		var did_unload : Number = 0;
		var new_times : Array = [];
		var z : Number = __loadedTimes.length;
		var loaded_time : Object;
		var draw_state : Boolean = false;
		var y : Number;
		var j : Number;
		if (unload_frame > 0)
		{
			new_times = [];
			for (var i = 0; i < z; i++)
			{
				loaded_time = __loadedTimes[i];
				if (loaded_time.start < unload_frame) 
				{
					y = Math.min(unload_frame, loaded_time.start + loaded_time.duration + 1);
					var tf = false;
					for (j = loaded_time.start; j < y; j++)
					{
						if (j >= start_frame)
						{
							__bitmapBuffer['f_' + j] = undefined;
							if (! did_unload) did_unload = j;
							if (tf)
							{
								tf = false;
								new_times.push({start: loaded_time.start, duration: j - loaded_time.start});
								loaded_time.duration -= (j - loaded_time.start);
								loaded_time.start = j;
							}
							else
							{
								loaded_time.start++;
								loaded_time.duration--;
							}
						}
						else tf = true;
					}
				}
				if (loaded_time.duration > 0) new_times.push(loaded_time);
			}
			if (did_unload) 
			{
			//_global.com.moviemasher.Control.Debug.msg('unloaded ' + did_unload + ' -> ' + j);
				draw_state = true;
				__loadedTimes = new_times;
			}
		}
		
		var begin_kill;
		unload_frame = frame_location + config.bufferframes;
		if (unload_frame < frame_length)
		{
			did_unload = 0;
			z = __loadedTimes.length;
			new_times = [];
			for (var i = 0; i < z; i++)
			{
				loaded_time = __loadedTimes[i];
				if ((loaded_time.start + loaded_time.duration) > unload_frame) 
				{
					y = loaded_time.start + loaded_time.duration;
					begin_kill = Math.max(unload_frame, loaded_time.start);
				//	y = Math.min(unload_frame, loaded_time.start + loaded_time.duration + 1);
					for (j = begin_kill; j < y; j++)
					{
						__bitmapBuffer['f_' + j] = undefined;
						if (! did_unload) did_unload = j;
						loaded_time.duration--;
							
					}
				}
				if (loaded_time.duration > 0) new_times.push(loaded_time);
				
			}
			if (did_unload) 
			{
				// _global.com.moviemasher.Control.Debug.msg('unloaded ' + did_unload + ' -> ' + j);
				draw_state = true;
				__loadedTimes = new_times;
			}
			
		}
		if (draw_state) __drawLoadState();
	}

}	