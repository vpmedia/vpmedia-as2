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

import pl.milib.anim.static_.Animation;
import pl.milib.anim.static_.AnimationElement;
import pl.milib.core.MIObjSoul;
import pl.milib.util.MIArrayUtil;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.static_.ObjectAnimations {

	private var obj : Object;
	private var animationsElementsRunning : Object;
	private var animationsElements : Array;
	
	private function ObjectAnimations(obj:Object) {
		this.obj=obj;
		animationsElementsRunning={};		animationsElements=[];
	}//<>
	
	public function setNewTargetByParam(param:String, target:Number):Void {
		for(var i=0,animationsElement:AnimationElement;i<animationsElements.length;i++){
			animationsElement=animationsElements[i];
			if(animationsElement.param==param){
				animationsElement.target=target;
			}
		}
	}//<<
	
	public function regAnimationElement(ae:AnimationElement):Void {
		animationsElements.push(ae);
	}//<<
	
	public function regRunningAnimationElement(ae:AnimationElement):Void {
		if(animationsElementsRunning[ae.param]){
			AnimationElement(animationsElementsRunning[ae.param]).isBlocked=true;
		}
		animationsElementsRunning[ae.param]=ae;
		ae.isBlocked=false;
	}//<<
	
	public function unregRunningAnimationElement(ae:AnimationElement):Void {
		for(var i in animationsElementsRunning){
			if(i==ae.param){
				delete animationsElementsRunning[ae.param];
			}
		}
	}//<<
	
	public function regAnimation(anim:Animation):Void {
		var milibObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObj.animations){ milibObj.animations=[]; }
		MIArrayUtil.addUnique(milibObj.animations, anim);
	}//<<
	
	static public function forInstance(obj:Object):ObjectAnimations {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forObjectAnimations.o){ milibObjObj.forObjectAnimations=MIObjSoul.forInstance(new ObjectAnimations(obj)); }
		return milibObjObj.forObjectAnimations.o;
	}//<<
	
//	static public function hasInstance(obj:Object):Boolean {
//		return MILibUtil.getObjectMILibObject(obj).forObjectAnimations.o!=null;
//	}//<<
	
}