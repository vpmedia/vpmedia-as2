/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.events.CuePointEvent;
import asgard.events.MediaEvent;
import asgard.events.NetServerEvent;
import asgard.events.NetServerEventType;
import asgard.media.AbstractMediaLoader;
import asgard.media.FLVMetaData;
import asgard.net.NetServerConnection;
import asgard.net.NetServerStatus;
import asgard.net.NetStreamStatus;

import vegas.errors.IllegalArgumentError;
import vegas.errors.UnsupportedOperation;
import vegas.errors.Warning;
import vegas.events.BasicEvent;
import vegas.events.Delegate;
import vegas.events.EventType;
import vegas.events.TimerEvent;
import vegas.util.ConstructorUtil;
import vegas.util.FrameTimer;
import vegas.util.Timer;

/**
 * This loader load an external FLV video in the application.
 * @author eKameleon
 */
class asgard.media.VideoLoader extends AbstractMediaLoader 
{
	
	/**
	 * Creates a new VideoLoader instance.
	 * @param mcTarget the target of this VideoLoader.
	 * @param video the video reference of this VideoLoader (default use a Video instance in the mcTarget with the instance name : "video").
	 * @param sName the name of the VideoLoader.
	 */
	function VideoLoader( mcTarget:MovieClip , video:Video , sName:String ) 
	{
		
		super(mcTarget, sName);
		
		_oVideo = video ? video : _mcTarget.video ;
		
		if (_oVideo == undefined) 
		{
			throw new IllegalArgumentError( toString() + " failed. Invalid video object was passed in the constructor.") ;
		}
		
		_timerHeadTime = new Timer(100, 1) ;
		_timerHeadTime.addEventListener(TimerEvent.TIMER, new Delegate(this, _onFrameUpdate)) ;

		addEventListener(MediaEvent.MEDIA_PROGRESS , new Delegate(this, _onMediaProgress)) ;

		setAutoPlay( true ) ;
		setAutoSize( false ) ;
		setBufferTime( VideoLoader.BUFFER_TIME_DEFAULT );
		setPlaying ( false ) ;
		setVolume( VideoLoader.VOLUME_DEFAULT ) ;

		setConnection(null) ;
		
	}
	
	/**
	 * The default buffer time value.
	 */
	static public var BUFFER_TIME_DEFAULT:Number = 4 ;

	/**
	 * The default sound' volume of the video.
	 */
	static public var VOLUME_DEFAULT:Number = 60 ;

	/**
	 * (read-only) Returns the current time of the loader.
	 * @return the current time of the loader.
	 */
	public function get time():Number
	{
		return getTime() ;	
	}

	/**
	 * (read-only) Sets the current time of the loader.
	 */
	public function set time(n:Number):Void
	{
		setTime(n) ;	
	}

	/**
	 * Clear the video.
	 */
	public function clear():Void
	{
		_oVideo.clear() ;
		notifyEvent(MediaEvent.MEDIA_CLEAR) ;
	}

	/**
	 * Returns the number of bytes loaded (streamed) for the specified object.
	 * @return the number of bytes loaded (streamed) for the specified object.
	 */
	public function getBytesLoaded():Number 
	{
		var bytesLoaded:Number = _oNS.bytesLoaded ;
		return isNaN(bytesLoaded) ? 0 : bytesLoaded ;
	}

	/**
	 * Returns the size, in bytes, of the specified object.
	 * @return the size, in bytes, of the specified object.
	 */
	public function getBytesTotal():Number 
	{
		var bytesTotal:Number = _oNS.bytesTotal ;
		return isNaN(bytesTotal) ? 0 : bytesTotal ;
	}

	/**
	 * Returns the duration of the loader.
	 * @return the duration of the loader.
	 */
	/*override*/ public function getDuration():Number 
	{
		return isNaN(_duration) ? 0 : _duration ;
	}
	
	/**
	 * Returns the height of the loader.
	 * @return the height of the loader.
	 */
	public function getHeight() : Number 
	{
		return _mcTarget._height ;
	}

