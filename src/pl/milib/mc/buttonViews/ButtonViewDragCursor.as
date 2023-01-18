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
import pl.milib.mc.abstract.AbstractButtonView;
import pl.milib.mc.service.MIMC;

/** @author Marek Brun 'minim' */
class pl.milib.mc.buttonViews.ButtonViewDragCursor extends AbstractButtonView {
	
	private var mimc : MIMC;
	
	public function ButtonViewDragCursor(mcAttachName:String) {
		
	}//<>
	
//****************************************************************************
// EVENTS for FourFramesButtonView
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
								
							break;
							case state_OVER:
								
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