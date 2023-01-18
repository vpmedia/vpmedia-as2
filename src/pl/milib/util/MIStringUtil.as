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

import pl.milib.util.MIMathUtil;


class pl.milib.util.MIStringUtil {
	
	static public function split2D(str:String, divider0:String, divider1:String):Array {
		var tab:Array=str.split(divider0);
		for(var i=0;i<tab.length;i++){
			tab[i]=tab[i].split(divider1);
		} 
		return tab;
	}//<<
	
	static public function safeHTML(str:String):String{
		return str.split('<').join('&lt;').split('>').join('&gt;');
	}//<<
	
	static public function frontZero(digitSum:Number, number:Number):String {
		var str:String=String(int(number));
		var len:Number=digitSum-str.length+1;
		var summStr:Array=[];
		for(var i=1;i<len;i++){ summStr.push('0'); }
		return summStr.join('')+str;
	}//<<
	
	static public function getHTMLColor(text:String, color:Number):String{
		return '<FONT COLOR="#'+MIMathUtil.getHEXString(color)+'" >'+text+'</FONT>';
	}//<<
	
	static public function replace(str:String, from:String, to:String):String {
		return str.split(from).join(to);
	}//<<
	
	static public function replaceFirst(str:String, from:String, to:String):String {
		var split:Array=str.split(from);
		if(split.length<2){
			return str;
		}else if(split.length==2){
			return split.join(to); 
		}else{
			var first:String=split[0];
			var splitRest:Array=split.concat();
			splitRest.shift();
			return first+to+splitRest.join(from); 
		}
	}//<<
	
	static public function replaceLast(str:String, from:String, to:String):String {
		var split:Array=str.split(from);
		if(split.length<2){
			return str;
		}else if(split.length==2){
			return split.join(to); 
		}else{
			var last=split.pop();
			return split.join(from)+to+last; 
		}
	}//<<
	
	static public function getHTMLSize(text:String, size:Number):String {
		return '<FONT SIZE="'+size+'" >'+text+'</FONT>';
	}//<<
	
	/**
	 * @return Array "folder/folder/file.jpg" to ["folder/folder", "file.jpg"]
	 */
	static public function getFileNameAndFolderByURL(url:String):Array {
		var tab:Array=url.split('/');
		if(tab.length==1){ return ['', url]; }
		var fileName:String=String(tab.pop());
		return [tab.join('/')+'/', fileName];
	}//<<
	
	static public function multiply(str:String, length:Number):String {
		var resultStr:String='';
		for(var i=0;i<length;i++){ resultStr+=str; }
		return resultStr;
	}//<<
}

