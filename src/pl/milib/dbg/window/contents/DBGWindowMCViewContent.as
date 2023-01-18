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

import pl.milib.core.MIObjSoul;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MIBitmapUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.DBGWindowMCViewContent extends DBGWindowContent {
	
	public var ID : String='mcview';
	public var name : String='mcview';
	private var servMimc : MIMC;
	
	public function DBGWindowMCViewContent(servMimc:MIMC) {
		this.servMimc=servMimc;
	}//<>
	
	private function doSetupMC(Void):Void {
		MIBitmapUtil.pasteBitmapInCenterMC(MIBitmapUtil.getBitmapFromMC(servMimc.mc), mimc.mc);
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo {
		MIBitmapUtil.getBitmapMC(mimc.mc)._x=width/2;		MIBitmapUtil.getBitmapMC(mimc.mc)._y=height/2;
		return new WidthAndHeightInfo(width, height);
	}//<<
	
	static public function forInstance(mimc:MIMC):DBGWindowMCViewContent {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(mimc);
		if(!milibObjObj.forDBGWindowMCViewContent.o){ milibObjObj.forDBGWindowMCViewContent=MIObjSoul.forInstance(new DBGWindowMCViewContent(mimc)); }
		return milibObjObj.forDBGWindowMCViewContent.o;
	}//<<
		
	static public function hasInstance(mimc:Object):Boolean {
		return MILibUtil.getObjectMILibObject(mimc).forDBGWindowMCViewContent.o!=null;
	}//<<
	
}