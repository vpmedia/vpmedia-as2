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

 

 /**
 * Horizontal Scroll Panel Base Class
 * 
 * This is a simple extension of the scroll panel that supports horizontal scrolling.  
 * The trick here is to create a vertical scroll panel, and then rotate it -90 on the 
 * stage.  Then, the content is attach at 90 degrees to compensate.  The weird part, then
 * is that a lot of the dimensions (height and width) are backwards in the update function.
 * This class takes care of that messiness.  
 * 
 * TODO: Make scrollbar work natively in a horizontal mode so we don't have to deal with this.
 * 
 * @author David Knape
 * 
 */

class com.bumpslide.ui.HorizontalScrollPanel extends com.bumpslide.ui.ScrollPanel {
	
	function init() {
		scroll_mc.hideWhenDisabled = false;
	}
	
	// attach content rotated
	function attachContent() {	
		var initObj = {parentPanel: this, _rotation: 90};
		holder_mc.attachMovie(_contentPath, 'content'+_contentLevel, _contentLevel, initObj);	
	}	
	
	// Note: we are rotated, so, various dimensions are swapped
	function update() {		
				
		// amount we have to subtract from content width to compensate for scrollbar
		var scrollBarWidth = Math.floor( scroll_mc._width + paddingMid );
				
		// update mask size
		mask_mc._height = contentWidth;
		mask_mc._width = contentHeight - scrollBarWidth;
		mask_mc._x = scrollBarWidth + paddingBottom;
		mask_mc._y = paddingLeft;
				
		holder_mc._x = height - paddingTop ;
				
		if(bg_mc) {
			bg_mc._width = height;
			bg_mc._height = width;
		}
		
		// update content size
		content_mc.setSize(contentWidth, contentHeight - scrollBarWidth);
		
		updateScroller();
		
	}
	
	function updateScroller() {
		// update scrollbar position and height
		scroll_mc._x = paddingBottom;
		scroll_mc._y = paddingLeft;
		scroll_mc.setHeight( contentWidth );	
		
		// if scrollbar not necessary, fill content to far edge
		if(!scroll_mc._visible) {
			content_mc.setSize( contentWidth, contentHeight);
			mask_mc._width = contentHeight;			
		}
	}
	

	
	
}