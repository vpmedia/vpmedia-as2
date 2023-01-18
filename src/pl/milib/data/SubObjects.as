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

import pl.milib.data.Couples;
import pl.milib.data.SubObjectsOwner;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.data.SubObjects extends Couples {

	private var owner : SubObjectsOwner;
	private var isSubsSubscribingMainEvents : Boolean;
	
	public function SubObjects(mainObject:SubObjectsOwner, $isSubsSubscribingMainEvents:Boolean) {
		owner=mainObject;
		isSubsSubscribingMainEvents=$isSubsSubscribingMainEvents==null ? false : $isSubsSubscribingMainEvents;
	}//<>
	
	public function setupIsSubsSubscribingMainEvents(isSubsSubscribingMainEvents:Boolean):Void {
		if(this.isSubsSubscribingMainEvents==isSubsSubscribingMainEvents){ return; }
		this.isSubsSubscribingMainEvents=isSubsSubscribingMainEvents;
		var subs:Array=getArray();
		for(var i=0,sub;i<subs.length;i++){
			sub=subs[i];
			if(isSubsSubscribingMainEvents){
				owner.addListener(sub);
			}else{
				owner.removeListener(sub);
			}
		}
	}//<<
	
	public function addSubObject(sub):Void {
		addPair(sub);
		if(isSubsSubscribingMainEvents){
			owner.addListener(sub);
		}
		owner.onSlave_SubObjects_AddSubObject(this, sub);
	}//<<
	
	public function setSubObject(sub):Void {
		clear();
		addSubObject(sub);
	}//<<
	
	public function addSubObjects(subObjects:Array):Void {
		for(var i=0,sub;i<subObjects.length;i++){
			addSubObject(subObjects[i]);
		}
	}//<<
	
	public function setSubObjects(subObjects:Array):Void {
		clear();
		for(var i=0,sub;i<subObjects.length;i++){
			addSubObject(subObjects[i]);
		}
	}//<<
	
	public function clear(Void):Void {
		var subs:Array=getArray();
		for(var i=0,sub;i<subs.length;i++){
			owner.removeListener(subs[i]);
		}
		super.clear();
	}//<<
	
}