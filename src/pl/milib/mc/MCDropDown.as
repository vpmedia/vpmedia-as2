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
import pl.milib.core.value.MIBooleanValue;
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.managers.MouseManager;
import pl.milib.mc.buttonViews.ButtonViewFourFrames;
import pl.milib.mc.MCDropDownOwner;
import pl.milib.mc.MCDropDownTitle;
import pl.milib.mc.MCListWithScroller;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualRectButtonsManager;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCDropDown extends MIBroadcastClass implements MIValueOwner {
	
	//DATA: Object //selected element data
	public var event_ElementSelect:Object={name:'ElementSelect'};
	
	public var mimc : MIMC;
	public var list : MCListWithScroller;
	private var btn : MIButton;
	public var areWrapped : MIBooleanValue;
	private var title : MCDropDownTitle;
	private var mm : MouseManager;
	
	public function MCDropDown(owner:MCDropDownOwner, mc:MovieClip, $scrlArr:ScrollableArray) {
		mc.gotoAndStop(2);
		mimc=MIMC.forInstance(mc);
		list=new MCListWithScroller(owner, mimc.g('list'), $scrlArr);
		list.addListener(this);
		btn=mimc.getMIButton('btn');
		btn.addButtonView(new ButtonViewFourFrames(btn['btn']));
		btn.addListener(this);
		title=owner.slaveGet_MCDropDown_Title(this, mimc.g('title'));
		
		areWrapped=(new MIBooleanValue(true)).setOwner(this);
		areWrapped.apply();
		
		VirtualRectButtonsManager.getInstance().unregButton(list.area);
		
		setWidth(mc._width);
		mc._xscale=100;
		mm=MouseManager.getInstance();
	}//<>
	
	public function setWidth(width:Number):Void {
		btn.btn._x=width-btn.btn._width;
		title.setWidth(width-btn.btn._width);
		list.setWidth(width);
	}//<<
	
	public function setHeight(height:Number):Void {
		list.setHeight(height-list.mimc.mc._y);
	}//<<
	
	public function setTitleData(data:Object):Void {
		title.setData(data);
	}//<<
	
	private function doDelete(Void):Void {
		list.getDeleter().DELETE(); delete list;
	}//<<
	
//****************************************************************************
// EVENTS for MCDropDown
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				switch(ev.event){
					case btn.event_Press:
						areWrapped.sWitch();
					break;
				}
			break;
			case list:
				switch(ev.event){
					case list.event_ElementSelect:
						bev(event_ElementSelect, ev.data);
					break;
				}
			break;
			case mm:
				switch(ev.event){
					case mm.event_Down:
						if(!list.area.getIsOver() && !btn.getIsOver()){
							areWrapped.v=true;
						}
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		mimc.g('list')._visible=!areWrapped.v;
		if(areWrapped.v){ 			mm.removeListener(this);
		}else{
			mm.addListener(this);
		}
	}//<<
	
}