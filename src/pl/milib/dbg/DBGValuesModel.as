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

/** @author Marek Brun 'minim' */
class pl.milib.dbg.DBGValuesModel extends MIBroadcastClass {
	
	//nastąpiło utworzenie obiektu
	//DATA:	num:Number
	public var event_ElementCreate:Object={name:'ElementCreate'};
	
	//nastąpiła zmiana elementu
	//DATA:	num:Number
	public var event_ElementChanged:Object={name:'ElementChanged'};
	
	private var data : Object;
	private var count : Number;
	private var datas : Array;
	private var dataByNum : Array;
	
	public function DBGValuesModel() {
		count=0;
		data={};
		dataByNum=[];		datas=[];
	}//<>
	
	public function addData(name:String, value:String, $sender:Object){
		if(!data[name]){
			data[name]={};
			data[name].name=name;
			if($sender){ data[name].senderSoulObj=MIObjSoul.forInstance($sender); }			data[name].num=count;
			data[name].count=0;
			dataByNum[count]=data[name];
			datas.push(data[name]);
			bev(event_ElementCreate, {num:count});
			count++;
		}
		var obj=data[name];
		if(value===undefined){
			data[name].count++;
			data[name].value='*'+data[name].count;
		}else{
			data[name].value=value;
		}
		bev(event_ElementChanged, {num:data[name].num});
	}//<<
	
	/** @return new Array of Object of {num:Number, name:String, value, senderSoulObj:MIObjSoul} */
	public function getData():Array{
		var tab:Array=[];
		for(var i=0,vl;vl=datas[i];i++){
			tab.push({num:vl.num, name:vl.name, value:vl.value, senderSoulObj:vl.senderSoulObj});
		}
		return tab;
	}//<<
	
	public function getElementValue(num:Number):String{
		return dataByNum[num].value;
	}//<<
	
	public function getElementName(num:Number):String{
		return dataByNum[num].name;
	}//<<
	
	public function getElementSender(num:Number){
		return dataByNum[num].senderSoulObj.o;
	}//<<
	
	public function gotElementSender(num:Number):Boolean{
		return Boolean(dataByNum[num].senderSoulObj.o);
	}//<<
	
}