	/**
	 * Returns the {@code FLVMetaData} of the current FLV video.
	 * @return the {@code FLVMetaData} of the current FLV video.
	 */
	public function getMetaData():FLVMetaData 
	{
		return _oMetaData ;	
	}
	
	/**
	 * Returns the NetConnection reference of this loader.
	 * @return the NetConnection reference of this loader.
	 */
	public function getConnection():NetServerConnection
	{
		return _oNC ;	
	}

	/**
	 * Returns the current time of the loader.
	 * @return the current time of the loader.
	 */
	public function getTime():Number 
	{
		return getContent().time ;
	}

	/**
	 * Returns the current position of the loader.
	 * @return the current position of the loader.
	 */
	public function getPosition():Number 
	{
		return (duration > 0) ? Math.round(getTime() * 100 / getDuration()) : 0 ;
	}

	/**
	 * Returns the internal NetStream reference of this video loader.
	 * @return the internal NetStream reference of this video loader.
	 */
	public function getStream():NetStream
	{
		return _oNS ;	
	}

	/**
	 * Returns the internal video reference.
	 * @return the internal video reference.
	 */
	public function getVideo():Video 
	{
		return _oVideo ;	
	}

	/**
	 * Returns the width of the loader.
	 * @return the width of the loader.
	 */
	public function getWidth():Number 
	{
		return _mcTarget._width ;
	}
	
	/**
	 * Returns {@code true} if the loader auto size.
	 * @return {@code true} if the loader auto size.
	 */
	public function isAutoSize():Boolean 
	{
		return _bAutoSize ;
	}

	/**
	 * Returns {@code true} if the video is a progressive download video.
	 * @return {@code true} if the video is a progressive download video.
	 */
	public function isProgressive():Boolean
	{
		return (_oNC.uri == "null" || _oNC.uri == null ) ;	
	}
	
	/**
	 * Returns {@code true} if the video is a stream video.
	 * @return {@code true} if the video is a stream video.
	 */
	public function isStream():Boolean
	{
		return _oNC.uri != null && _oNC.uri != 'null' ;	
	}

	/**
	 * Load the external video.
	 */
	public function load(sURL:String):Void 
	{
		getVideo().clear() ;
		setUrl(sURL) ;
	}
	
	/**
	 * Move the loader view.
	 */
	public function move( x : Number, y : Number):Void 
	{
		_mcTarget._x = x ;
		_mcTarget._y = y ;
	}

	/**
	 * Pause the loader.
	 */
	public function pause(noEvent:Boolean):Void 
	{
	
		if (!isResumed() || isPlaying()) 
		{
			
			setResumed(true) ;
			
			_oNS.pause(true) ;	
			
			stopProgress() ;
			if (noEvent != true) 
			{
				notifyEvent(MediaEvent.MEDIA_RESUME) ;
			}
		
		}
		else 
		{
			
			setResumed(false) ;
			_oNS.pause( false ) ;
			_startLoadProgress() ;
			startProgress() ;
			
		}
	}

	/**
	 * Play the loader.
	 */
	public function play(n:Number, noEvent:Boolean):Void 
	{
		
		if (!isLoaded()) 
		{
			_load();
		}
		
		if (!isNaN(n)) 
		{
			_oNS.seek(n) ;
		}
		else 
		{
			_oNS.seek(0) ;	
		}
		
		_oNS.pause(false) ;
		
		startProgress() ;
		
		if (noEvent != true) 
		{
			notifyEvent(MediaEvent.MEDIA_START) ;
		}
		
	}
	
	/**
	 * Release the loader.
	 */
	public function release():Void 
	{
		_oMetaData = null  ;
		_oNS.close() ;
		_oNC.close() ;
		_oNC = null ;
		_oNS = null ;
		_oVideo.clear() ;
		_duration = 0 ;
		super.release() ;
	}
	
	/**
	 * Notify an CuePointEvent object with the specified info object in argument.
	 * @param info the primitive CuePoint information object.
	 * @see CuePoint
	 * @see CuePointEvent
	 */
	public function notifyCuePoint( info:Object ):Void
	{
		dispatchEvent( new CuePointEvent( CuePointEvent.INFO, this, info ) ) ;	
	}
	
