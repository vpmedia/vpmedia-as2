/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.date.Time;
import asgard.events.ProgressEvent;
import asgard.net.Stream;
import asgard.net.StreamCollector;

import vegas.data.map.HashMap;
import vegas.events.AbstractCoreEventDispatcher;
import vegas.events.Delegate;
import vegas.events.Event;
import vegas.events.EventDispatcher;
import vegas.events.StringEvent;
import vegas.events.TimerEvent;
import vegas.string.StringFormatter;
import vegas.util.ConstructorUtil;
import vegas.util.Timer;

/**
 * This singleton controls a Stream instance.
 * @author eKameleon
 */
class asgard.net.StreamExpert extends AbstractCoreEventDispatcher
{
	
	/**
	 * Creates a new StreamExpert instance.
	 * @param streamID the id of the stream to control with this object.
	 */
	private function StreamExpert( streamID:String ) 
	{
		
		initEvent() ;

		_formatter = new StringFormatter() ;

		_streamID = streamID ;		
		
		_tProgress = new Timer( DEFAULT_DELAY ) ;
		_tProgress.addEventListener( TimerEvent.TIMER , new Delegate(this, _onProgress) ) ;
		
	}
	
	/**
	 * The default delay of the internal timer of this object.
	 */
	static public var DEFAULT_DELAY:Number = 150  ;

	/**
	 * The time pattern to format the time in the getTimeString() method.
	 */
	static public var DEFAULT_TIME_PATTERN:String = "{0}:{1}:{2}" ;

	/**
	 * The name of the event when the stream is finished.
	 */
	static public var STREAM_PLAY_FINISH:String = "onStreamPlayFinish" ;

	/**
	 * The name of the event when the stream is looped.
	 */
	static public var STREAM_PLAY_LOOP:String = "onStreamPlayLooped" ;

	/**
	 * The name of the event when the stream is paused.
	 */
	static public var STREAM_PLAY_PAUSE:String = "onStreamPlayPause" ;
	
	/**
	 * The name of the event when the stream is in progress.
	 */
	static public var STREAM_PLAY_PROGRESS:String = "onStreamPlayProgress" ;

	/**
	 * The name of the event when the stream is resumed.
	 */
	static public var STREAM_PLAY_RESUME:String = "onStreamPlayResume" ;

	/**
	 * The name of the event when the stream is started.
	 */
	static public var STREAM_PLAY_START:String = "onStreamPlayStart" ;
	
	/**
	 * The name of the event when the stream is stopped.
	 */
	static public var STREAM_PLAY_STOP:String = "onStreamPlayStop" ;

	/**
	 * (read-only) Returns {@code true] if the play activity of the Stream in in progress.
	 */
	public function get isPlaying():Boolean 
	{
		return _isPlaying ;
	}

