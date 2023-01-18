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

import pl.milib.collection.MIObjects;
import pl.milib.core.MIObjSoul;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.dbg.MethodWatcher;
import pl.milib.dbg.window.contents.DBGWindowObjectContent;
import pl.milib.dbg.window.contents.MethodsListElement;
import pl.milib.mc.MCList;
import pl.milib.mc.MCListElement;
import pl.milib.mc.MCListOwner;
import pl.milib.mc.MCScroller;
import pl.milib.util.MIArrayUtil;
import pl.milib.util.MILibUtil;


/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.contents.DBGWindowMethodsContent extends DBGWindowObjectContent implements MCListOwner {
	
	public var name : String = 'methods';
	public var ID : String = 'methods';
	private var scrlArr : ScrollableArray;
	private var scroller : MCScroller;
	private var list : MCList;	
	public var eleDataType_method : Object={name:'method'};
	public var eleDataType_title : Object={name:'title'};
	private var methodWatchers : MIObjects; //of MethodWatcher
	private var cookieObj_methodsDbg : Array;
	
	public function DBGWindowMethodsContent(obj:Object) {
		setupDeubggedObject(obj);
		methodWatchers=new MIObjects();
		methodWatchers.addListener(this);
		scrlArr=new ScrollableArray(getMethodsNamesList());
	}//<>
	
	/** @return Array of {name:String} */
	public function getMethodsNamesList():Array{
		var list:Array=[];
		var obj:Object=getObj();
		methodWatchers.clear();
		
		var methodsInfo:Array=MILibUtil.getClassMetodsNamesByInstance(obj);
		//{className:String, methods:Array of String}
		for(var i=0,mw:MethodWatcher,pm;i<methodsInfo.length;i++){
			list.push({type:eleDataType_title, name:methodsInfo[i].className});
			for(pm=0;pm<methodsInfo[i].methods.length;pm++){
				mw=MethodWatcher.forInstance(obj, obj[methodsInfo[i].methods[pm]]);
				methodWatchers.addObject(mw);
				list.push({type:eleDataType_method, name:methodsInfo[i].methods[pm], mw:mw});
			}
		}
		
		return list;
	}//<<
	
	private function doSetupMC(Void):Void {
		list=new MCList(this, mimc.g('elements'), scrlArr);
		scroller=new MCScroller(mimc.g('scroller'));
		scroller.setScrolledObject(scrlArr);
		list.setupScroller(scroller);
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
		return (new MethodsListElement(this)).setup(eleMC, eleNum);
	}//<<
	
	public function setCookie(cookieObj:Object):Void {
		if(!cookieObj.methodsDbg){ cookieObj.methodsDbg=[]; }
		cookieObj_methodsDbg=cookieObj.methodsDbg;
		for(var i=0;i<cookieObj_methodsDbg.length;i++){
			MethodWatcher.forInstance(getObj(), getObj()[cookieObj_methodsDbg[i]]).areShowEnabled.v=true;
		}
	}//<<
	
	static public function forInstance(obj:Object):DBGWindowMethodsContent {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forDBGWindowMethodsContent.o){ milibObjObj.forDBGWindowMethodsContent=MIObjSoul.forInstance(new DBGWindowMethodsContent(obj)); }
		return milibObjObj.forDBGWindowMethodsContent.o;
	}//<<
	
	static public function hasInstance(obj:Object):Boolean {
		return MILibUtil.getObjectMILibObject(obj).forDBGWindowMethodsContent.o!=null;
	}//<<
	
//****************************************************************************
// EVENTS for DBGWindowMethodsContent
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case methodWatchers:
				var mw:MethodWatcher=MethodWatcher(ev.data.hero);
				switch(ev.data.event){
					case mw.event_AreWatchedChange:
						if(mw.areShowEnabled.v){
							cookieObj_methodsDbg.push(mw.methodName);
						}else{
							MIArrayUtil.remove(cookieObj_methodsDbg, mw.methodName);
						}
					break;
				}
			break;
		}
	}//<<Events
	
}