	/**
	 * Sets the flag of the autoSize property.
	 */
	public function setAutoSize(b:Boolean):Void 
	{
		_bAutoSize = b ;
	}

	/**
	 * Sets the delay time of the bugger of the video.
	 */	
	public function setBufferTime(n:Number):Void 
	{
		_nBufferTime = n ;
	}
	
	/**
	 * Sets the duration property.
	 */
	public function setDuration(n:Number):Void 
	{
		_duration = (n>0) ? n : 0 ;
	}
	
	/**
	 * Sets the NetConnection reference of this VideoLoader.
	 * @param nc The NetConnection reference of this VideoLoader.
	 */
	public function setConnection( nc:NetConnection ):Void
	{

		stopProgress() ;
	
		if (nc == null)
		{
			_oNC = new NetServerConnection()  ;
			_oNC.connect(null) ;
		}
		else
		{
			
			if (nc instanceof NetServerConnection)
			{
				_oNC = NetServerConnection(nc) ;	
			}
			else
			{
				_oNC = NetServerConnection( ConstructorUtil.createVisualInstance( NetServerConnection, nc ) ) ; 	
			}
			
		}
		
		_oNC.addEventListener( NetServerEventType.NET_STATUS , new Delegate(this, _onNetServerStatus) ) ;

		
	}

	/**
	 * Sets the current time of the loader.
	 */
	public function setTime(n:Number):Void 
	{
		_oNS.seek(n);
	}
	
	/**
	 * Sets the position of the loader.
	 */
	/*override*/ public function setPosition(n:Number):Void 
	{
		var time = Math.round(n * getDuration() / 100) ;
		setTime(time) ;
	}

	/**
	 * Set the size of the loader (width and height)
	 */
	public function setSize(w:Number, h:Number):Void 
	{
		_mcTarget._width = w ;
		_mcTarget._height = h ;
		dispatchEvent( new BasicEvent(EventType.RESIZE, this) ) ;
	}

	/**
	 * Sets the url of the loader.
	 * @throws Warning if the url is invalid and the video can't be loading.
	 */
	public function setUrl( sURL:String ):Void 
	{
		if (sURL) 
		{
			super.setUrl( sURL ) ;
			setLoaded(false) ;
			if (isPlaying()) 
			{
				this.play(0);
			}
			else 
			{
				_load() ;
			}
		}
		else 
		{
			throw new Warning( toString() + " got invalid url property, can't load." );
		}
	}

	/**
	 * Stop the loader.
	 */
	public function stop():Void 
	{
		if (isResumed() || isPlaying()) 
		{
			_oNS.close() ;
			_oVideo.clear() ;
			setLoaded(false) ;
			if ( isResumed() ) 
			{
				setResumed(false) ;
			}
			stopProgress() ;
			notifyEvent(MediaEvent.MEDIA_PROGRESS) ;
			notifyEvent(MediaEvent.MEDIA_STOP) ;
		}
	}

	/**
	 * Internal load method.
	 * @throws if the url property is invalid.
	 */
	private function _load():Void 
	{

		if ( this.getUrl() == null ) 
		{
			throw new UnsupportedOperation( this + " can't play without any valid url property, loading fails.");
		}
		
		setLoaded(true) ;
		
		_oMetaData = null ;

		_oNS = new NetStream( _oNC ) ;
		_oNS.setBufferTime( _nBufferTime ) ;
		_oNS.onStatus = Delegate.create(this, _onNetStreamStatus) ;
		_oNS["onCuePoint"] = Delegate.create(this, _onCuePoint) ; 
		_oNS["onMetaData"] = Delegate.create(this, _onMetaData) ;
		
		_oNS.toString = function()
		{
			return "[NetStream]" ;
		} ;
		
		setContent( _oNS ) ;
		
		_oVideo.attachVideo(_oNS) ;
		_mcTarget.attachAudio(_oNS) ;
				
		_oNS.play( this.getUrl() );

		startProgress() ;

		if ( isAutoPlay() == false ) 
		{
			this.pause(true) ;
		} 

		super.load();
		
	}

