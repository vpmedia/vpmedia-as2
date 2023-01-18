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

import pl.milib.data.info.MIEventInfo;
import pl.milib.managers.MouseManager;
import pl.milib.mc.abstract.AbstractButtonView;
import pl.milib.mc.service.MIMC;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.buttonViews.ButtonViewFourFramesMouseMovePress extends AbstractButtonView {

	private var mimc : MIMC;
	private var mm : MouseManager;
	
	public function ButtonViewFourFramesMouseMovePress(mc:MovieClip) {
		mimc=MIMC.forInstance(mc);
		mm=MouseManager.getInstance();
	}//<>
	
//****************************************************************************
// EVENTS for FourFramesButtonView
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		switch(ev.hero){
			case btn:
				setStateByActual();
			break;
			case state:
				switch(ev.event){
					case state.event_ValueChanged:
						switch(state.v){
							case state_OUT:
								mimc.gotoAndStop(1);
							break;
							case state_OVER:
								mimc.gotoAndStop(2);
							break;
							case state_PRESSED:
								mm.addListener(this);
							break;
							case state_DISABLED:
								mimc.gotoAndStop(4);
							break;
						}
					break;
				}
			break;
			case mm:
				switch(ev.event){
					case mm.event_Move:
						if(state.v==state_PRESSED){
							mimc.gotoAndStop(3);
						}
						mm.removeListener(this);
					break;
				}
			break;
		}
		//super.onEvent(ev);
	}//<<Events
	
}