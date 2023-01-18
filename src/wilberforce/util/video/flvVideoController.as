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
 * @author Simon Oliver
 * @version 1.0
 */
 
import wilberforce.event.Delegate;
import wilberforce.event.simpleEventDispatcher;
import wilberforce.event.frameEventBroadcaster;

/**
* FLV Controller. Used to issue information relating to the playing of an flv
* TODO - This has been superceded by com.bourre.medias.video.VideoDisplay from pixlib
*/
class wilberforce.util.video.flvVideoController extends simpleEventDispatcher
{
	var video:Video;
	var netConnection:NetConnection;
	var netStream:NetStream;
	
	var currentVideoUrl:String;
	
	// Metadata
	var creationdate:String;
	var framerate:Number;
	var audiocodecid:Number;
	var audiodatarate:Number;
	var videocodecid:Number;
	var canSeekToEnd:Boolean;
	var videodatarate:Number;
	var height:Number;
	var width:Number;
	var duration:Number;
	
	var time:Number;	
	var percentPlayed:Number;
	var percentLoaded:Number;
	var percentBufferFull:Number;
	
	var paused:Boolean;
	
	function flvVideoController(tVideo:Video,dontMonitor:Boolean)
	{
		video=tVideo;
		netConnection= new NetConnection();
		
		// We are loading an flv file rather than streaming from flashcom
		netConnection.connect(null);
		netStream = new NetStream(netConnection);
		
		video.attachVideo(netStream);
		
		netStream.onStatus = Delegate.create(this, onStreamStatus);
		netStream.onMetaData = Delegate.create(this, onMetaData);	
		
		// Set up a frame event to monitor loading and playback
		if (!dontMonitor)
		{
			frameEventBroadcaster.addEventListener("frameStep",this,frameStep);
		}
	}
	
	function playFlv(videoUrl:String)
	{
		currentVideoUrl=videoUrl;
		netStream.play(videoUrl);
		
		// Reset the status
		percentPlayed=0;
		time=0;
		percentBufferFull=0;
		percentLoaded=0;
		paused=false;
	}
	
	function onStreamStatus(infoObject:Object)
	{

		switch (infoObject.level) {
			case "status" :			
				processStatusMessage(infoObject.code);
				break;
			case "error" :
				processErrorMessage(infoObject.code);
				break;
		}
		
	}
	
	function processStatusMessage(tCode:String)
	{
		trace("** VIDEO STATUS: "+tCode);
		dispatchEvent("videoStatus",tCode,currentVideoUrl);
		switch (tCode)
		{
			case "NetStream.Play.Start" :
				
				break;
			case "NetStream.Play.Stop" :
				break;
			case "NetStream.Buffer.Full" :
				dispatchEvent("videoPlaying",currentVideoUrl);
				break;
			case "NetStream.Buffer.Empty " :
				dispatchEvent("videoBuffering",currentVideoUrl);
				break;
		}
	}
	function processErrorMessage(tCode:String)
	{
		trace("** ERROR: "+tCode);
		dispatchEvent("videoError",tCode,currentVideoUrl);
		switch (tCode)
		{
			case "NetStream.Play.StreamNotFound":
				dispatchEvent("StreamNotFound",currentVideoUrl);
				break;
		}
	}
	function onMetaData(infoObject:Object) {
		
		trace("___METADATA_______");
		for (var prop in infoObject) {
            trace("\t"+prop+":\t"+infoObject[prop]);
        }
		
		if (infoObject.creationdate) creationdate=infoObject.creationdate;
		if (infoObject.framerate) framerate=infoObject.framerate;
		if (infoObject.audiocodecid) audiocodecid=infoObject.audiocodecid;
		if (infoObject.audiodatarate) audiodatarate=infoObject.audiodatarate;
		if (infoObject.videocodecid) videocodecid=infoObject.videocodecid;
		if (infoObject.canSeekToEnd) canSeekToEnd=infoObject.canSeekToEnd;
		if (infoObject.videodatarate) videodatarate=infoObject.videodatarate;
		if (infoObject.height) height=infoObject.height;
		if (infoObject.width) width=infoObject.width;
		if (infoObject.duration) duration=infoObject.duration;
		
		// Broadcast to listeners
		if (width && height) dispatchEvent("videoSize",width,height);
		if (framerate) dispatchEvent("framerate",framerate);
		if (duration) dispatchEvent("duration",duration);
		
	}
	
	public function frameStep():Void
	{		
		// Update video position
		var tNewTime=netStream.time;
		if (tNewTime!=time)
		{			
			time=tNewTime;
			percentPlayed=time/duration;
			dispatchEvent("videoTimeElapsed",time,duration);
			dispatchEvent("videoPercentElapsed",percentPlayed);
		}
				
		// Update loaded percentage
		var tPercentLoaded:Number=netStream.bytesLoaded/netStream.bytesTotal;
		if (tPercentLoaded!=percentLoaded)
		{
			percentLoaded=tPercentLoaded;
			dispatchEvent("videoPercentLoaded",percentLoaded);
		}
		
		// Update buffer size percentage
		var tPercentBufferFull:Number=netStream.bufferLength/netStream.bufferTime;
		if (percentBufferFull!=tPercentBufferFull)
		{
			dispatchEvent("videoPercentBufferFull",percentBufferFull);
		}
		
	}
	
	function pause()
	{
		trace("Pause called");
		if (paused) return;
		netStream.pause();
		dispatchEvent("videoPaused");
		paused=true;
	}
	
	function stop()
	{
		
	}
	
	function unpause()
	{
		if (!paused) return;
		netStream.pause();
		
		dispatchEvent("videoUnpaused");
		paused=false;
	}
	
	function jumpTo(time:Number)
	{
		
		
	}
	
}