	private var _bAutoSize : Boolean ;

	private var _duration:Number ;
	
	private var _nBufferTime : Number;	

	private var _oMetaData:FLVMetaData ;
	
	private var _oNC:NetServerConnection ;
	
	private var _oNS:NetStream ;
	
	private var _oVideo:Video ;
	
	private var _timer:FrameTimer ;
	
	private var _timerHeadTime:Timer ;
	
	/**
	 * Invoqued when the onCuePoint callback method is fired over the internal NetStream of this loader.
	 */
	private function _onCuePoint ( info:Object ) : Void
	{
		notifyCuePoint( info ) ;
	}
	
	/**
	 * Invoqued when the onMetaData changed.
	 */
	private function _onMetaData (info:Object):Void 
	{

		for (var props in info) 
		{
			getLogger().info( this + " onMetaData, " + props + " : " + info[props]) ;
		}
		
		_oMetaData = new FLVMetaData(info) ;
		
		setDuration( isNaN(info.duration) ? 0 : parseInt(info.duration) ) ;
		
		if ( isAutoSize() ) 
		{
			setSize( info.width , info.height) ;	
		}

	}
	
	private function _onNetServerStatus( e:NetServerEvent ):Void
	{
		
		var status:NetServerStatus = e.getStatus() ;

		switch ( true ) 
		{

			case status.equals( NetServerStatus.CLOSED )  :
			{ 
				getLogger().info(this + " connect closed.") ;
				stopProgress() ;
				break ;
			}	
			
			case status.equals( NetServerStatus.SUCCESS )  :
			{
				getLogger().info(this + " connect success.") ;
				break ;
			}	
			
			case status.equals( NetServerStatus.FAILED )  :
			{ 
				getLogger().warn(this + " connect failed.") ;
				break ;
			}
		}	
	}
	
	private var _isFull:Boolean = false ;
	
	/**
	 * Invoqued when the status of the stream change.
	 */
	private function _onNetStreamStatus( info:Object ):Void 
	{
		
		var code:String = info.code ;
		
		getLogger().debug( this + " stream status : " + code + ", level : " + (info.level || "") ) ;
		
		switch ( true ) 
		{
			
			case NetStreamStatus.BUFFER_EMPTY.equals(code) :
			{
				if (_isFull)
				{
					_checkStop() ;
				}
				break ;
			}
			
			case NetStreamStatus.PLAY_START.equals(code) :
			{
				_isFull = false ;
				// getLogger().info( this + " stream starts playing.");
				break;
			}		
			case NetStreamStatus.PLAY_STOP.equals(code) :
			{
				_isFull = true ;
				break;
			}
			
			case NetStreamStatus.PLAY_STREAM_NOT_FOUND.equals(code) :
			{
				getLogger().warn( this + " stream not found.");
				stopProgress() ;
				break ;
			}
			
			case NetStreamStatus.SEEK_INVALID_TIME.equals(code) :
			{
				getLogger().warn( this + " seeks invalid time in '" + this.getUrl() + "'.");
				break;
			}	
			
			case NetStreamStatus.BUFFER_FULL.equals(code) :
			{
				getLogger().info( this + " stream buffer is full." );
				break;
			}

		}
	}
	
	private function _checkStop():Void
	{
		if (_isFull)
		{
			_isFull = false ;
			notifyEvent(MediaEvent.MEDIA_FINISH) ;
			if (isLoop()) 
			{
				this.play(0) ;
			}
			else 
			{
				this.stop() ;	
			}
		}
	}

	/**
	 * Invoqued when the frame update.
	 */
	private function _onFrameUpdate():Void 
	{
		_oNS.pause(true) ;					
		stopProgress() ;				
	}

	/**
	 * Start the load progress timer.
	 */
	/*override*/ private function _startLoadProgress():Void
	{
		if ( isProgressive() )
		{
			_tLoadProgress.start() ;
		}
	}
	
	private function _onMediaProgress( e:MediaEvent ):Void
	{
		if ( e.getPosition() == 100 )
		{
			_isFull = true ;
			_checkStop() ;	
		}
	}
			

}