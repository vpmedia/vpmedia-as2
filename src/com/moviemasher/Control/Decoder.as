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

/** Panel control symbol displays a preview of a {@link com.moviemasher.Mash.Mash} object.
*/

class com.moviemasher.Control.Decoder extends com.moviemasher.Control.Player
{
	
// PUBLIC INSTANCE PROPERTIES






// PUBLIC INSTANCE METHODS

	function createChildren() : Void
	{
		super.createChildren();
		__audio_mc._visible = false;
		
		//__loadingThings++;
		//__createSocket();
	
	}	

	
	function drawFrame()
	{
		if (! __calledIntercept) __callIntercept(); 
		
	}

	function __callIntercept()
	{
		if (__mash && __playingAudio)
		{
			__calledIntercept = true;
			__intervals.__intercept = setInterval(this, '__interceptMonitor', 1000)
			
			//__socket.send('intercept' + newline);
		}
	}

/*
			super.drawFrame();
			if (! __bmInterval) 
			{
				
			//	__app.msg('drawFrame ' + loc);
				
				if ((! __frameCounter) || ( ! (__frameCounter % Math.round(config.fps))))
				{
					__videoPreloadMonitor();
					__videoUnloadMonitor();
					playing = false;
				}
				
				__frameCounter++;
				
				var loc = __mash.getValue('location');
				__socket.send(__frameCounter + newline);
						
			}
*/

// PRIVATE INSTANCE PROPERTIES
		
	private var __port : Number = 0;
	private var __socket:XMLSocket;
	private var __decodeStartTime : Number = 0;
	private var __decodedLocation : Number = -1;
	private var __startTime : Number = -1;
	private var __stopTime : Number = -1;
	private var __decodeFrame : Number = -1;
	private var __playingAudio : Boolean = false;
	private var __startFrame : Number = -1;
	private var __stopFrame : Number = -1;
	private var __bufferingFrame : Number = -1;
	private var __grabbing : Boolean = false;
	private var __calledIntercept : Boolean = false;
	
// PRIVATE INSTANCE METHODS
	
	private function Decoder()
	{
		
		super();
		__drawFrameTime = 250;
		__port = appinstance.getValue('decodeport');
		if (! __port) fscommand('quit');
		else System.security.loadPolicyFile("xmlsocket://localhost:" + __port);
		if (! _global.app) _global.app = appinstance;
	}

	
	private function __decodeVideo()
	{
		if (! config.hide) 
		{
			
		/*	__sendData('frame', {number: (__decodeFrame - __startFrame)});
			fscommand('quit');
			return;
*/
			__intervals.__decode = setInterval(this, '__decodeMonitor', 100);	
			__decodeMonitor();
			
		}
		else __decodeAudio();
	}
	
	private function __decodeAudio()
	{
	//	__socket.send(__log.join(newline));
		if (! config.mute)
		{
			__clearBitmapBuffer();
			__playingAudio = true;
			//var snd = new Sound();
			//snd.setVolume(100);
			__volume = 100;
			__setBufferTimes(10, 2);
			__sendMash(__startTime);
		}
		else __allDone();
		//__intervals.__decode = setInterval(this, '__decodeMonitor', 10);
		//__socket.send('done' + newline);
	}
	

	private function __doneAudio() : Boolean
	{
		var is_done : Boolean = false;
		//__decodeLog('__doneAudio ' + typeof(__audio_mc) + ' ' + __mash.getValue('location') + newline);
					
		if ((__mash.getValue('location')) >= appinstance.fpsTime(__stopTime + appinstance.options.frametime))
		{
			is_done = true;
			paused = true;
		//	var now : Date = new Date();
		//	appinstance.msg('DONE ' + __mash.getValue('location') + ' took ' + (((now.getTime() - __decodeStartTime) / 1000)));
			//__socket.send('took: ' + ((now.getTime() - __decodeStartTime) / 1000) + newline);
			__allDone();
			
		}
		return is_done;
	}

	private function __allDone()
	{
		__sendData('quit');
	}

	private function __doData(d : String)
	{

		var n : Number = Number(d);
		if (isNaN(n))
		{
			switch (d)
			{
				case 'job':
				{
					__decodeVideo();
					break;
				}
				case 'intercept':
				{
					__stopMonitor('__intercept');
					paused = false;
					break;
				}
				case 'quit':
				{			
					fscommand("quit");
					break;
				}
			}
		}	
		else
		{
			__grabbing = false;
			__decodeMonitor();
		}
	}
	
