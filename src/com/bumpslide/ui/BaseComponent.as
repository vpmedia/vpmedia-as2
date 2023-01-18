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


class com.bumpslide.ui.BaseComponent extends MovieClip implements IResizable
{
	
	private var height : Number;
	private var width : Number;
	
	/**
	 * Constructor
	 */
	public function BaseComponent() {		
		init();
	}
	
	/**
	 *  Init clip height and width
	 */
	private function init() {
		// by default, make height and width be the stretched height and width.
		if(width==null) width = Math.round( _width );
		if(height==null) height = Math.round( _height );
		_xscale = _yscale = 100;
		
	}
	
	public function update() {
		redraw();
	}
	
	/**
	 * onLoad Handler
	 */
	private function onLoad() {
		
	}
	
	/**
	 *  Redraw display 
	 */
	private function redraw() {
		
		
	}	
	
	/**
	* Sets component's size (width and height)
	* @param	w	width
	* @param	h	height
	*/
	public function setSize( w:Number, h:Number ) {
		width = (w!=null) ? Math.round(w) : width;
		height = (h!=null) ? Math.round(h) : height;
		redraw();
	}
	
	
}
