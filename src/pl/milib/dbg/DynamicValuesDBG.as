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
import pl.milib.data.DynamicValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.data.TextWithTabs;
import pl.milib.dbg.DynamicValueListElement;
import pl.milib.dbg.MIDBG;
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.mc.MCListElement;
import pl.milib.mc.MCListOwner;
import pl.milib.mc.MCListWithScroller;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.DynamicValuesDBG extends DBGWindowContent implements MCListOwner {
	
	public var name : String = 'values';
	public var ID : String = 'values';
	private static var instance : DynamicValuesDBG;
	private var dvs : MIObjects; //of DynamicValue
	private var list : MCListWithScroller;
	private var dvsList : ScrollableArray;
	
	private function DynamicValuesDBG() {
		dvs=new MIObjects();
		dvs.addListener(this);
		dvsList=new ScrollableArray();
		if(MIDBG.getInstance().isUILoaded()){ setupDBGWindow(); }
		else{ MIDBG.getInstance().addListener(this); }
	}//<>
	
	public function regDynamicValue(dv:DynamicValue):Void {
		dvs.addObject(dv);
		dvsList.push(dv);
	}//<<
	
	private function doSetupMC(Void):Void {
		list=new MCListWithScroller(this, mimc.g('list'), dvsList);
	}//<<
	
	private function unsetupMC(Void):Void {
		list.getDeleter().DELETE(); delete list;
	}//<<
	
	public function slaveGet_MCList_NewListElement(mcList:MCListWithScroller, eleNum:Number, eleMC:MovieClip):MCListElement {
		return (new DynamicValueListElement()).setup(eleMC, eleNum);
	}//<<
	
	private function setupDBGWindow(Void):Void {
		MIDBG.getInstance().dbgMainWindow.addDBGContent(this);
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo {
		list.setHeight(height-24);		list.setWidth(width-8);
		return new WidthAndHeightInfo(width, height);
	}//<<
	
	private function pasteValuesDataToClippboard(Void):Void {
//	
//	static public var val_Some : DynamicValue;
//	
//	private function setupValues() {
//		val_Some=new DynamicValue(123, 'Some')
//	}//<>
//
		var classStr:TextWithTabs=new TextWithTabs();
		classStr.plusTab();
		var valuesArr:Array=dvs.getArray();
		for(var i=0,dv:DynamicValue;i<valuesArr.length;i++){
			dv=valuesArr[i];
			classStr.addLine('static public var dv_'+dv.name+' : DynamicValue;');
		}
		classStr.addLine('');
		classStr.addLineAndPlus('private function setupValues() {');
		for(var i=0,dv:DynamicValue,dvVl:String;i<valuesArr.length;i++){
			dv=valuesArr[i];
			if(typeof(dv.value.v)=='number'){ dvVl=String(dv.value.v); }			else{ dvVl='"'+dv.value.v+'"'; }
			classStr.addLine("dv_"+dv.name+'=new DynamicValue('+dvVl+", '"+dv.name+"');");
		}
		classStr.minusAndAddLine('}//<<');
		MIDBG.getInstance().pasteToClippoard('DynamicValuesDBG', classStr.toString());
	}//<<
	
	static public function start(Void):Void {
		getInstance();
	}//<<
	
	/** @return singleton instance of DynamicValues */
	static public function getInstance(Void):DynamicValuesDBG {
		if(instance==null){ instance=new DynamicValuesDBG(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for DynamicValuesDBG
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case MIDBG.getInstance():
				switch(ev.event){
					case MIDBG.getInstance().event_UILoaded:
						setupDBGWindow();
					break;
				}
			break;
			case dvs:
				var hero:DynamicValue=DynamicValue(ev.data.hero);
				switch(ev.data.event){
					case hero.event_ValueChange:
						pasteValuesDataToClippboard();
					break;
				}
			break;
		}
	}//<<Events
	
}