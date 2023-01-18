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


class pl.milib.util.MIArrayUtil {
	
	static public function applyFunc(arr:Array, funcName:String, args:FunctionArguments):Void {
		var len=arr.length;
		for(var i=0;i<len;i++){
			arr[i][funcName].apply(arr[i], args);
		}
	}//<<
	
	static public function applyProps(arr:Array, propName:String, value):Void {
		var len=arr.length;
		for(var i=0;i<len;i++){
			arr[i][propName]=value;
		}
	}//<<
	
	static public function getWhereObjProp(arr:Array, objectPropName:String, value):Object {
		var i:Number = arr.length;
		var found:Object;
		while (--i-(-1)) {
			if(arr[i][objectPropName] == value) {
				found = arr[i];
				break;
			}
		}
		return found;
	}//<<
	
	static public function getIndexWhereObjProp(arr:Array, objectPropName:String, value):Number {
		var p:Number = arr.length;
		var found:Object;
		while (--p-(-1)) {
			if(arr[p][objectPropName] == value) {
				return p;
				break;
			}
		}
		return null;
	}//<<
	
	static public function getObjWhereObjProp(arr:Array, objectPropName:String, value):Number {
		return arr[getIndexWhereObjProp(arr, objectPropName, value)];
	}//<<
	
	static public function getWhereObjsProp(arr:Array, objectPropName:String, value):Array {
		var i:Number = arr.length;
		var founds:Array=[];
		while(--i-(-1)) {
			if(arr[i][objectPropName] == value) {
				founds.push(arr[i]);
			}
		}
		return founds;
	}//<<
	
	static public function getWhereObjsOneOfProps(arr:Array, objectPropName:String, values:Array):Array {
		var i:Number = arr.length;
		var founds:Array=[];
		var p;
		while(--i-(-1)) {
			for(p=0;p<values.length;p++){
				if(arr[i][objectPropName]==values[p]) {
					founds.push(arr[i]);
					break;
				}
			}
		}
		return founds;
	}//<<
	
	static public function getWhereObjsPropNumberBetween(arr:Array, objectPropName:String, between:Array):Array {
		var i:Number = arr.length;
		var founds:Array=[];
		var p;
		while(--i-(-1)) {
			if(arr[i][objectPropName]>=between[0] && arr[i][objectPropName]<=between[1]) {
				founds.push(arr[i]);
			}
		}
		return founds;
	}//<<
	
	static public function getByProp(arr:Array, propNumOrName):Array {
		var byProp=[];
		for(var i=0;i<arr.length;i++){
			byProp[arr[i][propNumOrName]]=arr[i];
		}
		return byProp; 
	}//<<
	
	static public function getNextByValue(arr:Array, value):Object {
		for(var i=0;i<arr.length;i++){
			if(arr[i]==value){
				if(i==arr.length-1){ return arr[0]; }				else{ return arr[i+1]; }
			}
		}
	}//<<
	
	static public function getPrevByValue(arr:Array, value):Object {
		for(var i=0;i<arr.length;i++){
			if(arr[i]==value){
				if(i==0){ return arr[arr.length-1]; }
				else{ return arr[i-1]; }
			}
		}
	}//<<
	
	static public function getByTurn(arr:Array, value, turn:Number):Object {
		if(turn>0){ return getNextByValue(arr, value); }		else{ return getPrevByValue(arr, value); }
	}//<<
	
	static public function got(arr:Array, value):Boolean {
		for(var i=0;i<arr.length;i++){
			if(arr[i]===value){ return true; }
		}
		return false;
	}//<<
	
	static public function gotVar(arr:Array, varName:String, value):Boolean {
		for(var i=0;i<arr.length;i++){
			if(arr[i][varName]===value){ return true; }
		}
		return false;
	}//<<
	
	static public function getIndexNumber(arr:Array, value):Number {
		for(var i=0;i<arr.length;i++){
			if(arr[i]===value){ return i; }
		}
		return null;
	}//<<
	
	static public function getIndexNumberFromBack(arr:Array, value):Number {
		for(var i=arr.length-1;i>-1;i--){
			if(arr[i]===value){ return i; }
		}
		return null;
	}//<<
	
	static public function addUnique(arr:Array, value):Boolean {
		for(var i=0;i<arr.length;i++){
			if(arr[i]===value){ return false; }
		}
		arr.push(value);
		return true;
	}//<<
	
	
	static public function remove(arr:Array, value):Void {
		var i:Number = arr.length;
		while (--i-(-1)) {
			if(arr[i]===value) {
				arr.splice(i, 1);
			}
		}
	}//<<
	
	static public function removes(arr:Array, toRemoves:Array):Void {
		for(var i=0;i<toRemoves.length;i++){ remove(arr, toRemoves[i]); }
	}//<<
	
	static public function removeWhereObjProp(arr:Array, objectPropName:String, value):Void {
		var i:Number = arr.length;
		while (--i-(-1)) {
			if(arr[i][objectPropName] == value) {
				arr.splice(i, 1);
			}
		}
		return;
	}//<<
	
	static public function clear(arr:Array):Void {
		var i:Number = arr.length;
		while(--i-(-1)){ arr.splice(i, 1); }
	}//<<
	
}