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

import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.ScrollableArray;
import pl.milib.managers.EnterFrameRenderManager;
import pl.milib.managers.MouseManager;
import pl.milib.mc.abstract.MIScroller;
import pl.milib.mc.MCDuplicator;
import pl.milib.mc.MCDuplicatorOwner;
import pl.milib.mc.MCListElement;
import pl.milib.mc.MCListOwner;
import pl.milib.mc.service.MIMC;
import pl.milib.mc.virtualUI.VirtualRectButton;
import pl.milib.util.MIMCUtil;

/**
 * @often_name mcList
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCList extends MIBroadcastClass implements MCDuplicatorOwner {
	
	//DATA:	Object //element data
	public var event_ElementSelect:Object={name:'ElementSelect'};
	
	private var mc : MovieClip;
	public var scrlArr : ScrollableArray;
	public var mimc : MIMC;
	private var duplicator : MCDuplicator;
	private var height : Number;
	private var elmentsDist : Number;
	private var lines : Number;
	private var owner : MCListOwner;
	private var mcMask : MovieClip;
	private var elements : Array; //of MCListElement
	private var p : Object;
	private var scroller : MIScroller;
	private var isWidthToSet : Boolean;
	private var width : Number;
	public var area : VirtualRectButton;
	private var mm : MouseManager;
	private var elementsEvs : MIObjects;
	private var mc_bg : MovieClip;
	
	/**
	 * @param listElementClass must extend {@code MCListElement} 
	 */
	public function MCList(owner:MCListOwner, mc:MovieClip, $scrlArr:ScrollableArray,con) {
		this.owner=owner;
		this.mc=mc;
		mimc=MIMC.forInstance(mc);
		scrlArr=$scrlArr==null ? new ScrollableArray() : $scrlArr;
		scrlArr.addListener(this);
		duplicator=new MCDuplicator(this, [mimc.g('ele0'), mimc.g('ele1')]);
		elmentsDist=mimc.g('ele1')._y-mimc.g('ele0')._y;
		mcMask=MIMCUtil.createRectangle(mc._parent, mc._name+'Mask');
		mcMask._x=mc._x;		mcMask._y=mc._y;		mcMask._width=mc._width;		mcMask._height=mc._height;
		mc.setMask(mcMask);
		elements=[];
		elementsEvs=new MIObjects();
		elementsEvs.addListener(this);
		area=new VirtualRectButton(mc);
		area.setRect(new Rectangle(0, 0, mcMask._width, mcMask._height));
		mm=MouseManager.getInstance();
		mm.addListener(this);
		mc_bg=mimc.mc.bg;
		mc_bg._x=mc_bg._y=-1;
		if(!_root.isDBG){ mcMask._alpha=0; }
		
		
		addDeleteWith(mimc);		addDeletingSubs([duplicator]);
		if(scrlArr){ render(); }
		EnterFrameRenderManager.getInstance().addRenderMethod(this, render);
	}//<>
	/*abstract*/ private function getIsSetYInRender(Void):Boolean { return true; }//<<
	
	public function render(Void):Void {
		var arr:Array=[scrlArr.getBaseArrayElementByScrollArrayNum(-1)].concat(scrlArr.getCurrentArray(), [scrlArr.getBaseArrayElementByScrollArrayNum(scrlArr.getScrollScope())]);
		var isSetY:Boolean=getIsSetYInRender();
		for(var i=0,eleMC:MovieClip;i<arr.length+1;i++){
			eleMC=duplicator.getMC(i);
			if(isSetY){ eleMC._y=(i-1)*elmentsDist; }
			if(arr[i]){
				MCListElement(elements[i]).setData(arr[i]);
			}else{
				MCListElement(elements[i]).areEnabled.v=false;
			}
		}
		MCListElement(elements[0]).setWidth(width);
		MCListElement(elements[arr.length-1]).setWidth(width);
		if(isWidthToSet){
			isWidthToSet=false;
			mcMask._width=width;
			for(var i=0;i<arr.length;i++){
				MCListElement(elements[i]).setWidth(width);
			}
		}
		
		mc.setMask(mcMask);
	}//<<
	
	public function setupScroller(scroller:MIScroller):Void {
		this.scroller.removeListener(this);
		this.scroller=scroller;
		this.scroller.addListener(this);
	}//<<
	
	public function setHeight(height:Number):Void {
		mc_bg._height=height+2;
		this.height=height;
		lines=int(height/elmentsDist);
		mcMask._x=mc._x;
		mcMask._y=mc._y;
		mcMask._height=height;
		scrlArr.removeListener(this);
		scrlArr.setScrollScope(lines);
		scrlArr.addListener(this);
		duplicator.duplicateToNum(lines+2);
		render();
		area.setHeight(height);
	}//<<
	
	public function setWidth(width:Number):Void {
		mc_bg._width=width+2;
		this.width=width;
		isWidthToSet=true;
		render();
		area.setWidth(width);
	}//<<
	
	public function getListNumByMC(mc:MovieClip):Number {
		return duplicator.getNumByMC(mc);
	}//<<
	
	public function getDataByMC(mc:MovieClip) {
		return scrlArr.getBaseArrayElementByScrollArrayNum(getListNumByMC(mc));
	}//<<
	
	private function doDelete(Void):Void {
		mcMask.unloadMovie();
		area.getDeleter().DELETE(); delete area;
	}//<<
	
//****************************************************************************
// EVENTS for MCList
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case scrlArr:
				switch(ev.event){
					case scrlArr.event_NewScrollData:
						render();
					break;
				}
			break;
			case scroller:
				switch(ev.event){
					case scroller.event_Moved:
						var oneScroll01:Number=scrlArr.getMaxScroll()/scrlArr.getScrollScope();
						var minusY:Number=(scrlArr.getScroll01()-scrlArr.scroll01)*scrlArr.getMaxScroll()*elmentsDist;
						for(var i=0;i<lines+3;i++){
							duplicator.getMC(i)._y=(i-1)*elmentsDist+minusY;
						}
					break;
				}
			break;
			case mm:
				switch(ev.event){
					case mm.event_MoveWhell:
						if(area.getIsOver()){
							scrlArr.setScrollByOneUnit(-ev.data.turn);
						}
					break;
				}
			break;
			case elementsEvs:
				var hero:MCListElement=MCListElement(ev.data.hero);
				switch(ev.data.event){
					case hero.event_Select:
						bev(event_ElementSelect, scrlArr.getBaseArrayElementByScrollArrayNum(elementsEvs.getSubByMain(hero)-1));
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MCDuplicator_NewMC(duplicator:MCDuplicator, eleNum:Number, eleMC:MovieClip):Void {
		var ele:MCListElement=owner.slaveGet_MCList_NewListElement(this, eleNum, eleMC);
		elementsEvs.addObject(ele, eleNum);
		elements[eleNum]=ele;
	}//<<
	
	public function onSlave_MCDuplicator_MCIsEnabledChange(duplicator:MCDuplicator, eleNum:Number, eleMC:MovieClip, isEnaled:Boolean):Void {
		if(isEnaled){
			var arr:Array=[scrlArr.getBaseArrayElementByScrollArrayNum(-1)].concat(scrlArr.getCurrentArray(), [scrlArr.getBaseArrayElementByScrollArrayNum(scrlArr.getScrollScope())]);
			MCListElement(elements[eleNum]).setData(arr[eleNum]);
			MCListElement(elements[eleNum]).setWidth(width);
		}else{
			MCListElement(elements[eleNum]).areEnabled.v=false;
		}
	}//<<
	
}