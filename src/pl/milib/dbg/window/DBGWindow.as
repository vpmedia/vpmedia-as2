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
import pl.milib.dbg.window.contents.DBGWindowContent;
import pl.milib.dbg.window.DBGWindowUI;
import pl.milib.managers.HTMLASFunctionsManager;
import pl.milib.util.MIArrayUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.DBGWindow extends MIBroadcastClass {
	
	public var ui : DBGWindowUI;
	private var dbgContents : Array;
	private var linksProvider : HTMLASFunctionsManager;  //of DBGWindowContent
	
	public function DBGWindow(mc:MovieClip) {
		ui=new DBGWindowUI(this, mc);
		ui.contents.addListener(this);
		linksProvider=HTMLASFunctionsManager.getInstance();
		linksProvider.addListener(this);
		
		addDeleteTogether(ui);
	}//<>
	/*abstract optional*/private function doNewContent(Void):Void {}//<<
	
	public function setCookie(cookieObj:Object):Void {
		if(!cookieObj.ui){ cookieObj.ui={}; }
		ui.setCookie(cookieObj.ui);
	}//<<
	
	public function setContent(dbgContentToOpen:DBGWindowContent):Void {
		ui.contents.open(dbgContentToOpen);
		renderContentNames();
	}//<<
	public function setContentByNumber(num:Number):Void {
		setContent(dbgContents[num]);
	}//<<
	public function setContentByName(name:String):Void {
		var cont:DBGWindowContent=getContentByName(name);
		if(cont){ setContent(cont); }
	}//<<
	
	public function getContentByName(name:String):DBGWindowContent {
		for(var i=0;i<dbgContents.length;i++){
			if(DBGWindowContent(dbgContents[i]).getName()==name){
				return dbgContents[i];
			}
		}
	}//<<
	
	public function getContentNum(Void):Number {
		return MIArrayUtil.getIndexNumber(dbgContents, ui.contents.getCurrentMCAContent());
	}//<<
	
	/** @param dbgContents Array of DBGWindowContent */
	public function setupDBGContents(dbgContents:Array):Void {
		this.dbgContents=dbgContents;
		for(var i=0,dbgContent:DBGWindowContent;i<dbgContents.length;i++){
			dbgContent=dbgContents[i];
			dbgContent.setupDbgWindow(this);
		}
		setContentByNumber(0);
	}//<<
	
	public function addDBGContent(dbgContent:DBGWindowContent):Void {
		dbgContents.push(dbgContent);
		renderContentNames();
		dbgContent.setupDbgWindow(this);
	}//<<
	
	public function getCurrentContent(Void):DBGWindowContent {
		return DBGWindowContent(ui.contents.getCurrentMCAContent());
	}//<<
	
	private function renderContentNames(Void):Void {
		var names:Array=[];
		for(var i=0,dbgContent:DBGWindowContent;i<dbgContents.length;i++){
			dbgContent=dbgContents[i];
			if(dbgContent==ui.contents.getCurrentMCAContent()){
				names.push('<b>'+dbgContent.getName()+'</b>');
			}else{
				names.push(linksProvider.getLink(this, dbgContent.getName(), i));
			}
		}
		ui.drawNames(names.join(' | '));
	}//<<
	
	
//****************************************************************************
// EVENTS for DBGWindow
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case ui.contents:
				switch(ev.event){
					case ui.contents.event_NewContent:
						ui.resetWidthAndHeight();
						doNewContent();
					break;
				}
			break;
			case linksProvider:
				switch(ev.event){
					case linksProvider.event_LinkPress:
						if(ev.data.id==this){
							setContent(dbgContents[ev.data.data]);
						}
					break;
				}
			break;
		}
	}//<<Events
	
}