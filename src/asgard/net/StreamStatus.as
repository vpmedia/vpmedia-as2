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

/**
 * The Stream status values list.
 * @author eKameleon
 */	
class asgard.net.StreamStatus
{
	
	/**
	 * Data is not being received quickly enough to fill the buffer. Data flow will be interrupted until the buffer refills.
	 */
	static public var BUFFER_EMPTY:String = "NetStream.Buffer.Empty" ;
	
	/**
	 * The buffer is full and the stream will begin playing.
	 */
	static public var BUFFER_FULL:String = "NetStream.Buffer.Full" ;
	
	/**
	 * Data has finished streaming, and the remaining buffer will be emptied.
	 */
	static public var BUFFER_FLUSH:String = "NetStream.Buffer.Flush" ;

	/**
	 * A recorded stream failed to delete.
	 */
	static public var CLEAR_FAILED:String = "NetStream.Clear.Failed" ;

	/**
	 * A recorded stream was deleted successfully.
	 */
	static public var CLEAR_SUCCESS:String = "NetStream.Clear.Success" ;

	/**
	 * An attempt to use a Stream method failed.
	 */
	static public var FAILED:String = "NetStream.failed" ;

	/**
	 * The stream is paused.
	 */
	static public var PAUSE:String = "NetStream.Pause.Notify" ;	

	/**
	 * Playback has completed. 
	 * This information object is handled by NetStream.onPlayStatus, and is not handled by NetStream.onStatus.
	 */
	static public var PLAY_COMPLETE:String = "NetStream.Play.Complete" ;

	/**
	 * An error has occurred in playback for a reason other than those listed elsewhere in this table,
	 * such as the subscriber not having read access.
	 */
	static public var PLAY_FAILED:String = "NetStream.Play.Failed" ;	
	
	/**
	 * Data is playing slower than the normal speed.
	 */
	static public var PLAY_INSUFFICIENT_BW:String = "NetStream.Play.InsufficientBW" ;
	
	/**
	 * Caused by a play list reset.
	 */
	static public var PLAY_RESET:String = "NetStream.Play.Start" ;	

	/**
	 * The initial publish to a stream is sent to all subscribers.
	 */
	static public var PLAY_PUBLISH:String = "NetStream.Play.PublishNotify" ;	
	
	/**
	 * Playback has started.
	 */
	static public var PLAY_START:String = "NetStream.Play.Start" ;	
		
	/**
	 * Playback has stopped.
	 */
	static public var PLAY_STOP:String = "NetStream.Play.Stop" ;	
	
	/**
	 * The FLV passed to the play() method can't be found.
	 */
	static public var PLAY_STREAM_NOT_FOUND:String = "NetStream.Play.StreamNotFound" ;	

	/**
	 * The subscriber is switching from one stream to another in a playlist.
	 * This information object is handled by NetStream.onPlayStatus, and is not handled by NetStream.onStatus.
	 */
	static public var PLAY_SWITCH:String = "NetStream.Play.Switch" ;
	
	/**
	 * An unpublish from a stream is sent to all subscribers.
	 */
	static public var PLAY_UNPUBLISH:String = "NetStream.Play.UnpublishNotify" ;	
		
	/**
	 *  Attempt to publish a stream which is already being published by someone else.
	 */
	static public var PUBLISH_BAD_NAME:String = "NetStream.Publish.BadName" ;		

	/**
	 * The publisher of the stream has been idling for too long.
	 */
	static public var PUBLISH_IDLE:String = "NetStream.Publish.Idle" ;	

	/**
	 * Publish was successful.
	 */
	static public var PUBLISH_START:String = "NetStream.Publish.Start" ;

	/**
	 * An attempt to record a stream failed.
	 */
	static public var RECORD_FAILED:String = "NetStream.Record.Failed" ;
	
	/**
	 * Attempt to record a stream that is still playing or the client has no access right.
	 */
	static public var RECORD_NOACCESS:String = "NetStream.Record.NoAccess" ;

	/**
	 * Recording has started.
	 */
	static public var RECORD_START:String = "NetStream.Record.Start" ;
	
	/**
	 * Recording stopped.
	 */
	static public var RECORD_STOP:String = "NetStream.Record.Stop" ;

	/**
	 * The seek fails, which happens if the stream is not seekable.
	 */
	static public var SEEK_FAILED:String = "NetStream.Seek.Failed" ;

	/**
	 * For video downloaded with progressive download, 
	 * the user has tried to seek or play past the end of the video data that has downloaded thus far,
	 * or past the end of the video once the entire file has downloaded. 
	 * The message.details  property contains a time code that indicates the last valid position to which the user can seek.
	 */
	static public var SEEK_INVALID_TIME:String = "NetStream.Seek.InvalidTime" ;

	/**
	 * The seek operation is complete.
	 */
	static public var SEEK_NOTIFY:String = "NetStream.Seek.Notify" ;

	/**
	 * The stream is unpaused.
	 */
	static public var UNPAUSE:String = "NetStream.UnPause.Notify" ;

	/**
	 * The unpublish operation was successfull.
	 */
	static public var UNPUBLISH_SUCCESS:String = "NetStream.Unpublish.Success" ;	
	
}