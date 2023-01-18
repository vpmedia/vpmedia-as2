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

import pl.milib.core.MIDeletable;
import pl.milib.core.MIObjSoul;
import pl.milib.core.supers.MIRunningClasser;
import pl.milib.util.MILibUtil;


/**
 * @author Marek Brun 'minim'
 */
class pl.milib.core.MIDeleter {
	
	private var deletingSub : Array; //of MIClass
	private var finishWhenDelete : Array; //of MIClass
	private var owner : MIDeletable;
	private var deleteSubOf : Array; //of MIObjSoul
	
	private function MIDeleter(owner:MIDeletable) {
		this.owner=owner;
		deletingSub=[];
		finishWhenDelete=[];
		deleteSubOf=[];
	}//<>
	
	public function DELETE(Void):Void {
		DELETE=null;
		owner['doBeforeDelete']();
		while(finishWhenDelete.length){
			MIRunningClasser(finishWhenDelete.pop()).finish();
		}
		while(deletingSub.length){
			MIDeletable(deletingSub.pop()).getDeleter().DELETE();
		}
		owner['doDelete']();
		MIObjSoul.forInstance(owner).deleteObject();
		MILibUtil.delObjectMILibObject(this);		delete finishWhenDelete;		delete deletingSub;
		delete owner;
	}//<<
	
	public function addDeletingSub(obj:MIDeletable):Void {
		for(var i=0;i<deletingSub.length;i++){
			if(deletingSub[i]===obj){ return; }
		}
		obj.getDeleter().addDeleteSubOf(owner);
		deletingSub.push(obj);
	}//<<
	
	public function addDeleteSubOf(obj:MIDeletable):Void {
		deleteSubOf.push(MIObjSoul.forInstance(obj));
	}//<<
	
	public function addDeletingsSub(objs:Array):Void {
		for(var i=0;i<objs.length;i++){
			addDeletingSub(objs[i]);
		}
	}//<<
	
	public function addFinishWhenDelete(runn:MIRunningClasser):Void {
		for(var i=0;i<finishWhenDelete.length;i++){
			if(finishWhenDelete[i]===runn){ return; }
		}
		finishWhenDelete.push(runn);
	}//<<
	
	public function getDeleteSubs(Void):Array {
		return deletingSub.concat();
	}//<<
	
	static public function forInstance(obj:MIDeletable):MIDeleter {
		var milibObjObj:Object=MILibUtil.getObjectMILibObject(obj);
		if(!milibObjObj.forMIDeleter.o){ milibObjObj.forMIDeleter=MIObjSoul.forInstance(new MIDeleter(obj)); }
		return milibObjObj.forMIDeleter.o;
	}//<<
	//static public function hasInstance(obj:MIDeletable):Boolean { return MILibUtil.getObjectMILibObject(obj).forMIDeleter.o!=null; }//<<
	
}