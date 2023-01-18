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

import pl.milib.data.info.ScrollInfo;
import pl.milib.mc.MIScrollable;
import pl.milib.util.MIMathUtil;

/**
 * @often_name *ScrlArr
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.data.ScrollableArray extends MIScrollable {

	private var scrollScope : Number;
	private var arr : Array;
	private var scroll : Number;
	public var scroll01 : Number;
		
	public function ScrollableArray($arr:Array, $scrollScope:Number) {
		arr=$arr==null ? [] : $arr.concat();
		scrollScope=$scrollScope==null ? 0 : $scrollScope;
		scroll=0;
	}//<>
	
	public function setBaseArray(newArr:Array){
		arr=newArr;
		bev(event_NewScrollData);
	}//<<
	
	public function setScrollScope(newScrollScope:Number):Void {
		if(scrollScope==Math.round(newScrollScope)){ return; }
		scrollScope=MIMathUtil.between(Math.round(newScrollScope), 1, Infinity);
		scroll=MIMathUtil.between(scroll, 0, getMaxScroll());
		if(scroll<0){ scroll=0; }
		bev(event_NewScrollData);
	}//<<
	
	public function setNewArray(arr:Array) {
		this.arr=arr;
		var orgScrollScope=scrollScope;
		delete scrollScope;
		setScrollScope(orgScrollScope);
		bev(event_NewScrollData);
	}//<<
	
	public function getScrollData(Void):ScrollInfo {
		var scrollData:ScrollInfo=new ScrollInfo(
			arr.length,
			scrollScope,
			getScroll01()
		);
		return scrollData;
	}//<<
	
	public function getScroll01(Void):Number {
		var maxScroll:Number=getMaxScroll();
		if(maxScroll>0){
			return scroll/maxScroll;
		}else{
			return 0;
		}
	}//<<
	
	public function getScroll(Void):Number {
		return scroll;
	}//<<
	
	public function setScroll(newScroll:Number):Void {
		if(scroll==Math.round(newScroll)){ return; } 		scroll=MIMathUtil.between(Math.round(newScroll), 0, getMaxScroll());
		if(scroll<0){ scroll=0; }
		bev(event_NewScrollData);
	}//<<
	public function setScrollByOneUnit(turn:Number):Void {
		setScroll(turn<0 ? scroll-1 : scroll+1);
	}//<<
	public function setScrollN01(scroll01:Number):Void {
		this.scroll01=scroll01;
		setScroll(scroll01*getMaxScroll());
	}//<<
	
	public function getCurrentArray(Void):Array {
		if(arr.length<scrollScope){ return arr.concat(); }
		var currArr:Array=[];
		var scrollEnd:Number=scroll+scrollScope;
		for(var i=scroll;i<scrollEnd;i++){
			currArr.push(arr[i]);
		}
		return currArr;
	}//<<
	
	public function getScrollScope(Void):Number {
		return scrollScope;
	}//<<
	
	public function getMaxScroll(Void):Number {
		return arr.length-scrollScope;
	}//<<
	
	public function getCurrentArrayElementByNumber(num:Number) : Object {
		return arr[scroll+num];
	}//<<
	
	public function getBaseNumberByListNumber(num:Number):Number{
		return scroll+num;
	}//<<
	
	public function push(value):Void {
		arr.push(value);
		bev(event_NewScrollData);
	}//<<
	
	public function getBaseArrayNumByScrollArrayNum(num:Number):Number { return scroll+num; }//<<
	public function getBaseArrayElementByScrollArrayNum(num:Number):Object {
		return arr[scroll+num];
	}//<<
	public function getBaseArrayLength(Void):Number { return arr.length; }//<<
	public function getBaseArray(Void):Array { return arr.concat(); }//<<
	
}