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
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.buttonViews.ButtonViewFourFrames;
import pl.milib.mc.MCScale9;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualDrag;
import pl.milib.util.MIMathUtil;
import pl.milib.util.MIMCUtil;

class pl.milib.mc.MCSlider extends MIBroadcastClass {
	
	public var event_DragStop:Object={name:'DragStop'};	
	public var event_DragStart:Object={name:'DragStart'};
	
	//SEE: get01():Number
	public var event_New01:Object={name:'New01'};
	
	private var btn:MIButton;
	private var bg:MCScale9;
	private var moveArea:Number;
	private var dragger:VirtualDrag;
	public var mimc : MIMC;
	
	public function MCSlider(mc:MovieClip){
		mimc=MIMC.forInstance(mc);
		btn=mimc.getMIButton('btn');
		btn.addButtonView(new ButtonViewFourFrames(btn['btn']));
		btn.addListener(this);
		
		bg=MCScale9.forInstance(mimc.g('bg'));
		bg.setWidth(mc._xscale);
		mc._xscale=mc._yscale=100;
		moveArea=bg.mc._width-btn.btn._width;
		dragger=new VirtualDrag(mc.btn);
		dragger.addListener(this);
		
		MIMCUtil.snapMCPosToPixels(mimc.mc);
		
		addDeleteWith(mimc);
	}//<>
	
	public function get01():Number{
		if(dragger.isDraged){
			return MIMathUtil.b01((dragger.getX()-btn.btn._width/2)/moveArea);
		}else{
			return MIMathUtil.b01((btn.btn._x-btn.btn._width/2)/moveArea);
		}
	}//<<
	
	public function set01(n01:Number){
		btn.btn._x=Math.round(btn.btn._width/2+n01*moveArea);
	}//<<
	
//****************************************************************************
// EVENTS for MCSlider
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				switch(ev.event){
					case btn.event_Press:
						dragger.start();
					break;
				}
			break;
			case dragger:
				switch(ev.event){
					case dragger.event_Start:
						bev(event_DragStart);
					break;
					case dragger.event_NewDragXY:
						bev(event_New01);
					break;
					case dragger.event_Stop:
						bev(event_DragStop);
					break;
				}
			break;
		}
	}//<<Events
	
}
