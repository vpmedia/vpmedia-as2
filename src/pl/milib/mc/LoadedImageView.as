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
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.LoadedImage;
import pl.milib.util.MIBitmapUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.LoadedImageView extends MIBroadcastClass {

	public var event_PasteImage:Object={name:'PasteImage'};
	
	private var image : LoadedImage;
	private var mc : MovieClip;
	private var isPasteInCenter : Boolean;
	
	public function LoadedImageView(mc:MovieClip, isPasteInCenter:Boolean) {
		this.mc=mc;
		this.isPasteInCenter=isPasteInCenter;		
	}//<>
	/*abstract*/ private function doAfterPasteImage(Void):Void {}//<<
	/*abstract*/ private function doAfterStartLoadImage(Void):Void {}//<<
	
	public function setupModel(image:LoadedImage):Void {
		unsetupModel();
		logHistory('URL>'+image.getImgageURL()+' image>'+link(image)+' image mc>'+link(image.mimc.mc));
		this.image=image;
		this.image.addListener(this);
		doAfterStartLoadImage();
		if(this.image.gotImage()){
			pasteImage();
		}
	}//<<
	
	public function getImageURL(Void):String {
		return image.getImgageURL(); 
	}//<<
	
	public function unsetupModel(Void):Void {
		if(this.image){
			this.image.removeListener(this);
			MIBitmapUtil.deleteBitmap(mc);
		}
	}//<<
	
	private function pasteImage(Void):Void {
		if(isPasteInCenter){
			MIBitmapUtil.pasteBitmapInCenterMC(image.getBitmapData(), mc);
		}else{
			MIBitmapUtil.pasteBitmap(image.getBitmapData(), mc);
		}
		if(mc._width){
			bev(event_PasteImage);
			doAfterPasteImage();
		}
	}//<<
	
//****************************************************************************
// EVENTS for LoadedImageView
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case image:
				switch(ev.event){
					case image.event_ImageLoaded:
						pasteImage();
					break;
				}
			break;
		}
	}//<<Events

}