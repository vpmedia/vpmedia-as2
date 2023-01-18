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
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;

/**
 * @often_name mm
 * 
 * @author Marek 'minim' Brun
 */
class pl.milib.managers.MouseManager extends MIBroadcastClass implements EnterFrameReciver {
	
	//nastąpił interwał podczas wciśnięcia myszy
	public var event_IntervalDown:Object={name:'IntervalDown'};
	
	//nastąpiło wcisnięcie myszy
	public var event_Down:Object={name:'Down'};
	
	//nastąpiło puszczenie myszy
	public var event_Up:Object={name:'Up'};
	
	//nastąpiła zmiana pozycji myszy
	public var event_Move:Object={name:'Move'};
	
	//nastąpiła zmiana pozycji myszy z wciśniętym przyciskiem
	public var event_MoveWhenDown:Object={name:'MoveWhenDown'};
	
	//nastąpiło poruszenie wałka myszy
	//data:	delta:Number
	//		scrollTarget:Object
	//		turn:Number //-1 albo 1
	public var event_MoveWhell:Object={name:'MoveWhell'};
	
	private static var instance : MouseManager;
	public var isDown : Boolean;
	public var lastVX : Number;
	public var lastVY : Number;
	public var lastX : Number;
	public var lastY : Number;
	private var downX : Number;
	private var downY : Number;
	
	private function MouseManager() {
		Mouse.addListener(this);
		lastVX=0;		lastVY=0;
		lastX=_root._xmouse;
		lastY=_root._ymouse;
	}//<>
	
	public function getDragVX(Void):Number {
		if(isDown){ return downX-_root._xmouse; } 
		else{ return 0; }
	}//<<
	
	public function getDragVY(Void):Number {
		if(isDown){ return downY-_root._ymouse; } 
		else{ return 0; }
	}//<<
	
	public function getLastVX(Void):Number { return lastVX; }//<<
	public function getLastVY(Void):Number { return lastVY; }//<<
	
	public function getIsDown(Void):Boolean {
		return isDown;
	}//<<
	
	/** @return singleton instance of MouseManager */
	static public function getInstance(Void):MouseManager {
		if(instance==null){ instance=new MouseManager(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for MouseManager
//****************************************************************************
	public function onEnterFrame(id):Void {
		bev(event_IntervalDown);
	}//<<
	
	private function onMouseWheel(delta,scrollTarget):Void {
		bev(
			event_MoveWhell,
			{
				delta:delta,
				scrollTarget:scrollTarget,
				turn:delta<0 ? -1 : 1
			}
		);
	}//<<
	
	private function onMouseUp(Void):Void {
		isDown=false;
		EnterFrameBroadcaster.stop(this);
		bev(event_Up);
	}//<<
	
	private function onMouseMove(Void):Void {
		lastVX=_root._xmouse-lastX;
		lastVY=_root._ymouse-lastY;
		lastX=_root._xmouse;
		lastY=_root._ymouse;
		bev(event_Move);
		if(isDown){
			bev(event_MoveWhenDown);
		}
	}//<<
	
	private function onMouseDown(Void):Void {
		isDown=true;
		downX=_root._xmouse;
		downY=_root._ymouse;
		EnterFrameBroadcaster.start(this);
		bev(event_Down);
	}//<<
	
}