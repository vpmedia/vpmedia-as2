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
import pl.milib.mc.MCDuplicatorOwner;
import pl.milib.mc.service.MIMC;
import pl.milib.util.MIArrayUtil;

/**
 * @often_name *Duplicator
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.mc.MCDuplicator extends MIBroadcastClass {
	
	//DATA: num:Number
	//		mc:MovieClip
	//		isEnabled:Boolean
	public var event_MCIsEnabledChange:Object={name:'MCIsEnabledChange'};
	
	//DATA: num:Number
	//		mc:MovieClip
	public var event_NewMC:Object={name:'NewMC'};
	
	private var duplicatedMCS : Array; //of MovieClip
	private var ele0 : MovieClip;
	private var elementsName : String;
	private var enabledMCS : Number;
	private var owner : MCDuplicatorOwner;
	private var duplicatedMCS2 : Array;
	
	/** @param elements Array of MovieClip */
	public function MCDuplicator(owner:MCDuplicatorOwner, elements:Array) {
		this.owner=owner;
		duplicatedMCS=[];
		duplicatedMCS2=elements;
		for(var i=0,eleMC:MovieClip;eleMC=elements[i];i++){
			eleMC.gotoAndStop(eleMC._totalframes);
		}
		ele0=elements[0];
		elementsName=ele0._name.substr(0, -1);
		enabledMCS=0;
		
		addDeleteWith(MIMC.forInstance(ele0));
	}//<>
	
	public function duplicateToNum(num:Number):Void {
		for(var i=duplicatedMCS.length,eleMC:MovieClip;i<num;i++){
			if(!ele0._parent[elementsName+i]){
				ele0.duplicateMovieClip(elementsName+i, ele0._parent.getNextHighestDepth());
			}
			eleMC=ele0._parent[elementsName+i];
			duplicatedMCS2[i]=eleMC;
			duplicatedMCS.push(eleMC);
			eleMC.gotoAndStop(1);
			owner.onSlave_MCDuplicator_NewMC(this, i, eleMC);
			bev(event_NewMC, {mc:eleMC, num:i});
		}
		
		for(var i=enabledMCS,eleMC:MovieClip;i<num;i++){
			eleMC=duplicatedMCS[i];
			if(owner){
				owner.onSlave_MCDuplicator_MCIsEnabledChange(this, i, eleMC, true);
			}else{
				eleMC.gotoAndStop(1);
			}
			bev(event_MCIsEnabledChange, {mc:eleMC, num:i, isEnabled:true});
		}
		
		for(var i=num,eleMC:MovieClip;i<enabledMCS;i++){
			eleMC=duplicatedMCS[i];
			if(owner){
				owner.onSlave_MCDuplicator_MCIsEnabledChange(this, i, eleMC, false);
			}else{
				eleMC.gotoAndStop(eleMC._totalframes);
			}
			bev(event_MCIsEnabledChange, {mc:eleMC, num:i, isEnabled:false});
		}
		
		enabledMCS=num;
	}//<<
	
	public function getMC(num:Number):MovieClip {
		return duplicatedMCS2[num];
	}//<<
	
	public function getNumByMC(mc:MovieClip):Number {
		return MIArrayUtil.getIndexNumber(duplicatedMCS2, mc);
	}//<<
	
	public function getMCS(Void):Array {
		return duplicatedMCS2.concat();
	}//<<

}