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

/**
 * @varname couples*_*And*
 * 
 * @author Marek Brun 'minim'
 */
class pl.milib.data.Couples extends MIBroadcastClass {

	private var arr : Array;
	
	public function Couples() {
		arr=[];
	}//<>
	
	public function addPair(mainValue, $idValue):Void{
		arr.push([mainValue, $idValue]);
	}//<<
	
	public function setPairs(pairs:Array):Void{
		clear();
		for(var i=0;i<pairs.length;i++){
			addPair(pairs[i][0], pairs[i][1]);
		}
	}//<<
	
	public function getPair(value){
		for(var i=0,vl;vl=arr[i];i++){
			if(value==vl[0]){
				return vl[1];
			}else if(value==vl[1]){
				return vl[0];
			}
		}
		return null;
	}//<<
	
	public function getSubByMain(value){
		for(var i=0,vl;vl=arr[i];i++){
			if(value==vl[0]){ return vl[1]; }
		}
	}//<<
	
	public function getMainBySub(value){
		for(var i=0,vl;vl=arr[i];i++){
			if(value==vl[1]){ return vl[0]; }
		}
	}//<<
	
	public function getMainValue(indexNumber:Number) {
		return arr[indexNumber][0];
	}//<<
	
	public function getIndexNumber(value):Number{
		for(var i=0,vl;vl=arr[i];i++){
			if(value==vl[0]){
				return i;
			}else if(value==vl[1]){
				return i;
			}
		}
		return null;
	}//<<
	
	public function remove(value):Boolean{
		for(var i=0,vl;vl=arr[i];i++){
			if(value==vl[0]){
				arr.splice(i, 1);
				return true;
			}else if(value==vl[1]){
				arr.splice(i, 1);
				return true;
			}
		}
		return false;
	}//<<
	
	public function has(value):Boolean{
		for(var i=0,vl;vl=arr[i];i++){
			if(value==vl[0] || value==vl[1]){
				return true;
			}
		}
		return false;
	}//<<
	
	/** @return Array of values at index 0 */
	public function getArray():Array{
		var arrToRet:Array=[];
		for(var i=0;i<arr.length;i++){
			arrToRet.push(arr[i][0]);
		}
		return arrToRet;
	}//<<
	
	public function getLength():Number {
		return arr.length;
	}//<<
	
	public function replace(idValue, newValue){
		for(var i=0,vl;vl=arr[i];i++){
			if(idValue==vl[0]){
				vl[1]=newValue;
				return;
			}else if(idValue==vl[1]){
				vl[0]=newValue;
				return;
			}
		}
	}//<<
	
	public function clear(Void):Void {
		arr=[];
	}//<<
	
}

/* Example passed test
contents=[{id:'Info'},{id:'Options'},{id:'Methods'},{id:'Fields'},{id:'Life'}];
couplesBtnContent=new Couples();
couplesBtnContent.ad('btnInfo', contents[0]);
couplesBtnContent.ad(contents[1], 'btnOptions');
couplesBtnContent.ad(contents[2], 'btnMethods');
couplesBtnContent.gt('btnMethods').id>>Methods //Methods
couplesBtnContent.gt('contents[2]')>>btnMethods //btnMethods
couplesBtnContent.dl(contents[2])true //true
couplesBtnContent.dl(contents[2])false //false
couplesBtnContent.gt('btnMethods')>>null //null
couplesBtnContent.gt('contents[2]')>>null //null
couplesBtnContent.gt('btnInfo').id>>Info //Info
couplesBtnContent.gt('contents[0]')>>btnInfo //btnInfo
*/


