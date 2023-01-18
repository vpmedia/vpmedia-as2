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

 // Classes from wilberforce
import wilberforce.util.drawing.styles.*;
import wilberforce.util.textField.textFieldUtility;
import wilberforce.util.drawing.drawingUtility;
import wilberforce.geom.rect;

/**
* Utility library to assist in the creation of simple elements for testing and debugging
* such as scrollbars, buttons (without the need for any visual elements
*/
class wilberforce.ui.simpleUIFactory
{
	static var backgroundStyle:fillStyleFormat=new fillStyleFormat(0xCCCCCC,100,0);
	static var borderStyle:lineStyleFormat=new lineStyleFormat(0,0x555555,50);
		
	static function createButton(container:MovieClip,label:String,x:Number,y:Number,pressFunction:Function):MovieClip
	{
		var _depth=container.getNextHighestDepth();
		var _buttonClip=container.createEmptyMovieClip("button"+_depth,_depth);
		// Create the text
		var tTextField=textFieldUtility.createTextField(_buttonClip,0,0,300,200,null,label);
		var _rect:rect=textFieldUtility.toRect(tTextField);
		_rect.width=_rect.width+5;
		_rect.height=_rect.height+5;
		drawingUtility.drawRect(_buttonClip,_rect,borderStyle,backgroundStyle);
		//trace("added clip "+_buttonClip);
		if (x) _buttonClip._x=x;
		if (y) _buttonClip._y=y;
		if (pressFunction) _buttonClip.onPress=pressFunction;
		return _buttonClip;
	}
}