/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.commands.CommandManagerMS;
import com.bourre.commands.Delegate;
import com.bourre.data.libs.AbstractLib;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
import com.bourre.medias.video.VideoDisplayEvent;

class com.bourre.medias.video.VideoDisplay 
	extends AbstractLib
{
	private var _mcHolder : MovieClip;
	private var _oVideo : Video;
	private var _oSound : Sound;
	private var _oNC : NetConnection;
	private var _oNS : NetStream;
	
	private var _bIsPlaying : Boolean;
	private var _bIsLoaded : Boolean;
	private var _bAutoPlay : Boolean;
	private var _bAutoSize : Boolean;
	private var _bLoopPlayback : Boolean;
	
	public static var onLoadInitEVENT : EventType = AbstractLib.onLoadInitEVENT;
	public static var onLoadProgressEVENT : EventType = AbstractLib.onLoadProgressEVENT;
	public static var onTimeOutEVENT : EventType = AbstractLib.onTimeOutEVENT;	public static var onErrorEVENT : EventType = AbstractLib.onErrorEVENT;
	
	public static var onPlayHeadTimeChangeEVENT : EventType = new EventType( "onPlayHeadTimeChange" );	public static var onStartStreamEVENT : EventType = new EventType( "onStartStream" );	public static var onEndStreamEVENT : EventType = new EventType( "onEndStream" );	public static var onBufferFullEVENT : EventType = new EventType( "onBufferFull" );	public static var onBufferEmptyEVENT : EventType = new EventType( "onBufferEmpty" );	public static var onMetaDataEVENT : EventType = new EventType( "onMetaData" );	public static var onResizeEVENT : EventType = new EventType( "onResize" );
	
	private var _nBufferTime : Number;
	
	// metadata properties
	private var _oMetaData : Object;
	private var _nDuration : Number;
	private var _aKTimes : Array;	private var _aKFilePositions : Array;

	private var _dFirePlayHeadTimeEvent : Delegate;
	
	public function VideoDisplay( mcHolder : MovieClip, videoObject : Video )
	{
		super();
		
		_mcHolder = mcHolder;
		_oVideo = videoObject? videoObject : _mcHolder.video;
		if ( !_oVideo ) PixlibDebug.ERROR( this + " failed. Invalid video object was passed in the constructor." );

		setAutoPlay( true );
		setAutoSize( true );
		setBufferTime( 2 );
		_bLoopPlayback = false;
		
		_init();
	}
	
	public static function buildVideoDisplay( video : Video ) : VideoDisplay
	{
		return new VideoDisplay( video["_parent"], video );
	}
	
	public function initEventSource() : Void
	{
		_e = new VideoDisplayEvent( null, this );
	}
	
	public function setBufferTime(n:Number) : Void
	{
		_nBufferTime = n;
	}
	
	private function _init() : Void
	{
		setPlaying( false );
		_bIsLoaded = false;
		_dFirePlayHeadTimeEvent = new Delegate( this, fireEventType, VideoDisplay.onPlayHeadTimeChangeEVENT );
		
		_oSound = new Sound( getHolder() );
		_oSound.setVolume( 75 );
	}

	public function load( sURL : String ) : Void
	{
		setURL( sURL );
	}
	
	public function setLoopPlayback( b : Boolean ) : Void
	{
		if ( _bLoopPlayback != b )
		{
			_bLoopPlayback = b;
			
			if ( _bLoopPlayback )
			{
				addEventListener( VideoDisplay.onEndStreamEVENT, this, play, 0 );
			} else
			{
				removeEventListener( VideoDisplay.onEndStreamEVENT, this );
			}
		}
	}
	
	public function isLoopPlayback() : Boolean
	{
		return _bLoopPlayback;
	}
	
	private function _load() : Void
	{
		if ( this.getURL() == undefined )
		{
			PixlibDebug.ERROR( this + " can't play without any valid url property, loading fails." );

		} else
		{
		
			_oNC = new NetConnection();
			_oNC.connect( null );
			
			_oNS = new NetStream( _oNC );
			setContent( _oNS );
			_oNS.setBufferTime( _nBufferTime );
	
			_oNS.onStatus = Delegate.create( this, _onStatus );
			_oNS["onMetaData"] = Delegate.create( this, _onMetaData );
			
			_oMetaData = null;
			_nDuration = null;
			_aKTimes = null;			_aKFilePositions = null;
	
			_oVideo.attachVideo( _oNS );
			_mcHolder.attachAudio( _oNS );
			
			_oNS.play( this.getURL() );
			if ( !isAutoPlay() ) _oNS.pause( true );
		
			_bIsLoaded = true;
	
			super.load();
		}
	}
	
	private function _onMetaData ( metadata : Object ) : Void
	{
		_oMetaData = metadata;
		_nDuration = parseInt( metadata.duration );
		if ( isAutoSize() ) setSize( metadata.width, metadata.height );
		
		if ( metadata.keyframes )
		{
			_aKTimes = metadata.keyframes.times;
			_aKFilePositions = metadata.keyframes.filepositions;
		}
		
		PixlibDebug.DEBUG( this + " received metadata." );
				fireEventType( VideoDisplay.onMetaDataEVENT );
	}
	
	private function _onStatus ( info : Object ) : Void
	{
		switch ( info.code ) 
		{
			case 'NetStream.Play.Start' :
					PixlibDebug.DEBUG( this + " stream starts playing." );
					if ( !_bIsPlaying ) setPlaying( true );
					fireEventType( VideoDisplay.onStartStreamEVENT);
					break;
					
			case 'NetStream.Play.Stop' :
					PixlibDebug.DEBUG( this + " stream stops playing." );
					fireEventType( VideoDisplay.onEndStreamEVENT );
					break;
					
			case 'NetStream.Play.StreamNotFound' :
				PixlibDebug.ERROR( this + " can't find FLV passed to the play() method." );
				fireEventType( VideoDisplay.onErrorEVENT );
				break;
					
			case 'NetStream.Seek.InvalidTime' :
				PixlibDebug.WARN( this + " seeks invalid time in '" + this.getURL() + "'." );
				break;
				
			case 'NetStream.Buffer.Full' :
				PixlibDebug.DEBUG( this + " stream buffer is full." );
				fireEventType( VideoDisplay.onBufferFullEVENT );
				break;
				
			case 'NetStream.Buffer.Empty' :
				PixlibDebug.DEBUG( this + " stream buffer is empty." );
				fireEventType( VideoDisplay.onBufferEmptyEVENT );
				break;
		}
	}
	
	public function setSize( nX : Number, nY : Number ) : Void
	{
		_mcHolder._width = nX;
		_mcHolder._height = nY;
		
		fireEventType( VideoDisplay.onResizeEVENT );
	}
	
	public function getWidth() : Number
	{
		return _mcHolder._width;
	}
	
	public function getHeight() : Number
	{
		return _mcHolder._height;
	}
	
	public function move( x : Number, y : Number) : Void
	{
		_mcHolder._x = x;
		_mcHolder._y = y;
	}
	
	public function getHolder() : MovieClip
	{
		return _mcHolder;
	}
	
	public function getKeyFramePosition() : String
	{
		return _seekKeyFramePosition( getPlayheadTime() );
	}
	
	private function _seekKeyFramePosition( n : Number ) : String
	{
		var l : Number = _aKTimes.length;
		while( --l > -1 ) if ( n > _aKTimes[ l ] ) return _aKFilePositions[ l ];
		return _aKTimes[ 0 ];
	}
	
	public function streamFromPHP( n : Number ) : Void
	{
		if ( !_bIsLoaded ) 
		{
			load();
		} else
		{
			if ( isPlaying() ) _oNS.pause( true );
			var kfp : String = _seekKeyFramePosition( n );
			_oNS.play( this.getURL() + "&position=" + kfp );
			PixlibDebug.DEBUG( this + ".streamFromPHP(" + this.getURL() + "&position=" + kfp + ")" );
			setPlaying( true );
		}
	}
	
	public function play( n : Number ) : Void
	{
		if ( !_bIsLoaded ) _load();
		if ( n ) _oNS.seek( n );
		_oNS.pause( false );
		setPlaying( true );
	}

	public function pause() : Void
	{
		_oNS.pause(true);
		setPlaying(false);
	}

	public function stop() : Void
	{
		pause();
		setPlayheadTime(0);
	}
	
	public function release() : Void
	{
		CommandManagerMS.getInstance().remove( _dFirePlayHeadTimeEvent );
		
		_oNS.close();
		_oNC.close();
		_oVideo.clear();
		
		super.release();
	}
	
	public function getMetaData() : Object
	{
		return _oMetaData;
	}
	
	public function getDuration() : Number
	{
		return _nDuration;
	}

	public function getPlayheadTime() : Number
	{
		return _oNS.time;
	}
	
	public function setPlayheadTime( n : Number ) : Void
	{
		_oNS.seek(n);
		
		if ( !_bIsPlaying )
		{
			_oNS.pause( false );
			CommandManagerMS.getInstance().delay( new Delegate(this, _onFrameUpdate), 50);
		}
	}
	
	private function _onFrameUpdate() : Void
	{
		_oNS.pause( true );
		fireEventType( VideoDisplay.onPlayHeadTimeChangeEVENT );
	}
	
	public function isPlaying() : Boolean
	{
		return _bIsPlaying;
	}

	public function setPlaying( b : Boolean ) : Void
	{
		if ( b != _bIsPlaying )
		{
			_bIsPlaying = b;
			if ( _bIsPlaying )
			{
				CommandManagerMS.getInstance().push( _dFirePlayHeadTimeEvent, 50 );
			} else
			{
				CommandManagerMS.getInstance().remove( _dFirePlayHeadTimeEvent );
			}
		}
	}
	
	public function getVolume() : Number
	{
		return _oSound.getVolume();
	}

	public function setVolume( n : Number ) : Void
	{
		_oSound.setVolume(n);
	}

	public function setURL( sURL : String ) : Void
	{
		if (sURL) 
		{
			super.setURL( sURL );
			_bIsLoaded = false;
		
			if (isPlaying())
			{
				this.play(0);
			} else
			{
				_load();
			}
		} else
		{
			PixlibDebug.WARN( this + " got invalid url property, can't load." );
		}
	}
	
	public function getBytesLoaded() : Number
	{
		return _oNS.bytesLoaded;
	}

	public function getBytesTotal() : Number
	{
		return _oNS.bytesTotal;
	}
	
	public function isAutoPlay() : Boolean
	{
		return _bAutoPlay;
	}
	
	public function setAutoPlay( b : Boolean ) : Void
	{
		_bAutoPlay = b;
	}
	
	public function isAutoSize() : Boolean
	{
		return _bAutoSize;
	}
	
	public function setAutoSize( b : Boolean ) : Void
	{
		_bAutoSize = b;
	}
	
	public function getVideoObject() : Video
	{
		return _oVideo;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}