	function __interceptMonitor()
	{
		__sendData('intercept');
		
		
	}
	private function __hasDimensions()
	{
	 	return ! __playingAudio;
	}

	private function __playMonitor() // keep time for video manually
	{
		if (! __doneAudio()) super.__playMonitor();
		
	}

	var __sendInterval : Number = 0;
	private function __sendData(script, params)
	{
		if (__sendInterval) 
		{
			clearInterval(__sendInterval);
			__sendInterval = 0;
		}
		var url = 'http://localhost:' + __port + '/' + script + '.cgi';
		var __sender = new LoadVars();
		var __receiver = new LoadVars();
		if (params != undefined)
		{
			for (var k in params)
			{
				__sender[k] = params[k];
			}
		}
		__receiver.owner = this;

		__receiver.onData = function(d)
		{
		
			this.owner.__doData(d);
		}
		__sender.sendAndLoad(url, __receiver, 'GET');
	
	}
	
	private function __sendJobData()
	{
		var ob = {};
		
		
		if (! config.hide)
		{
			ob.frames = 1 + (__stopFrame - __startFrame);
			//Math.floor((__stopTime - __startTime) * appinstance.options.video.fps);
		}
		if (! config.mute)
		{
			__volume = 100;
			__rebuildAudioClips();
			var clips : Array = __timeRange2AudioClips(__startTime, __stopTime);
			var z : Number = clips.length;
			var url : String;
			var did : Object = {};
			var media_id : String;
			var ext : String;
			var clip;
			var new_url : String;
			for (var i = 0; i < z; i++)
			{
				clip = clips[i];
				media_id = clip.media.getValue('id');
				if (! did[media_id])
				{
					did[media_id] = true;
					
					url = appinstance.basedURL(clip.media.getValue('audio'));
					ext = url.substr(-3);
					
					new_url = 'http://localhost:' + __port + '/';
					new_url += _global.com.meychi.MD5.calculate(url);
					new_url += '.' + ext;
					ob['audio' + i] = url;
					
					//__socket.send('audio: ' + url + newline);
					clip.media.setValue('audio', new_url);
					//__decodeLog(new_url);
				}
			}
		}
		ob.duration = appinstance.options.frametime + (__stopTime - __startTime);
		__sendData('job', ob);
	}
		
	private function __setBufferTimes(buffer : Number, minbuffer : Number)
	{
		config.buffertime = buffer;
		config.minbuffertime = minbuffer;
		config.unbuffertime = 1;
		
		__adjustBufferTimes();
	
	}
	
	private function __sendMash(location : Number)
	{
		if (__mash.getValue('location') == location)
		{
			drawFrame();
		}
		else
		{
			__iChangedLocation = true;
			__mash.setValue('location', location);
			__iChangedLocation = false;
		}
	}
	var __bitmapInfo = {};
	var __bitmapTimes = {};
	private function __decodeMonitor()
	{
		if (! __grabbing)
		{
			if (__decodeFrame > __stopFrame)
			{
				__stopMonitor('__decode');
				//var now : Date = new Date();
				//__socket.send('took: ' + ((now.getTime() - __decodeStartTime) / 1000) + newline);
				return __decodeAudio();
			}
			var ob = __bitmapInfo['f_' + __decodeFrame];
			if (ob.bitmap)
			{
				__grabbing = true;
				
				__bitmapInfo['f_' + __decodeFrame] = null;
				delete(__bitmapInfo['f_' + __decodeFrame]);
				
				__clips_mc.attachBitmap(ob.bitmap, 1);
				
				ob.number = ((__decodeFrame + 1) - __startFrame);
				__decodeFrame++;
				//__decodeLog('START GRAB ' + (__decodeFrame - __startFrame) + newline);
				
				
				__sendInterval = setInterval(this, '__sendData', 250, 'frame', ob);
				//	__sendData('frame', {number: (__decodeFrame - __startFrame)});
				updateAfterEvent();
				
			}
			else 
			{
				if (__bitmapTimes['f_' + __decodeFrame])
				{
					var d = new Date();
					if (d.getTime() > (__bitmapTimes['f_' + __decodeFrame] + __timeout))
					{
						ob.number = ((__decodeFrame + 1) - __startFrame);
					
						__sendData('quit', ob);
					}
				}
			}
		}
		if (__bufferingFrame <= __stopFrame)
		{
			__decodeBuffer();
		}
	}
	var __toBuffer : Number = 1;
	var __timeout : Number = 1000 * 30;// half minute
	function __decodeBuffer()
	{
		var available_ticks = 5;
		var max_bms = 10;
		var d = new Date();
		var start_ticks = d.getTime();
		var b_frame = __bufferingFrame;
		var bm;
		while (max_bms-- && ((d.getTime() - start_ticks) < available_ticks))
		{
			bm = __bitmapInfo['f_' + b_frame];
			if (! bm.bitmap) 
			{
				if (! __bitmapTimes['f_' + b_frame]) __bitmapTimes['f_' + b_frame] = d.getTime();
				bm = __mash.time2Bitmap(__frame2Time(b_frame), config.width, config.height, __mash.highest.effect, true);
				__bitmapInfo['f_' + b_frame] = bm;
			}
			if (bm.bitmap)
			{
				//__bitmapInfo['f_' + b_frame] = bm;
				
				if (b_frame == __bufferingFrame) __bufferingFrame++;
			}
			 
			b_frame++;
			
			d = new Date();
		}
	}
	private function __playFinished() : Void
	{
		super.__playFinished();
		__allDone();
	
	}


