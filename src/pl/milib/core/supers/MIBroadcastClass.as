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

import pl.milib.core.Broadcastable;
import pl.milib.core.MIObjSoul;
import pl.milib.core.supers.MIClass;
import pl.milib.data.info.MIEventInfo;


/**
 * @author Marek Brun 'minim'
 */
class pl.milib.core.supers.MIBroadcastClass extends MIClass implements Broadcastable {
	
	//broadcasted when the object is deleted
	public var event_Deleted:Object={name:'Deleted'};
	
	//broadcast when the object is being deleted
	public var event_BeforeDelete:Object={name:'BeforeDelete'};
	
	private var l : Array; //of MIObjSoul
	private var disableBroadcastReleaseMethod : Function;
	
	private function MIBroadcastClass() {
		
	}//<>
	
	private function bev(event_:Object, $data):Void {
		if(disableBroadcastReleaseMethod){ return; }
		if(l.length > 0) {
			var objs:Array=l.concat();
			var ev:MIEventInfo=new MIEventInfo(this, event_, $data);
			for(var i=0;i<objs.length;i++){
				objs[i].o.onEvent(ev);
			}
		}
	}//<<
	
	private function disableBroadcast(Void):Void {
		if(disableBroadcastReleaseMethod){ return; }
		disableBroadcastReleaseMethod=arguments.caller;
	}//<<
	
	private function enableBroadcast(Void):Void { 
		if(arguments.caller!=disableBroadcastReleaseMethod){ return; }
		delete disableBroadcastReleaseMethod;
	}//<<
	
	private function ask(question_:Object) {
		if(l.length > 0){
			var objs:Array=l.concat();
			var ev:MIEventInfo=new MIEventInfo(this, question_);
			for(var i=0;i<objs.length;i++){
				objs[i].o.onEvent(ev);
				if(ev.data){ return ev.data; }
			}
		}
	}//<<
	
	public function addListener(obj):Void {
		l=[];
		delete bev;
		addListener=properAddListener;
		addListener(obj);
	}//<<
	public function properAddListener(obj):Void {
		var objSoul:Object=MIObjSoul.forInstance(obj);
		for(var i=0;i<l.length;i++){
			if(l[i]===objSoul){ return; }
		}
		l.push(objSoul);
		obj.addSubscription(this);
	}//<<
	
	public function removeListener(obj):Void {
		var l_lengthCount:Number = l.length;
		while (--l_lengthCount-(-1)) {
			if (l[l_lengthCount].o === obj) {
				l.splice(l_lengthCount, 1);
				obj.removeSubscription(this);
			}
		}
	}//<<
	
	public function cleanUp(Void):Void {
		if(l.length > 0) {
			for(var i=0;i<l.length;i++){
				if(l[i].o==null){
					l.splice(i, 1); i--;
				}
			}
		}
	}//<<
	
	private function doBeforeDelete(Void):Void {
		bev(event_BeforeDelete);
	}//<<
	
	private function doDelete(Void):Void {
		bev(event_Deleted);
		delete l;
		super.doDelete();
	}//<<
	
	private function getDBGInfo(Void):Array {
		var info:String='listeners: '+_global.pl.milib.dbg.MIDBGUtil.stringifyArrayParams(l, 'o');
		return [info].concat(super.getDBGInfo());
	}//<<
	
}