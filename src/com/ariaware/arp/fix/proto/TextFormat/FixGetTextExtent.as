////////////////////////////////////////////////////////////////////////////////
//
// Ariaware RIA Platform (ARP)
// Copyright © 2004 Aral Balkan.
// Copyright © 2004 Ariaware Limited
// http://www.ariaware.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
//	GetTextExtent fix (AS2 Version)
//	
//	Copyright © 2003, 2004 Aral Balkan. All Rights Reserved
//  Copyright © 2004 Ariaware Limited
//
////////////////////////////////////////////////////////////////

dynamic class com.ariaware.arp.fix.proto.TextFormat.FixGetTextExtent
{
	function FixGetTextExtent ()
	{
		_global.TextFormat2 = TextFormat;
		
		_global.TextFormat = function()
		{
			super();
			delete this.getTextExtent;
		}
		
		TextFormat.prototype = new TextFormat2();
		TextFormat.prototype.getTextExtent2 = TextFormat.prototype.getTextExtent;
		TextFormat.prototype.getTextExtent = function ( the_str ) {
			
			// create temporary textfield
			_root.createTextField("getTextExtentTemp_txt", 1000000, 1, 1, 10, 10);
			// local reference to text field
			var temp_txt = _root [ "getTextExtentTemp_txt" ];
			// set the text format
			temp_txt.setNewTextFormat( this );
			// populate textfield with string
			temp_txt.text = the_str;
			// get dimensions
			var w = temp_txt.textWidth;
			var h = temp_txt.textHeight;
			// wrap in object
			var textExtent = { width: w, height: h };
			
			// remove the textfield
			temp_txt.removeTextField();
			
			// return dimensions object
			return textExtent;
		}
		ASSetPropFlags(_global,"TextFormat,TextFormat2",131);
	}
}
