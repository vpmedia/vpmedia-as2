/**
 * com.sekati.data.FLV
 * @version 1.2.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.App;
import com.sekati.core.CoreObject;
import com.sekati.events.FramePulse;
import com.sekati.utils.Delegate;

/**
 * FLV class to be used with {@link com.sekati.ui.FLVPlayer}
 */
class com.sekati.data.FLV extends CoreObject {

	private var _this:FLV;
	private var _ns:NetStream;
	private var _nc:NetConnection;
	private var _video:Video;
	private var _videoURL:String;
	private var _audio:Sound;
	private var _audioContainer:MovieClip;
	private var _paused:Boolean;
	private var _started:Boolean;
	private var _duration:Number;
	private var _metadata:Object;
	private var _lastSeekableTime:Number;

	//event stubs
	public function onProgress():Void {
	}

	public function onEvent():Void {
	}

	//constructor
	public function FLV() {
		super( );
		_this = this;
		_paused = false;
		_started = false;
		// fix for bufferPreloader flakiness
		_duration = 1000000000;
	}

	/**
	 * load video and begin playback
	 * @param url (String) flv url
	 * @param videoInstance (Video)
	 * @param width (Number) video width
	 * @param height (Number) video height
	 * @param audioContainer (MovieClip) audio becon holder
	 * @return Void
	 */
	public function load(url:String, videoInstance:Video, width:Number, height:Number, audioContainer:MovieClip):Void {
		_videoURL = url;
		_video = videoInstance;
		_audioContainer = audioContainer;
		//netconnection & netstream
		_nc = new NetConnection( );
		_nc.connect( null );
		_ns = new NetStream( _nc );
		//detach audio
		audioContainer.attachAudio( _ns );
		_audio = new Sound( audioContainer );
		//init video
		_video._width = width;
		_video._height = height;
		//_video.smoothing = true;
		_video.attachVideo( _ns );
		//define buffer settings - higher will make loops and seeks VERY choppy, but play smoother: default is 0.1, good avg is 4
		var buffer:Number = (!App.FLV_BUFFER_TIME) ? 4 : App.FLV_BUFFER_TIME;
		//trace ("App.BUFFER_TIME: " + App.BUFFER_TIME);
		_ns.setBufferTime( buffer );
		//define NetStream & NetConnection events triggers
		_ns.onMetaData = Delegate.create( _this, ns_onMetaData );
		_ns.onStatus = Delegate.create( _this, ns_onStatus );
		_nc.onResult = Delegate.create( _this, nc_onResult );
		_nc.onStatus = Delegate.create( _this, nc_onStatus );
		//start to load movie, pause and put on first frame to see something
		playVideo( );
		stopVideo( );
		//init onEnterFrame beacon (this should be a beacon & should clean after itself)
		//audioContainer.onEnterFrame = Delegate.create (_this, _onEnterFrame);
		FramePulse.getInstance( ).addFrameListener( _this );
	}

	//==========================================================
	//beacon & cleanup
	private function _onEnterFrame():Void {
		//onProgress should be a generic update that gives preloadPercent, bufferPercent, currentTime
		//so that the same event can update the scroller, preloader and time indicator		
		onProgress( getPercent( ), getPercentTimePlayed( ) );
	}

	public function clean(scope:MovieClip, obj:String):Void {
		//deconstructor that will clean the beacon and then remove the instance
		delete _audioContainer.onEnterFrame;
		_audioContainer.onEnterFrame = null;
		delete scope[obj];
	}

	//===========================================================
	// Basic controls
	public function playVideo():Void {
		_started = true;
		_ns.play( _videoURL );
	}

	public function stopVideo():Void {
		_ns.pause( true );
		// dunno why this was here: maybe important?
		//seek (0);
		_started = false;
		_paused = false;
	}

	public function pause():Void {
		if (!_paused && _started) {
			_paused = true;
			_ns.pause( true );
		}
	}

	public function resume():Void {
		if (_paused && _started) {
			_paused = false;
			_ns.pause( false );
		}
	}

	public function pauseResume():Void {
		if(_paused) {
			resume( );
		} else {
			pause( );
		}
	}

