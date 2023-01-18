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
import pl.milib.data.CurrentAndTargetValue;
import pl.milib.data.info.MIEventInfo;
import pl.milib.mc.abstract.AbstractContentMCA;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MILibUtil;

/**
 * var name: mcaContents*
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.ContentsMCA extends MIBroadcastClass {

	//broadcasted when new content is setted
	public var event_NewContent:Object={name:'NewContent'};
	
	private var mimc : MIMC;	private var mcaContent : AbstractContentMCA;
	private var mcaContentToOpen : AbstractContentMCA;
	private var valueContent : CurrentAndTargetValue;//start closing current >>> start target
	private var isDeleteOldClasses : Boolean;
	private var isOpenDBGWindows : Boolean;
	private var count : Number; 
	
	public function ContentsMCA(mc:MovieClip, isDeleteOldClasses:Boolean, isOpenDBGWindows:Boolean) {
		mimc=MIMC.forInstance(mc);
		mimc.gotoLastFrame();
		this.isDeleteOldClasses=Boolean(isDeleteOldClasses);		this.isOpenDBGWindows=Boolean(isOpenDBGWindows);
		valueContent=new CurrentAndTargetValue();
		valueContent.addListener(this);
		valueContent.currentValue.isValueEventsReflect=true;
		valueContent.currentValue.addListener(this);
		valueContent.targetValue.addListener(this);
		count=0;
	}//<>
	
	public function open(newMCAContent:AbstractContentMCA):Void {
		if(!newMCAContent.ID.length){ logError_UnexpectedSituation(arguments, '<b>!newMCAContent.ID.length</b>| return;'); return; }
		if(MILibUtil.getConstructor(newMCAContent)==MILibUtil.getConstructor(mcaContent)){ return; }
		valueContent.setTargetValue(newMCAContent);
	}//<<
	
	public function getCurrentMCAContent(Void):AbstractContentMCA {
		return AbstractContentMCA(valueContent.currentValue.v);
	}//<<
	
	public function getTargetMCAContent(Void):AbstractContentMCA {
		return AbstractContentMCA(valueContent.targetValue.v);
	}//<<
	
//****************************************************************************
// EVENTS for ContentsMCA
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case valueContent:
				switch(ev.event){
					case valueContent.question_PermissionToStart:
						if(getCurrentMCAContent().getIsRunning()){
							ev.data=valueContent.answer_PermissionToStart_Deny;
							getCurrentMCAContent().finish();
						}
					break;
					case valueContent.event_RunningStart:
						valueContent.setTargetAsCurrent();
					break;
					case valueContent.event_BeforeTargetValueIsChangedToCurrent:
//						getCurrentMCAContent().mimc.mc.unloadMovie();
						if(isDeleteOldClasses){
							getCurrentMCAContent().getDeleter().DELETE();
						}
						
						
						//SETUP MC FOR TARET
						count++;
						//MIMCUtil.getFrameNumber()
//						var conMC:MovieClip=mimc.gotoAndGetFirstMC(getTargetMCAContent().ID).duplicateMovieClip(getTargetMCAContent().ID+'dopy'+count, mimc.mc.getNextHighestDepth()+count);
//						mimc.gotoLastFrame();
						getTargetMCAContent().setupMC(mimc.gotoAndGetFirstMC(getTargetMCAContent().ID));
						
						//^^^^^
						
					break;
					case valueContent.event_TargetValueIsChangedToCurrent:
						getCurrentMCAContent().start();
						if(isOpenDBGWindows){
							_global.pl.milib.dbg.MIDBG.getInstance().openObjectWindow(getCurrentMCAContent());
						}
						bev(event_NewContent);
					break;
				}
			break;
			case valueContent.currentValue:
				switch(ev.event){
					case valueContent.currentValue.event_ValueEvent:
						switch(ev.data.event){
							case getCurrentMCAContent().event_RunningFinish:
								valueContent.start();
							break;
						}
					break;
				}
			break;
		}
	}//<<Events
	
}