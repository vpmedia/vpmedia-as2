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
import pl.milib.data.TextModel;
import pl.milib.dbg.window.contents.DBGWindowTextContent;
import pl.milib.dbg.window.DBGWindow;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.DBGTextWindow extends DBGWindow {
	
	private var log:TextModel;
	
	public function DBGTextWindow(mc:MovieClip, log:TextModel) {
		super(mc);
		this.log=log;
		log.addListener(this);
		setupDBGContents([new DBGWindowTextContent(log)]);
		ui.drawTitle('<b>main logger</b>');
		ui.drawNames('log');
		setTitleExtra();
	}//<>
	
	public function getCurrentContent(Void):DBGWindowTextContent  {
		return DBGWindowTextContent(super.getCurrentContent());
	}//<<
	
	private function setTitleExtra(Void):Void {
		ui.drawTitleExtra(log.getLastLineText().split('\n').join('<b>|</b>'));
	}//<<
	
//****************************************************************************
// EVENTS for DBGTextWindow
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		super.onEvent(ev);
		switch(ev.hero){
			case log:
				switch(ev.event){
					case log.event_Changed:
						setTitleExtra();
					break;
				}
			break;
		}
	}//<<Events
	
}