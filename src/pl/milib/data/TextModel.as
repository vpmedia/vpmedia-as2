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

import pl.milib.core.supers.MIModel;
import pl.milib.data.LimitedLengthArray;
import pl.milib.util.MIArrayUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.data.TextModel extends MIModel {

	private var lines : LimitedLengthArray;
	private var isHtml : Boolean;
	private var countRepeats : Number;
	private var lastText : String;
	
	public function TextModel($isHtml:Boolean, $numOfLinesLimit:Number) {
		isHtml=$isHtml==null ? false : $isHtml;
		lines=new LimitedLengthArray($numOfLinesLimit);
		countRepeats=0;
	}//<>
	
	public function setupNumOfLinesLimit($num:Number):Void {
		lines.setupLengthLimit($num);
		broChanged();
	}//<<
	
	public function getLastLineText(Void):String {
		return lines[lines.length-1];
	}//<<
	
	public function addText(text:String):Void {
		lines.push(text);
		lastText=text;
		countRepeats=0;
		broChanged();
	}//<<
	
	public function setText(text:String):Void {
		MIArrayUtil.clear(lines);
		addText(text);
	}//<<
	
	public function addTextNoRepeat(text:String):Void {
		if(text==lastText){
			countRepeats++;
			lines[lines.length-1]=lastText+' *'+(countRepeats+1);
			broChanged();
		}else{
			addText(text);
		}
	}//<<
	
	public function getIsHtml(Void):Boolean {
		return isHtml;
	}//<<
	
	public function getText(Void):String {
		return lines.join('\n');
	}//<<
	
	public function clear(Void):Void {
		lines=new LimitedLengthArray(lines.lengthLimit);
		broChanged();
	}//<<
	
}