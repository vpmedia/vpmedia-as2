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
import wilberforce.geom.*;
import wilberforce.util.drawing.styles.*
import wilberforce.util.drawing.drawingUtility;

/**
* Class to encapsulate a shape and its properties (lineStyle and fillStyle). This is to allow a collection of shapes to be passed
*/
class wilberforce.util.drawing.drawingShape
{
	var _shape;//:shape2D;
	var _fillStyle:fillStyleFormat;
	var _lineStyle:lineStyleFormat;
	
	function drawingShape(shape:IShape2D,tLineStyle:lineStyleFormat,tFillStyle:fillStyleFormat)
	{
		_shape=shape;		
		_fillStyle=tFillStyle;
		_lineStyle=tLineStyle;
	}
	
	public function render(_movieClip:MovieClip):Void
	{
		if (_shape instanceof rect) drawingUtility.drawRect(_movieClip,_shape,_lineStyle,_fillStyle);
		if (_shape instanceof circle) {
			drawingUtility.drawCircle(_movieClip,_shape,_lineStyle,_fillStyle);
		}
	}
}