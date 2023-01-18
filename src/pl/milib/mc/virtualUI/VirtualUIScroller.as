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

import pl.milib.core.value.MINumberValue;
import pl.milib.data.info.ScrollInfo;
import pl.milib.managers.MouseManager;
import pl.milib.mc.MIScrollable;
import pl.milib.mc.virtualUI.VirtualUI;
import pl.milib.mc.virtualUI.VirtualUITwoSidesAndMid;

/**
 * @often_name viScrl
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.virtualUI.VirtualUIScroller extends VirtualUI {
	
	
	//nastąpiło rozpoczęcie przesuwania
	public var event_DragStart:Object={name:'DragStart'};
	
	//nastąpiło przesunięcie
	public var event_DragNewXY:Object={name:'DragNewXY'};
	
	//nastąpiło zatrzymanie przesuwania
	public var event_DragStop:Object={name:'DragStop'};
	
	public var viSlider : VirtualUITwoSidesAndMid;
	private var scrollData : ScrollInfo;
	public var setupBtnUpLength : MINumberValue;
	public var setupBtnDnLength : MINumberValue;
	public var setupLength : MINumberValue;
	public var setupMinLength : MINumberValue;
	private var mm : MouseManager;
	private var scrolled : MIScrollable;
	private var downY : Number;
	
	public function VirtualUIScroller(Void) {
		setupBtnUpLength=(new MINumberValue(null, 0)).setOwner(this);		setupBtnDnLength=(new MINumberValue(null, 0)).setOwner(this);
		setupLength=(new MINumberValue(null, 0)).setOwner(this);
		setupLength.setupMinNumber(0);
		
		viSlider=new VirtualUITwoSidesAndMid();
		scrollData=new ScrollInfo(0,0,0);
	}//<>
	
	public function setupScrollData(scrollData:ScrollInfo):Void {
		this.scrollData=scrollData;	
		downY=_root._ymouse;
		viSlider.setupLength.v=getScrollingAreaLength()*scrollData.visibleN01;
	}//<<
	
	public function setupStartDrag(Void):Void {
		mm.addListener(this);
	}//<<
	
	public function getButtonsLength(Void):Number {
		return getButtonUpLength()+getButtonDnLength();
	}//<<
	
	public function getButtonDnIniPos(Void):Number {
		return setupLength.v-getButtonDnLength();
	}//<<
	
	public function getIsEnabled(Void):Boolean {
		return scrollData.total>scrollData.visible;
	}//<<
	
	public function getScrollingAreaLength(Void):Number {
		return setupLength.v-getButtonsLength();
	}//<<
	
	public function getMovingAreaLength(Void):Number {
		return getScrollingAreaLength()-viSlider.getLength();
	}//<<
	
	public function getSliderIniPos(Void):Number {
		return getButtonUpLength()+getMovingAreaLength()*scrollData.scrollN01;
	}//<<
	
	public function getMovingAreaIniPos(Void):Number {
		return setupBtnUpLength.v;
	}//<<
	
	public function getButtonUpLength(Void):Number {
		var buttonsLength:Number=setupBtnUpLength.v+setupBtnDnLength.v;
		var scrollingArea:Number=setupLength.v-buttonsLength;
		if(scrollingArea<0){
			return Math.max(setupBtnUpLength.v+scrollingArea/2, 0);
		}else{
			return setupBtnUpLength.v;
		}
	}//<<
	
	public function getButtonDnLength(Void):Number {
		var buttonsLength:Number=setupBtnUpLength.v+setupBtnDnLength.v;
		var scrollingArea:Number=setupLength.v-buttonsLength;
		if(scrollingArea<0){
			return Math.max(setupBtnDnLength.v+scrollingArea/2, 0);
		}else{
			return setupBtnDnLength.v;
		}
	}//<<
	
//****************************************************************************
// EVENTS for VirtualUIScroller
//****************************************************************************
	public function onSlave_MIValue_ValueChange(val:MINumberValue):Void {
		switch(val){
			case setupLength:
				viSlider.setupLength.v=getScrollingAreaLength()*scrollData.visibleN01;
			break;
		}
		super.onSlave_MIValue_ValueChange(val);
	}//<<
	
}