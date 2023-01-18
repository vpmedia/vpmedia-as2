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

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.core.value.MIBooleanValue;
import pl.milib.core.value.MINumberValue;
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.FLVPlayer extends MIBroadcastClass implements EnterFrameReciver, MIValueOwner {
	
	public var event_NewFLVFile : Object={name:'NewFLVFile'};	public var event_MovieIsFinished : Object={name:'MovieIsFinished'};
	
	//set of public values for ui
	//read only
	public var isPlaying : MIBooleanValue;
	public var isBuffering : MIBooleanValue;
	public var loadingProgress : MINumberValue;
	public var playingProgress : MINumberValue;
	public var isStreamNotFound : MIBooleanValue;
	
	//read and write
	public var isPlay : MIBooleanValue;
	public var volume : MINumberValue;
	
	private var videoObject : Video;
	private var count : Number;
	private var netConnection : NetConnection;
	private var netStream : NetStream;
	private var fileUrl : String;
	private var audioMC : MovieClip;
	private var sound : Sound;
	private var metaData : Object;
	
	public function FLVPlayer(videoObject:Video) {
		this.videoObject=videoObject;
		if(!videoObject){
			logError_UnexpectedArg(arguments, 0, ['videoMCObject:Video'], '!videoObject; videoObject>'+link(videoObject));
		}
		
		count=0;
		
		netConnection=new NetConnection();
		netConnection.connect(null);
		
		isPlay=(new MIBooleanValue(false)).setOwner(this);		isPlaying=(new MIBooleanValue(false)).setOwner(this);		isBuffering=(new MIBooleanValue(false)).setOwner(this);		isStreamNotFound=(new MIBooleanValue(false)).setOwner(this);		volume=(new MINumberValue(null, .2)).setOwner(this);		loadingProgress=(new MINumberValue(0, 0)).setOwner(this);		playingProgress=(new MINumberValue(0, 0)).setOwner(this);
		volume.setupMaxMinNumber(0, 1);		loadingProgress.setupMaxMinNumber(0, 1);		playingProgress.setupMaxMinNumber(0, 1);
		
		addDeleteTogether(MIMC.forInstance(videoObject['_parent']));
		
	}//<>
	
	public function setupFile(fileUrl:String):Void{		
		if(fileUrl==this.fileUrl){ return; }
		this.fileUrl=fileUrl;
		
		isStreamNotFound.v=false;
		delete metaData;
		
		count++;
		
		delete netStream.onStatus;
		delete netStream.onMetaData;
		netStream.close();
		videoObject.clear();
		delete netStream;
		
		netStream=new NetStream(netConnection);
		netStream.onStatus=MILibUtil.createDelegate(this, onNetStreamStatus);
		netStream.onMetaData=MILibUtil.createDelegate(this, onNetStreamMetaData);
		netStream.setBufferTime(5);
		
		audioMC.unloadMovie();
		var audioMILIBMC:MovieClip=MILibUtil.getMCMILibMCForObject(videoObject['_parent']);
		audioMC=audioMILIBMC.createEmptyMovieClip("flv_audio"+count, audioMILIBMC.getNextHighestDepth());
		audioMC.attachAudio(netStream);
		sound=new Sound(audioMC);
		sound.setVolume(volume.v*100);
		
		videoObject.attachVideo(netStream);
		
		loadingProgress.v=0;		playingProgress.v=0;
		isPlay.v=true;
		isBuffering.v=true;
		//isPlaying.v=false;
		
		netStream.play(fileUrl);
		
//		var contVol=this.VCC.Controls.getVolume01()
//		if(contVol.isNumber){ this.setFlvVolume(contVol) }
//		else{ this.setFlvVolume(.2) }
		
		bev(event_NewFLVFile);
		
		EnterFrameBroadcaster.start(this);
		
	}//<<
	
	public function setPlayingProgress(n01:Number):Void {
		if(metaData.duration){
			netStream.seek(n01*metaData.duration);
		}
	}//<<
	
	public function revindFlvAndStop():Void{
		netStream.seek(0);
		isPlay.v=false;
	}//<<
	
	public function isFlvEnd(){
		return Math.round(netStream.time)==Math.round(metaData.duration);
	}//<<
	
	public function getTime(Void):Number { return netStream.time; }//<<
	public function getDuration(Void):Number { return metaData.duration; }//<<
	
	private function doDelete(Void):Void {
		netStream.close();
		EnterFrameBroadcaster.stop(this);
		//this.setFlvVolume(0)
		audioMC.unloadMovie();
		super.doDelete();
	}//<<
	
//****************************************************************************
// EVENTS for FLVPlayer
//****************************************************************************
	private function onNetStreamStatus(infoObject:Object):Void {
		switch(infoObject.level){
			case 'error':
			break;
			case 'status':
				logHistory(infoObject.code);
				switch(infoObject.code){
					case 'NetStream.Buffer.Empty':
						if(isPlaying.v){
							if(isFlvEnd()){
								bev(event_MovieIsFinished);
							}else{
								isBuffering.v=true;
							}
						}else{
							if(isFlvEnd()){
								playingProgress.v=1;
							}
						}
					break;
					case 'NetStream.Buffer.Flush':
						
					break;
					case 'NetStream.Buffer.Full':
						isBuffering.v=false;
					break;
					case 'NetStream.Play.Start':
						isPlaying.v=true;
						isBuffering.v=false;
					break;
					case 'NetStream.Play.Stop':
						//isPlaying.v=false;
					break;
					case 'NetStream.Play.StreamNotFound':
						EnterFrameBroadcaster.stop(this);
						isPlay.v=false;						isStreamNotFound.v=true;
						logError_UnexpectedSituation(arguments, 'NetStream.Play.StreamNotFound');
					break;
				}
			break;
		}
	}//<<
	
	private function onNetStreamMetaData(metaData:Object):Void {
		// {duration:109.45, creationdate:"Fri Sep 10 19:12:26 2004", framerate:24, audiodatarate:112, videodatarate:896, height:480, width:480}
		this.metaData=metaData;
	}//<<
	
	public function onEnterFrame(id):Void {
		loadingProgress.v=netStream.bytesLoaded/netStream.bytesTotal;
		playingProgress.v=netStream.time/metaData.duration;
	}//<<
	
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		switch(val){
			case isPlay:
				netStream.pause(!isPlay.v);
				isBuffering.v=false;
			break;
			case volume:
				sound.setVolume(volume.v*100);
			break;
		}
	}//<<
	
}