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

import flash.geom.Rectangle;

import pl.milib.data.info.MIEventInfo;
import pl.milib.managers.MouseManager;
import pl.milib.mc.abstract.AbstractButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualRectButtonsManager;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.virtualUI.VirtualRectButton extends AbstractButton {

	public var mimc : MIMC;
	private var mm : MouseManager;
	private var width : Number;
	private var height : Number;
	private var x0 : Number;
	private var y0 : Number;
	private var x1 : Number;
	private var y1 : Number;
	private var isNoRegAtManager : Boolean;
	
	public function VirtualRectButton(mc:MovieClip, $rect:Rectangle, $isNoRegAtManager:Boolean) {		
		mimc=MIMC.forInstance(mc);
		addDeleteWith(mimc);
		mm=MouseManager.getInstance();
		mm.addListener(this);
		if($rect==null){
			setRectByMC();
		}else{
			setRect($rect);
		}
		isNoRegAtManager=$isNoRegAtManager== null ? false : $isNoRegAtManager;
		if(!isNoRegAtManager){
			VirtualRectButtonsManager.getInstance().regButton(this);
		}
		addDeleteWith(mimc);
	}//<>
	
	public function setRect(rect:Rectangle):Void {
		width=rect.width;		height=rect.height;		x0=rect.x;		y0=rect.y;
		x1=x0+width;
		y1=y0+height;
	}//<<
	public function setRectByMC(Void):Void {
		var rect=mimc.mc.getRect(mimc.mc);
		setRect(new Rectangle(rect.xMin, rect.yMin, rect.xMax-rect.xMin, rect.yMax-rect.yMin));
	}//<<
	
	public function setWidth(width:Number):Void {
		setRect(new Rectangle(x0, y0, width, height));
	}//<<
	public function setHeight(height:Number):Void {
		setRect(new Rectangle(x0, y0, width, height));
	}//<<
	
	private function doOver(Void):Boolean {
		if(!isNoRegAtManager){
			return VirtualRectButtonsManager.getInstance().isSetNewOver(this);
		}
	}//<<
	
//	private function isOverMyButton(Void):Boolean {
//		var mcs:Array=MIMCUtil.getMouseHITMCS();
//		return MIArrayUtil.got(mcs, mimc.mc);
//	}//<<
	
	private function doDelete(Void):Void {
		mm.removeListener(this);
		super.doDelete();
	}//<<
	
//****************************************************************************
// EVENTS for AreaGuard
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mm:
				switch(ev.event){
					case mm.event_Down:
						if(isOver){
							setPress();
						}
					break;
					case mm.event_Up:
						if(isOver){
							setRelease();
						}else if(isPressed){
							setReleaseOutside();
						}
					break;
					case mm.event_Move:
						var mouseX:Number=mimc.mc._xmouse;
						var mouseY:Number=mimc.mc._ymouse;
						if(isOver){
							if(mouseX<x0 || mouseX>x1 || mouseY<y0 || mouseY>y1){
								if(mm.getIsDown()){
									setDragOut();
								}else{
									setRollOut();
								}
							}
						}else{
							if(mouseX>x0 && mouseX<x1){
								if(mouseY>y0 && mouseY<y1){
									if(!isNoRegAtManager){
										if(!VirtualRectButtonsManager.getInstance().isSetNewOver(this)){
											return;
										}
									}
									if(mm.getIsDown()){
										setDragOver();
									}else{
										setRollOver();
									}
								}
							}
						}
					break;
				}
			break;
		}
	}//<<Events
		
}
