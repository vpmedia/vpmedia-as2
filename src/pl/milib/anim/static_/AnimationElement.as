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

import pl.milib.anim.static_.MIEase;
import pl.milib.anim.static_.ObjectAnimations;

/**
 * @often_name aei
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.static_.AnimationElement {
	
	public var obj : Object;
	public var param : String;
	public var target : Number;
	public var ease : MIEase;
	public var isMirrorEase : Boolean;
	private var init : Number;
	private var dist : Number;
	public var isBlocked : Boolean;
	
	public function AnimationElement(obj:Object, param:String, target:Number, ease:MIEase) {
		this.obj=obj;
		this.param=param;
		this.target=target;
		this.ease=ease;
		ObjectAnimations.forInstance(obj).regAnimationElement(this);
	}//<>
	
	public function restart(Void):Void {
		init=obj[param];		dist=target-init;
		isBlocked=false;
		ObjectAnimations.forInstance(obj).regRunningAnimationElement(this);
	}//<<
	
	public function applyN01(n01:Number):Void {
		if(isBlocked){ return; }
		if(isMirrorEase){
			obj[param]=init+dist*ease.ease01WithMirrorEase(n01);
		}else{
			obj[param]=init+dist*ease.ease01(n01);
		}
	}//<<
	
	public function applyTargetParam(Void):Void {
		if(isBlocked){ return; }
		obj[param]=target;
	}//<<
	
	public function clone(Void):AnimationElement {
		var ae:AnimationElement=new AnimationElement(obj, param, target, ease);
		return ae;
	}//<<
	
	public function cloneByTargetAsCurrent($isMirrorEase:Boolean):AnimationElement {
		var ae:AnimationElement=new AnimationElement(obj, param, obj[param], ease);
		ae.isMirrorEase=Boolean($isMirrorEase);
		return ae;
	}//<<
	
	public function cloneByNewObject(newObject:Object):AnimationElement {
		var ae:AnimationElement=new AnimationElement(newObject, param, target, ease);
		return ae;
	}//<<
	
}