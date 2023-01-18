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
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.mc.abstract.AbstractButton;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.abstract.AbstractButtonView extends MIBroadcastClass implements MIValueOwner {

	private var btn : AbstractButton;
	private var state : MIValue;
	private var state_OUT:Object={name:'out'};
	private var state_OVER:Object={name:'over'};
	private var state_PRESSED:Object={name:'pressed'};	private var state_DISABLED:Object={name:'disabled'};
	private var freez : MIValue;
	
	public function AbstractButtonView() {
		state=(new MIValue());
		state.addListener(this);
		freez=(new MIBooleanValue(false)).setOwner(this);
	}//<>
	
	public function setButton(btn:AbstractButton):Void {
		this.btn.removeListener(this);		this.btn=btn;		this.btn.addListener(this);
		doSetButon();
		setStateByActual();
	}//<<
	
	public function setStateByActual(Void):Void {
		if(freez.v){ return; }
		if(!btn.getIsEnabled()){
			state.v=state_DISABLED;
		}else if(btn.getIsPressed()){
			state.v=state_PRESSED;
		}else if(btn.getIsOver()){
			state.v=state_OVER;
		}else{
			state.v=state_OUT;
		}
	}//<<
	
	public function setIsFreez(isFreez:Boolean):Void {
		freez.v=isFreez;
	}//<<
	
	/*abstract optional*/ private function doSetButon(Void):Void {}//<<
	
//****************************************************************************
// EVENTS for AbstractButtonView
//****************************************************************************
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		switch(val){
			case freez:
				if(freez.v){
					this.btn.removeListener(this);
				}else{
					this.btn.addListener(this);
					setStateByActual();
				}
			break;
		}
	}//<<

}