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

import pl.milib.core.MIObjSoul;
import pl.milib.core.supers.MIClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.TextModel;
import pl.milib.dbg.DebuggableInstance;
import pl.milib.dbg.InstanceDebugProvider;
import pl.milib.dbg.MIDBG;
import pl.milib.dbg.window.contents.DBGWindowObjectContent;
import pl.milib.dbg.window.contents.DBGWindowVariablesContent;
import pl.milib.dbg.window.DBGWindow;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.window.DBGClassWindow extends DBGWindow {

	private var obj : DebuggableInstance;
	private var logger : TextModel;
	
	public function DBGClassWindow(mc:MovieClip, obj:MIClass) {
		super(mc);
		this.obj=obj;
		var contents:Array=[
			DBGWindowVariablesContent.forInstance(obj)
		];
		contents=contents.concat(obj.getDebugContents());
		
		var title:String='<b>'+MILibUtil.getClassNameByInstance(obj)+'</b>';
		if(obj['name'].length){ title+=' "'+obj['name']+'"'; }
		ui.drawTitle('<b>'+title+'</b>');
		ui.setXY(
			ui.mimc.mc._parent._xmouse-ui.getWidth()/2,
			ui.mimc.mc._parent._ymouse-ui.getHeight()/2
		);
		addDeleteWith(obj);
		
		logger=InstanceDebugProvider.forInstance(obj).logger;
		logger.addListener(this);
		
		setTitleExtra();
		
		setupDBGContents(contents);
	}//<>
	
	public function setCookie(cookieObj:Object):Void {
		InstanceDebugProvider.forInstance(obj).setCookie(cookieObj);
		super.setCookie(cookieObj);
	}//<<
	
	public function getCurrentContent(Void):DBGWindowObjectContent  {
		return DBGWindowObjectContent(super.getCurrentContent());
	}//<<
	
	public function getObj(Void):DebuggableInstance {
		return obj;
	}//<<
	
	private function setTitleExtra(Void):Void {
		ui.drawTitleExtra(logger.getLastLineText().split('\n').join('<b>|</b>'));
	}//<<
	
	static public function forInstance(obj:Object):DBGClassWindow {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forDBGClassWindow.o){ milibObjObj.forDBGClassWindow=MIObjSoul.forInstance(MIDBG.getInstance().getNewDBGClassWindow(obj)); }
		return milibObjObj.forDBGClassWindow.o;
	}//<<
	
	static public function hasInstance(obj:Object):Boolean {
		return MILibUtil.getObjectMILibObject(obj).forDBGClassWindow.o!=null;
	}//<<
	
//****************************************************************************
// EVENTS for DBGClassWindow
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		super.onEvent(ev);
		switch(ev.hero){
			case logger:
				switch(ev.event){
					case logger.event_Changed:
						setTitleExtra();
					break;
				}
			break;
		}
	}//<<Events
	
}