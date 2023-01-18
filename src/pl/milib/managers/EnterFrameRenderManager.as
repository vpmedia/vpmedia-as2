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
import pl.milib.managers.EnterFrameBroadcaster;
import pl.milib.managers.EnterFrameReciver;
import pl.milib.util.MILibUtil;

/** @author Marek Brun 'minim' */
class pl.milib.managers.EnterFrameRenderManager extends MIClass implements EnterFrameReciver {
	
	private static var instance : EnterFrameRenderManager;
	private var mc : MovieClip;
	private var rendersChanged : Array;
	
	private function EnterFrameRenderManager() {
		EnterFrameBroadcaster.start(this);
		mc.addListener(this);		rendersChanged=[];
	}//<>
	
	public function addRenderMethod(render:Object, renderMethod:Function, $isOneTime:Boolean):Void{
		var renderMethodName:String=MILibUtil.getMethodName(render, renderMethod);
		if(render['isRender'+renderMethodName]){ return; }
		var renderObj={
			renderSoul:MIObjSoul.forInstance(render),
			renderMethod:renderMethod,
			isChan:false,
			isOneTime:Boolean($isOneTime)
		};
		
		render[renderMethodName]=function(){
			arguments.callee.efRender.setRenderChangedMethod(arguments.callee.renderObj);
		};//<
		render[renderMethodName].efRender=this;
		render[renderMethodName].renderObj=renderObj;
		render['isRender'+renderMethodName]=true;
	}//<<
	
	public function removeRenderMethod(render:Object, renderMethod:Function):Void{
		var renderMethodName:String=MILibUtil.getMethodName(render, renderMethod);
		if(render['isRender'+renderMethodName]){
			delete render[renderMethodName];
			render['isRender'+renderMethodName]=false;
		}
	}//<<
	
	public function setRenderChangedMethod(renderObj):Void{
		if(!renderObj.isChan){
			rendersChanged.push(renderObj);
			renderObj.isChan=true;
		}
	}//<<
	
	/** @return singleton instance of EnterFrameRenderManager */
	static public function getInstance(Void):EnterFrameRenderManager {
		if(instance==null){ instance=new EnterFrameRenderManager(); }
		return instance;
	}//<<
	
//****************************************************************************
// EVENTS for EnterFrameRenderManager
//****************************************************************************
	public function onEnterFrame(id):Void {
		for(var i=0,renderObj:Object;renderObj=rendersChanged[i];i++){
			renderObj.renderMethod.apply(renderObj.renderSoul.o);
			renderObj.isChan=false;
			if(renderObj.isOneTime){
				removeRenderMethod(renderObj.renderSoul.o, renderObj.renderMethod);
			}
		}
		rendersChanged=[];
	}//<<

}