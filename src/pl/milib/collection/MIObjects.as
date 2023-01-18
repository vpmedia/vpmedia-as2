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

import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.data.Couples;
import pl.milib.data.info.MIEventInfo;


/**
 * @often_name *Objects
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.collection.MIObjects extends Couples {
	
	public var event_Changed:Object={name:'Changed'};
	
	//DATA:	MIEventInfo
	public var event_EventReflection:Object={name:'EventReflection'};
	
	public function MIObjects(Void) {
		
	}//<>
	
	public function addObject(obj:MIBroadcastClass, $objID):Void {
		disableBroadcast();
		
		obj.addListener(this);
		super.addPair(obj, $objID);
		
		enableBroadcast();
		bev(event_Changed);
	}//<<
	
	public function removeObject(obj:MIBroadcastClass):Void {
		disableBroadcast();
		
		obj.removeListener(this);
		super.remove(obj);
		
		enableBroadcast();
		bev(event_Changed);
	}//<<
	
	public function setObjects(objs:Array):Void {
		disableBroadcast();
		
		clear();
		addObjects(objs);
		
		enableBroadcast();
		bev(event_Changed);
	}//<<
	public function addObjects(objs:Array):Void {
		disableBroadcast();
		
		for(var i=0;i<objs.length;i++){
			objs[i].addListener(this);
			super.addPair(objs[i], i);
		}
		
		enableBroadcast();
		bev(event_Changed);
	}//<<
	
	public function setPairsObjects(objs:Array):Void {
		disableBroadcast();
		
		clear();
		for(var i=0;i<objs.length;i++){
			objs[i][0].addListener(this);
			super.addPair(objs[i][0], objs[i][1]);
		}
		
		enableBroadcast();
		bev(event_Changed);
	}//<<
	
	public function clear(Void):Void {
		disableBroadcast();
		
		super.clear();
		
		enableBroadcast();
		bev(event_Changed);
	}//<<
	
	private function doDelete(Void):Void {
		clear();
	}//<<
	
	public function exe(methodName:String, args:Array):Void {
		var arr:Array=getArray();
		for(var i=0;i<arr.length;i++){ arr[i][methodName].apply(arr[i], args); }
	}//<<
	
	public function gotValueAtIndex(indexNumber:Object):Boolean {
		return Boolean(arr[indexNumber][0]);
	}//<<
	
//****************************************************************************
// EVENTS for MIObjects
//****************************************************************************
	private function onEvent(ev:MIEventInfo):Void {
		if(ev.event==MIBroadcastClass(ev.hero).event_Deleted){
			removeObject(MIBroadcastClass(ev.hero));
		}
		bev(event_EventReflection, ev);
	}//<<Events

}