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

import vegas.core.CoreObject;

/**
 * The NetStream status object who contains the level and the status value of all NetStreams in the application.
 * @author eKameleon
 * @version 1.0.0.0
 */	
class asgard.net.NetStreamStatus extends CoreObject 
{
	
	/**
	 * Creates a new NetStreamStatus instance.
	 * @param sCode the {@code String} code value.
	 * @param sLevel the {@code String} level value.
	 */
	public function NetStreamStatus( sCode:String , sLevel:String) 
	{
		code = sCode ;
		level = sLevel ;
	}

	/**
	 * The 'error' level code.
	 */
	static public var ERROR:String = "error" ;
	
	/**
	 * The 'status' level code.
	 */
	static public var STATUS:String = "status" ;
	
	/**
	 * Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills.
	 */
	static public var BUFFER_EMPTY:NetStreamStatus = new NetStreamStatus("NetStream.Buffer.Empty", STATUS) ;
	
	/**
	 * The buffer is full and the stream will begin playing.
	 */
	static public var BUFFER_FULL:NetStreamStatus = new NetStreamStatus("NetStream.Buffer.Full", STATUS) ;
	
	/**
	 * Data has finished streaming, and the remaining buffer will be emptied.
	 */
	static public var BUFFER_FLUSH:NetStreamStatus = new NetStreamStatus("NetStream.Buffer.Flush", STATUS) ;

	/**
	 * The stream is paused.
	 */
	static public var PAUSE:NetStreamStatus = new NetStreamStatus("NetStream.Pause.Notify", STATUS) ;	

	/**
	 * An error has occurred in playback for a reason other than those listed elsewhere in this table,
	 * such as the subscriber not having read access.
	 */
	static public var PLAY_FAILED:NetStreamStatus = new NetStreamStatus("NetStream.Play.Failed", ERROR) ;	
	
	/**
	 * Caused by a play list reset.
	 */
	static public var PLAY_RESET:NetStreamStatus = new NetStreamStatus("NetStream.Play.Start", STATUS) ;	

	/**
	 * The initial publish to a stream is sent to all subscribers.
	 */
	static public var PLAY_PUBLISH:NetStreamStatus = new NetStreamStatus("NetStream.Play.PublishNotify", STATUS) ;	
	
	/**
	 * Playback has started.
	 */
	static public var PLAY_START:NetStreamStatus = new NetStreamStatus("NetStream.Play.Start", STATUS) ;	
		
	/**
	 * Playback has stopped.
	 */
	static public var PLAY_STOP:NetStreamStatus = new NetStreamStatus("NetStream.Play.Stop", STATUS) ;	
	
	/**
	 * The FLV passed to the play() method can't be found.
	 */
	static public var PLAY_STREAM_NOT_FOUND:NetStreamStatus = new NetStreamStatus("NetStream.Play.StreamNotFound", ERROR) ;	

	/**
	 * An unpublish from a stream is sent to all subscribers.
	 */
	static public var PLAY_UNPUBLISH:NetStreamStatus = new NetStreamStatus("NetStream.Play.UnpublishNotify", STATUS) ;	
	
	/**
	 * Publish was successful.
	 */
	static public var PUBLISH_START:NetStreamStatus = new NetStreamStatus("NetStream.Publish.Start", STATUS) ;	
	
	/**
	 *  Attempt to publish a stream which is already being published by someone else.
	 */
	static public var PUBLISH_BAD_NAME:NetStreamStatus = new NetStreamStatus("NetStream.Publish.BadName", ERROR) ;		

	/**
	 * The publisher of the stream has been idling for too long.
	 */
	static public var PUBLISH_IDLE:NetStreamStatus = new NetStreamStatus("NetStream.Publish.Idle", STATUS) ;	

	/**
	 * An attempt to record a stream failed.
	 */
	static public var RECORD_FAILED:NetStreamStatus = new NetStreamStatus("NetStream.Record.Failed", ERROR) ;
	
	/**
	 * Attempt to record a stream that is still playing or the client has no access right.
	 */
	static public var RECORD_NOACCESS:NetStreamStatus = new NetStreamStatus("NetStream.Record.NoAccess", ERROR) ;

	/**
	 * Recording has started.
	 */
	static public var RECORD_START:NetStreamStatus = new NetStreamStatus("NetStream.Record.Start", STATUS) ;
	
	/**
	 * Recording stopped.
	 */
	static public var RECORD_STOP:NetStreamStatus = new NetStreamStatus("NetStream.Record.Stop", STATUS) ;

	/**
	 * The seek fails, which happens if the stream is not seekable.
	 */
	static public var SEEK_FAILED:NetStreamStatus = new NetStreamStatus("NetStream.Seek.Failed", ERROR) ;

	/**
	 * For video downloaded with progressive download, 
	 * the user has tried to seek or play past the end of the video data that has downloaded thus far,
	 * or past the end of the video once the entire file has downloaded. 
	 * The message.details  property contains a time code that indicates the last valid position to which the user can seek.
	 */
	static public var SEEK_INVALID_TIME:NetStreamStatus = new NetStreamStatus("NetStream.Seek.InvalidTime", ERROR) ;

	/**
	 * The seek operation is complete.
	 */
	static public var SEEK_NOTIFY:NetStreamStatus = new NetStreamStatus("NetStream.Seek.Notify", STATUS) ;

	/**
	 * The stream is unpaused.
	 */
	static public var UNPAUSE:NetStreamStatus = new NetStreamStatus("NetStream.UnPause.Notify", STATUS) ;

	/**
	 * The unpublish operation was successfull.
	 */
	static public var UNPUBLISH_SUCCESS:NetStreamStatus = new NetStreamStatus("NetStream.Unpublish.Success", STATUS) ;	
	
	/**
	 * The code of the NetStream information.
	 */
	public var code:String ;
	
	/**
	 * The level of the NetStream status information.
	 */
	public var level:String ;

	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean
	{
		return o.toString() == toString() ;	
	}

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String 
	{
		return code ;	
	}

}