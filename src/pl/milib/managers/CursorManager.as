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

import flash.filters.DropShadowFilter;

import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.managers.MouseManager;
import pl.milib.mc.abstract.AbstractButton;
import pl.milib.mc.cursorViews.CursorModifier;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MIMCUtil;

/**
 * TODO create VirtualAreaButton and implement his cursor behaviour 
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.CursorManager extends MIBroadcastClass {
	
	private static var instance : CursorManager;
	private var mimc : MIMC;
	private var couplesBtnCursorInfo : MIObjects; // of [AbstractButton, ButtonCursorsInfo]
	private var mimcCursors : MIMC;
	private var currentCursorMode : CursorModifier;
	private var mm : MouseManager;
	private var overDropShadow : DropShadowFilter;
	private var downDropShadow : DropShadowFilter;
	public var cursorDragMode : CursorModifier;
	
	private function CursorManager() {
		mimc=MIMC.forInstance(_root.createEmptyMovieClip('MCForCursorManager', _root.getNextHighestDepth()));
		var cursorsMC:MovieClip=mimc.mc.attachMovie('milib_cursors', 'milib_cursors', mimc.mc.getNextHighestDepth());
		if(cursorsMC){
			mimcCursors=MIMC.forInstance(cursorsMC);
		
			overDropShadow=new DropShadowFilter(3, 45, 0x000000, .4, 2, 2, 1, 3, false, false, false);			downDropShadow=new DropShadowFilter(2, 45, 0x000000, .6, 2, 2, 1, 3, false, false, false);
			
			cursorDragMode=new CursorModifier('drag_over', 'drag_down');
			
			couplesBtnCursorInfo=new MIObjects();
			couplesBtnCursorInfo.addListener(this);
			mimc.mc._visible=false;
			mm=MouseManager.getInstance();
			
		}
	}//<>
	
	public function addButton(btn:AbstractButton, cursorMode:CursorModifier):Void {
		btn.getDeleter().addFinishWhenDelete(cursorMode);
		couplesBtnCursorInfo.addObject(btn, cursorMode);
	}//<<
	
	public function addButtons(buttons:Array, cursorMode:CursorModifier):Void {
		for(var i=0;i<buttons.length;i++){
			addButton(buttons[i], cursorMode);
		}
	}//<<
	
	public function setCursor(frame:String, $isVisibleMouse:Boolean):Boolean {
		mimcCursors.gotoLastFrame();		mimcCursors.gotoAndStop(frame);
		Mouse.hide();
		return !mimcCursors.isInLastFrame();
	}//<<
	
	public function setStandardCursor(Void):Void {
		mimcCursors.gotoLastFrame();
		Mouse.show();
	}//<<
	
	public function setNoCursor(Void):Void {
		mimcCursors.gotoLastFrame();
		Mouse.hide();
	}//<<
	
	/** @return singleton instance of CursorManager */
	public static function getInstance():CursorManager {
		if(instance==null){ instance=new CursorManager(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for CursorManager
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case couplesBtnCursorInfo:
				var hero:AbstractButton=AbstractButton(ev.data.hero);
				switch(ev.data.event){
					case hero.event_Over:
						MIMCUtil.swapDepthToUp(mimc.mc);
						currentCursorMode=CursorModifier(couplesBtnCursorInfo.getSubByMain(hero));
						currentCursorMode.setupButton(hero);
						currentCursorMode.addListener(this);
						currentCursorMode.start();
					break;
					case hero.event_OutAndRelease:
						currentCursorMode.finish();
					break;
				}
			break;
			case currentCursorMode:
				switch(ev.event){
					case currentCursorMode.event_RunningStart:
						mm.addListener(this);
						mimc.mc._visible=true;
					break;
					case currentCursorMode.event_RunningFinish:
						setStandardCursor();
						delete currentCursorMode;
						mimc.mc._visible=false;
					break;
					case currentCursorMode.event_Over:
						mimcCursors.mc.filters=[overDropShadow];
					break;
					case currentCursorMode.event_Down:
						mimcCursors.mc.filters=[downDropShadow];
					break;
				}
			break;
			case mm:
				switch(ev.event){
					case mm.event_Move:
						mimcCursors.mc._x=mimcCursors.mc._parent._xmouse;
						mimcCursors.mc._y=mimcCursors.mc._parent._ymouse;
					break;
				}
			break;
		}
	}//<<Events
	
}