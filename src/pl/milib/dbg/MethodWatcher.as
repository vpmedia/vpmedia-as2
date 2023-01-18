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
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.core.value.MIBooleanValue;
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.dbg.InstanceDebugProvider;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.util.MILibUtil;

class pl.milib.dbg.MethodWatcher extends MIBroadcastClass implements MIValueOwner {
	
	//nastąpiło wywołanie metody
	//DATA: args:FunctionArguments
	//		returnValue
	public var event_MethodExecute:Object={name:'MethodExecute'};
	
	public var event_AreWatchedChange:Object={name:'AreWatchedChange'};
	
	public var methodName:String;
	private var method : Function;
	private var objSoul : MIObjSoul;
	public var areShowEnabled : MIBooleanValue;
	
	private function MethodWatcher(obj:Object, methodName:String){
		objSoul=MIObjSoul.forInstance(obj);
		this.methodName=methodName;
		method=obj[methodName];
		areShowEnabled=(new MIBooleanValue(false)).setOwner(this);
	}//<>
	
	public function reg(args, ret){
		InstanceDebugProvider.forInstance(objSoul.o).logger.addText(MIDBGUtil.formatMethodNameText(methodName)+MIDBGUtil.formatArgs(args)+(ret==null ? '' : '-> '+link(ret)));
		bev(event_MethodExecute, {args:args, returnValue:ret});
	}//<<
	
	public function getObject(){
		return objSoul.o;
	}//<<
	
	public function exe(Void):Void {
		getObject()[methodName]();
	}//<<
	
	static public function forInstance(obj:Object, method:Function):MethodWatcher {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		var methodName:String=MILibUtil.getMethodName(obj, method);
		if(!milibObjObj.forMethodWatcher){ milibObjObj.forMethodWatcher={}; }
		if(!milibObjObj.forMethodWatcher[methodName]){ milibObjObj.forMethodWatcher[methodName]=new MethodWatcher(obj, methodName); }
		return milibObjObj.forMethodWatcher[methodName];
	}//<<
	
	static public function isMethodWatchedEnabled(obj:Object, methodName:String){
		return Boolean(obj[methodName].detective);
	}//<<
	
//****************************************************************************
// EVENTS for MethodWatcher
//****************************************************************************
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		var obj=getObject();
		if(areShowEnabled.v){
			obj[methodName]=function(){
				var ret=arguments.callee.detective.method.apply(this, arguments);
				arguments.callee.detective.reg(arguments, ret);
				return ret;
			};
			obj[methodName].detective=this;
		}else{
			delete obj[methodName];
		}
		bev(event_AreWatchedChange);
	}//<<
	
}