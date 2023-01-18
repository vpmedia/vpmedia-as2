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

import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.dbg.window.contents.DBGWindowObjectContent;
import pl.milib.dbg.window.contents.VariablesListElement;
import pl.milib.mc.buttonViews.ButtonViewContrast;
import pl.milib.mc.MCList;
import pl.milib.mc.MCListElement;
import pl.milib.mc.MCListOwner;
import pl.milib.mc.MCScroller;
import pl.milib.mc.service.MIButton;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.DBGWindowVariablesContent extends DBGWindowObjectContent implements MCListOwner {
	
	public var name : String = 'variables';	public var ID : String = 'variables';
	private var scroller : MCScroller;
	private var list : MCList;
	private var scrlArr : ScrollableArray;	public var eleDataType_varable : Object={name:'varable'};	public var eleDataType_title : Object={name:'title'};
	private var btnRefresh : MIButton;
	
	private function DBGWindowVariablesContent(obj:Object) {
		setupDeubggedObject(obj);
		scrlArr=new ScrollableArray();
	}//<>
	
	/** @return Array of String */
	public function getListData():Array{
		var list:Array=[];
		//{localVars:Array of String, protoVars:Array of String}
		var vars:Object=MIDBGUtil.getClassVariablesNamesByInstance(objSoul.o);
		
		if(vars.localVars.length){
			list.push({type:eleDataType_title, name:'local value:'});
			for(var i=0;i<vars.localVars.length;i++){
				list.push({type:eleDataType_varable, name:vars.localVars[i]});
			}
		}
		if(vars.protoVars.length){
			list.push({type:eleDataType_title, name:'prototype value:'});
			for(var i=0;i<vars.protoVars.length;i++){
				list.push({type:eleDataType_varable, name:vars.protoVars[i]});
			}
		}
		return list;
	}//<<
	
	private function doSetupDeubggedObject(Void):Void {
		
	}//<<
	
	private function doSetupMC(Void):Void {
		scrlArr.setNewArray(getListData());
		list=new MCList(this, mimc.g('elements'), scrlArr);
		scroller=new MCScroller(mimc.g('scroller'));
		scroller.setScrolledObject(scrlArr);
		list.setupScroller(scroller);
		btnRefresh=mimc.getMIButton('btnRefresh');
		btnRefresh.addListener(this);
		btnRefresh.addButtonView(new ButtonViewContrast(btnRefresh['btn']));
	}//<<
	
	public function slaveGet_MCList_NewListElement(mcList:MCList, eleNum:Number, eleMC:MovieClip):MCListElement {
		return (new VariablesListElement(this)).setup(eleMC, eleNum);
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo {
		list.setHeight(height-24);
		scroller.length=height-24;
		var listWidth=width-list.mimc.mc._x-scroller.mimc.mc._width-4;
		list.setWidth(listWidth);
		scroller.mimc.mc._x=list.mimc.mc._x+listWidth;
		btnRefresh.btn._y=height-24+list.mimc.mc._y;
		return new WidthAndHeightInfo(width, height);
	}//<<
	
	public function getTitle(Void):String { return null; }//<<
	
	static public function forInstance(obj:Object):DBGWindowVariablesContent {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.serviceByDBGWindowVariablesContent){
			var srv:DBGWindowVariablesContent=new DBGWindowVariablesContent(obj);
			milibObjObj.serviceByDBGWindowVariablesContent=srv;
		}
		return milibObjObj.serviceByDBGWindowVariablesContent;
	}//<<
	
//****************************************************************************
// EVENTS for DBGWindowVariablesContent
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btnRefresh:
				switch(ev.event){
					case btnRefresh.event_Press:
						scrlArr.setNewArray(getListData());
					break;
				}
			break;
		}
	}//<<Events
	
}