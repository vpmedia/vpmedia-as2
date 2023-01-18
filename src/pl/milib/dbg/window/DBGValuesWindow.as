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
import pl.milib.dbg.DBGValuesModel;
import pl.milib.dbg.window.contents.DBGWindowValuesContent;
import pl.milib.dbg.window.DBGWindow;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.DBGValuesWindow extends DBGWindow {

	private var values : DBGValuesModel;
	
	public function DBGValuesWindow(mc:MovieClip, values:DBGValuesModel) {
		super(mc);
		this.values=values;
		values.addListener(this);
		setupDBGContents([new DBGWindowValuesContent(values)]);
		ui.drawTitle('values');
		ui.drawNames(' ');
		
	}//<>
	
	public function getCurrentContent(Void):DBGWindowValuesContent {
		return DBGWindowValuesContent(super.getCurrentContent());
	}//<<
	
//****************************************************************************
// EVENTS for DBGValuesWindow
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		super.onEvent(ev);
		switch(ev.hero){
			case values:
				switch(ev.event){
					case values.event_ElementChanged:
						ui.drawTitleExtra(values.getElementName(ev.data.num)+':'+values.getElementValue(ev.data.num));
					break;
				}
			break;
		}
	}//<<Events
	
}