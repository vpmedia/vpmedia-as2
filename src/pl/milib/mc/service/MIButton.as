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

import pl.milib.mc.abstract.AbstractButton;
import pl.milib.mc.abstract.AbstractButtonView;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.service.MIButton extends AbstractButton {
	
	public var btn : Button;
	
	private function MIButton(btn:Button) {
		this.btn=btn;
		btn.onPress=MILibUtil.createDelegate(this, setPress);
		btn.onRelease=MILibUtil.createDelegate(this, setRelease);
		btn.onReleaseOutside=MILibUtil.createDelegate(this, setReleaseOutside);
		btn.onRollOut=MILibUtil.createDelegate(this, setRollOut);
		btn.onRollOver=MILibUtil.createDelegate(this, setRollOver);
		btn.onDragOut=MILibUtil.createDelegate(this, setDragOut);
		btn.onDragOver=MILibUtil.createDelegate(this, setDragOver);		btn.onSetFocus=MILibUtil.createDelegate(this, setRollOver);		btn.onKillFocus=MILibUtil.createDelegate(this, setRollOut);		btn['onUnload']=MILibUtil.createDelegate(this, onBtnUnload); //...because it can be MovieClip
		MIMC.forInstance(btn._parent).getDeleter().addDeletingSub(this);
		isEnabled=btn.enabled;
	}//<>
	
	public function getServicedObject(Void):Button {
		return btn;
	}//<<
	
	public function setIsEnabled(bool:Boolean):Void {
		bool=Boolean(bool);
		if(bool==btn.enabled){ return; }
		isEnabled=bool;
		if(!isEnabled){ doArtificialOut(); }		btn.enabled=isEnabled;
		bev(event_EnabledChanged);
	}//<<
	
	public function getIsEnabled(Void):Boolean {
		return btn.enabled;
	}//<<
	
	public function addButtonView(view:AbstractButtonView):MIButton {
		super.addButtonView(view);
		return this;
	}//<<
	
	public function setButtonView(view:AbstractButtonView):MIButton {
		super.setButtonView(view);
		return this;
	}//<<
	
	/** @param views Array of AbstractButtonView */  
	public function addButtonViews(buttonViews:Array):MIButton {
		super.addButtonViews(buttonViews);
		return this;
	}//<<
	
	/** @param views Array of AbstractButtonView */  
	public function setButtonViews(buttonViews:Array):MIButton {
		super.setButtonViews(buttonViews);
		return this;
	}//<<
	
	private function setIsOver(bool):Void {
		isOver=bool;
	}//<<
	
	private function setIsPressed(bool):Void {
		isPressed=bool;
//		mouseMinusX=btn._parent._xmouse-btn._x;
//		mouseMinusY=btn._parent._ymouse-btn._y;
		Mouse.addListener(this);
	}//<<
	
	private function doDelete(Void):Void {
		if(btn){
			var unmc:MovieClip=btn._parent.createEmptyMovieClip('buttonOverwriter', btn.getDepth());
			unmc.unloadMovie();
		}
		super.doDelete();
	}//<<
	
	static public function gotForInstance(btn:Button):Boolean {
		return MILibUtil.getObjectMILibObject(btn).serviceByMIButton!=null;
	}//<<
	
	static public function forInstance(btn:Button):MIButton {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(btn);
		if(!milibObjObj.serviceByMIButton){ milibObjObj.serviceByMIButton=new MIButton(btn); }
		return milibObjObj.serviceByMIButton;
	}//<<
	
//****************************************************************************
// EVENTS for MIButton
//****************************************************************************
	private function onBtnUnload(Void):Void {
		getDeleter().DELETE();
	}//<<
	
}