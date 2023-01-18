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

class pl.milib.mc.virtualUI.VirtualDrag extends MIBroadcastClass {
	
	//nastąpiło rozpoczęcie przesuwania
	public var event_Start:Object={name:'Start'};
	
	//nastąpiło przesunięcie
	public var event_NewDragXY:Object={name:'NewDragXY'};
	
	//nastąpiło zatrzymanie przesuwania
	public var event_Stop:Object={name:'Stop'};
	
	public var mc:MovieClip;
	public var isDraged:Boolean;
	public var mouseMinusX:Number;
	public var mouseMinusY:Number;
	
	
	public function VirtualDrag(mc){
//		if(!mi.isMC(mc)){ l('no mc in>'+this); }
		this.mc=mc;
		isDraged=false;
	}//<>
	
	public function start(){
		mouseMinusX=mc._parent._xmouse-mc._x;
		mouseMinusY=mc._parent._ymouse-mc._y;
		Mouse.addListener(this);
		isDraged=true;
		bev(event_Start);
	}//<<
	
	public function stop(){
		Mouse.removeListener(this);
		isDraged=false;
		bev(event_Stop);
	}//<<
	
	public function getX(){
		if(isDraged){ return mc._parent._xmouse-mouseMinusX; }		else{  return mc._x; }
	}//<<
	
	public function getY(){
		if(isDraged){ return mc._parent._ymouse-mouseMinusY; }
		else{  return mc._y; }
	}//<<
	
//****************************************************************************
// EVENTS for VirtualDrag
//****************************************************************************
	public function onMouseMove(){
		bev(event_NewDragXY);
	}//<<
	
	public function onMouseUp(){
		this.stop();
	}//<<
	
}