	private function __mashDidChange()
	{
		//appinstance.msg('__mashDidChange');
		if (config.fps) appinstance.setFPS(config.fps);
		config.dontloop = 1;
		
		__startTime = 0;
		__stopTime = __mash.length;// - appinstance.options.frametime;
		
		if (config.starttime != undefined) __startTime += config.starttime;
		
		
		if (config.stoptime != undefined) __stopTime = config.stoptime;
		else if (config.duration != undefined) __stopTime = __startTime + config.duration;
		else if (config.trim != undefined) __stopTime -= config.trim;
		
		///__setBufferTimes(2, 1);
		//__volume = 0;
		__bufferingFrame = __decodeFrame = __startFrame = Math.floor(__startTime * appinstance.options.video.fps);
		//__bufferingFrame --;
		__stopFrame = Math.floor(__stopTime * appinstance.options.video.fps);
		
//		return __test();
		var d = new Date();
		__decodeStartTime = d.getTime();
		__sendJobData();
		
	}
		
		/*
		
		
		
		
		
		var frame_location = __decodeFrame;
		var frame_length = __stopFrame;
		if ((__decodeFrame - 1) == __bufferingFrame) __toBuffer = 1;
		var frame_buffer = __toBuffer;
		var next_unloaded = __findNextUnloadedFrame(frame_location);
		if (next_unloaded == -1) // at the end
		{
			__bufferingFrame = __stopFrame;
			//__decodeLog('__bufferingFrame ALL ' + __bufferingFrame + newline);
			
		}
		else if ((next_unloaded - frame_location) >= frame_buffer)
		{
			__bufferingFrame = next_unloaded;
			//__decodeLog('__bufferingFrame FULL ' + __bufferingFrame + newline);
		}
		else 
		{
			var last_loaded_frame : Number = __videoPreloadRange(next_unloaded, Math.min(frame_location + frame_buffer, frame_length), available_ticks);
			
		
			if (last_loaded_frame != -1) // something was loaded during __videoPreloadRange
			{
				//if (! isNaN(last_loaded_frame)) 
				__bufferingFrame = last_loaded_frame;
				//__decodeLog('__bufferingFrame FILLED ' + __bufferingFrame + newline);
				if (__toBuffer < 10) __toBuffer++;
			}
		}
	}
	*/

//private function __drawBuffer() : Boolean

/*
	private function __clipBufferTime(clip)
	{
		var audio_player = __playerForClip(clip);
		var n = 0;
		var media_duration = clip.media.getValue('duration');
		if (audio_player.ext == 'flv') n = media_duration * (audio_player.bytesLoaded / audio_player.bytesTotal);
		else 
		{
			n = audio_player.snd.getBytesLoaded();
			if (n)
			{
				// must entirely load
				if (n == audio_player.snd.getBytesTotal())
				{
				//	n = clip.length;
					if (clip.media.getValue('loop'))// && (n == media_duration))
					{
						n = clip.length;
					}
					else n = media_duration;
				}
				else n = 0;
					
				
				n = media_duration * (audio_player.snd.getBytesLoaded() / audio_player.snd.getBytesTotal());
				//_global.app.msg('__clipBufferTime ' + n);
			
			}
			else n = 0;
		}
		return n;
	}
	
	private function __createAudioClip(clip_ob) : MovieClip
	{
		var clip_name = 'id_' + clip_ob.id;
		//_global.root = {base: config.base};
		
		var path = appinstance.basedURL(clip_ob.media.getValue('audio'));
		__decodeLog('path=' + path + ' ' + appinstance.base + ' ' + typeof(appinstance)+ ' ' + typeof(appinstance.basedURL));
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
			__audio_mc[clip_name].snd.loadSound(path, false);//, (clip_ob.media.getValue('duration') > 20)
		}
		__audio_mc[clip_name].ext = ext;
		return __audio_mc[clip_name];
	}
	*/
	//	__decodeLog('manager = ' + typeof(_global.com.moviemasher.Manager.LoadManager));
		
/*		appinstance.decoder = this;
		appinstance.msg = function(s)
		{
			this.decoder.__decodeLog(s);
		}
*/		
		//__socket.send('frames: ' + Math.floor((__stopTime - __startTime) * appinstance.options.video.fps) + newline);
		
/*
	var __log = [];
	private function __decodeLog(s)
	{
		var d = new Date();
		//__socket.send('msg: ' + d.getTime() + ' ' + s + newline);
		//__log.push
	}
	*/

/*

	function __test()
	{
		var clip_name = 'tester_mc';
		__audio_mc.createEmptyMovieClip(clip_name, __audio_mc.getNextHighestDepth());
			__audio_mc[clip_name].snd = new Sound(__audio_mc[clip_name]);
		//var snd = new Sound(__audio_mc);
		__audio_mc[clip_name].snd.owner = this;
		__audio_mc[clip_name].snd.onSoundComplete = function()
		{
			this.owner.__decodeLog('Stopping');
			fscommand('quit');
			
			this.owner.__allDone();
			//trace('quit');
		}
		__audio_mc[clip_name].snd.onLoad = function(success:Boolean) 
		{
			if (success) 
			{
				this.owner.__decodeLog('Starting');
				this.start(1,1);
				var sound_transform = {};
				sound_transform.ll = 100;
				sound_transform.rr = 100;
				sound_transform.lr = 0;
				sound_transform.rl = 0;
				
				this.setTransform(sound_transform);
			}
		};			
		__audio_mc[clip_name].snd.loadSound('http://localhost:' + __port + '/05daa332a8ac63377d7ed33d2972bb7d.mp3');
		//http://www.moviemasher.com/svn/example_patriot/media/audio/NewsIntro/audio.mp3');

	}	
*/
	/*
	private function __audioPreloadMonitor() // keeps audio preloading
	{
		var audio_player;
		var mash_location = __mash.getValue('location');
		
		var clips = __timeRange2AudioClips(mash_location, mash_location + (config.buffertime)); 
		var z = clips.length;
		//__decodeLog('__audioPreloadMonitor ' + z + newline);
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
			//__decodeLog('__audioPreloadMonitor ' + __audio_mc[clip_name].ext  + newline);
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
	*/
	/*	
private function __startMonitor(monitor_name : String, milliseconds : Number)
	{
		__decodeLog('__startMonitor ' + monitor_name  + ' ' + typeof(__intervals) + newline);
		return super.__startMonitor(monitor_name, milliseconds);
	}
	
	
	private function __stopMonitor(monitor_name : String)
	{
		__decodeLog('__stopMonitor ' + monitor_name + newline);
		return super.__stopMonitor(monitor_name);

	}
	
	
	private function __audioString(clip : Object) : String
	{
		var s = '';
		s += _global.com.moviemasher.Manager.LoadManager.basedURL(clip.media.getValue('audio')) + ';';

		if (clip.type == 'audio')
		{
			s += (clip.getValue('start') - __startTime) + ';';
		
		}
		else
		{
			s += (clip.start - __startTime) + ';';
		}
		s += clip.media.getValue('duration') + ';';
		s += (clip.media.loop ? clip.getValue('loops') + ';0;0' : '1;' + clip.getValue('trim')) + ';';
		s += clip.getValue('volume');
		return s;
	}
	private function __createSocket() : Void
	{
		//appinstance.msg('Create socket');
		__socket = new XMLSocket();
		
		__socket['mm_owner'] = this;
		
		__socket.onData = function(d : String)
		{
			this.mm_owner.__doData(d);
		}
		
		__socket.onConnect = function(success)
		{
			if (success) this.mm_owner.__doConnect();
		}
		
		__socket.onClose = function()
		{
			this.mm_owner.__doClose();
					
		}
		
		__socket.connect('localhost', __port);
		
		
	}
	
	private function __doClose()
	{
		if (__playingAudio) __intervals.__intercept = setInterval(this, '__interceptMonitor', 5000);
		
	}
	
	private function __doConnect()
	{
		if (__loadingThings)
		{
			//appinstance.msg('Created socket');
			__didLoad(undefined, 'loadingComplete');
		}
		else __socket.send('quit' + newline);
		
	}
	
		*/

}	



