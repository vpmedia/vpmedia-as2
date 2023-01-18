/**
 *  Copyright (c) 2006, David Knape and contributing authors
 *
 *  Permission is hereby granted, free of charge, to any person 
 *  obtaining a copy of this software and associated documentation 
 *  files (the "Software"), to deal in the Software without 
 *  restriction, including without limitation the rights to use, 
 *  copy, modify, merge, publish, distribute, sublicense, and/or 
 *  sell copies of the Software, and to permit persons to whom the 
 *  Software is furnished to do so, subject to the following 
 *  conditions:
 *  
 *  The above copyright notice and this permission notice shall be 
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

 
import com.bumpslide.ui.IResizable;
import com.bumpslide.ui.ScrollPanel;


class com.bumpslide.ui.ResizableText
{

	// this is a reference to the scroll panel that contains us
	// if we are loaded as scroll panel content
	var parentPanel : ScrollPanel;
	
	// my text
	var content_txt : TextField;
	
	function ResizableText()
	{
		content_txt.autoSize = true;
		content_txt.multline = content_txt.wordWrap = true;
		content_txt.mouseWheelEnabled = false;
	}
	
	function setSize(textWidth:Number) {
		content_txt._width = textWidth;
	}

	function set text (s:String) {
		content_txt.text = filter(s);
	}
	
	function set htmlText (s:String) {
		content_txt.html = true;
		content_txt.htmlText = filter(s);
	}
	
	function filter(s:String) {
		return s;
	}
}
