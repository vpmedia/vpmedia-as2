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

import pl.milib.core.value.MINumberValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.MCSlider;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCSliderViewer extends MCSlider {

	private var model : MINumberValue;
	private var isChangeWhenDrag : Boolean;
	
	public function MCSliderViewer(mc:MovieClip) {
		super(mc);
	}//<>
	
	public function setupModel(model:MINumberValue, isChangeWhenDrag:Boolean):Void {
		this.model.removeListener(this);
		this.model=model;
		this.model.addListener(this);
		this.isChangeWhenDrag=isChangeWhenDrag;
		render();
	}//<<
	
	private function render(Void):Void {
		set01(model.v);
	}//<<
	
//****************************************************************************
// EVENTS for MCSliderViewer
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		super.onEvent(ev);
		switch(ev.hero){
			case model:
				switch(ev.event){
					case model.event_ValueChanged:
						render();
					break;
				}
			break;
			case dragger:
				switch(ev.event){
					case dragger.event_NewDragXY:
						if(isChangeWhenDrag){ model.v=get01(); }
					break;
				}
			break;
		}
	}//<<Events
	
}