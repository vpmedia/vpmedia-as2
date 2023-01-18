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

import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.ScrollInfo;
import pl.milib.managers.CursorManager;
import pl.milib.mc.abstract.MIScroller;
import pl.milib.mc.buttonViews.ButtonViewFourFrames;
import pl.milib.mc.buttonViews.ButtonViewFourFramesMouseMovePress;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualDrag;
import pl.milib.mc.virtualUI.VirtualUIScroller;
import pl.milib.tools.DelayedImpuls;
import pl.milib.tools.Impuls;
import pl.milib.tools.ImpulsOwner;
import pl.milib.util.MIMathUtil;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCScroller extends MIScroller implements MIValueOwner, ImpulsOwner {

	public var mimc : MIMC;
	private var mc_bg : MovieClip;
	private var mc_btnUP : MovieClip;
	private var mc_btnSlider : MovieClip;
	private var mc_btnDN : MovieClip;
	private var btnUP : MIButton;
	private var btnDN : MIButton;
	private var btnSlider : MIButton;
	private var enabled : MIValue;
	private var viScrl : VirtualUIScroller;
	private var viDrag : VirtualDrag;
	private var impDelayedUpDnBtn : DelayedImpuls;
	
	public function MCScroller(mc:MovieClip) {
		mimc=MIMC.forInstance(mc);
		mc_bg=mimc.g('bg');
		btnUP=mimc.getMIButton('btnUP').addButtonView(
			new ButtonViewFourFrames(mimc.g('btnUP'))
		);
		btnUP.addListener(this);
		btnDN=mimc.getMIButton('btnDN').addButtonView(
			new ButtonViewFourFrames(mimc.g('btnDN'))
		);
		btnDN.addListener(this);
		btnSlider=mimc.getMIButton('btnSlider').addButtonViews([
			new ButtonViewFourFramesMouseMovePress(mimc.g('btnSlider.mid')),
			new ButtonViewFourFramesMouseMovePress(mimc.g('btnSlider.dn')),
			new ButtonViewFourFramesMouseMovePress(mimc.g('btnSlider.up'))
		]);
		btnSlider.addListener(this);
		CursorManager.getInstance().addButton(btnSlider, CursorManager.getInstance().cursorDragMode);
		
		mc_bg=mimc.g('bg');
		mc_btnUP=mimc.g('btnUP');
		mc_btnSlider=mimc.g('btnSlider');
		mc_btnDN=mimc.g('btnDN');
		
		viScrl=new VirtualUIScroller();
		
		mimc.gotoAndStop('sett');
		viScrl.setupBtnDnLength.v=mimc.g('setterBtnDnHeight')._height;
		viScrl.setupBtnUpLength.v=mimc.g('setterBtnUpHeight')._height;
		mimc.gotoAndStop(1);
		viScrl.viSlider.setupSide0Length.v=mimc.g('btnSlider.up')._height;		viScrl.viSlider.setupSide1Length.v=mimc.g('btnSlider.dn')._height;
		
		enabled=(new MIValue()).setOwner(this);
		
		length=(mc_btnDN._y+viScrl.setupBtnDnLength.v)*(mimc.mc._yscale/100);
		mimc.mc._yscale=100;
		
		viDrag=new VirtualDrag(mc_btnSlider);
		viDrag.addListener(this);
		
		impDelayedUpDnBtn=new DelayedImpuls(this, 50, 400);
		
		MIMCUtil.setBtnWithNoHandCursor(mc_bg);
		
		addDeleteWith(mimc);		addDeletingSub(mimc);
		
		//TODO enter frame render
	}//<>
	
	public function getBreadth(Void):Number {
		return mc_bg._width;
	}//<<
	
	public function doSetScrolledObject(Void):Void {
		
	}//<<
	
	public function applyScrollData(scrollData:ScrollInfo):Void {
		viScrl.setupScrollData(scrollData);
		render();
	}//<<
	
	public function set length(num:Number):Void {
		if(num==viScrl.setupLength.v){ return; }
		viScrl.setupLength.v=num;
		mc_btnUP._height=viScrl.getButtonUpLength();
		mc_btnDN._height=viScrl.getButtonDnLength();
		render();
	}//<<
	
	public function get length(Void):Number {
		return viScrl.setupLength.v;
	}//<<
	
	private function render(Void):Void {
		mc_bg._height=length;
		mc_btnDN._y=viScrl.getButtonDnIniPos();
		if(viScrl.getIsEnabled()){
			enabled.v=true;
			mc_btnSlider.mid._height=viScrl.viSlider.getMidLength();
			mc_btnSlider.dn._y=viScrl.viSlider.getSide1IniPos();
			mc_btnSlider._y=viScrl.getSliderIniPos();
			mc_btnSlider._visible=viScrl.viSlider.getLength()<viScrl.getScrollingAreaLength();
			mc_btnSlider.humps._visible=mc_btnSlider.mid._height>mc_btnSlider.humps._height;			mc_btnSlider.humps._y=viScrl.viSlider.setupLength.v/2;
		}else{
			enabled.v=false;
		}
	}//<<
	
//****************************************************************************
// EVENTS for MCScroller
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		super['onEvent'](ev);
		switch(ev.hero){
			case viDrag:
				switch(ev.event){
					case viDrag.event_Start:
						scrollable.removeListener(this);
					break;
					case viDrag.event_NewDragXY:
						var scroll01:Number=MIMathUtil.b01((viDrag.getY()-viScrl.setupBtnUpLength.v)/viScrl.getMovingAreaLength());
						scrollable.setScrollN01(scroll01);
						var sd:ScrollInfo=scrollable.getScrollData();
						sd.scrollN01=scroll01;
						applyScrollData(sd);
						bev(event_Moved);
					break;
					case viDrag.event_Stop:
						scrollable.addListener(this);
					break;
				}
			break;
			case btnSlider:
				switch(ev.event){
					case btnSlider.event_Press:
						viDrag.start();
					break;
				}
			break;
			case btnUP:
				switch(ev.event){
					case btnUP.event_Press:
						scrollable.setScrollByOneUnit(-1);
						impDelayedUpDnBtn.start();
					break;
					case btnUP.event_ReleaseAll:
						impDelayedUpDnBtn.finish();
					break;
				}
			break;
			case btnDN:
				switch(ev.event){
					case btnDN.event_Press:
						scrollable.setScrollByOneUnit(1);
						impDelayedUpDnBtn.start();
					break;
					case btnDN.event_ReleaseAll:
						impDelayedUpDnBtn.finish();
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		if(val.v){
			btnDN.setIsEnabled(true);
			btnUP.setIsEnabled(true);
			btnSlider.setIsEnabled(true);
			mc_btnSlider._visible=true;
		}else{
			btnDN.setIsEnabled(false);
			btnUP.setIsEnabled(false);
			btnSlider.setIsEnabled(false);
			mc_btnSlider._visible=false;
		}
	}//<<
	
	public function onSlave_Impuls_NewImpuls(imp:Impuls):Void {
		scrollable.setScrollByOneUnit(btnUP.getIsPressed() ? -1 : 1);
	}//<<
	
}