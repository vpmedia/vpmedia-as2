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

import flash.display.BitmapData;

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.service.MIMC;
import pl.milib.tools.LoadingObserver;
import pl.milib.util.MIBitmapUtil;

/**
 * @often_name image
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.LoadedImage extends MIBroadcastClass {
	
	//image is ready to get
	public var event_ImageLoaded:Object={name:'ImageLoaded'};
	
	//image load fail
	public var event_ImageLoadFail:Object={name:'ImageLoadFail'};
	
	public var mimc : MIMC;
	private var imgURL : String;
	private var loading : LoadingObserver;

	private var bd : BitmapData;
	
	public function LoadedImage(mcHolder:MovieClip, imgURL:String) {
		mimc=MIMC.forInstance(mcHolder);
		this.imgURL=imgURL;
		
		addDeleteTogether(mimc);
		
		mcHolder.createEmptyMovieClip('holder', 0).loadMovie(imgURL);
		loading=new LoadingObserver();
		loading.addListener(this);
		loading.startObserve(mimc.g('holder'));
	}//<>
	
	public function getImgageURL(Void):String {
		return imgURL;
	}//<<
	
	public function gotImage(Void):Boolean {
		return (mimc.mc._height>0 && mimc.mc._width>0 && loading.isLoaded()); 
	}//<<
	
	public function getBitmapData(Void):BitmapData {
		if(!bd){ bd=MIBitmapUtil.getBitmapFromMC(mimc.mc); } 
		return bd;
	}//<<
	
//****************************************************************************
// EVENTS for LoadedImage
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case loading:
				switch(ev.event){
					case loading.event_RunningFinish:
						if(gotImage()){
							logHistory('image loaded, url:'+imgURL);
							bev(event_ImageLoaded);
						}else{
							bev(event_ImageLoadFail);
						}
					break;
				}
			break;
		}
	}//<<Events
	
}