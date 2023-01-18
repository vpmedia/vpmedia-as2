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
import pl.milib.data.info.ScrollInfo;
import pl.milib.data.TextModel;
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.managers.EnterFrameRenderManager;
import pl.milib.managers.MouseManager;
import pl.milib.mc.MIScrollable;
import pl.milib.util.MILibUtil;

/**
 * @often_name mitf
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.service.MITextField extends MIScrollable implements EnterFrameReciver {
	
	//invoked when the content of a text field changes
	public var event_UserChanged:Object={name:'UserChanged'};
	
	//invoked when a button loses keyboard focus
	//DATA: newFocus:Object
	public var event_KillFocus:Object={name:'KillFocus'};
	
	//invoked when a button receives keyboard focus
	//DATA: oldFocus:Object
	public var event_SetFocus:Object={name:'SetFocus'};
	
	public var enterframe_ReCheckScroll : Object={name:'ReCheckScroll'};
	
	public var tf:TextField;
	private var lastBroadcastedScroll : Number;
	private var lastBroadcastedMaxscroll : Number;
	private var numberOfLinesHeight : Number;
	private var numberOfLines : Number;
	private var model : TextModel;
	private var gotFocus : Boolean;
	
	private function MITextField(tf:TextField){
		this.tf=tf;
		tf.onChanged=MILibUtil.createDelegate(this, onTFChanged);
		tf.onKillFocus=MILibUtil.createDelegate(this, onTFKillFocus);//(newFocus)
		tf.onScroller=MILibUtil.createDelegate(this, onTFScroller);
		tf.onSetFocus=MILibUtil.createDelegate(this, onTFSetFocus);//(oldFocus)
		EnterFrameRenderManager.getInstance().addRenderMethod(this, renderModel);
		gotFocus=false;
	}//<>
	
	public function setScrollN01(n01:Number):Void {
		tf.scroll=Math.round(1+(tf.maxscroll-1)*n01);
	}//<<
	
	public function set text(newText:String):Void {
		if(newText==null){ newText=''; }
		tf.text=newText;
	}//<<
	
	public function get text(Void):String {
		return tf.text;
	}//<<
	
	public function getNumberOfLines(Void):Number {
		if(numberOfLinesHeight!=tf._height || numberOfLinesHeight==null){
			numberOfLinesHeight=tf._height;
			var orgHTML=tf.htmlText;
			var safeCount:Number=100;
			while(tf.maxscroll==1 && safeCount>0){
				tf.text+='\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n';
				safeCount--;
			}
			numberOfLines=tf.bottomScroll-tf.scroll+1;			tf.htmlText=orgHTML;
		}		return numberOfLines;
	}//<<
	
	public function getScrollData():ScrollInfo {
		var visible=getNumberOfLines();
		var total=tf.maxscroll+visible-1;
		var scroll01=(tf.scroll-1)/(tf.maxscroll-1);
		return (new ScrollInfo(total, visible, scroll01, 1, 1));
	}//<<
	
	private function broNewScrollData(){
		lastBroadcastedScroll=tf.scroll;		lastBroadcastedMaxscroll=tf.maxscroll;
		bev(event_NewScrollData);
	}//<<
	
	public function setScrollByOneUnit(turn:Number):Void {
		tf.scroll=tf.scroll+turn;
	}//<<
	
	static public function forInstance(tf:TextField):MITextField {
		if(!tf){
			_global.pl.milib.dbg.MIDBGUtil.logStaticMethodBadArgs(arguments, 0, ['tf:TextField']);
			return null;
		}
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(tf);
		if(!milibObjObj.serviceByMITextField){ milibObjObj.serviceByMITextField=new MITextField(tf); }
		return milibObjObj.serviceByMITextField;
	}//<<<
	
	public function setupModel(model:TextModel):Void {
		this.model.removeListener(this);
		this.model=model;
		this.model.addListener(this);
		renderModel();
	}//<<
	
	private function renderModel(Void):Void {
		if(model.getIsHtml()){
			tf.htmlText=model.getText();
		}else{
			tf.text=model.getText();
		}
		if(!MouseManager.getInstance().isDown){
			tf.scroll=tf.maxscroll;
		}
	}//<<
	
	public function getGotFocus(Void):Boolean {
		return gotFocus;
	}//<<
	
//****************************************************************************
// EVENTS for MITextField
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case model:
				switch(ev.event){
					case model.event_Changed:
						renderModel();
					break;
				}
			break;
		}
	}//<<Events
	
	private function onTFChanged(Void):Void {
		bev(event_UserChanged);
	}//<<
	
	private function onTFScroller(Void):Void {
		broNewScrollData();
		EnterFrameBroadcaster.start(this, enterframe_ReCheckScroll);
	}//<<
	
	private function onTFKillFocus(Void):Void {
		gotFocus=false;
		bev(event_KillFocus, arguments[0]);
	}//<<
	
	private function onTFSetFocus(Void):Void {
		gotFocus=true;
		bev(event_SetFocus, arguments[0]);
	}//<<
	
	public function onEnterFrame(id):Void {
		switch(id){
			case enterframe_ReCheckScroll:
				if(lastBroadcastedScroll!=tf.scroll || lastBroadcastedMaxscroll!=tf.maxscroll){
					broNewScrollData();
				}else{
					EnterFrameBroadcaster.stop(this, enterframe_ReCheckScroll);
				}
			break;
		}
	}//<<
	
}