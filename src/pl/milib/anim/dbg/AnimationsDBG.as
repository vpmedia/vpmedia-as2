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

import pl.milib.anim.dbg.DBGWindowMIEaseContent;
import pl.milib.anim.static_.Animation;
import pl.milib.anim.static_.MIEase;
import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIClass;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.TextModel;
import pl.milib.data.TextWithTabs;
import pl.milib.dbg.MIDBG;
import pl.milib.dbg.window.contents.DBGWindowTextContent;
import pl.milib.dbg.window.DBGWindow;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.dbg.AnimationsDBG extends MIClass {
	
	private static var instance : AnimationsDBG;
	private var easesListLog : TextModel;
	private var animsListLog : TextModel;
	private var eases : MIObjects;//of MIEase
	private var anims : MIObjects;//of Animation
	
	public function AnimationsDBG() {
		easesListLog=new TextModel(true, 200);		animsListLog=new TextModel(true, 200);
		eases=new MIObjects();
		eases.addListener(this);		anims=new MIObjects();
		if(MIDBG.getInstance().isUILoaded()){ setupDBGWindow(); }
		else{ MIDBG.getInstance().addListener(this); }
	}//<>
	
	private function setupDBGWindow(Void):Void {
		var win:DBGWindow=MIDBG.getInstance().dbgMainWindow;
		var dbgContEases:DBGWindowTextContent=new DBGWindowTextContent(easesListLog);
		var dbgContAnims:DBGWindowTextContent=new DBGWindowTextContent(animsListLog);
		dbgContEases.name='eases';
		dbgContAnims.name='animations';
		win.addDBGContent(dbgContEases);
		win.addDBGContent(dbgContAnims);
	}//<<
	
	public function regEase(ease:MIEase):Void {
		eases.addObject(ease);
		var easesArr:Array=eases.getArray();
		var t:Array=[];
		for(var i=0;i<easesArr.length;i++){
			ease=easesArr[i];
			t.push(link(ease)+' name:'+ease.name);
		}
		easesListLog.setText(t.join('\n'));
	}//<<
	
	public function regAnim(anim:Animation):Void {
		anims.addObject(anim);
		var animsArr:Array=anims.getArray();
		var t:Array=[];
		for(var i=0;i<animsArr.length;i++){
			anim=animsArr[i];
			t.push(link(anim)+' first obj:'+link(anim.getFirstObj()));
		}
		animsListLog.setText(t.join('\n'));
	}//<<
	
	/** @return singleton instance of AnimationsDBG */
	static public function getInstance(Void):AnimationsDBG {
		if(instance==null){ instance=new AnimationsDBG(); }
		return instance;
	}//<<
	
	static public function start(Void):Void {
		DBGWindowMIEaseContent({});
		getInstance();
	}//<<
	
	private function pasteEasesDataToClippboard(Void):Void {
//
//	static public var ease_ball : MIEase;
//	
//	private function setupEases() {
//		ease_ball=(new MIEase('ball')).setupEaseElastic(14.9936075597554, 2.27487493051695, 0.6100611450806, 1.73346303501946);
//	}//<>
//
		var classStr:TextWithTabs=new TextWithTabs();
		classStr.plusTab();		var easesArr:Array=eases.getArray();
		for(var i=0,ease:MIEase;i<easesArr.length;i++){
			ease=easesArr[i];
			classStr.addLine('static public var ease_'+ease.name+' : MIEase;');
		}
		classStr.addLine('');
		classStr.addLineAndPlus('private function setupEases() {');
		for(var i=0,ease:MIEase;i<easesArr.length;i++){
			ease=easesArr[i];
			classStr.addLine("ease_"+ease.name+"=(new MIEase('"+ease.name+"')).setupEase"+ease.getEaseName()+"("+ease.getEaseProps().join(', ')+");");
		}
		classStr.minusAndAddLine('}//<<');
		MIDBG.getInstance().pasteToClippoard('AnimationsDBG', classStr.toString());
	}//<<
	
//****************************************************************************
// EVENTS for AnimationsDBG
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case MIDBG.getInstance():
				switch(ev.event){
					case MIDBG.getInstance().event_UILoaded:
						setupDBGWindow();
					break;
				}
			break;
			case eases:
				var hero:MIEase=MIEase(ev.data.hero);
				switch(ev.data.event){
					case hero.event_Changed:
						pasteEasesDataToClippboard();
					break;
				}
			break;
		}
	}//<<Events
	
}