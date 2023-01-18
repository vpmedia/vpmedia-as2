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

import pl.milib.core.supers.MIClass;
import pl.milib.managers.ObjectsIdNumbersManager;
import pl.milib.util.MILibUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.managers.DelayedExecutionsManager extends MIClass {
	
	private static var instance : DelayedExecutionsManager;
	private var sessions : Array;
	
	private function DelayedExecutionsManager() {
		sessions=[];
	}//<>
	
	public function addNew_(instance:Object, method:Function):Boolean {
		var methodName:String=MILibUtil.getMethodName(instance, method);
		if(instance[methodName].owner==this || !methodName){
			//if(log.isWarningEnabled()){ warning(new MIDBGMethodInfoData(this, arguments, "instance[methodName].owner==this || !methodName", '[exestop] drugie przyznanie zrobiło by małe zamieszanie (methodName='+methodName+')')); }
			return false;
		}
		var session:Object={
			iimn:ObjectsIdNumbersManager.getInstance().getObjectIdNumber(instance),
			methodName:methodName,
			store:[]
		};
		
		instance[session.methodName]=function(){
			arguments.callee.store.push(arguments);
		};
		session.method=instance[session.methodName];
		instance[session.methodName].store=session.store;
		instance[session.methodName].owner=this;
		
		sessions.push(session);
		return true;
	}//<<
	
	public function flush_(instance:Object, method:Function):Boolean {
		var iimn=ObjectsIdNumbersManager.getInstance().getObjectIdNumber(instance);
		for(var i=0,session;session=sessions[i];i++){
			if(session.iimn==iimn && session.method==method){
				sessions.splice(i,1);
				delete instance[session.methodName];
				for(var i2=0;i2<session.store.length;i2++){
					instance[session.methodName].apply(instance, session.store[i2]);
				}
				return true;
			}
		}
		return false;
	}//<<
	
	static public function addNew(instance:Object, method:Function):Boolean {
		return getInstance().addNew_(instance, method);
	}//<<
	
	static public function flush(instance:Object, method:Function):Boolean {
		return getInstance().flush_(instance, method);
	}//<<
	
	/** @return singleton instance of DelayedExecutions */
	static public function getInstance() : DelayedExecutionsManager {
		if (instance == null){ instance = new DelayedExecutionsManager(); }
		return instance;
	}//<<
	
}