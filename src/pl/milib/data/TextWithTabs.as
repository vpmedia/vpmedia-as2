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

import pl.milib.util.MIStringUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.data.TextWithTabs {

	private var arr : Array; //of [0]tab:Number, [1]text:String
	private var tab : Number;	private var tabString : String = '	';
	
	public function TextWithTabs() {
		arr=[];
		tab=0;
	}//<>
	
	public function plusTab(){
		tab++;
	}//<<
	
	public function minusTab(){
		tab--;
		if(tab<0){ tab=0; }
	}//<<
	
	public function addLine(text:String){
		arr.push([tab, text]);
	}//<<
	
	public function addLineAndPlus(text:String){
		addLine(text);
		plusTab();
	}//<<
	
	public function addLineAndMinus(text:String){
		addLine(text);
		minusTab();
	}//<<
	
	public function minusAndAddLine(text:String){
		minusTab();
		addLine(text);
	}//<<
	
	public function addLines(texts:Array){
		for(var i=0;i<texts.length;i++){ addLine(texts[i]); }
	}//<<
	
	public function toString():String{
		var lines:Array=[];
		for(var i=0;i<arr.length;i++){
			lines.push(MIStringUtil.multiply(tabString, arr[i][0])+arr[i][1]);
		}
		return lines.join('\n');
	}//<<
	
}