	/**
	 * Specifies whether audio should be sent over the stream (from a Microphone object passed as source) 
	 * or not (null passed as source). This method is available only to the publisher of the specified stream.
	 * @param source The source of the audio to be transmitted. 
	 * Valid values are a Microphone object and null.
	 */
	public function attachAudio( source:Microphone ):Void
	{
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().attachAudio(source) ;
		}
		else
		{
			getLogger().warn( this + " attachAudio failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * Specifies whether audio should be sent over the stream (from a Microphone object passed as source) 
	 * or not (null passed as source). This method is available only to the publisher of the specified stream.
	 * @param camSource The source of the video transmission. 
	 * Valid values are a Camera object (which starts capturing video) and null. 
	 * If you pass null, Flash stops capturing video, and any additional parameters you send are ignored.
	 * @param snapShotMilliseconds An optional integer that specifies whether the video stream is continuous, a single frame, or a series of single frames used to create time-lapse photography.
	 */
	public function attachVideo( camSource:Camera , snapShotMilliseconds:Number ):Void
	{
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().attachVideo.apply( getStream() , arguments ) ;
		}
		else
		{
			getLogger().warn( this + " attachVideo failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * Returns {@code true} if the stream is loop when the stream is finished.
	 * @return {@code true} if the stream is loop when the stream is finished.
	 */
	public function get isLoop():Boolean
	{
		return _isLoop ; 	
	}

	/**
	 * Sets if the stream is loop when the stream is finished.
	 */
	public function set isLoop(b:Boolean):Void
	{
		_isLoop = b ; 	
	}

	/**
	 * Close the Stream.
	 */	
	public function close():Void
	{
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().close() ;
		}
		else
		{
			getLogger().warn( this + " start play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}
	
	/**
	 * Returns {@code true} if the StreamExpert factory contains the specified {@code StreamExpert} ID.
	 * @param streamID the stream id of the StreamExpert singleton.
	 * @return {@code true} if the StreamExpert factory contains the specified {@code StreamExpert} ID.
	 */
	static public function contains( streamID:String ):Boolean
	{
		return _map.containsKey( streamID ) ;
	}

	/**
	 * Returns the event name when the stream play is finished.
	 * @return the event name when the stream play is finished.
	 */
	public function getEventTypePLAY_FINISH():String
	{
		return _ePlayFinish.getType() ;	
	}
	
	/**
	 * Returns the event name when the stream play is looped.
	 * @return the event name when the stream play is looped.
	 */
	public function getEventTypePLAY_LOOP():String
	{
		return _ePlayLoop.getType() ;	
	}
	
	/**
	 * Returns the event name when the stream play is paused.
	 * @return the event name when the stream play is paused.
	 */
	public function getEventTypePLAY_PAUSE():String
	{
		return _ePlayPause.getType() ;	
	}
	
	/**
	 * Returns the event name when the stream play is in progress.
	 * @return the event name when the stream play is in progress.
	 */
	public function getEventTypePLAY_PROGRESS():String
	{
		return _ePlayProgress.getType() ;	
	}
	
	/**
	 * Returns the event name when the stream play is resumed.
	 * @return the event name when the stream play is resumed.
	 */
	public function getEventTypePLAY_RESUME():String
	{
		return _ePlayResume.getType() ;	
	}

	/**
	 * Returns the event name when the stream play is started.
	 * @return the event name when the stream play is started.
	 */
	public function getEventTypePLAY_START():String
	{
		return _ePlayStart.getType() ;	
	}
	
	/**
	 * Returns the event name when the stream play is stopped.
	 * @return the event name when the stream play is stopped.
	 */
	public function getEventTypePLAY_STOP():String
	{
		return _ePlayStop.getType() ;	
	}

	/**
	 * Returns a StreamExpert singleton.
	 * @param streamID the stream id of the StreamExpert singleton.
	 * @return a StreamExpert singleton or null .
	 */
	static public function getInstance( streamID:String ):StreamExpert
	{
		if ( _map == null)
		{
			_map = new HashMap() ;	
		}
		if ( !_map.containsKey( streamID ) )
		{
			_map.put( streamID, new StreamExpert( streamID ) ) ;
		}
		return _map.get( streamID ) || null ;
	}
	
	/**
	 * Returns the delay of the internal timer to notify the progress of the Stream.
	 * @return the delay of the internal timer to notify the progress of the Stream.
	 */
	public function getProgressDelay():Number
	{
		return _tProgress.getDelay() ;	
	}
	
	/**
	 * Returns the Stream reference to control.
	 * @return the Stream reference to control.
	 */
	public function getStream():Stream
	{
		return StreamCollector.get( getStreamID() ) ;	
	}
	
	/**
	 * Returns the id of the Stream to control.
	 * @return the id of the Stream to control.
	 */
	public function getStreamID():String
	{
		return _streamID ;	
	}

	/**
	 * Returns the formatted string representation of the time position of the stream passed in argument.
	 * @param pattern the optional string pattern to format the hours, the minutes and the seconds of the passed-in time. 
	 * By default the method use the static constant DEFAULT_TIME_PATTERN with the value "{0}:{1}:{2}".
	 * <li>{0} is the representation of the hours value.</li>
	 * <li>{1} is the representation of the minutes value.</li>
	 * <li>{2} is the representation of the seconds value.</li>
	 * @return the formatted string representation of the time position of the stream passed in argument.
	 * @see StringFormatter
	 */
	public function getTimeString( pattern:String ):String
	{
	
		var time:Number ;

		if ( StreamCollector.contains( getStreamID() ) )
		{
			time = getStream().time ;
		}
	
		var t:Time = new Time( isNaN(time)? 0 : time , "s" ) ;
		
		_formatter.pattern = pattern || DEFAULT_TIME_PATTERN ;
		
		var hours:Number   = t.getHours(0) ;
		var minutes:Number = t.getMinutes(0) ;
		var seconds:Number = t.getSeconds(0) ;

		return _formatter.format
		(
			( (hours < 10)   ? "0" : "" ) +  hours.toString() ,
			( (minutes < 10) ? "0" : "" ) +  minutes.toString() ,
			( (seconds < 10) ? "0" : "" ) +  seconds.toString() 
		) ;	
		
	}

	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 * Overrides this method.
	 */
	public function initEvent():Void
	{
		_ePlayFinish   = new StringEvent   ( STREAM_PLAY_FINISH , getStreamID() ) ;
		_ePlayLoop     = new StringEvent   ( STREAM_PLAY_LOOP , getStreamID() ) ;
		_ePlayPause    = new StringEvent   ( STREAM_PLAY_PAUSE , getStreamID() ) ;
		_ePlayProgress = new ProgressEvent ( STREAM_PLAY_PROGRESS ) ;
		_ePlayResume   = new StringEvent   ( STREAM_PLAY_RESUME , getStreamID() ) ;
		_ePlayStart    = new StringEvent   ( STREAM_PLAY_START , getStreamID() ) ;
		_ePlayStop     = new StringEvent   ( STREAM_PLAY_STOP , getStreamID() ) ;
	}

	/**
	 * Pause the Stream.
	 */
	public function pause():Void
	{
		_global.clearTimeout(_timeout) ;
		if ( StreamCollector.contains( getStreamID() ) )
		{
			setPlaying(false) ;
			getStream().pause( true ) ;
			dispatchEvent( _ePlayPause ) ;	
			_tProgress.stop() ;
		}
		else
		{
			getLogger().warn( this + " start play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * This method start the stream.
	 */
	public function play( name:Object, start:Number, len:Number, reset:Object ):Void
	{
		_global.clearTimeout(_timeout) ;
		if ( StreamCollector.contains( getStreamID() ) )
		{
			var s:Stream = getStream() ;
			setPlaying(true) ;
			s.play.apply( s, arguments ) ;
			dispatchEvent( _ePlayStart ) ;	
			_tProgress.start() ;
		}
		else
		{
			getLogger().warn( this + " play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}
	
	/**
	 * Sends streaming audio, video, and text messages from the client to the Flash Media Server.
	 * Optionally recording the stream during transmission. 
	 * This method is available only to the publisher of the specified stream.
	 * @param name A string value that identifies the stream. If you pass false, the publish operation stops. 
	 * Subscribers to this stream must pass this same name when they call {@code NetStream.play()}. 
	 * You don’t need to include a file extension for the stream name.
	 * @param howToPublish An optional string that specifies how to publish the stream. 
	 * Valid values are "record", "append", and "live". The default value is "live".
	 */
	public function publish( name , howToPublish:String ):Void
	{
		
		_global.clearTimeout(_timeout) ;
		
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getLogger().fatal( this + ".... publish " + getStream()) ;
			getStream().publish( name, howToPublish ) ;
		}
		else
		{
			getLogger().warn( this + " publish failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * Specifies whether incoming audio plays on the specified stream. 
	 * This method is available only to clients subscribed to the specified stream, not to the stream's publisher.
	 * @param flag A Boolean value that specifies whether incoming audio plays on the specified stream (true) or not (false). The default value is true.
	 */
	public function receiveAudio( flag:Boolean ):Void
	{
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().receiveAudio( flag ) ;
		}
		else
		{
			getLogger().warn( this + " start play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * Specifies whether incoming video will play on the specified stream, or specifies the frame rate of the video. 
	 * This method is available only to clients subscribed to the specified stream, not to the stream's publisher.
	 * @param value A Boolean value that specifies whether incoming video plays on the specified stream (true) or not (false). 
	 * The default value is true.
	 * Or a number that specifies the frame rate per second of the incoming video. 
	 * The default rate is the frame rate of the FLV file or live stream being played.
	 */
	public function receiveVideo( value ):Void
	{
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().receiveVideo( value ) ;
		}
		else
		{
			getLogger().warn( this + " start play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * Registers the Stream object of this expert to handles this events.
	 */
	public function registerStream():Void
	{
		if ( StreamCollector.containsStream( getStream() ) )
		{
			getStream().setParent( EventDispatcher(this) ) ;
		}
		else
		{
			getLogger().warn( this + " registerStream failed with an unknow or empty Stream object.") ;	
		}
	}

	/**
	 * Release the specified StreamExpert singleton.
	 * @param streamID the stream id of the StreamExpert singleton.
	 * @return the removed StreamExpert singleton or null .
	 */
	static public function release( streamID:String ):StreamExpert
	{
		if ( StreamCollector.contains( streamID ) )
		{
			StreamExpert.getInstance(streamID).unregisterStream() ;
		}
		return _map.remove( streamID ) ;
	}

	/**
	 * Resume the Stream.
	 */
	public function resume():Void
	{
		_global.clearTimeout(_timeout) ;
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().pause( false ) ;
			setPlaying(true) ;
			dispatchEvent( _ePlayResume ) ;
			_tProgress.start() ;
		}
		else
		{
			getLogger().warn( this + " start play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * 
	 */
	public function seek( offset:Number ):Void
	{
		_global.clearTimeout(_timeout) ;
		if ( StreamCollector.contains( getStreamID() ) )
		{
			getStream().seek( offset ) ;
		}
		else
		{
			getLogger().warn( this + " start play failed with an unknow Stream id : " + getStreamID() ) ;	
		}
	}

	/**
	 * Sets the event name when the stream play is finished.
	 */
	public function setEventTypePLAY_FINISH( type:String ):Void
	{
		_ePlayFinish.setType( type ) ;	
	}
	
	/**
	 * Sets the event name when the stream play is looped.
	 */
	public function setEventTypePLAY_LOOP( type:String ):Void
	{
		_ePlayLoop.setType( type ) ;		
	}
	
	/**
	 * Sets the event name when the stream play is paused.
	 */
	public function setEventTypePLAY_PAUSE( type:String ):Void
	{
		_ePlayPause.setType( type ) ;
	}
	
	/**
	 * Sets the event name when the stream play is in progress.
	 */
	public function setEventTypePLAY_PROGRESS( type:String ):Void
	{
		_ePlayProgress.setType( type ) ;		
	}
	
	/**
	 * Sets the event name when the stream play is resumed.
	 */
	public function setEventTypePLAY_RESUME( type:String ):Void
	{
		_ePlayResume.setType( type ) ;		
	}

	/**
	 * Sets the event name when the stream play is started.
	 */
	public function setEventTypePLAY_START( type:String ):Void
	{
		_ePlayStart.setType( type ) ;	
	}
	
	/**
	 * Sets the event name when the stream play is stopped.
	 */
	public function setEventTypePLAY_STOP( type:String ):Void
	{
		_ePlayStop.setType( type ) ;	
	}

	/**
	 * Sets the delay of the internal timer to notify the progress of the Stream.
	 * @param n the delay of the internal Timer of this object.
	 */
	public function setProgressDelay( n:Number ):Void
	{
		_tProgress.setDelay( n ) ;	
	}

	/**
	 * Sets the play activity of the Stream.
	 */
	public function setPlaying(b:Boolean):Void 
	{
		_isPlaying = b ;
	}

	/**
	 * This method stop stream.
	 * @param time the optional time value to seek the video before to stop it.
	 */
	public function stop( nTime:Number ):Void
	{
		_global.clearTimeout(_timeout) ;				
		if (_tProgress.running)
		{
			_tProgress.stop() ;
		}
		if ( StreamCollector.contains( getStreamID() ) )
		{
			setPlaying(false) ;
			getStream().stop() ;
			dispatchEvent( _ePlayStop ) ;
			if (nTime > -1)
			{
				_timeout = _global.setTimeout(this, "seek", 150, nTime) ;
			}
		}
		else
		{
			getLogger().warn( this + " stop play failed with an unknow Stream id : " + getStreamID() ) ;	
		}	
	}
	
	/**
	 * Returns the String representation of the object.
	 * @return the String representation of the object.
	 */
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + ( getStreamID() != null ? (":" + getStreamID()) : "" ) + "]" ;	
	}
	
	/**
	 * Unregisters the Stream object of this expert to handles this events.
	 */
	public function unregisterStream():Void
	{
		if ( StreamCollector.containsStream( getStream() ) )
		{
			getStream().setParent( null ) ;
		}
		else
		{
			getLogger().warn( this + " registerStream failed with an unknow or empty Stream object.") ;	
		}
	}
	
	/**
	 * Update the audio activity notify by the external stream publish.
	 * @param level The audio activity level value.
	 */
	public function updateAudioActivity( level:Number ):Void
	{
		if ( StreamCollector.containsStream( getStream() ) )
		{
			getStream().updateAudioActivity( level ) ;
		}
		else
		{
			getLogger().warn( this + " updateAudioActivity failed with an unknow or empty Stream object.") ;	
		}
	}

	private var _ePlayFinish:Event ;
	
	private var _ePlayLoop:Event ;
	
	private var _ePlayPause:Event ;
	
	private var _ePlayProgress:Event ;
	
	private var _ePlayResume:Event ;
	
	private var _ePlayStart:Event ;
	
	private var _ePlayStop:Event ;
	
	private var _formatter:StringFormatter ;
	
	private var _isLoop:Boolean = false ;
	
	private var _isPlaying:Boolean = false ;
	
	static private var _map:HashMap  ;
	
	private var _streamID:String ;
	
	private var _timeout:Number ;
	
	private var _tProgress:Timer ;
	
	/**
	 * Invoqued when the stream is in progress.
	 */
	private function _onProgress( e:TimerEvent ):Void
	{
		
		var progress:Number = getStream().progress ;
		
		if (progress == 100)
		{
			dispatchEvent( _ePlayFinish ) ;
			if (_isLoop)
			{
				dispatchEvent( _ePlayLoop ) ;
				getStream().seek(0) ;
			}
			else
			{
				_tProgress.stop() ;
			}	
		}
		else
		{
			_ePlayProgress.setContext( getStreamID ) ;
			ProgressEvent(_ePlayProgress).percent = progress ;
			dispatchEvent( _ePlayProgress ) ;
		}

	}
	
}