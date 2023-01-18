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

import pl.milib.core.supers.MIRunningClass;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.tools.MIMovieClipLoader extends MIRunningClass {

	//Invoked when a call to MovieClipLoader.loadClip() has begun to download a file.
	public var event_LoadStart:Object={name:'LoadStart'};
	
	//Invoked before mc enter first frame (1st frame mc's are rechable)
	public var event_Enter1StFrame:Object={name:'Enter1StFrame'};
	
	//Invoked when a file that was loaded with MovieClipLoader.loadClip()
	//is completely downloaded.
	//{httpStatus:httpStatus}
	public var event_LoadComplete:Object={name:'LoadComplete'};
	
	//Invoked when a file loaded with MovieClipLoader.loadClip() has failed to load.
	//{errorCode:errorCode, httpStatus:httpStatus}
	public var event_LoadError:Object={name:'LoadError'};
	
	//Invoked when the actions on the first frame of the loaded clip have been executed.
	public var event_LoadInit:Object={name:'LoadInit'};
	
	//Invoked every time the loading content is written to the hard disk during
	//the loading process (that is, between MovieClipLoader.onLoadStart
	//and MovieClipLoader.onLoadComplete).
	//{progress:loadedBytes/totalBytes}
	public var event_LoadProgress:Object={name:'LoadProgress'};
	
	private var mcl : MovieClipLoader;
	private var targetMC : MovieClip;
	private var url : String;
	private var mc : MovieClip;
	
	public function MIMovieClipLoader() {
		mcl=new MovieClipLoader();
		mcl.addListener(this);
	}//<>
	
	public function loadClip(url:String, mc:MovieClip):Void {
		this.url=url;
		this.mc=mc;
		mcl.loadClip(url, mc);
	}//<<
	
	public function getProgress(Void):Number {
		return targetMC.getBytesLoaded()/targetMC.getBytesTotal();
	}//<<
	
	private function setTargetMC(mc:MovieClip):Void {
		if(mc._framesloaded<1 || targetMC){ return; }
		mc.gotoAndPlay(1);
		targetMC=mc;
		bev(event_Enter1StFrame);
	}//<<
	
	public function getTargetMC(Void):MovieClip {
		return targetMC;
	}//<<
	
//****************************************************************************
// EVENTS for MIMovieClipLoader
//****************************************************************************
	private function onLoadStart(target_mc:MovieClip):Void {
		delete targetMC;
		start();
		bev(event_LoadStart);
		setTargetMC(target_mc);
	}//<<
	
	private function onLoadInit(target_mc:MovieClip):Void {
		setTargetMC(target_mc);
		bev(event_LoadInit);
	}//<<
	
	private function onLoadProgress(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number):Void {
		setTargetMC(target_mc);
		bev(event_LoadProgress, {progress:loadedBytes/totalBytes});
	}//<<
	
	private function onLoadComplete(target_mc:MovieClip, httpStatus:Number):Void {
		setTargetMC(target_mc);
		logHistory('LoadComplete url>'+url+' mc>'+link(getTargetMC())+' httpStatus>'+httpStatus);
		bev(event_LoadComplete, {httpStatus:httpStatus});
		finish();
	}//<<
	
	private function onLoadError(target_mc:MovieClip, errorCode:String, httpStatus:Number):Void {
		setTargetMC(target_mc);
		logHistory('LoadError url>'+url+' mc>'+link(getTargetMC())+' errorCode>'+errorCode+' httpStatus>'+httpStatus);
		logError_UnexpectedSituation(arguments, 'LoadError url>'+url+' mc>'+link(getTargetMC())+' errorCode>'+errorCode+' httpStatus>'+httpStatus);
		bev(event_LoadError, {errorCode:errorCode, httpStatus:httpStatus});
		finish();
	}//<<
	
}