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
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.info.ScrollInfo;
import pl.milib.mc.MIScrollable;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.abstract.MIScroller extends MIBroadcastClass {
	
	//broadcasted when scroll is moved
	public var event_Moved:Object={name:'Moved'};

	private var scrollable : MIScrollable;
	
	/*abstract*/ public function applyScrollData(scrollData:ScrollInfo):Void { }//<<
	/*abstract*/ public function doSetScrolledObject(Void):Void { }//<<
	
	public function setScrolledObject(scrollable:MIScrollable):Void {
		this.scrollable.removeListener(this);		this.scrollable=scrollable;
		applyScrollData(this.scrollable.getScrollData());		this.scrollable.addListener(this);
		doSetScrolledObject();
	}//<<
	
//****************************************************************************
// EVENTS for MIScroller
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		switch(ev.hero){
			case scrollable:
				switch(ev.event){
					case scrollable.event_NewScrollData:
						applyScrollData(scrollable.getScrollData());
					break;
				}
			break;
		}
		//super.onEvent(ev);
	}//<<Events
	
}