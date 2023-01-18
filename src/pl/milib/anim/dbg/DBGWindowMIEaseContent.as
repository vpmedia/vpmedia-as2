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

import pl.milib.anim.dbg.EaseListElement;
import pl.milib.anim.static_.MIEase;
import pl.milib.collection.MIObjects;
import pl.milib.core.MIObjSoul;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.dbg.window.DBGWindow;
import pl.milib.managers.EnterFrameRenderManager;
import pl.milib.mc.DuplicatedMCSAutoY;
import pl.milib.mc.MCDropDown;
import pl.milib.mc.MCDropDownOwner;
import pl.milib.mc.MCDropDownTitle;
import pl.milib.mc.MCDuplicator;
import pl.milib.mc.MCDuplicatorOwner;
import pl.milib.mc.MCList;
import pl.milib.mc.MCListElement;
import pl.milib.mc.MCSlider;
import pl.milib.util.MIArrayUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.dbg.DBGWindowMIEaseContent extends DBGWindowContent implements MCDropDownOwner, MCDuplicatorOwner {
	
	public var ease_None : Object={name:'none', title:'none'};
	public var ease_Sin : Object={name:'Sin', title:'Sin'};
	public var ease_Log : Object={name:'Log', title:'Log'};
	public var ease_Circ : Object={name:'Circ', title:'Circ'};
	public var ease_CircHard : Object={name:'CircHard', title:'CircHard'};
	public var ease_Elastic : Object={name:'Elastic', title:'CircHard', args:[['humps', 1, 40], ['dynamic', 0, 5], ['power', 0, 5], ['friction', 0, 3]]};
	public var ease_Bounce : Object={name:'Bounce', title:'Bounce', args:[['humps', 1, 40], ['power', 0, 5], ['friction', 0, 3]]};
	public var ease_Pow : Object={name:'Pow', title:'Pow', args:[['', 0, 10]]};
	public var ease_Bezier : Object={name:'Bezier', title:'Bezier', args:[['', -2, 2], ['', -2, 2]]};
	public var ease_Bezier2 : Object={name:'Bezier2', title:'Bezier2', args:[['', -2, 2], ['', -2, 2], ['', -2, 2]]};
	
	public var ID : String='ease';	public var name : String='ease';
	private var eases : ScrollableArray;
	private var dropDown : MCDropDown;
	private var ease : MIEase;
	private var mc_f01 : MovieClip;
	private var slidersDupl : MCDuplicator;
	private var slidersAutoY : DuplicatedMCSAutoY;
	private var sliders : MIObjects; //of MCSlider
	
	public function DBGWindowMIEaseContent(ease:MIEase) {
		this.ease=ease;
		eases=new ScrollableArray([
			ease_None,
			ease_Sin,
			ease_Log,
			ease_Circ,
			ease_CircHard,
			ease_Bounce,
			ease_Elastic,
			ease_Pow,
			ease_Bezier,
			ease_Bezier2
		]);
		EnterFrameRenderManager.getInstance().addRenderMethod(this, renderEase);
		sliders=new MIObjects();
		sliders.addListener(this);
	}//<>
	
	public function setupDbgWindow(dbgWindow:DBGWindow):Void {
		
	}//<<
	
	private function renderEase(Void):Void {
		var tabF01:Array=[];
		for(var i=0;i<300;i++){
			tabF01.push(ease.ease01(i/300));
		}
		var w:Number=mc_f01.bg._width;
		var h:Number=mc_f01.bg._height;
		mc_f01.clear();
		mc_f01.lineStyle(0, 0x65C7DE, 100);
		mc_f01.moveTo(0, h);
		for(var i=0;i<300;i++){
			mc_f01.lineTo(i/300*w, h-tabF01[i]*h);
		}
		mc_f01.lineTo(w, h);
		mc_f01.lineTo(0, h);
		
		var easeProps:Array=ease.getEaseProps();
		slidersDupl.duplicateToNum(easeProps.length);
		var easeName:String=ease.getEaseName();
		var easesArr:Array=eases.getBaseArray();
		var easeData:Object=MIArrayUtil.getObjWhereObjProp(easesArr, 'name', easeName);
		dropDown.setTitleData(easeData);
		var slidersArr:Array=sliders.getArray();
		for(var i=0,slider:MCSlider;i<easeProps.length;i++){
			slider=slidersArr[i];
			slider.set01((easeProps[i]-easeData.args[i][1])/(easeData.args[i][2]-easeData.args[i][1]));
			slider.mimc.mc._parent.tfTitle.text=easeData.args[i][0];
		}
		
	}//<<
	
	private function doSetupMC(Void):Void {
		ease.addListener(this);
		mc_f01=mimc.g('f01');
		dropDown=new MCDropDown(this, mimc.g('dropDown'), eases);
		dropDown.addListener(this);
		
		slidersDupl=new MCDuplicator(this, [mimc.g('sliders.ele0'), mimc.g('sliders.ele1')]);
		slidersAutoY=new DuplicatedMCSAutoY(slidersDupl, true);
		
		renderEase();
	}//<<
	
	private function unsetupMC(Void):Void {
		dropDown.getDeleter().DELETE(); delete dropDown;		slidersDupl.getDeleter().DELETE(); delete slidersDupl;		slidersAutoY.getDeleter().DELETE(); delete slidersAutoY;
		sliders.clear();
		ease.removeListener(this);
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):WidthAndHeightInfo {
		mc_f01._y=height/2-20;
		return new WidthAndHeightInfo(width, height);
	}//<<
	
	public function getTitle(Void):String { return null; }//<<
	
	public function slaveGet_MCDropDown_Title(dropDown:MCDropDown, titleMC:MovieClip):MCDropDownTitle {
		return (new MCDropDownTitle(titleMC));
	}//<<
	
	public function slaveGet_MCList_NewListElement(mcList:MCList, eleNum:Number, eleMC:MovieClip):MCListElement {
		return (new EaseListElement(this)).setup(eleMC, eleNum);
	}//<<
	
	static public function forInstance(ease:MIEase):DBGWindowMIEaseContent {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(ease);
		if(!milibObjObj.forDBGWindowMIEaseContent.o){ milibObjObj.forDBGWindowMIEaseContent=MIObjSoul.forInstance(new DBGWindowMIEaseContent(ease)); }
		return milibObjObj.forDBGWindowMIEaseContent.o;
	}//<<
	
	static public function hasInstance(ease:MIEase):Boolean {
		return MILibUtil.getObjectMILibObject(ease).forDBGWindowMIEaseContent.o!=null;
	}//<<
	
//****************************************************************************
// EVENTS for DBGWindowMIEaseContent
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case dropDown:
				switch(ev.event){
					case dropDown.event_ElementSelect:
						var args:Array=[];
						for(var i=0;i<ev.data.args.length;i++){
							args.push(ev.data.args[i][1]+(ev.data.args[i][2]+ev.data.args[i][1])/2);
						}
						ease['setupEase'+ev.data.name].apply(ease, args);
						
						//dropDown.areWrapped.v=true;
					break;
				}
			break;
			case ease:
				switch(ev.event){
					case ease.event_Changed:
						renderEase();
					break;
				}
			break;
			case sliders:
				var hero:MCSlider=MCSlider(ev.data.hero);
				switch(ev.data.event){
					case hero.event_New01:
						var easeData:Object=MIArrayUtil.getObjWhereObjProp(eases.getBaseArray(), 'name', ease.getEaseName());
						var propIndex:Number=sliders.getSubByMain(hero);
						ease.setupEaseProp(easeData.args[propIndex][1]+hero.get01()*(easeData.args[propIndex][2]-easeData.args[propIndex][1]), propIndex);
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MCDuplicator_NewMC(duplicator:MCDuplicator, eleNum:Number, eleMC:MovieClip):Void {
		var slider:MCSlider=new MCSlider(eleMC.sl);
		sliders.addObject(slider, eleNum);
	}//<<
	
	public function onSlave_MCDuplicator_MCIsEnabledChange(duplicator:MCDuplicator, eleNum:Number, eleMC:MovieClip, isEnaled:Boolean):Void {
		eleMC._visible=isEnaled;
	}//<<
	
}