	public function setVolume(val:Number):Void {
		_audio.setVolume( val );
	}

	//=======================================
	//seek stuff
	public function seek(time:Number):Void {
		_ns.seek( resolveTime( time ) );
	}

	public function seekToPercent(percent:Number):Void {
		seek( _duration * percent / 100 );
	}

	public function ff():Void {
		//optional step size as param
		seek( getTime( ) + 2 );
	}

	public function rew():Void {
		//optional step size as param
		seek( getTime( ) - 2 );
	}

	private function resolveTime(time:Number):Number {
		//formats time so that it fits inside the available seek scope
		var maxTime:Number = (_lastSeekableTime != null) ? _lastSeekableTime : _duration;
		return Math.max( Math.min( time, maxTime ), 0 );
	}

	//=======================================
	//status tools
	public function isPaused():Boolean {
		return _paused;
	}

	public function isPlaying():Boolean {
		return _started;
	}

	public function isStopped():Boolean {
		return !_started;
	}

	public function getTime():Number {
		return _ns.time;
	}

	public function getTotalTime():Number {
		return _duration;
	}

	public function getPercentTimePlayed():Number {
		return getTime( ) * 100 / _duration;
	}

	//========================================
	//preload status tools
	public function getPercent():Number {
		return Math.round( _ns.bytesLoaded / _ns.bytesTotal * 100 );
	}

	public function getBufferPercent():Number {
		var total:Number = Math.min( _duration, _ns.bufferTime );
		return Math.min( Math.round( _ns.bufferLength / total * 100 ), 100 );
	}

	//=======================================
	//Netstream & Netconnection events
	private function nc_onResult(info:Object):Void {
		trace( "unknown ncOnResult: " + info.code );
	}

	private function nc_onStatus(info:Object):Void {
		trace( "unknown ncOnStatus: " + info.code );
	}

	private function ns_onStatus(info:Object):Void {
		switch (info.code) {
			case "NetStream.Buffer.Empty" :
				onEvent( "bufferEmpty" );
				break;
			case "NetStream.Buffer.Full" :
				onEvent( "bufferFull" );
				break;
			case "NetStream.Buffer.Flush" :
				onEvent( "bufferFlush" );
				break;
			case "NetStream.Play.Start" :
				onEvent( "start" );
				break;
			case "NetStream.Play.Stop" :
				onEvent( "stop" );
				break;
			case "NetStream.Play.StreamNotFound" :
				onEvent( "play_streamNotFound" );
				break;
			case "NetStream.Seek.InvalidTime" :
				onEvent( "seek_InvalidTime" );
				break;
			case "NetStream.Seek.Notify" :
				onEvent( "seek_notify" );
				break;
			default :
				trace( "unrecognized onStatus value: " + info.code );
		}
	}

	private function ns_onMetaData(metadata:Object):Void {
		_duration = metadata.duration;
		_lastSeekableTime = metadata.lastkeyframetimestamp;
		_metadata = metadata;
		//depends on which application was used to encode the FLV file
		//trace("nsOnMetaData event at " + _ns.time);
		/*
		SORENSON - INITIAL META:
		creationdate - Mon Jun 12 16:21:12 2006 
		framerate - 29.9699859619141
		audiocodecid - 2
		audiodatarate - 64
		videocodecid - 5
		canSeekToEnd - false
		videodatarate - 600
		height - 358
		width - 150
		duration - 17.65
		*/
		//find what metadata is available now
		/*
		for (var i in metadata) {
			trace (i + " - " + metadata[i]);
		}
		//trace cuepoints
		for (var i in metadata.cuePoints) {
			trace ("CUEPOINTS: " + i + " - " + metadata.cuePoints[i]);
			for (var y in metadata.cuePoints[i]) {
				trace ("  CUEPOINTS: " + y + " - " + metadata.cuePoints[i][y]);
			}
		}
		*/
	}

	/**
	 * calls superclasses destroy and executes its own destroy behaviors.
	 * @return Void
	 */
	public function destroy():Void {
		FramePulse.getInstance( ).removeFrameListener( _this );
		super.destroy( );
	}
}