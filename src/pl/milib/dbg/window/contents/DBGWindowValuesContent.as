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
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.dbg.DBGValuesModel;
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.dbg.window.contents.ValuesListElement;
import pl.milib.mc.MCList;
import pl.milib.mc.MCListElement;
import pl.milib.mc.MCListOwner;
import pl.milib.mc.MCScroller;
import pl.milib.mc.service.MITextField;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.DBGWindowValuesContent extends DBGWindowContent implements MCListOwner {
	
	public var name : String = 'values';
	public var ID : String = 'variables';	private var mimc_tf : MITextField;
	private var scroller : MCScroller;
	private var model : DBGValuesModel;
	private var scrlArr : ScrollableArray;
	private var list : MCList;
	public var eleDataType_value : Object={name:'value'};
	public var eleDataType_title : Object={name:'title'};
	
	public function DBGWindowValuesContent(model:DBGValuesModel) {
		scrlArr=new ScrollableArray();
		setupModel(model);
	}//<>
	
	public function setupModel(model:DBGValuesModel):Void {
		this.model.removeListener(this);
		this.model=model;
		this.model.addListener(this);
	}//<<
	
	private function getData(Void):Array {
		var arr:Array=model.getData();
		for(var i=0;i<arr.length;i++){
			arr[i].type=eleDataType_value;
		}
		return arr;
	}//<<
	
	private function doSetupMC(Void):Void {
		scrlArr.setNewArray(getData());
		list=new MCList(this, mimc.g('elements'), scrlArr);
		scroller=new MCScroller(mimc.g('scroller'));
		scroller.setScrolledObject(scrlArr);
		list.setupScroller(scroller);
		mimc.g('btnRefresh').unloadMovie();
//		btnRefresh=mimc.getMIButton('btnRefresh');
//		btnRefresh.addListener(this);
//		btnRefresh.addButtonView(new ButtonViewContrast(btnRefresh['btn']));
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo {
		list.setHeight(height-24);
		scroller.length=height-24;
		var listWidth=width-list.mimc.mc._x-scroller.mimc.mc._width-4;
		list.setWidth(listWidth);
		scroller.mimc.mc._x=list.mimc.mc._x+listWidth;
		return new WidthAndHeightInfo(width, height);
	}//<<
	
	public function getTitle(Void):String { return null; }//<<
	
	public function slaveGet_MCList_NewListElement(mcList:MCList, eleNum:Number, eleMC:MovieClip):MCListElement {
		return (new ValuesListElement(this)).setup(eleMC, eleNum);
	}//<<
	
	static public function forInstance(obj:DBGValuesModel):DBGWindowValuesContent {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forDBGWindowValuesContent.o){ milibObjObj.forDBGWindowValuesContent=MIObjSoul.forInstance(new DBGWindowValuesContent(obj)); }
		return milibObjObj.forDBGWindowValuesContent.o;
	}//<<
		
	static public function hasInstance(obj:Object):Boolean {
		return MILibUtil.getObjectMILibObject(obj).forDBGWindowValuesContent.o!=null;
	}//<<
	
//****************************************************************************
// EVENTS for DBGWindowValuesContent
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case model:
				switch(ev.event){
					case model.event_ElementCreate:
						scrlArr.setNewArray(getData());
					break;
					case model.event_ElementChanged:
						scrlArr.setNewArray(getData());
					break;
				}
			break;
		}
	}//<<Events

}