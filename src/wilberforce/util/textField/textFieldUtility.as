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
 
/**
 * @author Simon Oliver
 * @version 1.0
 */

// Classes from Wilberforce
import wilberforce.geom.rect;

/**
* Utility class to simplify the creation of text fields and to provide simple functionality to make text layout easier
*/
class wilberforce.util.textField.textFieldUtility
{
	///TextFormat([font:String], [size:Number], [color:Number], [bold:Boolean], [italic:Boolean], [underline:Boolean], [url:String], [target:String], [align:String], [leftMargin:Number], [rightMargin:Number], [indent:Number], [leading:Number])

	static var defaultTextFormat=new TextFormat("_sans",12,0x686868,true,false,false,null,null,null);
	static var defaultRightAlignedTextFormat=new TextFormat("_sans",12,0x686868,true,false,false,null,null,"right");
	
	
	public static function createTextField(tMovieClip:MovieClip,x:Number,y:Number,width:Number,height:Number,textFormat:TextFormat,text:String,html:Boolean,embedFonts:Boolean,noMultiline:Boolean,depth:Number):TextField
	{
		//trace("Holder clip "+tHolderClip)
		if (!depth) depth=tMovieClip.getNextHighestDepth();
		var name:String="tfield"+depth;		
		if (textFormat==undefined) textFormat=defaultTextFormat;
		tMovieClip.createTextField(name,depth,x,y,width,height);		
		
		var tTextField:TextField=tMovieClip[name];
		tTextField.type= "dynamic";																	
		if (!noMultiline) tTextField.wordWrap=true;
		
		if (embedFonts)
		{
			tTextField.embedFonts=true;
		}
		tTextField.selectable=false;
		
				
		// Assign the title
		if (html)
		{	
			tTextField.html=true;
			if (text) tTextField.htmlText=text;
		}
		else
		{
			if (text) tTextField.text=text;
		}
				
		tTextField.setTextFormat(textFormat);		
		tTextField.setNewTextFormat(textFormat);		
		if (text) {
			tTextField._height=5+tTextField.textHeight;
			// Add a tiny bit of extra spacing
			if (!textFormat.align!="center") tTextField._width=10+tTextField.textWidth;
		}
		
		return tTextField;		
	}
	
	public static function toRect(textField:TextField):rect
	{
		return new rect(textField._x,textField._y,textField.textWidth,textField.textHeight);
	}
	
	

}