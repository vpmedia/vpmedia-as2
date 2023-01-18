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
 
import pl.milib.anim.static_.Animation;
import pl.milib.anim.static_.MIEase;
import pl.milib.data.DynamicValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.abstract.AbstractButtonView;
import pl.insignia.mc.buttonViews.ButtonViewIniMidEnd;

/**
 * @author Marek Brun
 */
class pl.milib.mc.buttonViews.ButtonViewAnimated extends AbstractButtonView {
	
	private var animOn : Animation;
	private var animOff : Animation;
	private var ease : MIEase;
	private var time : DynamicValue;
	private var rollOverValue : Number;
	
	private function ButtonViewAnimated(Void) {}//<>
	
	private function setup($ease:MIEase, $time:DynamicValue) {
		
		ease=$ease==null ? new MIEase() : $ease;
		time=$time==null ? new DynamicValue(350) : $time;
		
		_rollOver=0;
		
		animOn=new Animation();
		animOn.setupWorkingTimeAsDynamicValue(time);		animOn.addElement(this, '_rollOver', 1, ease);
		animOff=animOn.cloneByTargetsAsCurrents(true);
	}//<>
	
	/*abstract*/ private function doRollOver(n01:Number):Void {}//<<
	
	private function set _rollOver(n01:Number):Void {
		rollOverValue=n01;
		doRollOver(n01);
	}//<<
	
	private function get _rollOver(Void):Number {
		return rollOverValue;
	}//<<
	
//****************************************************************************
// EVENTS for ButtonViewAnimated
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case btn:
				setStateByActual();
			break;
			case state:
				switch(ev.event){
					case state.event_ValueChanged:
						switch(state.v){
							case state_OUT:
								animOff.start();
							break;
							case state_OVER:
								animOn.start();
							break;
							case state_PRESSED:
								
							break;
							case state_DISABLED:
								
							break;
						}
					break;
				}
			break;
		}
	}//<<Events
	
}