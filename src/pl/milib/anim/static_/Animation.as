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

import pl.milib.anim.static_.AnimationDistance;
import pl.milib.anim.static_.AnimationElement;
import pl.milib.anim.static_.MIEase;
import pl.milib.anim.static_.ObjectAnimations;
import pl.milib.core.supers.MIWorkingClass;

/**
 * @often_name anim
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.anim.static_.Animation extends MIWorkingClass {

	private var elements : Array;
	public var name : String;
	private var animTimeUnit : AnimationDistance; 
	
	public function Animation($name:String){
		elements=[];
		if($name){
			this.name=$name;			_global.pl.milib.anim.dbg.AnimationsDBG.getInstance().regAnim(this);
		}
	}//<>
	
	public function setupEaseForAll(ease:MIEase):Void {
		for(var i=0,ele:AnimationElement;i<elements.length;i++){
			ele=elements[i];
			ele.ease=ease;
		}
	}//<<
	
	public function addElement(obj:Object, param:String, target:Number, ease:MIEase):AnimationElement {
		return addElementByInstance(new AnimationElement(obj, param, target, ease));
	}//<<
	public function addElementByInstance(aei:AnimationElement):AnimationElement {
		ObjectAnimations.forInstance(aei.obj).regAnimation(this);
		elements.push(aei);
		return aei;
	}//<<
	
	public function getElements(Void):Array {
		return elements.concat();
	}//<<
	
	public function setupDistanceUnit(animTimeUnit:AnimationDistance):Void {
		this.animTimeUnit=animTimeUnit;
	}//<<
	public function setupDistanceUnitByElement(aei:AnimationElement):Void {
		animTimeUnit=new AnimationDistance(aei);
	}//<<
	
	public function getWorkingTime(Void):Number {
		if(animTimeUnit){
			return animTimeUnit.getTime(super.getWorkingTime());
		}else{
			return super.getWorkingTime();
		}
	}//<<
	
	public function addElementsFromAnimation(anim:Animation, $isTargetsAsCurrents:Boolean):Void {
		var eles:Array=anim.getElements();
		for(var i=0;i<eles.length;i++){
			if($isTargetsAsCurrents){
				addElementByInstance(AnimationElement(eles[i]).cloneByTargetAsCurrent());
			}else{
				addElementByInstance(AnimationElement(eles[i]).clone());
			}
		}
	}//<<
	
	public function addElementsFromAnimations(anims:Array, $isTargetsAsCurrents:Boolean):Void {
		for(var i=0;i<anims.length;i++){
			addElementsFromAnimation(anims[i], $isTargetsAsCurrents);
		}
	}//<<
	
	private function doStart(Void):Boolean {
		for(var i=0,aei:AnimationElement;aei=elements[i];i++){ aei.restart(); }
		return super.doStart();
	}//<<
	
	private function doWork(Void):Void {
		var progress:Number=getProgress();
		for(var i=0,aei:AnimationElement;aei=elements[i];i++){
			aei.applyN01(progress);
		}
	}//<<
	
	private function doFinish(Void):Boolean {
		for(var i=0,aei:AnimationElement;aei=elements[i];i++){
			ObjectAnimations.forInstance(aei.obj).unregRunningAnimationElement(aei);
			aei.applyTargetParam();
		}
		super.doFinish();
		return true;
	}//<<
	
	public function cloneByTargetsAsCurrents($isMirrorEase:Boolean, $name:String):Animation {
		var anim:Animation=new Animation($name);
		if(workingTimeDV){ anim.setupWorkingTimeAsDynamicValue(workingTimeDV); }
		else if(workingTime){ anim.setupWorkingTime(workingTime); }
		for(var i=0,aei:AnimationElement;aei=elements[i];i++){
			anim.addElementByInstance(aei.cloneByTargetAsCurrent($isMirrorEase));
		} 
		return anim;
	}//<<
	
	public function cloneByNewObject(newObject:Object, $name:String):Animation {
		var anim:Animation=new Animation($name);
		if(workingTimeDV){ anim.setupWorkingTimeAsDynamicValue(workingTimeDV); }
		else if(workingTime){ anim.setupWorkingTime(workingTime); }
		for(var i=0,aei:AnimationElement;aei=elements[i];i++){
			anim.addElementByInstance(aei.cloneByNewObject(newObject));
		} 
		return anim;
	}//<<
	
	public function clonesByNewObjects(newObjects:Array, $prefixName:String):Array {
		var anims:Array=[];
		var namePrefix:String=$prefixName==null ? '' : $prefixName;
		if(name){ namePrefix=name+namePrefix; }
		for(var i=0,newObject:Object;i<newObjects.length;i++){
			newObject=newObjects[i];
			anims.push(cloneByNewObject(newObject, namePrefix+i));
		}
		return anims;
	}//<<
	
	private function getDBGInfo(Void):Array {
		var infoText:Array=[];
		infoText.push('Animation elements: (object, variable name, ease)');
		for(var i=0,element:AnimationElement;i<elements.length;i++){
			element=elements[i];
			infoText.push('	'+link(element.obj)+', '+element.param+', '+link(element.ease));
		}
		
		return [infoText.join('\n')+'\n'].concat(super.getDBGInfo());;
	}//<<
	
	public function getFirstObj(Void):Object {
		return elements[0].obj;
	}//<<
	
	public function setNewTargetByParam(param:String, target:Number):Void {
		for(var i=0,animationsElement:AnimationElement;i<elements.length;i++){
			animationsElement=elements[i];
			if(animationsElement.param==param){
				animationsElement.target=target;
			}
		}
	}//<<
	
}