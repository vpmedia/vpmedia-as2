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
import pl.milib.data.SubObjects;
import pl.milib.data.SubObjectsOwner;
import pl.milib.mc.abstract.AbstractButtonView;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.abstract.AbstractButton extends MIBroadcastClass implements SubObjectsOwner {

	//nastąpiła zmiana trybu aktywności
	public var event_EnabledChanged:Object={name:'EnabledChanged'};
	//nastąpiło naciśniecie
	public var event_Press:Object={name:'Press'};
	//nastąpiło podwójne naciśniecie
	public var event_DoublePress:Object={name:'DoublePress'};
	//nastąpiło puszczenie przycisku w obszarze HIT
	public var event_Release:Object={name:'Release'};
	//nastąpiło puszczenie przycisku poza obszarem HIT
	public var event_ReleaseOutside:Object={name:'ReleaseOutside'};
	//nastąpiło puszczenie przycisku
	public var event_ReleaseAll:Object={name:'ReleaseAll'};
	//nastąpiło wyjechanie z obszaru HIT
	public var event_RollOut:Object={name:'RollOut'};
	//nastąpiło wjechanie na obszar HIT z przytrzymaniem
	public var event_RollOver:Object={name:'RollOver'};
	//nastąpiło wyjechanie z obszaru HIT z przytrzymaniem
	public var event_DragOut:Object={name:'DragOut'};
	//nastąpiło wjechanie na obszar HIT z przytrzymaniem
	public var event_DragOver:Object={name:'DragOver'};
	//nastąpiło najechanie na obszar HIT 
	public var event_Over:Object={name:'Over'};
	//nastąpiło wyjechanie z obszaru HIT 
	public var event_Out:Object={name:'Out'};
	//nastąpiło wyjechanie z obszaru HIT z nieprzytrzymanym przyciskiem	//lub nastąpiło puszczenie przycisku poza obszarem HIT
	public var event_OutAndRelease:Object={name:'OutAndRelease'};
	//nastąpiło najechanie lub wyjechanie z obszaru HIT 
	public var event_OverOrOut:Object={name:'OverOrOut'};
	
	private var isPressed : Boolean;
	private var isOver : Boolean;
	private var isEnabled : Boolean;
	private var views : SubObjects;
	private var lastPressTime : Number;
	
	public function AbstractButton(Void) {
		isOver=false;		isPressed=false;		isEnabled=false;
		views=new SubObjects(this, true);
	}//<>
	private function doOver(Void):Boolean { return true; }//<<
	
	public function getIsPressed():Boolean{
		return isPressed;
	}//<<
	
	public function getIsOver():Boolean{
		return isOver;
	}//<<
	
	public function getIsEnabled(Void):Boolean {
		return isEnabled;
	}//<<
	
	public function addButtonView(view:AbstractButtonView):Void {
		views.addSubObject(view);
	}//<<
	
	public function setButtonView(view:AbstractButtonView):Void {
		views.setSubObject(view);
	}//<<
	
	/** @param buttonViews Array of AbstractButtonView */  
	public function addButtonViews(buttonViews:Array):Void {
		views.addSubObjects(buttonViews);
	}//<<
	
	/** @param buttonViews Array of AbstractButtonView */  
	public function setButtonViews(buttonViews:Array):Void {
		views.setSubObjects(buttonViews);
	}//<<
	
	private function setPress(Void):Void {
		if(!isOver){ return; }
		if(isPressed){ return; }
		isPressed=true;
		if(getTimer()-lastPressTime<250){ bev(event_DoublePress); }
		lastPressTime=getTimer();
		bev(event_Press);
	}//<<
	
	private function setRelease(Void):Void {
		if(!isOver){ return; }
		if(!isPressed){ return; }
		isPressed=false;
		bev(event_ReleaseAll);
		bev(event_Release);
	}//<<
	
	private function setReleaseOutside(Void):Void {
		if(!isPressed){ return; }
		isPressed=false;
		bev(event_OutAndRelease);
		bev(event_ReleaseAll);
		bev(event_ReleaseOutside);
	}//<<
	
	private function setRollOut(Void):Void {
		if(!isOver){ return; }
		isOver=false;
		bev(event_OutAndRelease);
		bev(event_OverOrOut);
		bev(event_Out);
		bev(event_RollOut);
	}//<<
	
	private function setRollOver(Void):Void {
		if(isOver){ return; }
		if(!doOver()){ return; }
		isOver=true;
		bev(event_OverOrOut);
		bev(event_Over);
		bev(event_RollOver);
	}//<<
	
	private function setDragOut(Void):Void {
		if(!isOver){ return; }
		isOver=false;
		bev(event_OverOrOut);
		bev(event_Out);
		bev(event_DragOut);
	}//<<
	
	private function setDragOver(Void):Void {
		if(isOver){ return; }
		if(!doOver()){ return; }
		isOver=true;
		bev(event_OverOrOut);
		bev(event_Over);
		bev(event_DragOver);
	}//<<
	
	public function doArtificialOut(Void):Void {
		if(isPressed){ setRelease(); }
		if(isOver){ setRollOut(); }
	}//<<
	
	private function doDelete(Void):Void {
		doArtificialOut();
		super.doDelete();
	}//<<
	
//****************************************************************************
// EVENTS for AbstractButton
//****************************************************************************
	public function onSlave_SubObjects_AddSubObject(subs:SubObjects, sub):Void {
		var view:AbstractButtonView=AbstractButtonView(sub);
		view.setButton(this);
	}//<<
	
}