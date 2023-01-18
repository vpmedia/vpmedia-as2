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
import pl.milib.data.TextModel;
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.mc.MCScroller;
import pl.milib.mc.service.MITextField;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.DBGWindowTextContent extends DBGWindowContent {
	
	public var ID : String='text';	public var name : String='text';	private var mimc_tf : MITextField;
	private var scroller : MCScroller;
	private var model : TextModel;
	
	public function DBGWindowTextContent(model:TextModel) {
		this.model=model;
	}//<>
	
	public function setupModel(model:TextModel):Void {
		this.model=model;
		mimc_tf.setupModel(model);
	}//<<
	
	private function doSetupMC(Void):Void {
		mimc_tf=mimc.getMITextField('tf');
		scroller=new MCScroller(mimc.g('scroller'));
		scroller.setScrolledObject(mimc_tf);
		mimc_tf.setupModel(model);
	}//<<
	
	private function doUnsetupMC(Void):Void {
		mimc_tf.setupModel(null);
		scroller.getDeleter().DELETE(); delete scroller;
		mimc_tf.getDeleter().DELETE(); delete mimc_tf;
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo {
		var wid:Number=width-mimc_tf.tf._x-scroller.mimc.mc._width-4;		var hei:Number=height-mimc_tf.tf._y-24;
		scroller.length=hei;		scroller.mimc.mc._x=mimc_tf.tf._x+wid;
		mimc_tf.tf._width=wid;
		mimc_tf.tf._height=hei;
		return new WidthAndHeightInfo(width, height);
	}//<<
	
	public function getTitle(Void):String { return null; }//<<
	
	public function addText(text:String):Void {
		model.addText(text);
	}//<<
	
	static public function forInstance(obj:TextModel):DBGWindowTextContent {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forDBGWindowTextContent.o){ milibObjObj.forDBGWindowTextContent=MIObjSoul.forInstance(new DBGWindowTextContent(obj)); }
		return milibObjObj.forDBGWindowTextContent.o;
	}//<<
	
	static public function hasInstance(obj:TextModel):Boolean {
		return MILibUtil.getObjectMILibObject(obj).forDBGWindowTextContent.o!=null;
	}//<<
	
}