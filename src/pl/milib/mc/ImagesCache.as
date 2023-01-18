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
import pl.milib.mc.LoadedImage;
import pl.milib.mc.MCDuplicaton;
import pl.milib.util.MIArrayUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.ImagesCache extends MIBroadcastClass {

	private var images : Object;
	private var mc : MovieClip;
	private var mcd : MCDuplicaton;
	private var maxCachedImages : Number;
	private var imagesUseArr : Array;
	
	public function ImagesCache(maxCachedImages:Number) {
		this.maxCachedImages=maxCachedImages;
		images={};
		imagesUseArr=[];
		
		mc=MILibUtil.getMCMILibMCForObject(_root, this);
		mc._visible=false;
		mc._width=mc._height=10;
		mc._x=mc._y=10000;
		mcd=new MCDuplicaton(mc.createEmptyMovieClip('holder', 0));
		
	}//<>
	
	public function getOrCreateLoadedImage(imgURL:String):LoadedImage {
		if(!imgURL.length){ return null; }
		if(!images[imgURL]){
			images[imgURL]=new LoadedImage(mcd.getNewMC(), imgURL);
			logHistory('create new LoadedImage for url:'+imgURL+', LoadedImage>'+link(images[imgURL]));
			for(var i=maxCachedImages,image:LoadedImage;i<imagesUseArr.length;i++){
				image=imagesUseArr[i];
				logHistory('delete from cache '+image.getImgageURL());
				delete images[image.getImgageURL()];
				imagesUseArr.splice(i, 1); i--;
				image.getBitmapData().dispose();
				image.mimc.getDeleter().DELETE();
			}
		}
		MIArrayUtil.remove(imagesUseArr, images[imgURL]);
		imagesUseArr.unshift(images[imgURL]);
		return images[imgURL];
	}//<<
	
}