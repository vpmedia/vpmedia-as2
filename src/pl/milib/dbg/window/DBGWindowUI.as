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
import pl.milib.core.value.MIValueOwner;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.WidthAndHeightInfo;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.dbg.window.DBGWindow;
import pl.milib.managers.CursorManager;
import pl.milib.managers.EnterFrameRenderManager;
import pl.milib.mc.buttonViews.ButtonViewContrast;
import pl.milib.mc.ContentsMCA;
import pl.milib.mc.MCScale9;
import pl.milib.mc.service.MIButton;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.service.MITextField;
import pl.milib.mc.virtualUI.VirtualDrag;
import pl.milib.util.MILibUtil;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.DBGWindowUI extends MIBroadcastClass implements MIValueOwner {
	
	public var event_PressWhenDisabled:Object={name:'PressWhenDisabled'};
	
	private var mc_bg : MovieClip;
	private var tfNames : MITextField;
	private var tfTitle : MITextField;
	private var bodyScale9 : MCScale9;
	private var btnCorner : MIButton;
	private var mc_contents : MovieClip;
	private var mc_contentMask : MovieClip;
	private var btnBeam : MIButton;
	private var viDragCorner : VirtualDrag;
	private var viDragWindow : VirtualDrag;
	private var cookieData : Object;
	private var btnClose : MIButton;
	private var owner : DBGWindow;
	private var mc_body : MovieClip;
	private var mc_allPress : MovieClip;
	private var tfTitleColorOrg : Number;
	public var areMaximized : MIBooleanValue;
	public var areSelected : MIBooleanValue;
	public var contents : ContentsMCA;
	public var mimc : MIMC;
	private var title : String;
	
	public function DBGWindowUI(owner:DBGWindow, mc:MovieClip) {
		mimc=MIMC.forInstance(mc);
		this.owner=owner;
		mc_bg=mimc.g('bg');
		tfNames=mimc.getMITextField('tfNames');
		tfTitle=mimc.getMITextField('tfTitle');
		tfTitleColorOrg=tfTitle.tf.textColor;
		mc_body=mimc.g('body');
		mc_body.gotoAndStop(1);
		bodyScale9=MCScale9.forInstance(mc_body);
		mc_contents=mimc.g('contents');
		mc_contentMask=mimc.g('contentMask');
		mc_contents.setMask(mc_contentMask);
		contents=new ContentsMCA(mc_contents);
		
		btnCorner=mimc.getMIButton('btnCorner');
		btnCorner.addListener(this);
		CursorManager.getInstance().addButton(btnCorner, CursorManager.getInstance().cursorDragMode);
		viDragCorner=new VirtualDrag(btnCorner['btn']);
		viDragCorner.addListener(this);
		btnBeam=mimc.getMIButton('btnBeam');
		btnBeam.addListener(this);
		CursorManager.getInstance().addButton(btnBeam, CursorManager.getInstance().cursorDragMode);
		viDragWindow=new VirtualDrag(mimc.mc);
		viDragWindow.addListener(this);
		mc_allPress=MIMCUtil.createRectangle(mc, 'allPress');
		mc_allPress._alpha=0;
		
		btnClose=mimc.getMIButton('btnClose');
		btnClose.addListener(this);
		btnClose.addButtonView(new ButtonViewContrast(btnClose['btn']));
		
		areMaximized=(new MIBooleanValue(true)).setOwner(this);
		areSelected=(new MIBooleanValue(false)).setOwner(this);
		
		EnterFrameRenderManager.getInstance().addRenderMethod(this, resetWidthAndHeight);
		
		addDeleteTogether(mimc);
		areMaximized.apply();		areSelected.apply();
	}//<>
	
	public function setCookie(cookieObj:Object):Void {
		if(!cookieObj.d){
			cookieObj.d={
				w:350, h:400,
				x:mimc.mc._parent._xmouse,
				y:mimc.mc._parent._ymouse,
				areMax:true
			};
		}
		cookieData=cookieObj.d;
		
		setXY(cookieData.x, cookieData.y);		setWidthAndHeight(cookieData.w, cookieData.h);
		areMaximized.v=cookieData.areMax;
	}//<<
	
	private function applyCookieCurrentData(Void):Void {
		cookieData.w=bodyScale9.getWidth();
		cookieData.h=bodyScale9.getHeight();
		cookieData.x=mimc.mc._x;
		cookieData.y=mimc.mc._y;		cookieData.areMax=areMaximized.v;
	}//<<
	
	public function setWidthAndHeight(width:Number, height:Number):Void {
		var marg:Number=mc_contents._x;		var contents_y:Number=mc_contents._y;
		
		width=Math.max(width, bodyScale9.getMinWidth());
		height=Math.max(height, bodyScale9.getMinHeight());
		
		var wh:WidthAndHeightInfo=DBGWindowContent(contents.getCurrentMCAContent()).setWidthAndHeight(width-marg*2, height-contents_y);
		
		bodyScale9.setWidthAndHeight(width, height);
		mc_contentMask._width=mc_bg._width=width-mc_bg._x-marg;		mc_contentMask._height=mc_bg._height=height-mc_bg._y-marg;
		btnCorner.btn._x=width;		btnCorner.btn._y=height;
		
		tfNames.tf._width=width-tfNames.tf._x;		tfTitle.tf._width=width-tfTitle.tf._x-btnClose.btn._width;
		//tfTitle.tf.hscroll=tfTitle.tf.maxhscroll;
		
		mc_allPress._width=width;
		if(areMaximized.v){ mc_allPress._height=height; }
		
		btnBeam.btn._width=width;
		btnClose.btn._x=width;
	}//<<
	public function resetWidthAndHeight(Void):Void {
		setWidthAndHeight(btnCorner.btn._x, btnCorner.btn._y);
	}//<<
	
	public function setXY(x:Number, y:Number):Void {
		mimc.mc._x=int(x);
		mimc.mc._y=int(y);
	}//<<
	
	public function getWidth(Void):Number {
		return btnCorner.btn._x;
	}//<<
	
	public function getHeight(Void):Number {
		return btnCorner.btn._y;
	}//<<
	
	public function drawNames(names:String):Void {
		tfNames.tf.htmlText=names;
	}//<<
	
	public function drawTitle(text:String):Void {
		if(!text){ return; }
		title=text;
		tfTitle.tf.htmlText=title;
		tfTitle.tf.textColor=areSelected.v ? tfTitleColorOrg : 0;
	}//<<
	
	public function drawTitleExtra(text:String):Void {
		if(!text){ return; }
		tfTitle.tf.htmlText=title+': '+text;
		tfTitle.tf.textColor=areSelected.v ? tfTitleColorOrg : 0;
	}//<<
	
	public function getOwner(Void):DBGWindow {
		return owner;
	}//<<
	
	public function disableCloseButton(Void):Void {
		btnClose.btn._visible=false;
	}//<<
	
	public function close(Void):Void {
		if(btnClose.btn._visible){
			mimc.getDeleter().DELETE();
		}
	}//<<
	
//****************************************************************************
// EVENTS for DBGWindowUI
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btnCorner:
				switch(ev.event){
					case btnCorner.event_Press:
						viDragCorner.start();
					break;
					case btnCorner.event_ReleaseAll:
						viDragCorner.stop();
						applyCookieCurrentData();
					break;
				}
			break;
			case viDragCorner:
				switch(ev.event){
					case viDragCorner.event_NewDragXY:
						btnCorner.btn._x=viDragCorner.getX();
						btnCorner.btn._y=viDragCorner.getY();
						resetWidthAndHeight();
					break;
				}
			break;
			case btnBeam:
				switch(ev.event){
					case btnBeam.event_Press:
						viDragWindow.start();
					break;
					case btnBeam.event_ReleaseAll:
						viDragWindow.stop();
						applyCookieCurrentData();
					break;
					case btnBeam.event_DoublePress:
						areMaximized.sWitch();
					break;
				}
			break;
			case viDragWindow:
				switch(ev.event){
					case viDragWindow.event_Start:
						mimc.mc.cacheAsBitmap=true;
					break;
					case viDragWindow.event_Stop:
						mimc.mc.cacheAsBitmap=false;
					break;
					case viDragWindow.event_NewDragXY:
						setXY(viDragWindow.getX(), viDragWindow.getY());
					break;
				}
			break;
			case btnClose:
				switch(ev.event){
					case btnClose.event_Press:
						close();
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MIValue_ValueChange(val:MIBooleanValue, oldValue):Void {
		switch(val){
			case areMaximized:
				tfNames.tf._visible=areMaximized.v;
				mc_contents._visible=areMaximized.v;				mc_bg._visible=areMaximized.v;
				btnCorner.btn._visible=areMaximized.v;				mc_contentMask._visible=areMaximized.v;
				if(areMaximized.v){
					mc_body.gotoAndStop(1);
					bodyScale9.render();
					resetWidthAndHeight();
				}else{
					mc_body.gotoAndStop(2);
					bodyScale9.render();
					mc_allPress._height=mc_body.beam._height;
				}
				applyCookieCurrentData();
			break;
			case areSelected:
				if(areSelected.v){
					mimc.mc._alpha=100;
					mc_allPress.onPress=function(){};
					mc_allPress.useHandCursor=false;
					mc_allPress.swapDepths(MIMCUtil.getLowestDepth(mimc.mc));
					mimc.mc.filters=[MIDBGUtil.getStandartDropShadow()];
					tfTitle.tf.textColor=tfTitleColorOrg;
				}else{
					mimc.mc._alpha=20;
					mc_allPress.onPress=MILibUtil.createDelegate(this, onDisabledMCPress);
					mc_allPress.useHandCursor=true;
					mc_allPress.swapDepths(mimc.mc.getNextHighestDepth());
					mimc.mc.filters=[];
					tfTitle.tf.textColor=0;
				}
			break;
		}
	}//<<
	
	private function onDisabledMCPress(Void):Void {
		bev(event_PressWhenDisabled);
	}//<<
	
}